import 'package:get/get.dart';

import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../../core/services/api_client.dart';
import '../models/user_model.dart';

class UserRepository {
  final ApiClient _api;

  UserRepository() : _api = Get.find<ApiClient>();

  /// Get user profile by Appwrite user ID
  Future<Result<UserModel, AppError>> getUser(String userId) async {
    final result = await _api.get('/api/v1/users/$userId');
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return const Result.failure(
            DocumentNotFoundError(message: 'User not found'),
          );
        }
        return Result.success(UserModel.fromApiJson(data));
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Create user profile on the backend (called after Appwrite auth registration)
  Future<Result<UserModel, AppError>> createUser(UserModel user) async {
    final result = await _api.post(
      '/api/v1/users',
      data: user.toApiJson(),
    );
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return const Result.failure(
            GeneralDatabaseError(message: 'Failed to create user'),
          );
        }
        return Result.success(UserModel.fromApiJson(data));
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Update user profile
  Future<Result<UserModel, AppError>> saveUser(UserModel user) async {
    final result = await _api.put(
      '/api/v1/users/${user.id}',
      data: user.toApiJson(),
    );
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return const Result.failure(
            GeneralDatabaseError(message: 'Failed to update user'),
          );
        }
        return Result.success(UserModel.fromApiJson(data));
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  /// Delete user profile
  Future<Result<void, AppError>> deleteUser(String userId) async {
    final result = await _api.delete('/api/v1/users/$userId');
    return result.fold(
      onSuccess: (_) => const Result.success(null),
      onFailure: (error) => Result.failure(error),
    );
  }
}
