import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/app.dart';
import '../bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _gotraController = TextEditingController();

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  bool _isFormValid = false;

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

    // Add listeners to all controllers to validate form
    _nameController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _cityController.addListener(_validateForm);
    _stateController.addListener(_validateForm);
    _dateOfBirthController.addListener(_validateForm);
    _gotraController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _nameController.text.trim().isNotEmpty &&
          _phoneController.text.trim().length == 10 &&
          _emailController.text.trim().isNotEmpty &&
          _cityController.text.trim().isNotEmpty &&
          _stateController.text.trim().isNotEmpty &&
          _dateOfBirthController.text.trim().isNotEmpty &&
          _gotraController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _dateOfBirthController.dispose();
    _gotraController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _dateOfBirthController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void _handleRegister() {
    if (_isFormValid) {
      context.read<AuthBloc>().add(
            RegisterEvent(
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              email: _emailController.text.trim(),
              city: _cityController.text.trim(),
              state: _stateController.text.trim(),
              dateOfBirth: _dateOfBirthController.text.trim(),
              gotra: _gotraController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print('RegisterScreen: AuthState changed: $state'); // Debug print
        if (state is OtpSentSuccess) {
          print('RegisterScreen: OtpSentSuccess received, navigating to OTP'); // Debug print
          context.push(
            '/otp',
            extra: {
              'phone': state.phone,
              'expiresIn': state.expiresIn,
              'otpCode': state.otpCode,
            },
          );
        } else if (state is AuthFailure) {
          print('RegisterScreen: AuthFailure received: ${state.message}'); // Debug print
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
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                      child: Column(
                        children: [
                          _buildFormCard(),
                          const SizedBox(height: 24),
                          _buildRegisterButton(),
                          const SizedBox(height: 20),
                          _buildLoginRedirect(context),
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
      padding: EdgeInsets.fromLTRB(20, top + 14, 20, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppTheme.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    color: AppTheme.white,
                    size: 13,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'वापस / Back',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          // ॐ circle + Title
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.white.withOpacity(0.15),
                  border: Border.all(
                    color: AppTheme.white.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'ॐ',
                  style: TextStyle(fontSize: 26, color: AppTheme.white),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'नया खाता बनाएं',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.accentColor.withOpacity(0.85),
                      letterSpacing: 1.1,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              'Jagadguru Shridharacharya Ji Maharaj',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.accentColor.withOpacity(0.85),
                fontStyle: FontStyle.italic,
                letterSpacing: 0.6,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Form Card ────────────────────────────────────────────────────────────────
  Widget _buildFormCard() {
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1 — Personal Details
          const _SectionLabel(
            hindi: 'व्यक्तिगत जानकारी',
            english: 'Personal Details',
          ),
          const SizedBox(height: 18),

          _buildField(
            controller: _nameController,
            label: 'पूरा नाम / Full Name',
            hint: 'Neharika Singh',
            icon: Icons.person_outline_rounded,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z\u0900-\u097F\s]'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildField(
            controller: _phoneController,
            label: 'मोबाइल नंबर / Phone',
            hint: '9876543210',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),

          _buildField(
            controller: _emailController,
            label: 'ईमेल / Email',
            hint: 'example@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          _buildField(
            controller: _cityController,
            label: 'शहर / City',
            hint: 'Vrindavan',
            icon: Icons.location_city_rounded,
          ),
          const SizedBox(height: 16),

          _buildField(
            controller: _stateController,
            label: 'राज्य / State',
            hint: 'Uttar Pradesh',
            icon: Icons.map_rounded,
          ),
          const SizedBox(height: 16),

          _buildDateField(),
          const SizedBox(height: 16),

          _buildField(
            controller: _gotraController,
            label: 'गोत्र / Gotra',
            hint: 'Bharadwaj',
            icon: Icons.family_restroom_rounded,
          ),
        ],
      ),
    );
  }

  // ─── Field Builder ────────────────────────────────────────────────────────────
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          style: TextStyle(
            fontSize: 14.5,
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
          cursorColor: AppTheme.primaryColor,
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            filled: true,
            fillColor: AppTheme.white,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(icon, color: AppTheme.primaryColor, size: 20),
            ),
            hintStyle: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.4),
              fontSize: 13.5,
              fontFamily: 'Poppins',
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppTheme.primaryDark.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Date Field Builder ────────────────────────────────────────────────────────
  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Text(
            'जन्मतिथि / Date of Birth',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        GestureDetector(
          onTap: _selectDate,
          child: AbsorbPointer(
            child: TextFormField(
              controller: _dateOfBirthController,
              style: TextStyle(
                fontSize: 14.5,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
              cursorColor: AppTheme.primaryColor,
              decoration: InputDecoration(
                hintText: 'YYYY-MM-DD',
                filled: true,
                fillColor: AppTheme.white,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                hintStyle: TextStyle(
                  color: AppTheme.textPrimary.withOpacity(0.4),
                  fontSize: 13.5,
                  fontFamily: 'Poppins',
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: AppTheme.primaryDark.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Register Button ──────────────────────────────────────────────────────────
  Widget _buildRegisterButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return GestureDetector(
          onTap: (_isFormValid && !isLoading) ? _handleRegister : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: _isFormValid
                  ? LinearGradient(
                      colors: [AppTheme.accentColor, AppTheme.primaryColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: _isFormValid ? null : AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isFormValid
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
                    _isFormValid
                        ? '🙏  पंजीकरण करें — Register'
                        : 'पंजीकरण करें — Register',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _isFormValid
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

  // ─── Login Redirect ───────────────────────────────────────────────────────────
  Widget _buildLoginRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'पहले से खाता है?  ',
          style: TextStyle(
            color: AppTheme.textPrimary.withOpacity(0.6),
            fontSize: 13,
            fontFamily: 'Poppins',
          ),
        ),
        GestureDetector(
          onTap: () => context.pop(),
          child: Text(
            'लॉग इन करें',
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

// ─── Section Label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.hindi, required this.english});
  final String hindi;
  final String english;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryDark, AppTheme.accentColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hindi,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              english,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textPrimary.withOpacity(0.6),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
