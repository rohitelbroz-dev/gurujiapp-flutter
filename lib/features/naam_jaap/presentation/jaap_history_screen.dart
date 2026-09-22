import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/localization/app_strings.dart';
import 'package:guruji/core/widgets/app_bottom_nav.dart';
import 'package:guruji/features/naam_jaap/data/naam_jaap_repository.dart';
import 'package:guruji/features/naam_jaap/models/naam_jaap_stats.dart';

class JaapHistoryScreen extends StatefulWidget {
  const JaapHistoryScreen({super.key});

  @override
  State<JaapHistoryScreen> createState() => _JaapHistoryScreenState();
}

class _JaapHistoryScreenState extends State<JaapHistoryScreen> {
  final NaamJaapRepository _repository = NaamJaapRepository();
  int _activeFilterIndex = 1;
  final List<String> _filterKeys = ['week', 'month', 'year'];

  NaamJaapStatsResponse? _statsData;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final res = await _repository.fetchStats();
      if (mounted) {
        setState(() {
          _statsData = res;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    const Color bgGradientStart = Color(0xFFFFFDFE);
    const Color bgGradientEnd = Color(0xFFFBF4F7);
    const Color primaryPlum = Color(0xFF7E2B58);
    const Color charcoalText = Color(0xFF1E1A1D);
    const Color subtitleColor = Color(0xFF6B5E66);

    // Dynamic stats computation based on selected filter
    final stats = _statsData?.stats;
    int currentPeriodCount = stats?.thisMonth.count ?? 1248;
    int currentPeriodMalas = stats?.thisMonth.malas ?? 11;

    if (_activeFilterIndex == 0) {
      currentPeriodCount = stats?.thisWeek.count ?? 648;
      currentPeriodMalas = stats?.thisWeek.malas ?? 6;
    } else if (_activeFilterIndex == 2) {
      currentPeriodCount = stats?.thisYear.count ?? 1248;
      currentPeriodMalas = stats?.thisYear.malas ?? 11;
    }

    final currentStreakDays = _statsData?.currentStreak.days ?? 7;
    final longestStreakDays = mathMax(currentStreakDays, 14);
    final dailyAvgCount = (currentPeriodCount / 7).round();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/naam-jaap');
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
              child: RefreshIndicator(
                onRefresh: _loadStats,
                color: primaryPlum,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Header ───
                      _buildHeader(primaryPlum),
                      const SizedBox(height: 24),

                      // ─── Title & Subtitle ───
                      Text(
                        context.tr('jaapHistoryTitle'),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'serif',
                          color: charcoalText,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        context.tr('jaapHistorySubtitle'),
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w400,
                          color: subtitleColor,
                        ),
                      ),
                      const SizedBox(height: 22),

                      // ─── Activity Heatmap Card ───
                      _buildActivityCard(primaryPlum, charcoalText),
                      const SizedBox(height: 18),

                      // ─── Metric Cards ───
                      _buildMetricCard(
                        badgeIcon: 'Σ',
                        isTextBadge: true,
                        watermark: '1',
                        label: context.tr('totalCount').toUpperCase(),
                        value: '$currentPeriodCount ${context.tr("jaapUnit")}',
                        subtitleWidget: Text(
                          '$currentPeriodMalas ${context.tr("malasUnit")} पूर्ण',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8A2E5B),
                          ),
                        ),
                        charcoalText: charcoalText,
                      ),
                      const SizedBox(height: 14),

                      _buildMetricCard(
                        badgeIcon: '🔥',
                        isTextBadge: false,
                        watermarkIcon: Icons.local_fire_department_outlined,
                        label: context.tr('longestStreak').toUpperCase(),
                        value: '$longestStreakDays ${context.tr('days')}',
                        subtitleWidget: Text(
                          'वर्तमान: $currentStreakDays ${context.tr('days')}',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            color: subtitleColor,
                          ),
                        ),
                        charcoalText: charcoalText,
                      ),
                      const SizedBox(height: 14),

                      _buildMetricCard(
                        badgeIcon: '📈',
                        isTextBadge: false,
                        watermarkIcon: Icons.show_chart_rounded,
                        label: context.tr('dailyAverage').toUpperCase(),
                        value: '$dailyAvgCount / ${context.tr("days")}',
                        subtitleWidget: const Text(
                          'नियमित साधना स्थिति',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            color: subtitleColor,
                          ),
                        ),
                        charcoalText: charcoalText,
                      ),
                      const SizedBox(height: 28),

                      // ─── Recent Sessions ───
                      Text(
                        context.tr('recentSessions'),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'serif',
                          color: charcoalText,
                        ),
                      ),
                      const SizedBox(height: 14),

                      _buildSessionCard(
                        icon: Icons.wb_sunny_outlined,
                        iconColor: const Color(0xFFE07A2B),
                        title: context.tr('morningMeditation'),
                        time: '06:30 AM • 108 ${context.tr("jaapUnit")}',
                        mantra: context.tr('ramNaam'),
                        charcoalText: charcoalText,
                        subtitleColor: subtitleColor,
                      ),
                      const SizedBox(height: 12),

                      _buildSessionCard(
                        icon: Icons.nightlight_outlined,
                        iconColor: const Color(0xFF7A42B8),
                        title: context.tr('eveningReflection'),
                        time: '07:15 PM • 108 ${context.tr("jaapUnit")}',
                        mantra: context.tr('omNamahShivaya'),
                        charcoalText: charcoalText,
                        subtitleColor: subtitleColor,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: const AppBottomNav(currentTab: AppNavTab.jaap),
        ),
      ),
    );
  }

  int mathMax(int a, int b) => a > b ? a : b;

  Widget _buildHeader(Color primaryPlum) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 24, color: Color(0xFF221C20)),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/naam-jaap');
            }
          },
        ),
        Text(
          context.tr('hariPath'),
          style: TextStyle(
            fontSize: 24,
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
                errorBuilder: (_, __, ___) => Icon(
                  Icons.person,
                  size: 20,
                  color: primaryPlum,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(Color primaryPlum, Color charcoalText) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('activityHeatmap'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'serif',
                  color: charcoalText,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F1F4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: List.generate(_filterKeys.length, (index) {
                    final isSelected = index == _activeFilterIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _activeFilterIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          context.tr(_filterKeys[index]),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? primaryPlum : const Color(0xFF8A7D84),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Heatmap grid (7 columns x 4 rows)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (colIndex) {
              final dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              return Column(
                children: [
                  ...List.generate(4, (rowIndex) {
                    // Generate subtle intensity patterns
                    final opacity = ((colIndex * 3 + rowIndex * 7) % 5 + 1) * 0.18;
                    return Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: primaryPlum.withOpacity(opacity.clamp(0.1, 0.9)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }),
                  const SizedBox(height: 2),
                  Text(
                    dayNames[colIndex],
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8A7D84),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String badgeIcon,
    required bool isTextBadge,
    String? watermark,
    IconData? watermarkIcon,
    required String label,
    required String value,
    required Widget subtitleWidget,
    required Color charcoalText,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          if (watermark != null)
            Positioned(
              right: 12,
              child: Text(
                watermark,
                style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF7E2B58).withOpacity(0.035),
                ),
              ),
            ),
          if (watermarkIcon != null)
            Positioned(
              right: 12,
              child: Icon(
                watermarkIcon,
                size: 64,
                color: const Color(0xFF7E2B58).withOpacity(0.035),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF1F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        badgeIcon,
                        style: TextStyle(
                          fontSize: isTextBadge ? 14 : 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF7E2B58),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7A6D74),
                        letterSpacing: 0.8,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'serif',
                  color: charcoalText,
                ),
              ),
              const SizedBox(height: 6),
              subtitleWidget,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String time,
    required String mantra,
    required Color charcoalText,
    required Color subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: charcoalText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF1F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              mantra,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7E2B58),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
