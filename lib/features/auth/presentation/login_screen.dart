import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/app.dart';
import 'package:guruji/features/auth/presentation/otp_screen.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  bool _isValid = false;

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
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

    _phoneController.addListener(() {
      setState(() {
        _isValid = _phoneController.text.trim().length == 10;
      });
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSendOtp() {
    final phone = _phoneController.text.trim();
    context.read<AuthBloc>().add(SendOtpEvent(phone: phone));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSentSuccess) {
          context.push(
            '/otp',
            extra: {
              'phone': state.phone,
              'expiresIn': state.expiresIn,
              'otpCode': state.otpCode,
            },
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
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
                          _buildWelcomeText(),
                          const SizedBox(height: 28),
                          _buildPhoneCard(),
                          const SizedBox(height: 28),
                          _buildContinueButton(),
                          const SizedBox(height: 24),
                          _buildDivider(),
                          const SizedBox(height: 24),
                          _buildRegisterRedirect(context),
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

  // ─── Header (unchanged) ───────────────────────────────────────────────────────
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            child: const Text(
              'ॐ',
              style: TextStyle(
                fontSize: 34,
                color: Color.fromARGB(255, 83, 75, 75),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'स्वागत है',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppTheme.white,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.white,
              letterSpacing: 1.2,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Jagadguru Shridharacharya Ji Maharaj',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.white,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.5,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'अपना मोबाइल नंबर दर्ज करें',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Enter your registered mobile number to continue',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textPrimary.withOpacity(0.55),
            fontFamily: 'Poppins',
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.cardColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryDark.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Text('🇮🇳', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      '+91',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'मोबाइल नंबर / Mobile Number',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(
              fontSize: 20,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              letterSpacing: 3,
            ),
            cursorColor: AppTheme.primaryColor,
            decoration: InputDecoration(
              hintText: '00000  00000',
              counterText: '',
              filled: true,
              fillColor: AppTheme.backgroundColor,
              hintStyle: TextStyle(
                color: AppTheme.textPrimary.withOpacity(0.3),
                fontSize: 20,
                letterSpacing: 3,
                fontFamily: 'Poppins',
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Icon(
                  Icons.phone_outlined,
                  color: AppTheme.primaryColor,
                  size: 22,
                ),
              ),
              suffixIcon: _isValid
                  ? Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green.shade600,
                        size: 22,
                      ),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppTheme.primaryDark.withOpacity(0.25),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 13,
                color: AppTheme.textPrimary.withOpacity(0.4),
              ),
              const SizedBox(width: 5),
              Text(
                'OTP आपके नंबर पर भेजा जाएगा',
                style: TextStyle(
                  fontSize: 11.5,
                  color: AppTheme.textPrimary.withOpacity(0.45),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Continue Button — now BLoC-aware ────────────────────────────────────────
  Widget _buildContinueButton() {
    return BlocBuilder<AuthBloc, AuthState>(

      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return GestureDetector(
          onTap: (_isValid && !isLoading) ? _handleSendOtp : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: _isValid
                  ? LinearGradient(
                      colors: [AppTheme.accentColor, AppTheme.primaryColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: _isValid ? null : AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isValid
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
                    _isValid
                        ? '🙏  OTP भेजें — Send OTP'
                        : 'OTP भेजें — Send OTP',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _isValid
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

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppTheme.primaryDark.withOpacity(0.2),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'अथवा',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textPrimary.withOpacity(0.4),
              fontFamily: 'Poppins',
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppTheme.primaryDark.withOpacity(0.2),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'नया खाता बनाएं?  ',
          style: TextStyle(
            color: AppTheme.textPrimary.withOpacity(0.6),
            fontSize: 13,
            fontFamily: 'Poppins',
          ),
        ),
        GestureDetector(
          onTap: () {
            context.push('/register');
          },
          child: Text(
            'पंजीकरण करें',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              decoration: TextDecoration.underline,
              decorationColor: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
