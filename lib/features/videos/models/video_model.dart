class Video {
  final String id;
  final String title;
  final String description;
  final String youtubeId;
  final String thumbnailUrl;
  final int? duration;
  final int views;
  final String category;
  final DateTime publishedAt;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeId,
    required this.thumbnailUrl,
    this.duration,
    required this.views,
    required this.category,
    required this.publishedAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      youtubeId: json['youtubeId']?.toString() ?? '',
      thumbnailUrl: json['thumbnailUrl']?.toString() ?? '',
      duration: _toNullableInt(json['duration']),
      views: _toInt(json['views']),
      category: json['category']?.toString() ?? '',
      publishedAt: _toDateTime(json['publishedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'youtubeId': youtubeId,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'views': views,
      'category': category,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }
}

class VideosResponse {
  final List<Video> videos;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  VideosResponse({
    required this.videos,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory VideosResponse.fromJson(Map<String, dynamic> json) {
    List<Video> videosList = [];
    if (json['data'] != null) {
      videosList = List<Video>.from(
        (json['data'] as List).map(
          (video) => Video.fromJson(video as Map<String, dynamic>),
        ),
      );
    }

    return VideosResponse(
      videos: videosList,
      total: _toInt(json['total']),
      page: _toInt(json['page'], fallback: 1),
      limit: _toInt(json['limit'], fallback: 10),
      totalPages: _toInt(json['totalPages']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': videos.map((video) => video.toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}

int _toInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

int? _toNullableInt(dynamic value) {
  if (value == null) return null;
  return _toInt(value);
}

DateTime _toDateTime(dynamic value) {
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }
  return DateTime.now();
}
