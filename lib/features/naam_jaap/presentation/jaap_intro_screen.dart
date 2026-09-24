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

  final List<Map<String, String>> slides = [
    {
      'title': 'Track Your Daily Chants',
      'desc':
          'Focus your mind with our digital mala counter. Seamlessly maintain your spiritual rhythm and track progress.',
    },
    {
      'title': 'Detailed History & Insights',
      'desc':
          'Visualize your sacred devotion over time with comprehensive heatmaps, statistics, and session logs.',
    },
    {
      'title': 'Spiritual Dedication',
      'desc':
          'Offer your daily sadhana with pure sankalpa and dedication towards your loved ones and spiritual growth.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() async {
    if (_currentPage < slides.length - 1) {
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
    final size = MediaQuery.sizeOf(context);
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    const Color primaryPlum = Color(0xFF7E2B58);
    const Color buttonColor = Color(0xFF8E3763);
    const Color charcoalText = Color(0xFF1E1A1D);
    const Color subtitleColor = Color(0xFF6E5D68);
    const Color bgGradientStart = Color(0xFFFFFDFE);
    const Color bgGradientEnd = Color(0xFFFBF2F6);

    // Calculate dynamic responsive sizing
    final imageBoxSize = (size.height * 0.26).clamp(160.0, 220.0);

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // Top bar with Back and Skip
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF756870),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Center Hero Mala Image (Responsive)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Container(
                        width: imageBoxSize,
                        height: imageBoxSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: primaryPlum.withValues(alpha: 0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/mala_intro.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFFAF2E7),
                              child: const Center(
                                child: Icon(
                                  Icons.circle_outlined,
                                  size: 70,
                                  color: Color(0xFFC75F8A),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Text Content & Slide Indicators
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
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                slide['title']!,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'serif',
                                  color: charcoalText,
                                  height: 1.2,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                slide['desc']!,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w400,
                                  color: subtitleColor,
                                  height: 1.4,
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
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 5,
                        width: _currentPage == index ? 22 : 5,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? primaryPlum : const Color(0xFFE8D6DE),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bottom Action Button
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, bottomPadding + 14),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: buttonColor.withValues(alpha: 0.35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPage == slides.length - 1 ? 'Get Started' : 'Next',
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
