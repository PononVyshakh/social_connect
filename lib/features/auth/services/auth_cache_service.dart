// lib/features/auth/services/auth_cache_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthCacheService {
  static const String _userUidKey = 'auth_user_uid';
  static const String _userPhoneKey = 'auth_user_phone';
  static const String _userGenderKey = 'auth_user_gender';
  static const String _userNameKey = 'auth_user_name';

  static Future<void> cacheUserData({
    required String uid,
    required String phoneNumber,
    required String gender,
    required String displayName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userUidKey, uid);
      await prefs.setString(_userPhoneKey, phoneNumber);
      await prefs.setString(_userGenderKey, gender);
      await prefs.setString(_userNameKey, displayName);
    } catch (e) {
      print('Error caching user data: $e');
    }
  }

  static Future<void> clearAuthCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userUidKey);
      await prefs.remove(_userPhoneKey);
      await prefs.remove(_userGenderKey);
      await prefs.remove(_userNameKey);
    } catch (e) {
      print('Error clearing auth cache: $e');
    }
  }

  static Future<String?> getCachedUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userUidKey);
    } catch (e) {
      print('Error retrieving cached user ID: $e');
      return null;
    }
  }

  static Future<Map<String, String?>> getCachedUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'uid': prefs.getString(_userUidKey),
        'phone': prefs.getString(_userPhoneKey),
        'gender': prefs.getString(_userGenderKey),
        'displayName': prefs.getString(_userNameKey),
      };
    } catch (e) {
      print('Error retrieving cached user data: $e');
      return {};
    }
  }
}
