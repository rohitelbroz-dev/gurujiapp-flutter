class Profile {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String dateOfBirth;
  final String city;
  final String state;
  final String gotra;
  final String? dikshaDate;
  final String? profileImage;
  final bool isVerified;
  final String? otpCode;
  final String? otpExpiresAt;
  final int otpAttempts;
  final String createdAt;
  final String updatedAt;
  final int totalGauSeva;
  final int jaapStreak;
  final bool? muhuratAlerts;
  final bool? prayerReminders;

  Profile({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.dateOfBirth,
    required this.city,
    required this.state,
    required this.gotra,
    required this.dikshaDate,
    required this.profileImage,
    required this.isVerified,
    required this.otpCode,
    required this.otpExpiresAt,
    required this.otpAttempts,
    required this.createdAt,
    required this.updatedAt,
    this.totalGauSeva = 0,
    this.jaapStreak = 0,
    this.muhuratAlerts,
    this.prayerReminders,
  });

  factory Profile.fromJson(Map<String, dynamic> raw) {
    final json = raw['data'] is Map<String, dynamic> ? raw['data'] as Map<String, dynamic> : raw;

    final muhuratRaw = json['muhuratAlerts'] ?? json['muhurat_alerts'] ?? json['muhuratAlert'] ?? json['isMuhuratAlertsEnabled'];
    final prayerRaw = json['prayerReminders'] ?? json['prayer_reminders'] ?? json['prayerReminder'] ?? json['isPrayerRemindersEnabled'];

    bool? parsedMuhurat;
    if (muhuratRaw != null) {
      parsedMuhurat = muhuratRaw == true || muhuratRaw.toString().toLowerCase() == 'true' || muhuratRaw == 1;
    }

    bool? parsedPrayer;
    if (prayerRaw != null) {
      parsedPrayer = prayerRaw == true || prayerRaw.toString().toLowerCase() == 'true' || prayerRaw == 1;
    }

    return Profile(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      dateOfBirth: json['dateOfBirth']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      gotra: json['gotra']?.toString() ?? '',
      dikshaDate: json['dikshaDate']?.toString(),
      profileImage: json['profileImage']?.toString(),
      isVerified: json['isVerified'] == true,
      otpCode: json['otpCode']?.toString(),
      otpExpiresAt: json['otpExpiresAt']?.toString(),
      otpAttempts: json['otpAttempts'] is int
          ? json['otpAttempts'] as int
          : int.tryParse(json['otpAttempts']?.toString() ?? '') ?? 0,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      totalGauSeva: json['totalGauSeva'] is int
          ? json['totalGauSeva'] as int
          : int.tryParse(json['totalGauSeva']?.toString() ?? '') ?? 0,
      jaapStreak: json['jaapStreak'] is int
          ? json['jaapStreak'] as int
          : int.tryParse(json['jaapStreak']?.toString() ?? '') ?? 0,
      muhuratAlerts: parsedMuhurat,
      prayerReminders: parsedPrayer,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'city': city,
      'state': state,
      'gotra': gotra,
      'dikshaDate': dikshaDate,
      'profileImage': profileImage,
      'isVerified': isVerified,
      'otpCode': otpCode,
      'otpExpiresAt': otpExpiresAt,
      'otpAttempts': otpAttempts,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'totalGauSeva': totalGauSeva,
      'jaapStreak': jaapStreak,
      if (muhuratAlerts != null) 'muhuratAlerts': muhuratAlerts,
      if (prayerReminders != null) 'prayerReminders': prayerReminders,
    };
  }

  Profile copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? dateOfBirth,
    String? city,
    String? state,
    String? gotra,
    String? dikshaDate,
    String? profileImage,
    bool? isVerified,
    String? otpCode,
    String? otpExpiresAt,
    int? otpAttempts,
    String? createdAt,
    String? updatedAt,
    int? totalGauSeva,
    int? jaapStreak,
    bool? muhuratAlerts,
    bool? prayerReminders,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      city: city ?? this.city,
      state: state ?? this.state,
      gotra: gotra ?? this.gotra,
      dikshaDate: dikshaDate ?? this.dikshaDate,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      otpCode: otpCode ?? this.otpCode,
      otpExpiresAt: otpExpiresAt ?? this.otpExpiresAt,
      otpAttempts: otpAttempts ?? this.otpAttempts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalGauSeva: totalGauSeva ?? this.totalGauSeva,
      jaapStreak: jaapStreak ?? this.jaapStreak,
      muhuratAlerts: muhuratAlerts ?? this.muhuratAlerts,
      prayerReminders: prayerReminders ?? this.prayerReminders,
    );
  }
}
