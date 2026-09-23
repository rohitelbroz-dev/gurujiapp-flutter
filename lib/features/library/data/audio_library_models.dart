class DeityCategory {
  final String id;
  final String key;
  final String name;
  final String imageUrl;
  final int order;
  final String? assetFallback;

  const DeityCategory({
    required this.id,
    required this.key,
    required this.name,
    required this.imageUrl,
    this.order = 0,
    this.assetFallback,
  });

  factory DeityCategory.fromJson(Map<String, dynamic> json) {
    return DeityCategory(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      key: json['key']?.toString() ?? json['name']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      assetFallback: json['assetFallback']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'key': key,
    'name': name,
    'imageUrl': imageUrl,
    'order': order,
  };
}

class AudioTrackItem {
  final String id;
  final String title;
  final String artist;
  final String deity;
  final String category;
  final String audioUrl;
  final String coverImage;
  final String durationFormatted;
  final int totalSeconds;
  final String lyrics;
  final bool isFavorite;
  final int playCount;
  final String? assetFallback;

  const AudioTrackItem({
    required this.id,
    required this.title,
    required this.artist,
    required this.deity,
    required this.category,
    required this.audioUrl,
    required this.coverImage,
    required this.durationFormatted,
    required this.totalSeconds,
    required this.lyrics,
    this.isFavorite = false,
    this.playCount = 0,
    this.assetFallback,
  });

  factory AudioTrackItem.fromJson(Map<String, dynamic> json) {
    return AudioTrackItem(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      artist: json['artist']?.toString() ?? json['author']?.toString() ?? '',
      deity: json['deity']?.toString() ?? 'All',
      category: json['category']?.toString() ?? 'chant',
      audioUrl: json['audioUrl']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? json['image']?.toString() ?? '',
      durationFormatted: json['durationFormatted']?.toString() ?? json['duration']?.toString() ?? '05:00',
      totalSeconds: (json['totalSeconds'] as num?)?.toInt() ?? 300,
      lyrics: json['lyrics']?.toString() ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      playCount: (json['playCount'] as num?)?.toInt() ?? 0,
      assetFallback: json['assetFallback']?.toString(),
    );
  }

  AudioTrackItem copyWith({
    bool? isFavorite,
    int? playCount,
  }) {
    return AudioTrackItem(
      id: id,
      title: title,
      artist: artist,
      deity: deity,
      category: category,
      audioUrl: audioUrl,
      coverImage: coverImage,
      durationFormatted: durationFormatted,
      totalSeconds: totalSeconds,
      lyrics: lyrics,
      isFavorite: isFavorite ?? this.isFavorite,
      playCount: playCount ?? this.playCount,
      assetFallback: assetFallback,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist': artist,
    'deity': deity,
    'category': category,
    'audioUrl': audioUrl,
    'coverImage': coverImage,
    'durationFormatted': durationFormatted,
    'totalSeconds': totalSeconds,
    'lyrics': lyrics,
    'isFavorite': isFavorite,
    'playCount': playCount,
  };
}
