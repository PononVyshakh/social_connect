// lib/features/profile/data/repositories/profile_repository.dart
import 'dart:io';
import '../../domain/models/profile_model.dart';
import '../../../../../core/errors/failures.dart';
import '../datasources/profile_remote_datasource.dart';

abstract class IProfileRepository {
  Future<ProfileModel> getProfile(String uid);
  Future<void> updateProfile(String uid, Map<String, dynamic> data);
  Future<String> uploadPhoto(String uid, File imageFile);
  Future<void> deleteProfile(String uid);
}

class ProfileRepository implements IProfileRepository {
  final IProfileRemoteDataSource _remoteDataSource;

  ProfileRepository({IProfileRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ProfileRemoteDataSource();

  @override
  Future<ProfileModel> getProfile(String uid) async {
    try {
      return await _remoteDataSource.getProfile(uid);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _remoteDataSource.updateProfile(uid, data);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  @override
  Future<String> uploadPhoto(String uid, File imageFile) async {
    try {
      return await _remoteDataSource.uploadPhoto(uid, imageFile);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> deleteProfile(String uid) async {
    try {
      await _remoteDataSource.deleteProfile(uid);
    } catch (e) {
      throw _mapExceptionToFailure(e);
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is Failure) {
      return exception;
    }
    return Failure(message: exception.toString());
  }
}
