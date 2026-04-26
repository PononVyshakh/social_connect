// lib/features/auth/services/auth_service.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static String? verificationId;

  // 1. SEND OTP
  static Future<void> sendOTP(String phone) async {
    final completer = Completer<void>();

    await _auth.verifyPhoneNumber(  
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
        if (!completer.isCompleted) completer.complete();
      },
      verificationFailed: (e) {
        if (!completer.isCompleted) completer.completeError(e.message ?? 'Failed');
      },
      codeSent: (vId, _) {
        verificationId = vId;
        if (!completer.isCompleted) completer.complete(); // ← success!
      },
      codeAutoRetrievalTimeout: (vId) {
        verificationId = vId;
      },
    );

    return completer.future; // ← waits until codeSent or error
  }

  // 2. VERIFY OTP
  static Future<User?> verifyOTP(String otp) async {
    if (verificationId == null) return null;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otp,
    );

    final result = await _auth.signInWithCredential(credential);
    return result.user;
  }

  // 3. CREATE FIRESTORE USER
  static Future<void> createUser({
    required String uid,
    required String mobile,
    required String gender,
    required String displayName,
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'mobile': mobile,
      'gender': gender,
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 4. CHECK IF USER EXISTS IN FIRESTORE
  static Future<bool> userExists(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.exists;
  }

  // 5. GET USER DATA FROM FIRESTORE
  static Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data();
  }

  // 6. SIGN OUT
  static Future<void> signOut() async {
    await _auth.signOut();
  }
}
