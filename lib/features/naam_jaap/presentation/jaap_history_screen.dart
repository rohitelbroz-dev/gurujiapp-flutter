import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/localization/app_strings.dart';
import 'package:guruji/core/widgets/app_bottom_nav.dart';

class JaapHistoryScreen extends StatefulWidget {
  const JaapHistoryScreen({super.key});

  @override
  State<JaapHistoryScreen> createState() => _JaapHistoryScreenState();
}

class _JaapHistoryScreenState extends State<JaapHistoryScreen> {
  int _activeFilterIndex = 1;
  final List<String> _filterKeys = ['week', 'month', 'year'];

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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
                    value: '1,248',
                    subtitleWidget: const Row(
                      children: [
                        Icon(Icons.trending_up_rounded, size: 16, color: Color(0xFF8A2E5B)),
                        SizedBox(width: 4),
                        Text(
                          '+12% this month',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8A2E5B),
                          ),
                        ),
                      ],
                    ),
                    charcoalText: charcoalText,
                  ),
                  const SizedBox(height: 14),

                  _buildMetricCard(
                    badgeIcon: '🔥',
                    isTextBadge: false,
                    watermarkIcon: Icons.local_fire_department_outlined,
                    label: context.tr('longestStreak').toUpperCase(),
                    value: '42 ${context.tr('days')}',
                    subtitleWidget: Text(
                      'Current: 14 ${context.tr('days')}',
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
                    value: '11 malas',
                    subtitleWidget: const Text(
                      'Consistent with goal',
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
                    icon: Icons.spa_outlined,
                    title: context.tr('morningMeditation'),
                    time: 'Today, 5:30 AM',
                    malas: '11',
                    duration: '45 mins',
                    primaryPlum: primaryPlum,
                    charcoalText: charcoalText,
                    subtitleColor: subtitleColor,
                  ),
                  const SizedBox(height: 12),

                  _buildSessionCard(
                    icon: Icons.nightlight_outlined,
                    title: context.tr('eveningReflection'),
                    time: 'Yesterday, 8:00 PM',
                    malas: '5',
                    duration: '20 mins',
                    primaryPlum: primaryPlum,
                    charcoalText: charcoalText,
                    subtitleColor: subtitleColor,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNav(currentTab: AppNavTab.jaap),
      ),
    ),
  );
}

  // ─── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(Color primaryPlum) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF221C20)),
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
        Container(
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
                color: Color(0xFF7E2B58),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Activity Card ─────────────────────────────────────────────────────────
  Widget _buildActivityCard(Color primaryPlum, Color charcoalText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF0F4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF9DEE7), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'serif',
                  color: primaryPlum,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: List.generate(_filterKeys.length, (idx) {
                    final key = _filterKeys[idx];
                    final isSelected = idx == _activeFilterIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _activeFilterIndex = idx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF8E3763) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          context.tr(key),
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF5A4E55),
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

          // Heatmap Grid (5 rows x 7 cols)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 28,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final intensities = [
                0.1, 0.4, 0.8, 1.0, 0.2, 0.6, 0.9,
                0.0, 0.7, 1.0, 0.5, 0.8, 0.3, 0.7,
                0.9, 0.6, 0.2, 0.8, 1.0, 0.4, 0.9,
                0.5, 0.8, 0.3, 0.7, 0.9, 0.6, 0.8,
              ];
              final intensity = intensities[index % intensities.length];
              return Container(
                decoration: BoxDecoration(
                  color: intensity == 0.0
                      ? Colors.white.withOpacity(0.5)
                      : primaryPlum.withOpacity(0.12 + (intensity * 0.75)),
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            },
          ),
          const SizedBox(height: 18),

          // Legend (LESS ... MORE)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'LESS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7A6D74),
                  letterSpacing: 0.8,
                ),
              ),
              Row(
                children: [0.2, 0.4, 0.7, 1.0].map((opacity) {
                  return Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    decoration: BoxDecoration(
                      color: primaryPlum.withOpacity(opacity),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }).toList(),
              ),
              const Text(
                'MORE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7A6D74),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Metric Card ───────────────────────────────────────────────────────────
  Widget _buildMetricCard({
    required String badgeIcon,
    required bool isTextBadge,
    IconData? watermarkIcon,
    String? watermark,
    required String label,
    required String value,
    required Widget subtitleWidget,
    required Color charcoalText,
  }) {
    const Color primaryPlum = Color(0xFF7E2B58);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Stack(
        children: [
          // Background Watermark
          Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: watermark != null
                  ? Text(
                      watermark,
                      style: TextStyle(
                        fontSize: 68,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFF3EDF1).withOpacity(0.8),
                      ),
                    )
                  : Icon(
                      watermarkIcon,
                      size: 64,
                      color: const Color(0xFFF3EDF1).withOpacity(0.8),
                    ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBEBF1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    badgeIcon,
                    style: TextStyle(
                      fontSize: isTextBadge ? 18 : 16,
                      fontWeight: FontWeight.w700,
                      color: primaryPlum,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7A6D74),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'serif',
                  color: charcoalText,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              subtitleWidget,
            ],
          ),
        ],
      ),
    );
  }

  // ─── Session Card ──────────────────────────────────────────────────────────
  Widget _buildSessionCard({
    required IconData icon,
    required String title,
    required String time,
    required String malas,
    required String duration,
    required Color primaryPlum,
    required Color charcoalText,
    required Color subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFBEBF1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: primaryPlum, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: charcoalText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$malas ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'serif',
                        color: primaryPlum,
                      ),
                    ),
                    TextSpan(
                      text: 'Malas',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: primaryPlum,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                duration,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
