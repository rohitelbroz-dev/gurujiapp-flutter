import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/app.dart';
import 'package:guruji/features/naam_jaap/data/naam_jaap_repository.dart';
import 'package:guruji/features/naam_jaap/models/naam_jaap_stats.dart';

class NaamJaapDashboardScreen extends StatelessWidget {
  const NaamJaapDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E7),
      body: SafeArea(
        child: FutureBuilder<NaamJaapStatsResponse>(
          future: NaamJaapRepository().fetchStats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _DashboardError(
                message: snapshot.error.toString().replaceAll(
                  'Exception: ',
                  '',
                ),
              );
            }

            final data = snapshot.data;
            if (data == null) {
              return const _DashboardError(
                message: 'Unable to load stats right now.',
              );
            }

            return _DashboardContent(data: data);
          },
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.data});

  final NaamJaapStatsResponse data;

  @override
  Widget build(BuildContext context) {
    final statCards = <_StatCardData>[
      _StatCardData('Today', data.stats.today),
      _StatCardData('This Week', data.stats.thisWeek),
      _StatCardData('This Month', data.stats.thisMonth),
      _StatCardData('This Year', data.stats.thisYear),
      _StatCardData('Lifetime', data.stats.lifetime),
    ];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryDark,
                  ),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Naam Jaap Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: _buildHighlightRow(),
          ),
        ),
        // SliverToBoxAdapter(
        //   child: Padding(
        //     padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        //     child: _buildSummaryCard(),
        //   ),
        // ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.95,
            children: statCards.map(_buildStatCard).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightRow() {
    return Row(
      children: [
        Expanded(
          child: _HighlightTile(
            title: 'Current Streak',
            value:
                '${data.currentStreak.days} day${data.currentStreak.days == 1 ? '' : 's'}',
            subtitle: data.currentStreak.status,
            color: const Color(0xFFE07C54),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _HighlightTile(
            title: 'Unique Mantras',
            value: '${data.uniqueMantrasCount}',
            subtitle: 'Chanted so far',
            color: const Color(0xFF4A90D9),
          ),
        ),
      ],
    );
  }

  // Widget _buildSummaryCard() {
  //   final updatedText = data.lastUpdated == null
  //       ? 'Not available'
  //       : _formatDateTime(data.lastUpdated!);

  //   return Container(
  //     padding: const EdgeInsets.all(18),
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         colors: [Color(0xFF8B4A34), Color(0xFFD27B47)],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.circular(24),
  //       boxShadow: [
  //         BoxShadow(
  //           color: const Color(0xFF8B4A34).withOpacity(0.22),
  //           blurRadius: 18,
  //           offset: const Offset(0, 8),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Last Synced',
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w700,
  //             color: Colors.white70,
  //             letterSpacing: 1.2,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           updatedText,
  //           style: const TextStyle(
  //             fontSize: 22,
  //             fontWeight: FontWeight.w800,
  //             color: Colors.white,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           'Lifetime total: ${data.stats.lifetime.count} jaap and ${data.stats.lifetime.malas} malas',
  //           style: const TextStyle(
  //             fontSize: 13,
  //             height: 1.35,
  //             color: Colors.white,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
                  '${card.period.malas} malas',
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

class _HighlightTile extends StatelessWidget {
  const _HighlightTile({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
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
              'Unable to load dashboard stats',
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
              onPressed: () => context.pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCardData {
  const _StatCardData(this.label, this.period);

  final String label;
  final NaamJaapStatPeriod period;
}
