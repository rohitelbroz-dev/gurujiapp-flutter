import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/widgets/app_bottom_nav.dart';
import 'package:guruji/features/naam_jaap/bloc/naam_jaap_bloc.dart';

class NaamJaapScreen extends StatefulWidget {
  const NaamJaapScreen({super.key});

  @override
  State<NaamJaapScreen> createState() => _NaamJaapScreenState();
}

class _NaamJaapScreenState extends State<NaamJaapScreen>
    with SingleTickerProviderStateMixin {
  String _selectedMantra = 'Ram Naam';
  final List<String> _mantras = [
    'Ram Naam',
    'Krishna Naam',
    'Radha Naam',
    'Om Namah Shivaya',
    'Custom...',
  ];

  int _currentBeads = 0;
  int _completedMalas = 11;
  int _streakDays = 7;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeOut,
    );

    context.read<NaamJaapBloc>().add(const NaamJaapDraftRestored());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onTapCount() {
    HapticFeedback.lightImpact();
    _pulseController.forward(from: 0.94);

    setState(() {
      _currentBeads++;
      if (_currentBeads >= 108) {
        _currentBeads = 0;
        _completedMalas++;
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🌸 1 Mala (108 Chants) Completed! Haribol!'),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFF7E2B58),
          ),
        );
      }
    });

    context.read<NaamJaapBloc>().add(const NaamJaapIncremented());
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
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
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
              child: Column(
                children: [
                  // ─── Header: Back, Hari Path, Profile ───
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, size: 24, color: Color(0xFF221C20)),
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/home');
                            }
                          },
                        ),
                      Text(
                        'Hari Path',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'serif',
                          color: primaryPlum,
                          letterSpacing: -0.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/profile'),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE8D0DC), width: 1.5),
                            color: const Color(0xFFFAF2E7),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/temple_welcome.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person,
                                size: 20,
                                color: primaryPlum,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // ─── Mantra Selector Chips ───
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _mantras.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final mantra = _mantras[index];
                      final isSelected = mantra == _selectedMantra;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMantra = mantra;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF8E3763) : Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF8E3763) : const Color(0xFFEBDCE3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? const Color(0xFF8E3763).withOpacity(0.25)
                                    : Colors.black.withOpacity(0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            mantra,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.white : charcoalText,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ─── Center Mala Ring & Tap Counter ───
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: _onTapCount,
                      behavior: HitTestBehavior.opaque,
                      child: ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          width: 310,
                          height: 310,
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Circular Ring Canvas
                              CustomPaint(
                                size: const Size(300, 300),
                                painter: _MalaRingPainter(
                                  progress: _currentBeads / 108.0,
                                  trackColor: const Color(0xFFEEDFE6),
                                  progressColor: const Color(0xFF8E3763),
                                ),
                              ),

                              // Center Target Bead & Tap To Count
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Minimalist Target Bead Icon
                                  Container(
                                    width: 62,
                                    height: 62,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF1E1A1D),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // "TAP TO COUNT"
                                  const Text(
                                    'TAP TO COUNT',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF6B5E66),
                                      letterSpacing: 1.6,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Beads Counter
                                  Text(
                                    '$_currentBeads / 108',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: primaryPlum.withOpacity(0.85),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ─── Bottom Floating Stats Card ───
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Column 1: TODAY
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'TODAY',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF7A6D74),
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$_completedMalas',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'serif',
                                color: charcoalText,
                              ),
                            ),
                          ],
                        ),

                        Container(width: 1, height: 32, color: const Color(0xFFF0E4EB)),

                        // Column 2: STREAK
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'STREAK',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF7A6D74),
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Text('🔥', style: TextStyle(fontSize: 15)),
                                const SizedBox(width: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '$_streakDays ',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'serif',
                                          color: charcoalText,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Days',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w500,
                                          color: subtitleColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Container(width: 1, height: 32, color: const Color(0xFFF0E4EB)),

                        // Column 3: HISTORY (Clickable)
                        GestureDetector(
                          onTap: () => context.push('/jaap-history'),
                          behavior: HitTestBehavior.opaque,
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                size: 20,
                                color: Color(0xFF221C20),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'HISTORY',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF221C20),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
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
        bottomNavigationBar: const AppBottomNav(currentTab: AppNavTab.jaap),
      ),
    ),
  );
}
}

// ─── Custom Painter for Circular Mala Ring ──────────────────────────────────
class _MalaRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  _MalaRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background track ring
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawCircle(center, radius, trackPaint);

    // Active progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4.5;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }

    // Top Guru bead marker
    final guruBeadPaint = Paint()..color = progressColor;
    final topBeadPos = Offset(center.dx, center.dy - radius);
    canvas.drawCircle(topBeadPos, 5, guruBeadPaint);
  }

  @override
  bool shouldRepaint(covariant _MalaRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}
