class Event {
  final String id;
  final String title;
  final String location;
  final String dateRange;
  final String coverImage;
  final int rsvpCount;

  Event({
    required this.id,
    required this.title,
    required this.location,
    required this.dateRange,
    required this.coverImage,
    required this.rsvpCount,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      dateRange: json['dateRange']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? '',
      rsvpCount: json['rsvpCount'] is int ? json['rsvpCount'] as int : int.tryParse(json['rsvpCount']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'dateRange': dateRange,
      'coverImage': coverImage,
      'rsvpCount': rsvpCount,
    };
  }
}

class EventsResponse {
  final List<Event> events;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final String source;

  EventsResponse({
    required this.events,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.source,
  });

  factory EventsResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] as List<dynamic>? ?? [];
    return EventsResponse(
      events: dataList.map((e) => Event.fromJson(e as Map<String, dynamic>)).toList(),
      total: json['total'] is int ? json['total'] as int : int.tryParse(json['total']?.toString() ?? '') ?? 0,
      page: json['page'] is int ? json['page'] as int : int.tryParse(json['page']?.toString() ?? '') ?? 1,
      limit: json['limit'] is int ? json['limit'] as int : int.tryParse(json['limit']?.toString() ?? '') ?? 10,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : int.tryParse(json['totalPages']?.toString() ?? '') ?? 1,
      source: json['source']?.toString() ?? '',
    );
  }
}
