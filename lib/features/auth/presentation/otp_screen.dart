import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/app.dart';
import 'package:guruji/core/services/user_persistence_service.dart';
import '../bloc/auth_bloc.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final int expiresIn;
  final String? otpCode;

  const OtpScreen({
    super.key,
    required this.phone,
    required this.expiresIn,
    this.otpCode,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  late int _secondsLeft;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();

    _secondsLeft = widget.expiresIn * 60; // expiresIn is in minutes

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();

    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _canResend = true;
        }
      });
      return _secondsLeft > 0;
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _otpValue => _controllers.map((c) => c.text).join();
  bool get _isOtpComplete => _otpValue.length == 6;

  String get _timerText {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _onOtpDigitChanged(int index, String value) {
    // If a digit is entered and it's not the last box, move to next box
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    // If current box is empty (backspace pressed) and not the first box
    if (value.isEmpty && index > 0) {
      // Clear the previous box and move focus to it
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _handleVerify() {
    if (_isOtpComplete) {
      context.read<AuthBloc>().add(
        VerifyOtpEvent(phone: widget.phone, otp: _otpValue),
      );
    }
  }

  void _handleResend() {
    if (_canResend) {
      for (final c in _controllers) c.clear();
      setState(() {
        _secondsLeft = widget.expiresIn * 60;
        _canResend = false;
      });
      context.read<AuthBloc>().add(SendOtpEvent(phone: widget.phone));
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is OtpVerifiedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🙏 ${state.message}'),
              backgroundColor: Colors.green.shade600,
            ),
          );
          // Save user session and navigate to home screen
          await UserPersistenceService.saveUserSession(state.token, state.user);
          context.go('/home');
        } else if (state is AuthFailure) {
          // Shake effect — clear OTP on wrong attempt
          for (final c in _controllers) c.clear();
          _focusNodes[0].requestFocus();
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
            ),
          );
        } else if (state is OtpSentSuccess) {
          // Resend success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP resent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
                      child: Column(
                        children: [
                          _buildInfoText(),
                          const SizedBox(height: 32),
                          _buildOtpBoxes(),
                          const SizedBox(height: 24),
                          _buildTimer(),
                          const SizedBox(height: 32),
                          _buildVerifyButton(),
                          const SizedBox(height: 24),
                          _buildResendRow(),
                          if (widget.otpCode != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.deepOrange.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.bug_report_outlined,
                                      size: 16,
                                      color: Colors.deepOrange.shade700,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'DEBUG: OTP = ${widget.otpCode}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.deepOrange.shade700,
                                        fontFamily: 'Courier',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryDark,
            AppTheme.primaryColor,
            AppTheme.accentColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, top + 18, 20, 30),
      child: Column(
        children: [
          // Back button row
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.white.withOpacity(0.3)),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppTheme.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.white.withOpacity(0.15),
              border: Border.all(
                color: AppTheme.white.withOpacity(0.4),
                width: 1.8,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.lock_open_rounded,
              color: AppTheme.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'OTP सत्यापन',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.white,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'OTP Verification',
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.white,
              letterSpacing: 1.2,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // ─── Info Text ────────────────────────────────────────────────────────────────
  Widget _buildInfoText() {
    return Column(
      children: [
        Text(
          'OTP दर्ज करें',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textPrimary.withOpacity(0.55),
              fontFamily: 'Poppins',
              height: 1.6,
            ),
            children: [
              const TextSpan(text: 'हमने '),
              TextSpan(
                text: '+91 ${widget.phone}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                ),
              ),
              const TextSpan(text: '\nपर 6 अंकों का OTP भेजा है'),
            ],
          ),
        ),
      ],
    );
  }

  // ─── OTP Boxes ────────────────────────────────────────────────────────────────
  Widget _buildOtpBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        final isFilled = _controllers[index].text.isNotEmpty;
        return SizedBox(
          width: 48,
          height: 58,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor,
              fontFamily: 'Poppins',
            ),
            cursorColor: AppTheme.primaryColor,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: isFilled
                  ? AppTheme.primaryColor.withOpacity(0.08)
                  : AppTheme.white,
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: isFilled
                      ? AppTheme.primaryColor
                      : AppTheme.primaryDark.withOpacity(0.25),
                  width: isFilled ? 2 : 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
              ),
            ),
            onChanged: (value) => _onOtpDigitChanged(index, value),
          ),
        );
      }),
    );
  }

  // ─── Timer ────────────────────────────────────────────────────────────────────
  Widget _buildTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _canResend ? Icons.timer_off_outlined : Icons.timer_outlined,
            size: 16,
            color: _canResend ? Colors.red.shade400 : AppTheme.primaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            _canResend ? 'OTP expired!' : 'OTP expires in $_timerText',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _canResend ? Colors.red.shade400 : AppTheme.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // ─── Verify Button ────────────────────────────────────────────────────────────
  Widget _buildVerifyButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return GestureDetector(
          onTap: (_isOtpComplete && !isLoading) ? _handleVerify : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: _isOtpComplete
                  ? LinearGradient(
                      colors: [AppTheme.accentColor, AppTheme.primaryColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: _isOtpComplete ? null : AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isOtpComplete
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    _isOtpComplete
                        ? '🙏  सत्यापित करें — Verify OTP'
                        : 'सत्यापित करें — Verify OTP',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _isOtpComplete
                          ? AppTheme.textPrimary
                          : AppTheme.textPrimary.withOpacity(0.35),
                      letterSpacing: 0.3,
                      fontFamily: 'Poppins',
                    ),
                  ),
          ),
        );
      },
    );
  }

  // ─── Resend Row ───────────────────────────────────────────────────────────────
  Widget _buildResendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'OTP नहीं मिला?  ',
          style: TextStyle(
            color: AppTheme.textPrimary.withOpacity(0.6),
            fontSize: 13,
            fontFamily: 'Poppins',
          ),
        ),
        GestureDetector(
          onTap: _canResend ? _handleResend : null,
          child: Text(
            'पुनः भेजें',
            style: TextStyle(
              color: _canResend
                  ? AppTheme.primaryColor
                  : AppTheme.textPrimary.withOpacity(0.3),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              decoration: _canResend
                  ? TextDecoration.underline
                  : TextDecoration.none,
              decorationColor: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
