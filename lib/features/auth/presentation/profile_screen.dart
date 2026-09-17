import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guruji/core/localization/app_strings.dart';
import 'package:guruji/core/services/language_service.dart';
import 'package:guruji/core/widgets/app_bottom_nav.dart';
import 'package:guruji/features/auth/models/profile_model.dart';
import 'package:guruji/features/language/bloc/language_bloc.dart';
import '../bloc/auth_bloc.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _nameController = TextEditingController(text: 'Anand Sharma');
  final _emailController = TextEditingController(text: 'anand.sharma@example.com');
  final _phoneController = TextEditingController(text: '9876543210');
  final _cityController = TextEditingController(text: 'Vrindavan');
  final _stateController = TextEditingController(text: 'Uttar Pradesh');
  final _dateOfBirthController = TextEditingController(text: '1992-08-15');
  final _gotraController = TextEditingController(text: 'Kashyap');

  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedProfileImageFile;
  String? _profileImageUrl;

  bool _isSaving = false;
  bool _showEditForm = false;

  // Preferences toggles
  bool _muhuratAlerts = true;
  bool _prayerReminders = true;

  final List<String> _states = [
    'Uttar Pradesh',
    'Madhya Pradesh',
    'Rajasthan',
    'Gujarat',
    'Maharashtra',
    'Delhi',
    'Haryana',
    'Punjab',
    'Bihar',
    'West Bengal',
    'Karnataka',
    'Tamil Nadu',
    'Andhra Pradesh',
    'Telangana',
    'Uttarakhand',
  ];

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const GetProfileEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _dateOfBirthController.dispose();
    _gotraController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedProfileImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1992, 8, 15),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7E2B58),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E1A1D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _saveProfile() {
    setState(() => _isSaving = true);
    context.read<AuthBloc>().add(
          UpdateProfileEvent(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim(),
            city: _cityController.text.trim(),
            state: _stateController.text.trim(),
            dateOfBirth: _dateOfBirthController.text.trim(),
            gotra: _gotraController.text.trim(),
            profileImageFile: _selectedProfileImageFile,
          ),
        );
  }

  void _handleBack() {
    if (_showEditForm) {
      setState(() => _showEditForm = false);
      return;
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color bgGradientStart = Color(0xFFFFFDFE);
    const Color bgGradientEnd = Color(0xFFFBF4F7);
    const Color primaryPlum = Color(0xFF7E2B58);
    const Color charcoalText = Color(0xFF1E1A1D);
    const Color subtitleColor = Color(0xFF6B5E66);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBack();
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            setState(() {
              _isSaving = false;
              _showEditForm = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🙏 Profile updated successfully'),
                backgroundColor: Color(0xFF7E2B58),
              ),
            );
          } else if (state is ProfileLoadSuccess) {
            final p = state.profile;
            if (p.name.isNotEmpty) _nameController.text = p.name;
            if (p.email != null && p.email!.isNotEmpty) _emailController.text = p.email!;
            if (p.phone.isNotEmpty) _phoneController.text = p.phone;
            if (p.city != null && p.city!.isNotEmpty) _cityController.text = p.city!;
            if (p.state != null && p.state!.isNotEmpty) _stateController.text = p.state!;
            if (p.gotra != null && p.gotra!.isNotEmpty) _gotraController.text = p.gotra!;
            if (p.dateOfBirth != null) _dateOfBirthController.text = p.dateOfBirth!;
            if (p.profileImage != null && p.profileImage!.isNotEmpty) {
              _profileImageUrl = p.profileImage;
            }
            setState(() {});
          } else if (state is LogoutSuccess) {
            context.go('/home');
          } else if (state is AuthFailure) {
            setState(() => _isSaving = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
            backgroundColor: bgGradientEnd,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bgGradientStart, bgGradientEnd],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
                  child: Column(
                    children: [
                      // ─── Header: Back Button, Title, and Action Icons ───
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_rounded, size: 22, color: primaryPlum),
                            onPressed: _handleBack,
                          ),
                          Text(
                            context.tr('profileTitle'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'serif',
                              color: primaryPlum,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  _showEditForm ? Icons.close_rounded : Icons.edit_outlined,
                                  size: 22,
                                  color: primaryPlum,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showEditForm = !_showEditForm;
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.settings_outlined, size: 22, color: primaryPlum),
                                onPressed: () {
                                  context.push('/choose-language', extra: {'fromSettings': true});
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      // ─── Center Avatar with Verified Badge & Tap to Change ───
                      Center(
                        child: GestureDetector(
                          onTap: _showEditForm ? _pickProfileImage : null,
                          child: Stack(
                            children: [
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFBEBF1),
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryPlum.withOpacity(0.12),
                                      blurRadius: 18,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: _selectedProfileImageFile != null
                                      ? Image.file(_selectedProfileImageFile!, fit: BoxFit.cover)
                                      : Image.asset(
                                          'assets/images/sadhak_avatar.jpg',
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Icon(
                                            Icons.person,
                                            size: 48,
                                            color: primaryPlum,
                                          ),
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: _showEditForm ? const Color(0xFF8E3763) : const Color(0xFF7E2B58),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: Icon(
                                    _showEditForm ? Icons.camera_alt_rounded : Icons.verified,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ─── User Name & Level Badge ───
                      Text(
                        _nameController.text.isNotEmpty ? _nameController.text : 'Anand Sharma',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'serif',
                          color: charcoalText,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBEBF1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          context.tr('devotee').toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8A2E5B),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // ─── 2 Top Stat Cards: Jaap Streak & Total Gauseva ───
                      Row(
                        children: [
                          Expanded(
                            child: _buildProfileStatCard(
                              badgeWidget: const Text('🎖', style: TextStyle(fontSize: 18)),
                              value: '108 ${context.tr('days')}',
                              label: context.tr('jaapStreak').toUpperCase(),
                              charcoalText: charcoalText,
                              primaryPlum: primaryPlum,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildProfileStatCard(
                              badgeWidget: const Text('🐄', style: TextStyle(fontSize: 18)),
                              value: '₹5,100',
                              label: context.tr('totalGauseva').toUpperCase(),
                              charcoalText: charcoalText,
                              primaryPlum: primaryPlum,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // ─── 1) PERSONAL INFORMATION SECTION (ABOVE PREFERENCES) ───
                      _buildPersonalInformationCard(primaryPlum, charcoalText, subtitleColor),
                      const SizedBox(height: 18),

                      // ─── 2) PREFERENCES SECTION (BELOW PERSONAL INFO) ───
                      _buildPreferencesCard(primaryPlum, charcoalText, subtitleColor),
                      const SizedBox(height: 18),

                      // ─── "View Path History" Action Button ───
                      GestureDetector(
                        onTap: () => context.push('/jaap-history'),
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBEBF1),
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.history_rounded, size: 20, color: Color(0xFF1E1A1D)),
                              const SizedBox(width: 8),
                              Text(
                                context.tr('jaapHistoryTitle'),
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E1A1D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ─── "Sign Out" Action Button ───
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: Text(context.tr('logout')),
                              content: Text(context.tr('logoutConfirm')),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.tr('cancel'))),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    context.read<AuthBloc>().add(const LogoutEvent());
                                  },
                                  child: Text(context.tr('logout'), style: const TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: const Color(0xFFF0E0E6)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout_rounded, size: 18, color: Color(0xFFC93737)),
                              const SizedBox(width: 8),
                              Text(
                                context.tr('logout'),
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFC93737),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: const AppBottomNav(currentTab: AppNavTab.profile),
          ),
        ),
      ),
    );
  }

  // ─── Personal Information Card (Default View & Edit Form) ──────────────────
  Widget _buildPersonalInformationCard(
    Color primaryPlum,
    Color charcoalText,
    Color subtitleColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.account_circle_outlined, size: 16, color: primaryPlum),
                  const SizedBox(width: 6),
                  Text(
                    context.tr('personalInfo').toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: primaryPlum,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showEditForm = !_showEditForm;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBEBF1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showEditForm ? Icons.check_rounded : Icons.edit_rounded,
                        size: 13,
                        color: primaryPlum,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _showEditForm ? context.tr('save') : context.tr('edit'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: primaryPlum,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (!_showEditForm) ...[
            // Read-only Details View (Displayed by default)
            _buildInfoRow(
              icon: Icons.phone_android_rounded,
              label: context.tr('phone'),
              value: _phoneController.text.isNotEmpty ? _phoneController.text : 'Not provided',
              charcoalText: charcoalText,
              subtitleColor: subtitleColor,
            ),
            const Divider(color: Color(0xFFF5EDF1), height: 18),
            _buildInfoRow(
              icon: Icons.mail_outline_rounded,
              label: context.tr('email'),
              value: _emailController.text.isNotEmpty ? _emailController.text : 'Not provided',
              charcoalText: charcoalText,
              subtitleColor: subtitleColor,
            ),
            const Divider(color: Color(0xFFF5EDF1), height: 18),
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              label: context.tr('cityState'),
              value: '${_cityController.text.isNotEmpty ? _cityController.text : "City"}, ${_stateController.text.isNotEmpty ? _stateController.text : "State"}',
              charcoalText: charcoalText,
              subtitleColor: subtitleColor,
            ),
            const Divider(color: Color(0xFFF5EDF1), height: 18),
            _buildInfoRow(
              icon: Icons.spa_outlined,
              label: context.tr('gotra'),
              value: _gotraController.text.isNotEmpty ? _gotraController.text : 'Not provided',
              charcoalText: charcoalText,
              subtitleColor: subtitleColor,
            ),
            const Divider(color: Color(0xFFF5EDF1), height: 18),
            _buildInfoRow(
              icon: Icons.cake_outlined,
              label: context.tr('dob'),
              value: _dateOfBirthController.text.isNotEmpty ? _dateOfBirthController.text : 'Not provided',
              charcoalText: charcoalText,
              subtitleColor: subtitleColor,
            ),
          ] else ...[
            // Editable Form Fields View
            _buildInputField(label: context.tr('fullName'), controller: _nameController, icon: Icons.person_outline_rounded),
            const SizedBox(height: 12),
            _buildInputField(label: context.tr('email'), controller: _emailController, icon: Icons.mail_outline_rounded),
            const SizedBox(height: 12),
            _buildInputField(label: context.tr('phone'), controller: _phoneController, icon: Icons.phone_android_rounded, enabled: false),
            const SizedBox(height: 12),
            _buildInputField(label: 'City', controller: _cityController, icon: Icons.location_city_rounded),
            const SizedBox(height: 12),
            _buildStateDropdown(primaryPlum, charcoalText),
            const SizedBox(height: 12),
            _buildInputField(label: context.tr('gotra'), controller: _gotraController, icon: Icons.spa_outlined),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: _buildInputField(
                  label: context.tr('dob'),
                  controller: _dateOfBirthController,
                  icon: Icons.calendar_today_rounded,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _showEditForm = false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: subtitleColor,
                      side: const BorderSide(color: Color(0xFFE0D4DA)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(context.tr('cancel')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8E3763),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _isSaving
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(context.tr('saveChanges'), style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color charcoalText,
    required Color subtitleColor,
  }) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFFBEBF1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 17, color: const Color(0xFF7E2B58)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: charcoalText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Preferences Card ──────────────────────────────────────────────────────
  Widget _buildPreferencesCard(
    Color primaryPlum,
    Color charcoalText,
    Color subtitleColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune_rounded, size: 16, color: primaryPlum),
              const SizedBox(width: 6),
              Text(
                context.tr('spiritualPreferences').toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: primaryPlum,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Muhurat Alerts
          _buildSwitchRow(
            title: 'Muhurat Alerts',
            subtitle: context.tr('todayAuspicious'),
            value: _muhuratAlerts,
            onChanged: (val) => setState(() => _muhuratAlerts = val),
            primaryPlum: primaryPlum,
            charcoalText: charcoalText,
            subtitleColor: subtitleColor,
          ),
          const Divider(color: Color(0xFFF5EDF1), height: 20),

          // Prayer Reminders
          _buildSwitchRow(
            title: context.tr('notifications'),
            subtitle: 'Daily sadhana notifications',
            value: _prayerReminders,
            onChanged: (val) => setState(() => _prayerReminders = val),
            primaryPlum: primaryPlum,
            charcoalText: charcoalText,
            subtitleColor: subtitleColor,
          ),
          const Divider(color: Color(0xFFF5EDF1), height: 20),

          // Language Selector
          BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, langState) {
              final currentLang = LanguageService.supportedLanguages.firstWhere(
                (l) => l.code == langState.languageCode,
                orElse: () => LanguageService.supportedLanguages.first,
              );
              return GestureDetector(
                onTap: () => context.push('/choose-language', extra: {'fromSettings': true}),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('languageSetting'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: charcoalText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${currentLang.englishName} (${currentLang.nativeName})',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: Color(0xFF8A7D84),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStateDropdown(Color primaryPlum, Color charcoalText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'STATE',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF7A6D74),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF5F8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFF1E3EA)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _states.contains(_stateController.text) ? _stateController.text : _states.first,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down_rounded, color: primaryPlum),
              items: _states
                  .map(
                    (st) => DropdownMenuItem(
                      value: st,
                      child: Text(st, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: charcoalText)),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _stateController.text = val);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStatCard({
    required Widget badgeWidget,
    required String value,
    required String label,
    required Color charcoalText,
    required Color primaryPlum,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFFBEBF1),
              shape: BoxShape.circle,
            ),
            child: Center(child: badgeWidget),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              fontFamily: 'serif',
              color: charcoalText,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7A6D74),
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color primaryPlum,
    required Color charcoalText,
    required Color subtitleColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: charcoalText,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF8E3763),
          activeTrackColor: const Color(0xFFFBEBF1),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF7A6D74),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF5F8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFF1E3EA)),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E1A1D),
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 17, color: const Color(0xFF8A7D84)),
              prefixIconConstraints: const BoxConstraints(minWidth: 30),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}
