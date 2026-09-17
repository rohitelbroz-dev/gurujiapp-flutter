import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/app.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1E7),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD94F), Color(0xFFF8F3E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 0.28],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: Column(
              children: [
                _buildStaticHeader(context),
                const SizedBox(height: 18),
                Expanded(
                  child: FutureBuilder<LeaderboardResponse>(
                    future: _leaderboardFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryDark,
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return _buildErrorState(
                          snapshot.error.toString().replaceAll(
                            'Exception: ',
                            '',
                          ),
                        );
                      }

                      final response = snapshot.data;
                      if (response == null || response.leaderboard.isEmpty) {
                        return _buildEmptyState();
                      }

                      return Column(
                        children: [
                          _buildSummaryCard(response),
                          const SizedBox(height: 18),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.only(bottom: 16),
                              itemCount: response.leaderboard.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final entry = response.leaderboard[index];
                                return _buildLeaderboardRow(entry);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                _buildBottomBar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStaticHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.go('/home'),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.82),
            foregroundColor: AppTheme.primaryDark,
          ),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Leaderboard',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Rank-wise naam jaap progress',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textPrimary.withOpacity(0.62),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _reloadLeaderboard,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.86),
            foregroundColor: AppTheme.primaryDark,
          ),
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(LeaderboardResponse response) {
    final topUser = response.leaderboard.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.24),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${response.timeframe.toUpperCase()} LEADER',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  topUser.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${topUser.totalJaps} jaap • ${topUser.totalMalas} malas',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'USERS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${response.totalUsers}',
                  style: const TextStyle(
                    fontSize: 18,
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

  Widget _buildLeaderboardRow(LeaderboardEntry entry) {
    final progress = (entry.percentageOfFirstPlace / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: entry.rank == 1
                  ? const Color(0xFFFFF2C4)
                  : AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryDark,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildAvatar(entry),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${entry.totalJaps} jaap • ${entry.totalMalas} malas',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary.withOpacity(0.68),
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: progress,
                    backgroundColor: const Color(0xFFF3E8D3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${entry.percentageOfFirstPlace}% of first place',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(LeaderboardEntry entry) {
    final initials = entry.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 52,
        height: 52,
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
          colors: [Color(0xFFF7C948), Color(0xFFD18C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, color: AppTheme.primaryDark),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _reloadLeaderboard,
              child: Text(
                'Retry',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          'No leaderboard data available right now.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
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
            child: _buildBottomItem(
              icon: Icons.leaderboard_rounded,
              label: 'Board',
              isActive: true,
              onTap: () {},
            ),
          ),
          Expanded(
            child: _buildBottomItem(
              icon: Icons.show_chart_rounded,
              label: 'Jaap',
              isActive: false,
              onTap: () => context.go('/naam-jaap'),
            ),
          ),
          Expanded(
            child: _buildBottomItem(
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              isActive: false,
              onTap: () => context.go('/profile'),
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
    required VoidCallback onTap,
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
}
