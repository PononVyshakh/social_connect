// lib/features/profile/services/profile_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get profile by UID
  static Future<Map<String, dynamic>?> getProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  // Update profile
  static Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  // Update specific field
  static Future<void> updateField(String uid, String field, dynamic value) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        field: value,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating field: $e');
      rethrow;
    }
  }

  // Get all user profiles (for user discovery/chat list)
  static Future<List<Map<String, dynamic>>> getAllProfiles() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching all profiles: $e');
      return [];
    }
  }

  // Search profiles by name
  static Future<List<Map<String, dynamic>>> searchByName(String query) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('displayName', isGreaterThanOrEqualTo: query)
          .where('displayName', isLessThan: query + 'z')
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error searching profiles: $e');
      return [];
    }
  }

  // Delete profile
  static Future<void> deleteProfile(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      print('Error deleting profile: $e');
      rethrow;
    }
  }
}
