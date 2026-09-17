import 'package:equatable/equatable.dart';

class FamilyMember extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String profileImage;
  final String relationType;
  final List<FamilyMember> children;
  final List<FamilyConnection> connections;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.phone,
    required this.profileImage,
    required this.relationType,
    required this.children,
    required this.connections,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      profileImage: json['profileImage']?.toString() ?? '',
      relationType: json['relationType']?.toString() ?? '',
      children: (json['children'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(FamilyMember.fromJson)
          .toList(),
      connections: (json['connections'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(FamilyConnection.fromJson)
          .toList(),
    );
  }

  bool get hasProfileImage => profileImage.trim().isNotEmpty;

  String get relationLabel {
    if (relationType.trim().isEmpty) return 'Family Member';

    final normalized = relationType.trim().toLowerCase();
    return normalized[0].toUpperCase() + normalized.substring(1);
  }

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    profileImage,
    relationType,
    children,
    connections,
  ];
}

class FamilyConnection extends Equatable {
  final String id;
  final String name;
  final String relationType;
  final String phone;
  final String profileImage;

  const FamilyConnection({
    required this.id,
    required this.name,
    required this.relationType,
    required this.phone,
    required this.profileImage,
  });

  factory FamilyConnection.fromJson(Map<String, dynamic> json) {
    return FamilyConnection(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      relationType: json['relationType']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      profileImage: json['profileImage']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, relationType, phone, profileImage];
}
