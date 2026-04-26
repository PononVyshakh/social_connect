// lib/features/profile/domain/models/profile_model.dart

class ProfileModel {
  final String userId;
  final String displayName;
  final String about;
  final String gender;
  final String? avatarUrl;
  final DateTime joinDate;
  final DateTime? updatedAt;
  final int messageCount;

  ProfileModel({
    required this.userId,
    required this.displayName,
    required this.about,
    required this.gender,
    this.avatarUrl,
    required this.joinDate,
    this.updatedAt,
    this.messageCount = 0,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      userId: map['userId'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      about: map['about'] as String? ?? '',
      gender: map['gender'] as String? ?? 'unknown',
      avatarUrl: map['avatarUrl'] as String?,
      joinDate: map['joinDate'] != null
          ? DateTime.parse(map['joinDate'].toString())
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'].toString())
          : null,
      messageCount: map['messageCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'displayName': displayName,
      'about': about,
      'gender': gender,
      'avatarUrl': avatarUrl,
      'joinDate': joinDate.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'messageCount': messageCount,
    };
  }

  ProfileModel copyWith({
    String? userId,
    String? displayName,
    String? about,
    String? gender,
    String? avatarUrl,
    DateTime? joinDate,
    DateTime? updatedAt,
    int? messageCount,
  }) {
    return ProfileModel(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      about: about ?? this.about,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinDate: joinDate ?? this.joinDate,
      updatedAt: updatedAt ?? this.updatedAt,
      messageCount: messageCount ?? this.messageCount,
    );
  }
}
