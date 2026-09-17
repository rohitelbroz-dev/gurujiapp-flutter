class NaamJaapStatsResponse {
  final NaamJaapStats stats;
  final NaamJaapCurrentStreak currentStreak;
  final int uniqueMantrasCount;
  final DateTime? lastUpdated;

  const NaamJaapStatsResponse({
    required this.stats,
    required this.currentStreak,
    required this.uniqueMantrasCount,
    required this.lastUpdated,
  });

  factory NaamJaapStatsResponse.fromJson(Map<String, dynamic> json) {
    return NaamJaapStatsResponse(
      stats: NaamJaapStats.fromJson(json['stats'] as Map<String, dynamic>),
      currentStreak: NaamJaapCurrentStreak.fromJson(
        json['currentStreak'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      uniqueMantrasCount: (json['uniqueMantrasCount'] as num?)?.toInt() ?? 0,
      lastUpdated: DateTime.tryParse(json['lastUpdated']?.toString() ?? ''),
    );
  }
}

class NaamJaapStats {
  final NaamJaapStatPeriod lifetime;
  final NaamJaapStatPeriod today;
  final NaamJaapStatPeriod thisWeek;
  final NaamJaapStatPeriod thisMonth;
  final NaamJaapStatPeriod thisYear;

  const NaamJaapStats({
    required this.lifetime,
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.thisYear,
  });

  factory NaamJaapStats.fromJson(Map<String, dynamic> json) {
    return NaamJaapStats(
      lifetime: NaamJaapStatPeriod.fromJson(
        json['lifetime'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      today: NaamJaapStatPeriod.fromJson(
        json['today'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      thisWeek: NaamJaapStatPeriod.fromJson(
        json['thisWeek'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      thisMonth: NaamJaapStatPeriod.fromJson(
        json['thisMonth'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      thisYear: NaamJaapStatPeriod.fromJson(
        json['thisYear'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }
}

class NaamJaapStatPeriod {
  final int count;
  final int malas;

  const NaamJaapStatPeriod({required this.count, required this.malas});

  factory NaamJaapStatPeriod.fromJson(Map<String, dynamic> json) {
    return NaamJaapStatPeriod(
      count: (json['count'] as num?)?.toInt() ?? 0,
      malas: (json['malas'] as num?)?.toInt() ?? 0,
    );
  }
}

class NaamJaapCurrentStreak {
  final int days;
  final String status;

  const NaamJaapCurrentStreak({required this.days, required this.status});

  factory NaamJaapCurrentStreak.fromJson(Map<String, dynamic> json) {
    return NaamJaapCurrentStreak(
      days: (json['days'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'Unknown',
    );
  }
}
