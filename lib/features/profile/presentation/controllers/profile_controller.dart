// lib/features/profile/presentation/controllers/profile_controller.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import '../../domain/models/profile_model.dart';

class ProfileController extends ChangeNotifier {
  ProfileModel? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _postFrameNotify() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Load profile
  Future<bool> loadProfile(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Implement actual profile loading from Firestore
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

  // Update profile
  Future<bool> updateProfile(ProfileModel profile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = profile;
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

  // Update name
  Future<bool> updateName(String newName) async {
    if (_profile == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = _profile!.copyWith(displayName: newName);
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

  // Update gender
  Future<bool> updateGender(String newGender) async {
    if (_profile == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = _profile!.copyWith(gender: newGender);
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

  // Update about
  Future<bool> updateAbout(String newAbout) async {
    if (_profile == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = _profile!.copyWith(about: newAbout);
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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
