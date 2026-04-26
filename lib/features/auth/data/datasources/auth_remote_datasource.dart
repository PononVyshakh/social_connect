// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/errors/exceptions.dart' as core_exceptions;

abstract class IAuthRemoteDataSource {
  Future<void> sendOTP(String phone);
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

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  static String? _verificationId;

  AuthRemoteDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> sendOTP(String phone) async {
    try {
      print('DEBUG Datasource: sendOTP called for $phone');
      final completer = Completer<void>();
      bool callbackExecuted = false;

      _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) async {
          print('DEBUG Datasource: verificationCompleted callback');
          if (!callbackExecuted) {
            callbackExecuted = true;
            await _auth.signInWithCredential(credential);
            if (!completer.isCompleted) completer.complete();
          }
        },
        verificationFailed: (e) {
          print('DEBUG Datasource: verificationFailed callback - ${e.message}');
          if (!callbackExecuted) {
            callbackExecuted = true;
            if (!completer.isCompleted) {
              completer.completeError(
                core_exceptions.AuthException(
                  message: e.message ?? 'Phone verification failed',
                  code: e.code,
                  originalException: e,
                ),
              );
            }
          }
        },
        codeSent: (vId, _) {
          print('DEBUG Datasource: codeSent callback - vId: $vId');
          if (!callbackExecuted) {
            callbackExecuted = true;
            _verificationId = vId;
            if (!completer.isCompleted) completer.complete();
          }
        },
        codeAutoRetrievalTimeout: (vId) {
          print('DEBUG Datasource: codeAutoRetrievalTimeout callback');
          _verificationId = vId;
          if (!callbackExecuted && !completer.isCompleted) {
            callbackExecuted = true;
            // On auto-retrieval timeout, complete successfully if we have the ID
            if (vId.isNotEmpty) {
              completer.complete();
            }
          }
        },
      );

      print('DEBUG Datasource: Waiting for completer.future');
      return completer.future;
    } on FirebaseAuthException catch (e) {
      print('DEBUG Datasource: FirebaseAuthException - ${e.message}');
      throw core_exceptions.AuthException(
        message: 'Failed to send OTP: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      print('DEBUG Datasource: Unexpected exception - $e');
      throw core_exceptions.AppException(
        message: 'Unexpected error sending OTP: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<User?> verifyOTP(String otp) async {
    try {
      if (_verificationId == null) {
        throw core_exceptions.AppException(
          message: 'Verification ID is null. Please send OTP first.',
        );
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      final result = await _auth.signInWithCredential(credential);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw core_exceptions.AuthException(
        message: e.message ?? 'Failed to verify OTP',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw core_exceptions.AppException(
        message: 'Failed to verify OTP: $e',
        originalException: e,
      );
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
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'mobile': mobile,
        'gender': gender,
        'displayName': displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw core_exceptions.FirebaseException(
        message: 'Failed to create user: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw core_exceptions.AppException(
        message: 'Failed to create user: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<bool> userExists(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw core_exceptions.FirebaseException(
        message: 'Failed to check user existence: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw core_exceptions.AppException(
        message: 'Failed to check user existence: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } on FirebaseException catch (e) {
      throw core_exceptions.FirebaseException(
        message: 'Failed to fetch user data: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw core_exceptions.AppException(
        message: 'Failed to fetch user data: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _verificationId = null;
    } on FirebaseException catch (e) {
      throw core_exceptions.FirebaseException(
        message: 'Failed to sign out: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw core_exceptions.AppException(
        message: 'Failed to sign out: $e',
        originalException: e,
      );
    }
  }
}
