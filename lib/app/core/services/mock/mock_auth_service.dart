import 'dart:async';

import '../../result/result.dart';
import '../../result/app_error.dart';
import '../../utils/app_logger.dart';
import '../interfaces/i_auth_service.dart';

/// Mock implementation of [IAuthService] for testing and offline development.
/// Simulates authentication without network calls.
///
/// Features:
/// - In-memory user storage
/// - Simulated delays for realistic behavior
/// - `forceError` flag to test error handling
///
/// Usage:
/// ```dart
/// final mockAuth = MockAuthService();
/// mockAuth.forceError = true; // Force errors for testing
/// ```
class MockAuthService implements IAuthService {
  static const String _tag = 'MockAuthService';
  static const Duration _simulatedDelay = Duration(milliseconds: 300);

  /// Flag to force errors for testing error handling
  bool forceError = false;

  /// Error to return when forceError is true
  AppError? forcedError;

  /// In-memory user storage: email -> {password, name, userId}
  final Map<String, Map<String, String>> _users = {};

  /// Current session
  String? _currentUserId;

  /// Stream controller for auth state changes
  final _authStateController = StreamController<String?>.broadcast();

  @override
  String? get currentUserId => _currentUserId;

  @override
  Stream<String?> get authStateChanges => _authStateController.stream;

  /// Update auth state and notify listeners
  void _updateAuthState(String? userId) {
    _currentUserId = userId;
    _authStateController.add(userId);
  }

  @override
  Future<Result<String, AppError>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Registering user $email', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    if (_users.containsKey(email)) {
      return const Result.failure(EmailAlreadyExistsError(
        message: 'Email already registered',
      ));
    }

    final userId = 'mock_user_${DateTime.now().millisecondsSinceEpoch}';
    _users[email] = {
      'password': password,
      'name': name,
      'userId': userId,
    };

    _updateAuthState(userId);
    return Result.success(userId);
  }

  @override
  Future<Result<String, AppError>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Logging in user $email', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    final user = _users[email];
    if (user == null) {
      return const Result.failure(UserNotFoundError(
        message: 'User not found',
      ));
    }

    if (user['password'] != password) {
      return const Result.failure(InvalidCredentialsError(
        message: 'Invalid password',
      ));
    }

    final userId = user['userId']!;
    _updateAuthState(userId);
    return Result.success(userId);
  }

  @override
  Future<Result<void, AppError>> logout() async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Logging out', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    _updateAuthState(null);
    return const Result.success(null);
  }

  @override
  Future<Result<bool, AppError>> checkSession() async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Checking session', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    return Result.success(_currentUserId != null);
  }

  @override
  Future<Result<void, AppError>> deleteAccount() async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Deleting account', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    if (_currentUserId == null) {
      return const Result.failure(SessionExpiredError(
        message: 'Not logged in',
      ));
    }

    // Remove user from storage
    _users.removeWhere((_, user) => user['userId'] == _currentUserId);
    _updateAuthState(null);
    return const Result.success(null);
  }

  @override
  Future<Result<void, AppError>> sendPasswordRecovery(String email) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Sending password recovery to $email', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    if (!_users.containsKey(email)) {
      return const Result.failure(UserNotFoundError(
        message: 'User not found',
      ));
    }

    // Simulate sending email (no actual action)
    return const Result.success(null);
  }

  @override
  Future<Result<void, AppError>> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Updating password', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    if (_currentUserId == null) {
      return const Result.failure(SessionExpiredError(
        message: 'Not logged in',
      ));
    }

    // Find current user and update password
    for (final entry in _users.entries) {
      if (entry.value['userId'] == _currentUserId) {
        if (entry.value['password'] != oldPassword) {
          return const Result.failure(InvalidCredentialsError(
            message: 'Invalid old password',
          ));
        }
        entry.value['password'] = newPassword;
        return const Result.success(null);
      }
    }

    return const Result.failure(SessionExpiredError(
      message: 'User session invalid',
    ));
  }

  @override
  Future<Result<void, AppError>> updateName(String name) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Updating name to $name', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    if (_currentUserId == null) {
      return const Result.failure(SessionExpiredError(
        message: 'Not logged in',
      ));
    }

    // Find current user and update name
    for (final entry in _users.entries) {
      if (entry.value['userId'] == _currentUserId) {
        entry.value['name'] = name;
        return const Result.success(null);
      }
    }

    return const Result.failure(SessionExpiredError(
      message: 'User session invalid',
    ));
  }

  @override
  void dispose() {
    _authStateController.close();
    AppLogger.debug('MockAuthService disposed', tag: _tag);
  }

  /// Reset mock state for testing
  void reset() {
    _users.clear();
    _currentUserId = null;
    forceError = false;
    forcedError = null;
  }

  /// Add a pre-registered user for testing
  void addMockUser({
    required String email,
    required String password,
    required String name,
    String? userId,
  }) {
    final id = userId ?? 'mock_user_${DateTime.now().millisecondsSinceEpoch}';
    _users[email] = {
      'password': password,
      'name': name,
      'userId': id,
    };
  }
}
