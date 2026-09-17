class AmritVachan {
  final String id;
  final String imageUrl;
  final String caption;
  final DateTime? scheduledDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AmritVachan({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.scheduledDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AmritVachan.fromJson(Map<String, dynamic> json) {
    return AmritVachan(
      id: json['id']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      caption: json['caption']?.toString() ?? '',
      scheduledDate: DateTime.tryParse(json['scheduledDate']?.toString() ?? ''),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }
}
