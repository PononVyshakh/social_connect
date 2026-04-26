// lib/features/auth/data/repositories/auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/errors/exceptions.dart' as custom_exceptions;
import '../../../../../core/errors/failures.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../services/auth_cache_service.dart';
import '../../services/session_manager.dart';

abstract class IAuthRepository {
  Future<User?> sendOTP(String phone);
  Future<User?> verifyOTP(String otp);
  Future<void> createUser({
    required String uid,
    required String mobile,
    required String gender,
    required String displayName,
  });
  Future<bool> userExists(String uid);
  Future<Map<String, dynamic>?> getUserData(String uid);
  Future<void> signOut();
}

class AuthRepository implements IAuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<User?> sendOTP(String phone) async {
    try {
      await _remoteDataSource.sendOTP(phone);
      return null;
    } on custom_exceptions.AuthException catch (e) {
      throw FirebaseFailure(e.message);
    } on Exception catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<User?> verifyOTP(String otp) async {
    try {
      final user = await _remoteDataSource.verifyOTP(otp);
      return user;
    } on custom_exceptions.AppException catch (e) {
      throw AuthFailure(e.message);
    } on Exception catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> createUser({
    required String uid,
    required String mobile,
    required String gender,
    required String displayName,
  }) async {
    try {
      await _remoteDataSource.createUser(
        uid: uid,
        mobile: mobile,
        gender: gender,
        displayName: displayName,
      );
      
      // Cache the data locally
      await AuthCacheService.cacheUserData(
        uid: uid,
        phoneNumber: mobile,
        gender: gender,
        displayName: displayName,
      );
      
      // Save session
      await SessionManager.saveSession(
        uid: uid,
        mobile: mobile,
        gender: gender,
        displayName: displayName,
      );
    } on custom_exceptions.AppException catch (e) {
      throw FirebaseFailure(e.message);
    } on Exception catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<bool> userExists(String uid) async {
    try {
      return await _remoteDataSource.userExists(uid);
    } on custom_exceptions.AppException catch (e) {
      throw FirebaseFailure(e.message);
    } on Exception catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      return await _remoteDataSource.getUserData(uid);
    } on custom_exceptions.AppException catch (e) {
      throw FirebaseFailure(e.message);
    } on Exception catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
      await SessionManager.logout();
      await AuthCacheService.clearAuthCache();
    } on custom_exceptions.AppException catch (e) {
      throw FirebaseFailure(e.message);
    } on Exception catch (e) {
      throw AuthFailure(e.toString());
    }
  }
}
