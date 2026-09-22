class PanchangTithi {
  final String name;
  final int? number;
  final String endsAt;

  const PanchangTithi({
    required this.name,
    this.number,
    required this.endsAt,
  });

  factory PanchangTithi.fromJson(Map<String, dynamic> json) {
    return PanchangTithi(
      name: json['name'] as String? ?? 'एकादशी',
      number: json['number'] as int?,
      endsAt: json['endsAt'] as String? ?? 'दोपहर 02:36 तक',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'number': number,
    'endsAt': endsAt,
  };
}

class PanchangItem {
  final String name;
  final String endsAt;

  const PanchangItem({
    required this.name,
    required this.endsAt,
  });

  factory PanchangItem.fromJson(Map<String, dynamic> json) {
    return PanchangItem(
      name: json['name'] as String? ?? '',
      endsAt: json['endsAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'endsAt': endsAt,
  };
}

class MuhuratItem {
  final String startTime;
  final String endTime;
  final bool isAuspicious;
  final String description;

  const MuhuratItem({
    required this.startTime,
    required this.endTime,
    this.isAuspicious = true,
    this.description = '',
  });

  factory MuhuratItem.fromJson(Map<String, dynamic> json) {
    return MuhuratItem(
      startTime: json['startTime'] as String? ?? '11:51 AM',
      endTime: json['endTime'] as String? ?? '12:45 PM',
      isAuspicious: json['isAuspicious'] as bool? ?? true,
      description: json['description'] as String? ?? '',
    );
  }

  String get timeRange => '$startTime - $endTime';
}

class CelestialInfo {
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  final String moonPhase;
  final int moonIlluminationPercent;

  const CelestialInfo({
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    this.moonPhase = 'Waxing Gibbous',
    this.moonIlluminationPercent = 85,
  });

  factory CelestialInfo.fromJson(Map<String, dynamic> json) {
    return CelestialInfo(
      sunrise: json['sunrise'] as String? ?? '05:32 AM',
      sunset: json['sunset'] as String? ?? '07:05 PM',
      moonrise: json['moonrise'] as String? ?? '02:15 PM',
      moonset: json['moonset'] as String? ?? '03:40 AM',
      moonPhase: json['moonPhase'] as String? ?? 'Waxing Gibbous',
      moonIlluminationPercent: json['moonIlluminationPercent'] as int? ?? 85,
    );
  }
}

class SamvatInfo {
  final int vikramSamvat;
  final int shakaSamvat;
  final String month;
  final String paksha;
  final String dayName;

  const SamvatInfo({
    required this.vikramSamvat,
    required this.shakaSamvat,
    required this.month,
    required this.paksha,
    required this.dayName,
  });

  factory SamvatInfo.fromJson(Map<String, dynamic> json) {
    return SamvatInfo(
      vikramSamvat: json['vikramSamvat'] as int? ?? 2083,
      shakaSamvat: json['shakaSamvat'] as int? ?? 1948,
      month: json['month'] as String? ?? 'ज्येष्ठ',
      paksha: json['paksha'] as String? ?? 'शुक्ल',
      dayName: json['dayName'] as String? ?? 'रविवार',
    );
  }
}

class DailyPanchangData {
  final String date;
  final String location;
  final String gregorianFormatted;
  final String greeting;
  final SamvatInfo samvat;
  final PanchangTithi tithi;
  final PanchangItem nakshatra;
  final PanchangItem yoga;
  final PanchangItem karana;
  final MuhuratItem abhijitMuhurat;
  final MuhuratItem rahuKaal;
  final CelestialInfo celestial;

  const DailyPanchangData({
    required this.date,
    required this.location,
    required this.gregorianFormatted,
    required this.greeting,
    required this.samvat,
    required this.tithi,
    required this.nakshatra,
    required this.yoga,
    required this.karana,
    required this.abhijitMuhurat,
    required this.rahuKaal,
    required this.celestial,
  });

  factory DailyPanchangData.fromJson(Map<String, dynamic> json) {
    final panchang = json['panchang'] as Map<String, dynamic>? ?? {};
    final muhurat = json['muhurat'] as Map<String, dynamic>? ?? {};
    final inauspicious = json['inauspicious'] as Map<String, dynamic>? ?? {};

    return DailyPanchangData(
      date: json['date'] as String? ?? '',
      location: json['location'] as String? ?? 'Vrindavan',
      gregorianFormatted: json['gregorianFormatted'] as String? ?? '',
      greeting: json['greeting'] as String? ?? 'राधे-राधे, आज का दिन मंगलमय हो',
      samvat: SamvatInfo.fromJson(json['samvat'] as Map<String, dynamic>? ?? {}),
      tithi: PanchangTithi.fromJson(panchang['tithi'] as Map<String, dynamic>? ?? {}),
      nakshatra: PanchangItem.fromJson(panchang['nakshatra'] as Map<String, dynamic>? ?? {'name': 'उत्तराभाद्रपद', 'endsAt': 'अगले दिन 04:12 AM तक'}),
      yoga: PanchangItem.fromJson(panchang['yoga'] as Map<String, dynamic>? ?? {'name': 'हर्षण', 'endsAt': 'रात 09:15 AM तक'}),
      karana: PanchangItem.fromJson(panchang['karana'] as Map<String, dynamic>? ?? {'name': 'बव', 'endsAt': 'दोपहर 02:36 PM तक'}),
      abhijitMuhurat: MuhuratItem.fromJson(muhurat['abhijit'] as Map<String, dynamic>? ?? {'startTime': '11:51 AM', 'endTime': '12:45 PM', 'description': 'नवीन कार्यों एवं खरीदारी हेतु अत्यंत शुभ फलदायी समय'}),
      rahuKaal: MuhuratItem.fromJson(inauspicious['rahuKaal'] as Map<String, dynamic>? ?? {'startTime': '05:15 PM', 'endTime': '06:55 PM', 'description': 'इस अवधि में शुभ कार्य न करें'}),
      celestial: CelestialInfo.fromJson(json['celestial'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class FestivalItem {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String badge;
  final int daysLeft;
  final String description;
  final String? imageUrl;

  const FestivalItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.badge,
    required this.daysLeft,
    required this.description,
    this.imageUrl,
  });

  factory FestivalItem.fromJson(Map<String, dynamic> json) {
    return FestivalItem(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      date: json['date'] as String? ?? '',
      badge: json['badge'] as String? ?? '',
      daysLeft: json['daysLeft'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
