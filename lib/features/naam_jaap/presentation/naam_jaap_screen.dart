import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/app.dart';
import 'package:guruji/features/naam_jaap/bloc/naam_jaap_bloc.dart';
import 'package:guruji/features/naam_jaap/data/naam_jaap_repository.dart';
import 'package:guruji/features/naam_jaap/models/naam_jaap_stats.dart';

enum _NaamJaapTab { chant, stats }

class NaamJaapScreen extends StatefulWidget {
  const NaamJaapScreen({super.key});

  @override
  State<NaamJaapScreen> createState() => _NaamJaapScreenState();
}

class _NaamJaapScreenState extends State<NaamJaapScreen> {
  final NaamJaapRepository _repository = NaamJaapRepository();
  _NaamJaapTab _activeTab = _NaamJaapTab.chant;
  Future<NaamJaapStatsResponse>? _statsFuture;

  void _showStatsTab() {
    setState(() {
      _activeTab = _NaamJaapTab.stats;
      _statsFuture ??= _repository.fetchStats();
    });
  }

  void _showChantTab() {
    setState(() {
      _activeTab = _NaamJaapTab.chant;
    });
  }

  void _refreshStats() {
    setState(() {
      _statsFuture = _repository.fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NaamJaapBloc, NaamJaapState>(
      listenWhen: (previous, current) =>
          previous.saveStatus != current.saveStatus &&
          current.saveStatus != NaamJaapSaveStatus.idle,
      listener: (context, state) {
        if (state.saveStatus == NaamJaapSaveStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Jaap session saved successfully.'),
              backgroundColor: AppTheme.primaryDark,
            ),
          );
          if (_activeTab == _NaamJaapTab.stats) {
            _refreshStats();
          }
        } else if (state.saveStatus == NaamJaapSaveStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }

        context.read<NaamJaapBloc>().add(const NaamJaapSaveStatusCleared());
      },
      child: BlocBuilder<NaamJaapBloc, NaamJaapState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F1E7),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD94F), Color(0xFFF8F3E8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.34],
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 108,
                      left: -50,
                      child: _glowCircle(
                        color: AppTheme.primaryColor.withOpacity(0.18),
                        size: 180,
                      ),
                    ),
                    Positioned(
                      right: -55,
                      bottom: 180,
                      child: _glowCircle(
                        color: const Color(0xFFD27B47).withOpacity(0.15),
                        size: 210,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: Column(
                        children: [
                          const SizedBox(height: 22),
                          Expanded(
                            child: _activeTab == _NaamJaapTab.chant
                                ? _buildChantView(context, state)
                                : _buildStatsView(),
                          ),
                          _buildBottomBar(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChantView(BuildContext context, NaamJaapState state) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const Spacer(), _buildMaalaCard(state)],
        ),
        const SizedBox(height: 28),
        Text(
          '${state.totalJaap}',
          style: const TextStyle(
            fontSize: 72,
            height: 1,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6B2719),
            letterSpacing: -2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'TOTAL JAAP',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary.withOpacity(0.7),
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 38),
        _buildSaveButton(context, state),
        const Spacer(),
        _buildChantButton(context, state),
        const Spacer(),
      ],
    );
  }

  Widget _buildStatsView() {
    final future = _statsFuture ??= _repository.fetchStats();

    return FutureBuilder<NaamJaapStatsResponse>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildStatsError(
            snapshot.error.toString().replaceAll('Exception: ', ''),
          );
        }

        final data = snapshot.data;
        if (data == null) {
          return _buildStatsError('Unable to load stats right now.');
        }

        final statCards = <_StatCardData>[
          _StatCardData('Today', data.stats.today),
          _StatCardData('This Week', data.stats.thisWeek),
          _StatCardData('This Month', data.stats.thisMonth),
          _StatCardData('This Year', data.stats.thisYear),
          _StatCardData('Lifetime', data.stats.lifetime),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Naam Jaap Stats',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _refreshStats,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.82),
                    foregroundColor: AppTheme.primaryDark,
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildHighlightTile(
                    title: 'Current Streak',
                    value:
                        '${data.currentStreak.days} day${data.currentStreak.days == 1 ? '' : 's'}',
                    subtitle: data.currentStreak.status,
                    color: const Color(0xFFE07C54),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildHighlightTile(
                    title: 'Unique Mantras',
                    value: '${data.uniqueMantrasCount}',
                    subtitle: 'Chanted so far',
                    color: const Color(0xFF4A90D9),
                  ),
                ),
              ],
            ),

            // _buildSummaryCard(data),
            const SizedBox(height: 18),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: statCards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  return _buildStatCard(statCards[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bar_chart_rounded,
              size: 56,
              color: Color(0xFF8B4A34),
            ),
            const SizedBox(height: 14),
            Text(
              'Unable to load stats',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary.withOpacity(0.65),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _refreshStats,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(NaamJaapStatsResponse data) {
    final updatedText = data.lastUpdated == null
        ? 'Not available'
        : _formatDateTime(data.lastUpdated!);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B4A34), Color(0xFFD27B47)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4A34).withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Last Synced',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            updatedText,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lifetime total: ${data.stats.lifetime.count} jaap and ${data.stats.lifetime.malas} Mala',
            style: const TextStyle(
              fontSize: 13,
              height: 1.35,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightTile({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withOpacity(0.14)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary.withOpacity(0.58),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary.withOpacity(0.62),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(_StatCardData card) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            '${card.period.count}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF6B2719),
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Jaap Count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary.withOpacity(0.55),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F3E8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Color(0xFFA95344), size: 16),
                const SizedBox(width: 8),
                Text(
                  '${card.period.malas} Mala',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B2719),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBanner(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.72),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.55)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryDark.withOpacity(0.14),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF40247A),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'राधा',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'राधा नाम जप',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Start your daily chant',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary.withOpacity(0.68),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F1FF),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  'D7',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaalaCard(NaamJaapState state) {
    return Container(
      width: 104,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.9)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textPrimary.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, size: 11, color: const Color(0xFFA95344)),
              const SizedBox(width: 4),
              Text(
                'MAALA',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary.withOpacity(0.55),
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              state.maalaCount.toString(),
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: Color(0xFF6B2719),
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, NaamJaapState state) {
    return OutlinedButton.icon(
      onPressed: state.totalJaap == 0 || state.isSaving
          ? null
          : () {
              context.read<NaamJaapBloc>().add(const NaamJaapSessionSaved());
            },
      icon: state.isSaving
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.favorite, size: 14),
      label: Text(state.isSaving ? 'SAVING...' : 'SAVE SESSION'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF6B2719),
        side: const BorderSide(color: Color(0xFF8B4A34), width: 1.4),
        backgroundColor: Colors.white.withOpacity(0.55),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.6,
        ),
      ),
    );
  }

  Widget _buildChantButton(BuildContext context, NaamJaapState state) {
    return GestureDetector(
      onTap: state.isSaving
          ? null
          : () {
              context.read<NaamJaapBloc>().add(const NaamJaapIncremented());
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: state.isSaving
                ? [const Color(0xFFB0B0B0), const Color(0xFF8C8C8C)]
                : [
                    const Color.fromARGB(255, 89, 136, 190),
                    const Color.fromARGB(255, 149, 137, 204),
                  ],
            center: Alignment(-0.2, -0.2),
            radius: 0.9,
          ),
          border: Border.all(color: Colors.white, width: 6),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC87646).withOpacity(0.35),
              blurRadius: 30,
              spreadRadius: 6,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 204,
            height: 204,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              'TAP TO CHANT',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.84),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildBottomItem(
              icon: Icons.home_outlined,
              label: 'Home',
              isActive: false,
              onTap: () => context.go('/home'),
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => context.go('/leaderboard'),
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.34),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.leaderboard_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildBottomItem(
              icon: Icons.show_chart_rounded,
              label: 'Jaap',
              isActive: _activeTab == _NaamJaapTab.chant,
              onTap: _showChantTab,
            ),
          ),
          Expanded(
            child: _buildBottomItem(
              icon: Icons.pie_chart_outline_rounded,
              label: 'Stats',
              isActive: _activeTab == _NaamJaapTab.stats,
              onTap: _showStatsTab,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomItem({
    required IconData icon,
    required String label,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    final color = isActive ? AppTheme.primaryDark : Colors.grey.shade500;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowCircle({required Color color, required double size}) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 80, spreadRadius: 25),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day/$month/$year  $hour:$minute';
  }
}

class _StatCardData {
  const _StatCardData(this.label, this.period);

  final String label;
  final NaamJaapStatPeriod period;
}
