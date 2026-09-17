import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guruji/app.dart';
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

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _gotraController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedProfileImageFile;
  String? _profileImageUrl;
  Profile? _originalProfile;

  bool _isSaving = false;
  bool _profileLoading = false;

  late AnimationController _animController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Delhi',
  ];

  String _selectedGender = 'Male';
  String _selectedState = 'Uttar Pradesh';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
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
    _animController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty && phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone number must be exactly 10 digits'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_originalProfile == null) return;

    final updatedName = _nameController.text.trim();
    final updatedEmail = _emailController.text.trim();
    final updatedPhone = phone;
    final updatedCity = _cityController.text.trim();
    final updatedState = _selectedState.trim();
    final updatedGotra = _gotraController.text.trim();
    final updatedDob = _dateOfBirthController.text.trim();

    final updateData = <String, dynamic>{};

    if (updatedName != _originalProfile!.name) {
      updateData['name'] = updatedName;
    }
    if (updatedEmail != _originalProfile!.email) {
      updateData['email'] = updatedEmail;
    }
    if (updatedPhone != _originalProfile!.phone) {
      updateData['phone'] = updatedPhone;
    }
    if (updatedCity != _originalProfile!.city) {
      updateData['city'] = updatedCity;
    }
    if (updatedState != _originalProfile!.state) {
      updateData['state'] = updatedState;
    }
    if (updatedGotra != _originalProfile!.gotra) {
      updateData['gotra'] = updatedGotra;
    }

    final originalDob = _originalProfile!.dateOfBirth;
    String formattedOriginalDob = originalDob;
    if (originalDob.isNotEmpty) {
      try {
        final parsed = DateTime.parse(originalDob);
        formattedOriginalDob =
            '${parsed.year.toString().padLeft(4, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
      } catch (_) {
        formattedOriginalDob = originalDob;
      }
    }
    if (updatedDob != formattedOriginalDob) {
      updateData['dateOfBirth'] = updatedDob;
    }

    if (updateData.isEmpty && _selectedProfileImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes to save'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    context.read<AuthBloc>().add(
      UpdateProfileEvent(
        name: updateData['name'] ?? '',
        phone: updateData['phone'] ?? '',
        email: updateData['email'] ?? '',
        city: updateData['city'] ?? '',
        state: updateData['state'] ?? '',
        dateOfBirth: updateData['dateOfBirth'] ?? '',
        gotra: updateData['gotra'] ?? '',
        profileImageFile: _selectedProfileImageFile,
      ),
    );
  }

  Future<void> _pickProfileImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    setState(() {
      _selectedProfileImageFile = File(pickedFile.path);
    });
  }

  void _populateProfile(Profile profile) {
    _originalProfile = profile;
    _profileImageUrl = profile.profileImage;
    _selectedProfileImageFile = null;
    _nameController.text = profile.name;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _cityController.text = profile.city;
    _stateController.text = profile.state;
    _gotraController.text = profile.gotra;

    final rawDob = profile.dateOfBirth;
    if (rawDob.isNotEmpty) {
      try {
        final parsed = DateTime.parse(rawDob);
        _dateOfBirthController.text =
            '${parsed.year.toString().padLeft(4, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
      } catch (_) {
        _dateOfBirthController.text = rawDob;
      }
    }

    if (_states.contains(_stateController.text)) {
      _selectedState = _stateController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ProfileLoading) {
          setState(() => _profileLoading = true);
        } else if (state is ProfileLoadSuccess) {
          _populateProfile(state.profile);
          setState(() => _profileLoading = false);
        } else if (state is ProfileUpdateSuccess) {
          _populateProfile(state.profile);
          setState(() {
            _profileLoading = false;
            _isSaving = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AuthFailure) {
          setState(() {
            _profileLoading = false;
            _isSaving = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
            ),
          );
        } else if (state is LogoutSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logged out successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F4F9),
        body: Column(
          children: [
            // _buildTopBanner(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Expanded(
              child: AnimatedBuilder(
                animation: _animController,
                builder: (_, child) => Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: child,
                  ),
                ),
                child: _profileLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            _buildProfileHeader(),
                            const SizedBox(height: 24),
                            _buildFormCard(),
                            const SizedBox(height: 14),
                            _buildSaveButton(),
                            const SizedBox(height: 12),
                            _buildLanguageSettingTile(),
                            const SizedBox(height: 12),
                            _buildLogoutButton(),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const AppBottomNav(currentTab: AppNavTab.profile),
      ),
    );
  }

  Widget _buildTopBanner() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE566), Color(0xFFFFD000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD000).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9D00), Color(0xFFFF6B00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF9D00).withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'राधा',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'राधा नाम जप',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.brown.shade800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Start your daily chant',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.brown.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A9E8F), Color(0xFF0D7A6E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1A9E8F).withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'D7',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Text(
          'Profile Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1A9E8F).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_rounded,
                size: 13,
                color: const Color(0xFF1A9E8F),
              ),
              const SizedBox(width: 4),
              Text(
                'VERIFIED ACCOUNT',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A9E8F),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Stack(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A9E8F), Color(0xFF0D7A6E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A9E8F).withOpacity(0.3),
                    blurRadius: 18,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 3),
              ),
              alignment: Alignment.center,
              child: ClipOval(
                child: SizedBox(
                  width: 84,
                  height: 84,
                  child: _selectedProfileImageFile != null
                      ? Image.file(
                          _selectedProfileImageFile!,
                          fit: BoxFit.cover,
                        )
                      : (_profileImageUrl != null &&
                            _profileImageUrl!.isNotEmpty)
                      ? Image.network(
                          _profileImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        )
                      : const Center(
                          child: Text(
                            'D7',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: GestureDetector(
                onTap: _pickProfileImage,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInputField(
            label: 'Full Name',
            controller: _nameController,
            icon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 18),
          _buildInputField(
            label: 'Email',
            controller: _emailController,
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 18),
          _buildInputField(
            label: 'Phone',
            controller: _phoneController,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          const SizedBox(height: 18),
          _buildInputField(
            label: 'City',
            controller: _cityController,
            icon: Icons.location_city_rounded,
          ),
          const SizedBox(height: 18),
          _buildStateDropdown(),
          const SizedBox(height: 18),
          _buildInputField(
            label: 'Gotra',
            controller: _gotraController,
            icon: Icons.family_restroom_rounded,
          ),
          const SizedBox(height: 18),
          _buildInputField(
            label: 'Date of Birth',
            controller: _dateOfBirthController,
            icon: Icons.calendar_today_rounded,
            keyboardType: TextInputType.datetime,
          ),
        ],
      ),
    );
  }

  Widget _buildStateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 7),
          child: Text(
            'STATE',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary.withOpacity(0.45),
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF6F4F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedState,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.map_rounded,
                size: 18,
                color: AppTheme.primaryColor.withOpacity(0.7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppTheme.primaryColor,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFF6F4F9),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            items: _states
                .map(
                  (state) => DropdownMenuItem(value: state, child: Text(state)),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selectedState = value;
                _stateController.text = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 7),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary.withOpacity(0.45),
              letterSpacing: 0.8,
            ),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              size: 18,
              color: AppTheme.primaryColor.withOpacity(0.7),
            ),
            filled: true,
            fillColor: const Color(0xFFF6F4F9),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _isSaving ? null : _saveProfile,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isSaving
                ? [Colors.grey.shade400, Colors.grey.shade500]
                : [AppTheme.primaryColor, AppTheme.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: _isSaving
              ? []
              : [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: _isSaving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Save Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    );
  }

  Widget _buildLanguageSettingTile() {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        final currentLang = LanguageService.supportedLanguages.firstWhere(
          (l) => l.code == state.languageCode,
          orElse: () => LanguageService.supportedLanguages.first,
        );
        return GestureDetector(
          onTap: () {
            context.push('/choose-language', extra: {'fromSettings': true});
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7E9F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      '文A',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7E2B58),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'App Language',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF221C20),
                        ),
                      ),
                      Text(
                        '${currentLang.nativeName} (${currentLang.englishName})',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7E2B58),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<AuthBloc>().add(const LogoutEvent());
                },
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.red.shade600),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.shade400, width: 2),
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.red.shade600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                Icons.home_rounded,
                'Home',
                false,
                () => context.go('/home'),
              ),
              _navItem(
                Icons.leaderboard_rounded,
                'Events',
                false,
                () => context.go('/events'),
              ),
              _navItem(
                Icons.play_circle_fill_rounded,
                'Shorts',
                false,
                () => context.go('/shorts'),
              ),
              _navItem(
                Icons.video_library_rounded,
                'Videos',
                false,
                () => context.go('/videos'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? Colors.deepPurple.shade100 : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: isActive
                  ? Colors.deepPurple.shade600
                  : Colors.grey.shade400,
              size: 22,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive
                  ? Colors.deepPurple.shade600
                  : Colors.grey.shade400,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
