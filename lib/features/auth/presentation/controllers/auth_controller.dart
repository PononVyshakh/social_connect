// lib/features/auth/presentation/controllers/auth_controller.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/auth_cache_service.dart';
import '../../services/session_manager.dart';
import '../../domain/models/user_model.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;
  
  // State variables
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  User? _firebaseUser;
  bool _isAuthenticated = false;
  bool _otpSending = false;
  String? _pendingPhoneForOtp; // Track phone number waiting for OTP entry
  String? _pendingOtpVerificationId; // Track verification ID for OTP entry
  bool _isLoginFlow = false; // Track if this is a login (vs register) flow

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get firebaseUser => _firebaseUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get otpSending => _otpSending;
  String? get pendingPhoneForOtp => _pendingPhoneForOtp;
  String? get pendingOtpVerificationId => _pendingOtpVerificationId;
  bool get isLoginFlow => _isLoginFlow;

  AuthController({
    AuthRepository? repository,
  }) : _repository = repository ??
      AuthRepository(
        remoteDataSource: AuthRemoteDataSource(),
      ) {
    _initializeAuth();
  }

  // Initialize auth state
  void _initializeAuth() {
    _firebaseUser = FirebaseAuth.instance.currentUser;
    _isAuthenticated = _firebaseUser != null;
    // Don't notify listeners during construction - no listeners exist yet
  }

  // Send OTP
  Future<bool> sendOTP(String phoneNumber, {bool isLoginFlow = true}) async {
    _isLoading = true;
    _otpSending = true;
    _errorMessage = null;
    _isLoginFlow = isLoginFlow;
    notifyListeners();

    try {
      print('DEBUG AuthController: Calling repository.sendOTP($phoneNumber)');
      await _repository.sendOTP(phoneNumber);
      print('DEBUG AuthController: sendOTP succeeded');
      
      // Save phone number for OTP entry - AuthWrapper will detect this and show OTP screen
      _pendingPhoneForOtp = phoneNumber;
      
      _isLoading = false;
      _errorMessage = null;
      _otpSending = false;
      _postFrameNotify();
      return true;
    } catch (e) {
      print('DEBUG AuthController: sendOTP failed with error: $e');
      _isLoading = false;
      _otpSending = false;
      _pendingPhoneForOtp = null;
      _errorMessage = e.toString();
      _postFrameNotify();
      return false;
    }
  }

  void _postFrameNotify() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Clear pending OTP state
  void clearPendingOtp() {
    _pendingPhoneForOtp = null;
    _pendingOtpVerificationId = null;
    notifyListeners();
  }

  // Verify OTP and sign in
  Future<bool> verifyOTP(String otp) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.verifyOTP(otp);
      if (user != null) {
        _firebaseUser = user;
        _isAuthenticated = true;
        _isLoading = false;
        _errorMessage = null;
        _postFrameNotify();
        return true;
      }
      _isLoading = false;
      _errorMessage = 'Verification failed';
      _postFrameNotify();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      _postFrameNotify();
      return false;
    }
  }

  // Register new user
  Future<bool> registerUser({
    required String uid,
    required String mobileNumber,
    required String displayName,
    required String gender,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.createUser(
        uid: uid,
        mobile: mobileNumber,
        gender: gender,
        displayName: displayName,
      );

      // Create local user model
      _currentUser = UserModel(
        uid: uid,
        mobile: mobileNumber,
        gender: gender,
        displayName: displayName,
        createdAt: DateTime.now(),
      );

      _isLoading = false;
      _errorMessage = null;
      _postFrameNotify();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      _postFrameNotify();
      return false;
    }
  }

  // Check if user exists
  Future<bool> checkUserExists(String uid) async {
    try {
      return await _repository.userExists(uid);
    } catch (e) {
      _errorMessage = e.toString();
      _postFrameNotify();
      return false;
    }
  }

  // Load user data
  Future<Map<String, dynamic>?> loadUserData(String uid) async {
    try {
      final userData = await _repository.getUserData(uid);
      if (userData != null) {
        _currentUser = UserModel.fromMap(userData);
        _errorMessage = null;
        _postFrameNotify();
      } else {
        _errorMessage = 'User data not found';
        _postFrameNotify();
      }
      return userData;
    } catch (e) {
      _errorMessage = e.toString();
      _postFrameNotify();
      return null;
    }
  }

  // Combined: Check user exists and load data (for AuthWrapper to reduce rebuilds)
  Future<Map<String, dynamic>?> loadUserDataWithCheck(String uid) async {
    try {
      // Check if user exists
      final exists = await _repository.userExists(uid);
      
      if (!exists) {
        // New user - return null to show register screen
        return null;
      }
      
      // User exists - load their data
      final userData = await _repository.getUserData(uid);
      if (userData != null) {
        _currentUser = UserModel.fromMap(userData);
        _errorMessage = null;
      }
      return userData;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }

  // Sign out
  Future<bool> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.signOut();
      _currentUser = null;
      _firebaseUser = null;
      _isAuthenticated = false;
      _isLoading = false;
      _errorMessage = null;
      _postFrameNotify();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      _postFrameNotify();
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Update user profile
  Future<bool> updateUserProfile({
    required String uid,
    required Map<String, dynamic> updates,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // For now, just update locally
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          displayName: updates['displayName'] ?? _currentUser!.displayName,
          about: updates['about'] ?? _currentUser!.about,
          gender: updates['gender'] ?? _currentUser!.gender,
        );
      }
      _isLoading = false;
      _postFrameNotify();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      _postFrameNotify();
      return false;
    }
  }
}
