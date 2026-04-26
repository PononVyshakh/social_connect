// lib/features/auth/domain/models/user_model.dart

class UserModel {
  final String uid;
  final String mobile;
  final String gender;
  final String displayName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? about;
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.mobile,
    required this.gender,
    required this.displayName,
    required this.createdAt,
    this.updatedAt,
    this.about,
    this.photoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      
      // Handle Firestore Timestamp objects
      if (value.runtimeType.toString() == '_JsonSerializableTimestamp' ||
          value.runtimeType.toString().contains('Timestamp')) {
        // Firestore Timestamp has toDate() method
        if (value is Map && value.containsKey('_seconds')) {
          // Direct timestamp map
          final seconds = value['_seconds'] as int?;
          if (seconds != null) {
            return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
          }
        }
        // Try calling toDate() if it's a Timestamp object
        try {
          if (value.runtimeType.toString().contains('Timestamp')) {
            final dateTime = value.toDate();
            if (dateTime is DateTime) return dateTime;
          }
        } catch (_) {}
      }
      
      // Handle ISO8601 string
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (_) {}
      }
      
      // Handle millisecondsSinceEpoch as int or double
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      if (value is double) {
        return DateTime.fromMillisecondsSinceEpoch(value.toInt());
      }
      
      return null;
    }

    return UserModel(
      uid: map['uid'] as String? ?? '',
      mobile: map['mobile'] as String? ?? '',
      gender: map['gender'] as String? ?? 'unknown',
      displayName: map['displayName'] as String? ?? '',
      createdAt: parseDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(map['updatedAt']),
      about: map['about'] as String?,
      photoUrl: map['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'mobile': mobile,
      'gender': gender,
      'displayName': displayName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'about': about,
      'photoUrl': photoUrl,
    };
  }

  UserModel copyWith({
    String? uid,
    String? mobile,
    String? gender,
    String? displayName,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? about,
    String? photoUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      mobile: mobile ?? this.mobile,
      gender: gender ?? this.gender,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      about: about ?? this.about,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
