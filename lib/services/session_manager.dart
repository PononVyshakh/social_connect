import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userMobileKey = 'user_mobile';
  static const String _userGenderKey = 'user_gender';
  static const String _userDisplayNameKey = 'user_display_name';

  static Future<void> saveSession(String mobile, String gender, String displayName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userMobileKey, mobile);
    await prefs.setString(_userGenderKey, gender);
    await prefs.setString(_userDisplayNameKey, displayName);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String?> getUserMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userMobileKey);
  }

  static Future<String?> getUserGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userGenderKey);
  }

  static Future<String?> getUserDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userDisplayNameKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isMobileRegistered(String mobile) async {
    final prefs = await SharedPreferences.getInstance();
    String? savedMobile = prefs.getString(_userMobileKey);
    return savedMobile == mobile;
  }
}