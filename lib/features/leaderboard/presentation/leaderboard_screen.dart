import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/widgets/app_bottom_nav.dart';
import 'package:guruji/features/leaderboard/data/leaderboard_repository.dart';
import 'package:guruji/features/leaderboard/models/leaderboard_model.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final LeaderboardRepository _repository = LeaderboardRepository();
  late Future<LeaderboardResponse> _leaderboardFuture;

  static const Color primaryPlum = Color(0xFF7E2B58);
  static const Color richRose = Color(0xFF8E3763);
  static const Color mauveAccent = Color(0xFFCE6590);
  static const Color bgEnd = Color(0xFFFBF4F7);
  static const Color charcoalText = Color(0xFF1F1A1D);
  static const Color subtitleColor = Color(0xFF6B5F66);

  @override
  void initState() {
    super.initState();
    _leaderboardFuture = _repository.fetchLeaderboard();
  }

  void _reloadLeaderboard() {
    setState(() {
      _leaderboardFuture = _repository.fetchLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        backgroundColor: bgEnd,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: primaryPlum),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: const Text(
          'Global Sadhak Leaderboard',
          style: TextStyle(
            color: primaryPlum,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            fontFamily: 'serif',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: primaryPlum),
            onPressed: _reloadLeaderboard,
          ),
        ],
      ),
      body: FutureBuilder<LeaderboardResponse>(
        future: _leaderboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryPlum),
            );
          }

          if (snapshot.hasError) {
            return _buildErrorState(
              snapshot.error.toString().replaceAll('Exception: ', ''),
            );
          }

          final response = snapshot.data;
          if (response == null || response.leaderboard.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            color: primaryPlum,
            onRefresh: () async => _reloadLeaderboard(),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                // Top Winner Hero Card
                _buildSummaryCard(response),
                const SizedBox(height: 20),

                // Top 3 Podium (if >= 3 items)
                if (response.leaderboard.length >= 3)
                  _buildPodium(response.leaderboard.take(3).toList()),

                const SizedBox(height: 20),

                // Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Sadhak Rankings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'serif',
                        color: charcoalText,
                      ),
                    ),
                    Text(
                      '${response.totalUsers} Active Sadhaks',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Leaderboard list
                ...response.leaderboard.map(_buildLeaderboardRow),
              ],
            ),
          );
        },
      ),
        bottomNavigationBar: const AppBottomNav(currentTab: AppNavTab.panchang),
      ),
    );
  }

  // ─── Summary Hero Card ─────────────────────────────────────────────────────
  Widget _buildSummaryCard(LeaderboardResponse response) {
    final topUser = response.leaderboard.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [primaryPlum, richRose],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryPlum.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Colors.amberAccent,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${response.timeframe.toUpperCase()} TOP SADHAK',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  topUser.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${topUser.totalJaps} jaap • ${topUser.totalMalas} malas',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                const Text(
                  'RANK',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '#1 👑',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Top 3 Podium ──────────────────────────────────────────────────────────
  Widget _buildPodium(List<LeaderboardEntry> topThree) {
    if (topThree.length < 3) return const SizedBox.shrink();
    final first = topThree[0];
    final second = topThree[1];
    final third = topThree[2];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF3E5EB)),
        boxShadow: [
          BoxShadow(
            color: primaryPlum.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd Place
          _buildPodiumColumn(
            entry: second,
            rank: 2,
            badgeEmoji: '🥈',
            badgeColor: const Color(0xFF9E9E9E),
            height: 90,
          ),
          // 1st Place
          _buildPodiumColumn(
            entry: first,
            rank: 1,
            badgeEmoji: '🥇',
            badgeColor: const Color(0xFFFFB300),
            height: 120,
            isFirst: true,
          ),
          // 3rd Place
          _buildPodiumColumn(
            entry: third,
            rank: 3,
            badgeEmoji: '🥉',
            badgeColor: const Color(0xFFCD7F32),
            height: 80,
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumColumn({
    required LeaderboardEntry entry,
    required int rank,
    required String badgeEmoji,
    required Color badgeColor,
    required double height,
    bool isFirst = false,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            _buildAvatar(entry, size: isFirst ? 58 : 46),
            Positioned(
              top: -4,
              right: -4,
              child: Text(badgeEmoji, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 80,
          child: Text(
            entry.name,
            style: TextStyle(
              fontSize: isFirst ? 13 : 11.5,
              fontWeight: FontWeight.w700,
              color: charcoalText,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '${entry.totalJaps} jaap',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: isFirst ? primaryPlum : subtitleColor,
          ),
        ),
      ],
    );
  }

  // ─── Single Row ────────────────────────────────────────────────────────────
  Widget _buildLeaderboardRow(LeaderboardEntry entry) {
    final progress = (entry.percentageOfFirstPlace / 100).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: entry.rank <= 3
              ? mauveAccent.withOpacity(0.4)
              : const Color(0xFFF3E5EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: entry.rank == 1
                  ? const Color(0xFFFFF0F5)
                  : const Color(0xFFFBF4F7),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: entry.rank <= 3 ? primaryPlum : charcoalText,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildAvatar(entry, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: charcoalText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${entry.totalJaps} jaap • ${entry.totalMalas} malas',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    value: progress,
                    backgroundColor: const Color(0xFFF3E5EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(primaryPlum),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(LeaderboardEntry entry, {double size = 48}) {
    final initials = entry.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2.4),
      child: SizedBox(
        width: size,
        height: size,
        child: entry.profileImage != null && entry.profileImage!.isNotEmpty
            ? Image.network(
                entry.profileImage!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildAvatarFallback(initials),
              )
            : _buildAvatarFallback(initials),
      ),
    );
  }

  Widget _buildAvatarFallback(String initials) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryPlum, richRose],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: charcoalText)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _reloadLeaderboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPlum,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'No leaderboard data available right now.',
          style: TextStyle(color: charcoalText, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
