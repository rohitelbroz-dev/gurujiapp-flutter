class LeaderboardResponse {
  final String timeframe;
  final int totalUsers;
  final List<LeaderboardEntry> leaderboard;

  const LeaderboardResponse({
    required this.timeframe,
    required this.totalUsers,
    required this.leaderboard,
  });

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    final leaderboardJson = json['leaderboard'] as List<dynamic>? ?? const [];

    return LeaderboardResponse(
      timeframe: json['timeframe'] as String? ?? 'all',
      totalUsers: (json['totalUsers'] as num?)?.toInt() ?? 0,
      leaderboard: leaderboardJson
          .map((item) => LeaderboardEntry.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class LeaderboardEntry {
  final int rank;
  final String name;
  final String? profileImage;
  final int totalJaps;
  final int totalMalas;
  final int percentageOfFirstPlace;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.profileImage,
    required this.totalJaps,
    required this.totalMalas,
    required this.percentageOfFirstPlace,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? 'Unknown user',
      profileImage: json['profileImage'] as String?,
      totalJaps: (json['totalJaps'] as num?)?.toInt() ?? 0,
      totalMalas: (json['totalMalas'] as num?)?.toInt() ?? 0,
      percentageOfFirstPlace:
          (json['percentageOfFirstPlace'] as num?)?.toInt() ?? 0,
    );
  }
}
