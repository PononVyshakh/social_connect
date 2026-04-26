// lib/features/profile/data/datasources/profile_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../domain/models/profile_model.dart';
import '../../../../../core/errors/exceptions.dart';

abstract class IProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String uid);
  Future<void> updateProfile(String uid, Map<String, dynamic> data);
  Future<String> uploadPhoto(String uid, File imageFile);
  Future<void> deleteProfile(String uid);
}

class ProfileRemoteDataSource implements IProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProfileRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<ProfileModel> getProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      
      if (!doc.exists) {
        throw NotFoundException(
          message: 'Profile not found',
          code: 'PROFILE_NOT_FOUND',
        );
      }

      return ProfileModel.fromMap(doc.data() ?? {});
    } on FirebaseException catch (e) {
      throw FirebaseAppException(
        message: 'Failed to fetch profile: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AppException(
        message: 'Unexpected error fetching profile',
        originalException: e,
      );
    }
  }

  @override
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      
      await _firestore.collection('users').doc(uid).update(data);
    } on FirebaseException catch (e) {
      throw FirebaseAppException(
        message: 'Failed to update profile: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AppException(
        message: 'Unexpected error updating profile',
        originalException: e,
      );
    }
  }

  @override
  Future<String> uploadPhoto(String uid, File imageFile) async {
    try {
      final fileName = 'profile_${uid}_${DateTime.now().millisecondsSinceEpoch}';
      final ref = _storage.ref('users/$uid/$fileName');
      
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      
      // Update user profile with new photo URL
      await updateProfile(uid, {'photoUrl': url});
      
      return url;
    } on FirebaseException catch (e) {
      throw FirebaseAppException(
        message: 'Failed to upload photo: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AppException(
        message: 'Unexpected error uploading photo',
        originalException: e,
      );
    }
  }

  @override
  Future<void> deleteProfile(String uid) async {
    try {
      // Delete all photos in user's folder
      final listResult = await _storage.ref('users/$uid').listAll();
      for (var file in listResult.items) {
        await file.delete();
      }
      
      // Delete user document
      await _firestore.collection('users').doc(uid).delete();
    } on FirebaseException catch (e) {
      throw FirebaseAppException(
        message: 'Failed to delete profile: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AppException(
        message: 'Unexpected error deleting profile',
        originalException: e,
      );
    }
  }
}
