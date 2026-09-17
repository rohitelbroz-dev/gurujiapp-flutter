import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/services/user_persistence_service.dart';

class JaapIntroScreen extends StatefulWidget {
  const JaapIntroScreen({super.key});

  @override
  State<JaapIntroScreen> createState() => _JaapIntroScreenState();
}

class _JaapIntroScreenState extends State<JaapIntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() async {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      final isLoggedIn = await UserPersistenceService.isLoggedIn();
      if (!mounted) return;
      if (isLoggedIn) {
        context.go('/naam-jaap');
      } else {
        context.go('/login', extra: {'redirectTo': '/naam-jaap'});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const Color bgGradientStart = Color(0xFFFFFDFE);
    const Color bgGradientEnd = Color(0xFFFBF2F6);
    const Color primaryPlum = Color(0xFF7E2B58);
    const Color charcoalText = Color(0xFF1E1A1D);
    const Color subtitleColor = Color(0xFF5A4E55);
    const Color buttonColor = Color(0xFF8E3763);

    final List<Map<String, String>> slides = [
      {
        'title': 'Track Your Daily\nChants',
        'desc':
            'Focus your mind with our digital mala counter. Seamlessly maintain your daily rhythm and spiritual discipline.',
      },
      {
        'title': 'Build Spiritual\nStreaks',
        'desc':
            'Cultivate divine habits with daily jaap targets, milestone badges, and guided mindfulness counters.',
      },
      {
        'title': 'Detailed History\n& Insights',
        'desc':
            'Visualize your sacred devotion over time with comprehensive heatmaps, statistics, and session logs.',
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
              // Top back button if navigatable
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryPlum, size: 20),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/home');
                        }
                      },
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        final isLoggedIn = await UserPersistenceService.isLoggedIn();
                        if (!mounted) return;
                        if (isLoggedIn) {
                          context.go('/naam-jaap');
                        } else {
                          context.go('/login', extra: {'redirectTo': '/naam-jaap'});
                        }
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF756870),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Center Hero Mala Image
              Expanded(
                flex: 5,
                child: Center(
                  child: Container(
                    width: 270,
                    height: 270,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(38),
                      boxShadow: [
                        BoxShadow(
                          color: primaryPlum.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(22),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Image.asset(
                        'assets/images/mala_intro.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFFAF2E7),
                          child: const Center(
                            child: Icon(
                              Icons.circle_outlined,
                              size: 90,
                              color: Color(0xFFC75F8A),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Text Content & Indicators
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: slides.length,
                        onPageChanged: (idx) {
                          setState(() {
                            _currentPage = idx;
                          });
                        },
                        itemBuilder: (context, index) {
                          final slide = slides[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  slide['title']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'serif',
                                    color: charcoalText,
                                    height: 1.22,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  slide['desc']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: subtitleColor,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Dot indicators
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
                    const SizedBox(height: 28),
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
                          _currentPage == slides.length - 1 ? 'Get Started' : 'Next',
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
}
