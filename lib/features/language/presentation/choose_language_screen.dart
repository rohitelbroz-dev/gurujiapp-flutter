import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/localization/app_strings.dart';
import 'package:guruji/core/services/language_service.dart';
import 'package:guruji/features/language/bloc/language_bloc.dart';

class ChooseLanguageScreen extends StatefulWidget {
  final bool isFromSettings;

  const ChooseLanguageScreen({
    super.key,
    this.isFromSettings = false,
  });

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  late String _selectedCode;

  @override
  void initState() {
    super.initState();
    _selectedCode = context.read<LanguageBloc>().state.languageCode;
  }

  void _onSelectLanguage(String code) {
    setState(() {
      _selectedCode = code;
    });
    context.read<LanguageBloc>().add(ChangeLanguageEvent(code));
  }

  void _onContinue() async {
    await LanguageService.setLanguage(_selectedCode);
    if (!mounted) return;

    if (widget.isFromSettings) {
      context.pop();
    } else {
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Theme Colors matching the design mockup
    const Color bgGradientStart = Color(0xFFFFF9FA);
    const Color bgGradientEnd = Color(0xFFFBF1F5);
    const Color primaryPlum = Color(0xFF7E2B58);
    const Color subtitleColor = Color(0xFF5D5157);
    const Color buttonColor = Color(0xFFCE638F);
    const Color iconCircleBg = Color(0xFFF7E9F0);

    return Scaffold(
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
          child: Column(
            children: [
              if (widget.isFromSettings)
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryPlum),
                    onPressed: () => context.pop(),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      SizedBox(height: widget.isFromSettings ? 10 : topPadding > 0 ? 16 : 32),
                      
                      // Top Translate Circular Icon Badge
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: iconCircleBg,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryPlum.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '文A',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: primaryPlum,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        AppStrings.get('chooseLanguageTitle', lang: _selectedCode),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'serif',
                          color: primaryPlum,
                          height: 1.22,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        AppStrings.get('chooseLanguageSubtitle', lang: _selectedCode),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: subtitleColor,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Languages 2-Column Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: LanguageService.supportedLanguages.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.28,
                        ),
                        itemBuilder: (context, index) {
                          final language = LanguageService.supportedLanguages[index];
                          final isSelected = language.code == _selectedCode;
                          return _buildLanguageCard(
                            language: language,
                            isSelected: isSelected,
                            onTap: () => _onSelectLanguage(language.code),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Bottom "Get Started ->" Button Container
              Padding(
                padding: EdgeInsets.fromLTRB(24, 8, 24, bottomPadding + 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: buttonColor.withOpacity(0.45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.isFromSettings 
                              ? AppStrings.get('saveChanges', lang: _selectedCode)
                              : AppStrings.get('getStarted', lang: _selectedCode),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
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

  Widget _buildLanguageCard({
    required AppLanguage language,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const Color primaryPlum = Color(0xFF7E2B58);
    const Color selectedBg = Color(0xFFFDF0F5);
    const Color unselectedBorder = Color(0xFFEFE2E7);
    const Color selectedSubtext = Color(0xFFA65882);
    const Color unselectedSubtext = Color(0xFF6B6267);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? selectedBg : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isSelected ? primaryPlum : unselectedBorder,
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? primaryPlum.withOpacity(0.12)
                    : Colors.black.withOpacity(0.04),
                blurRadius: isSelected ? 12 : 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Checkmark indicator for selected state
              if (isSelected)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryPlum, width: 1.8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        size: 14,
                        color: primaryPlum,
                      ),
                    ),
                  ),
                ),

              // Native and English Language text
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      language.nativeName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'serif',
                        color: isSelected ? primaryPlum : const Color(0xFF1E1A1D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      language.englishName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? selectedSubtext : unselectedSubtext,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
