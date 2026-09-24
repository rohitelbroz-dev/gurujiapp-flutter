import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/localization/app_strings.dart';
import 'package:guruji/core/widgets/app_bottom_nav.dart';
import 'package:guruji/features/naam_jaap/bloc/naam_jaap_bloc.dart';
import 'package:guruji/features/naam_jaap/data/naam_jaap_repository.dart';

class NaamJaapScreen extends StatefulWidget {
  const NaamJaapScreen({super.key});

  @override
  State<NaamJaapScreen> createState() => _NaamJaapScreenState();
}

class _NaamJaapScreenState extends State<NaamJaapScreen>
    with SingleTickerProviderStateMixin {
  final NaamJaapRepository _repository = NaamJaapRepository();

  int _selectedMantraIndex = 0;
  final List<String> _mantraKeys = [
    'ramNaam',
    'krishnaNaam',
    'radhaNaam',
    'omNamahShivaya',
  ];

  int _currentBeads = 0;
  int _completedMalas = 0;
  int _streakDays = 1;
  int _dailyGoalMalas = 11;
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;

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
    _loadLiveStatsAndSettings();
  }

  Future<void> _loadLiveStatsAndSettings() async {
    final goal = await _repository.getDailyGoal();
    final sound = await _repository.isSoundEnabled();
    final haptics = await _repository.isHapticsEnabled();

    final draft = await _repository.getDraftSessionCount();
    try {
      final stats = await _repository.fetchStats();
      if (mounted) {
        setState(() {
          _dailyGoalMalas = goal;
          _soundEnabled = sound;
          _hapticsEnabled = haptics;
          _currentBeads = draft % 108;
          _completedMalas = stats.stats.today.malas + (draft ~/ 108);
          _streakDays = stats.currentStreak.days > 0 ? stats.currentStreak.days : 1;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _dailyGoalMalas = goal;
          _soundEnabled = sound;
          _hapticsEnabled = haptics;
          _currentBeads = draft % 108;
          _completedMalas = draft ~/ 108;
        });
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onTapCount() {
    if (_hapticsEnabled) {
      HapticFeedback.lightImpact();
    }
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
    _pulseController.forward(from: 0.94);

    setState(() {
      _currentBeads++;
      if (_currentBeads >= 108) {
        _currentBeads = 0;
        _completedMalas++;
        if (_hapticsEnabled) {
          HapticFeedback.mediumImpact();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('malaCompletedToast')),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF7E2B58),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final totalChants = (_completedMalas * 108) + _currentBeads;
    _repository.saveDraftSessionCount(totalChants);
    context.read<NaamJaapBloc>().add(const NaamJaapIncremented());
  }

  void _showGoalSelector() {
    const goals = [1, 5, 11, 21, 51, 108];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr('dailyMalaGoal'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'serif',
                  color: Color(0xFF7E2B58),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: goals.map((g) {
                  final isSelected = g == _dailyGoalMalas;
                  return ChoiceChip(
                    label: Text('$g ${context.tr("malasUnit")}'),
                    selected: isSelected,
                    selectedColor: const Color(0xFF7E2B58),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF1E1A1D),
                      fontWeight: FontWeight.w700,
                    ),
                    onSelected: (val) {
                      if (val) {
                        setState(() => _dailyGoalMalas = g);
                        _repository.setDailyGoal(g);
                        Navigator.pop(ctx);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showSaveSessionDialog() {
    final state = context.read<NaamJaapBloc>().state;
    final count = state.totalJaap;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              const Text('🌸', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'प्रभु चरणों में समर्पण',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'serif',
                    color: Color(0xFF7E2B58),
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            count > 0
                ? 'क्या आप आज के $count नाम जप प्रभु के पावन चरणों में समर्पित करना चाहते हैं?'
                : 'आपने अभी तक कोई नया जप नहीं किया है। पहले गिनती शुरू करें।',
            style: const TextStyle(fontSize: 14, color: Color(0xFF4A3E45)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.tr('cancel')),
            ),
            if (count > 0)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7E2B58),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  context.read<NaamJaapBloc>().add(const NaamJaapSessionSaved());
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✨ आपके नाम जप सफलतापूर्वक समर्पित व सहेजे गए!'),
                      backgroundColor: Color(0xFF2E8A68),
                    ),
                  );
                  _loadLiveStatsAndSettings();
                },
                child: const Text('समर्पण करें', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
          ],
        );
      },
    );
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
                  // ─── Header: Back, Hari Path, Sound, Goal ───
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
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
                        Expanded(
                          child: Text(
                            context.tr('hariPath'),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'serif',
                              color: primaryPlum,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        // Sound toggle
                        IconButton(
                          icon: Icon(
                            _soundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                            size: 22,
                            color: _soundEnabled ? primaryPlum : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() => _soundEnabled = !_soundEnabled);
                            _repository.setSoundEnabled(_soundEnabled);
                          },
                        ),
                        // Goal selector button
                        GestureDetector(
                          onTap: _showGoalSelector,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7E9F0),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE8D0DC)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.flag_rounded, size: 14, color: primaryPlum),
                                const SizedBox(width: 4),
                                Text(
                                  '$_dailyGoalMalas ${context.tr("malasUnit")}',
                                  style: const TextStyle(
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
                  ),
                  const SizedBox(height: 4),

                  // ─── Mantra Selector Chips ───
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _mantraKeys.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final key = _mantraKeys[index];
                        final isSelected = index == _selectedMantraIndex;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMantraIndex = index;
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
                              context.tr(key),
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
                                    const SizedBox(height: 20),

                                    // "TAP TO COUNT"
                                    Text(
                                      context.tr('tapToCount').toUpperCase(),
                                      style: const TextStyle(
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
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

                  // ─── Dedicate / Save Session Button ───
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _showSaveSessionDialog,
                        icon: const Icon(Icons.volunteer_activism_rounded, size: 18, color: primaryPlum),
                        label: const Text(
                          'समर्पण करें (Save Session)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryPlum),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE8D0DC), width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

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
                              Text(
                                context.tr('today').toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7A6D74),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$_completedMalas / $_dailyGoalMalas',
                                style: TextStyle(
                                  fontSize: 20,
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
                              Text(
                                context.tr('streak').toUpperCase(),
                                style: const TextStyle(
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'serif',
                                            color: charcoalText,
                                          ),
                                        ),
                                        TextSpan(
                                          text: context.tr('days'),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
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

                          // Column 3: HISTORY
                          GestureDetector(
                            onTap: () => context.push('/jaap-history'),
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  context.tr('history').toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF7A6D74),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFFE5D5DC), width: 1.5),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 16,
                                      color: Color(0xFF221C20),
                                    ),
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
    final radius = size.width / 2 - 16;
    const totalBeads = 108;

    final filledBeadsCount = (progress * totalBeads).round();

    for (int i = 0; i < totalBeads; i++) {
      final angle = (i * (2 * math.pi / totalBeads)) - (math.pi / 2);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      final isFilled = i < filledBeadsCount;
      final isCurrent = i == filledBeadsCount;

      final paint = Paint()
        ..color = isFilled
            ? progressColor
            : (isCurrent ? progressColor.withOpacity(0.5) : trackColor)
        ..style = PaintingStyle.fill;

      final double beadRadius = (i % 27 == 0) ? 3.6 : 2.2;
      canvas.drawCircle(Offset(x, y), isCurrent ? 4.2 : beadRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MalaRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
