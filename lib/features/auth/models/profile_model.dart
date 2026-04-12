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
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id']?.toString() ?? '',
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
      otpAttempts: json['otpAttempts'] is int ? json['otpAttempts'] as int : int.tryParse(json['otpAttempts']?.toString() ?? '') ?? 0,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
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
    );
  }
}
