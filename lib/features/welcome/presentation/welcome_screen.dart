import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/localization/app_strings.dart';
import 'package:guruji/core/services/language_service.dart';
import 'package:guruji/features/language/bloc/language_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSkipOrFinish() async {
    await LanguageService.setHasSeenWelcome(true);
    if (!mounted) return;
    context.go('/home');
  }

  void _onNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _onSkipOrFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const Color primaryPlum = Color(0xFF7E2B58);
    const Color buttonColor = Color(0xFF8E3763);
    const Color skipColor = Color(0xFF5E5258);
    const Color bgGradientStart = Color(0xFFFFFDFE);
    const Color bgGradientEnd = Color(0xFFFBF2F6);

    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, langState) {
        final lang = langState.languageCode;

        final List<Map<String, String>> slides = [
          {
            'brand': AppStrings.get('hariPath', lang: lang),
            'title': AppStrings.get('welcomeToHariPath', lang: lang),
            'desc': AppStrings.get('welcomeDesc1', lang: lang),
          },
          {
            'brand': AppStrings.get('hariPath', lang: lang),
            'title': AppStrings.get('naamJaapTitle', lang: lang),
            'desc': AppStrings.get('naamJaapDesc', lang: lang),
          },
          {
            'brand': AppStrings.get('hariPath', lang: lang),
            'title': AppStrings.get('amritVachanTitle', lang: lang),
            'desc': AppStrings.get('amritVachanDesc', lang: lang),
          },
        ];

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
                  // Top Bar with Skip button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _onSkipOrFinish,
                          style: TextButton.styleFrom(
                            foregroundColor: skipColor,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppStrings.get('skip', lang: lang),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: skipColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 18,
                                color: skipColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Center Hero Card with Illustration & Decorative elements
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Soft halo glow
                          Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFBEBF1).withOpacity(0.7),
                            ),
                          ),

                          // Sunburst decorative icon (top right)
                          Positioned(
                            top: 10,
                            right: 28,
                            child: Icon(
                              Icons.wb_sunny_outlined,
                              size: 24,
                              color: const Color(0xFFDCA4BD).withOpacity(0.8),
                            ),
                          ),

                          // Lotus / flower decorative icon (bottom left)
                          Positioned(
                            bottom: 12,
                            left: 32,
                            child: Icon(
                              Icons.spa_outlined,
                              size: 22,
                              color: const Color(0xFFDCA4BD).withOpacity(0.8),
                            ),
                          ),

                          // Hero image container
                          Container(
                            width: 250,
                            height: 270,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAF2E7),
                              borderRadius: BorderRadius.circular(36),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryPlum.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(36),
                              child: Image.asset(
                                'assets/images/temple_welcome.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback graceful banner if image is loading
                                  return Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Color(0xFFFCE3C8), Color(0xFF8E3763)],
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.temple_hindu_rounded,
                                        size: 72,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Text Slider & Indicators
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: slides.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final slide = slides[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 28),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Brand Title
                                    Text(
                                      slide['brand']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'serif',
                                        color: primaryPlum,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // Heading
                                    Text(
                                      slide['title']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'serif',
                                        color: Color(0xFF221C20),
                                      ),
                                    ),
                                    const SizedBox(height: 14),

                                    // Body Description
                                    Text(
                                      slide['desc']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF5A4E55),
                                        height: 1.45,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        // Page indicator dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            slides.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 6,
                              width: _currentPage == index ? 26 : 6,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? primaryPlum
                                    : const Color(0xFFE8D6DE),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // Bottom Action Button
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, bottomPadding + 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _onNext,
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
                              _currentPage == slides.length - 1
                                  ? AppStrings.get('getStarted', lang: lang)
                                  : AppStrings.get('next', lang: lang),
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
      },
    );
  }
}
