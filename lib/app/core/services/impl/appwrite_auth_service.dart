import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../result/result.dart';
import '../../result/app_error.dart';
import '../../utils/app_logger.dart';
import '../../../data/providers/appwrite_client_provider.dart';
import '../interfaces/i_auth_service.dart';

/// Appwrite implementation of [IAuthService].
/// Handles authentication using Appwrite Account SDK.
///
/// Usage:
/// ```dart
/// final authService = Get.find<IAuthService>();
/// final result = await authService.loginWithEmail(
///   email: 'user@example.com',
///   password: 'password123',
/// );
/// ```
class AppwriteAuthService extends GetxService implements IAuthService {
  static const String _tag = 'AuthService';

  final AppwriteClientProvider _clientProvider;
  Account get _account => _clientProvider.account;

  /// Current user ID cached locally
  String? _currentUserId;

  /// Stream controller for auth state changes
  final _authStateController = StreamController<String?>.broadcast();

  /// Private constructor for dependency injection
  AppwriteAuthService(this._clientProvider);

  /// Factory method for GetX initialization
  static AppwriteAuthService init(AppwriteClientProvider provider) {
    return AppwriteAuthService(provider);
  }

  @override
  String? get currentUserId => _currentUserId;

  @override
  Stream<String?> get authStateChanges => _authStateController.stream;

  @override
  void onInit() {
    super.onInit();
    // Check session on service initialization
    _initializeAuthState();
  }

  /// Initialize auth state by checking existing session
  Future<void> _initializeAuthState() async {
    final result = await checkSession();
    result.fold(
      onSuccess: (isLoggedIn) {
        if (!isLoggedIn) {
          _updateAuthState(null);
        }
      },
      onFailure: (_) => _updateAuthState(null),
    );
  }

  /// Update auth state and notify listeners
  void _updateAuthState(String? userId) {
    _currentUserId = userId;
    _authStateController.add(userId);
    AppLogger.debug(
      userId != null ? 'Auth state: logged in ($userId)' : 'Auth state: logged out',
      tag: _tag,
    );
  }

  @override
  Future<Result<String, AppError>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    AppLogger.info('Registering user: $email', tag: _tag);

    try {
      // Create user account
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      AppLogger.info('User registered: ${user.$id}', tag: _tag);

      // Auto-login after registration
      final loginResult = await loginWithEmail(email: email, password: password);

      return loginResult.fold(
        onSuccess: (_) => Result.success(user.$id),
        onFailure: (error) => Result.failure(error),
      );
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Registration failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Registration failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<String, AppError>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    AppLogger.info('Logging in user: $email', tag: _tag);

    try {
      // Create email session
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // Get current user
      final user = await _account.get();
      _updateAuthState(user.$id);

      AppLogger.info('Login successful: ${user.$id}', tag: _tag);
      return Result.success(user.$id);
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Login failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Login failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<String, AppError>> signInWithGoogle() async {
    AppLogger.info('Initiating Google Sign-In', tag: _tag);

    try {
      final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      final googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        return Result.failure(AuthError(message: 'Google sign-in cancelled'));
      }

      AppLogger.info('Google user signed in: ${googleUser.email}', tag: _tag);

      // Create Appwrite OAuth2 session
      // Note: This flow might need adjustment depending on specific Appwrite + Flutter setup
      // For mobile, we often use createOAuth2Session which opens a webview
      // But since we are using google_sign_in package, we might want to use createSession with token if supported
      // Or standard OAuth2 flow. 
      // The standard Appwrite Flutter OAuth2 flow:
      await _account.createOAuth2Session(
        provider: 'google',
      );

      // After webview closes, we check session
      final user = await _account.get();
      _updateAuthState(user.$id);
      
      return Result.success(user.$id);
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Google Sign-In failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Google Sign-In failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<void, AppError>> logout() async {
    AppLogger.info('Logging out user', tag: _tag);

    try {
      // Delete current session
      await _account.deleteSession(sessionId: 'current');
      _updateAuthState(null);

      AppLogger.info('Logout successful', tag: _tag);
      return const Result.success(null);
    } on AppwriteException catch (e, stack) {
      // If already logged out, consider it success
      if (e.code == 401) {
        _updateAuthState(null);
        return const Result.success(null);
      }
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Logout failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Logout failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<bool, AppError>> checkSession() async {
    AppLogger.debug('Checking session', tag: _tag);

    try {
      final user = await _account.get();
      _updateAuthState(user.$id);
      return const Result.success(true);
    } on AppwriteException catch (e, stack) {
      // 401 means no valid session - not an error, just not logged in
      if (e.code == 401) {
        _updateAuthState(null);
        return const Result.success(false);
      }
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Session check failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Session check failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<void, AppError>> deleteAccount() async {
    AppLogger.info('Deleting user account', tag: _tag);

    try {
      // Update identity (this is how Appwrite handles account deletion)
      await _account.updateStatus();
      _updateAuthState(null);

      AppLogger.info('Account deleted successfully', tag: _tag);
      return const Result.success(null);
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Account deletion failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Account deletion failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<void, AppError>> sendPasswordRecovery(String email) async {
    AppLogger.info('Sending password recovery to: $email', tag: _tag);

    try {
      await _account.createRecovery(
        email: email,
        url: 'https://astra-app.com/auth/reset-password',
      );

      AppLogger.info('Password recovery email sent', tag: _tag);
      return const Result.success(null);
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Password recovery failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Password recovery failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<void, AppError>> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    AppLogger.info('Updating password', tag: _tag);

    try {
      await _account.updatePassword(
        password: newPassword,
        oldPassword: oldPassword,
      );

      AppLogger.info('Password updated successfully', tag: _tag);
      return const Result.success(null);
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Password update failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Password update failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<void, AppError>> updateName(String name) async {
    AppLogger.info('Updating user name', tag: _tag);

    try {
      await _account.updateName(name: name);

      AppLogger.info('Name updated successfully', tag: _tag);
      return const Result.success(null);
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Name update failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Name update failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  void dispose() {
    _authStateController.close();
    AppLogger.debug('AuthService disposed', tag: _tag);
  }

  @override
  void onClose() {
    dispose();
    super.onClose();
  }

  /// Map Appwrite exceptions to typed AppError
  AppError _mapAppwriteException(AppwriteException e, StackTrace stack) {
    AppLogger.warning(
      'Appwrite error: ${e.code} - ${e.message}',
      tag: _tag,
    );

    return switch (e.code) {
      // Authentication errors
      401 => SessionExpiredError(
          message: e.message ?? 'Session expired',
          originalError: e,
          stackTrace: stack,
        ),
      409 => EmailAlreadyExistsError(
          message: e.message ?? 'Email already exists',
          originalError: e,
          stackTrace: stack,
        ),
      400 when e.type == 'user_invalid_credentials' => InvalidCredentialsError(
          message: e.message ?? 'Invalid email or password',
          originalError: e,
          stackTrace: stack,
        ),
      400 when e.type == 'password_recently_used' ||
          e.type == 'password_personal_data' => WeakPasswordError(
          message: e.message ?? 'Password does not meet requirements',
          originalError: e,
          stackTrace: stack,
        ),
      404 => UserNotFoundError(
          message: e.message ?? 'User not found',
          originalError: e,
          stackTrace: stack,
        ),

      // Network errors
      0 || -1 => NetworkError(
          message: e.message ?? 'Network connection failed',
          originalError: e,
          stackTrace: stack,
        ),

      // Rate limiting
      429 => RateLimitError(
          message: e.message ?? 'Too many requests',
          originalError: e,
          stackTrace: stack,
        ),

      // Default
      _ => UnknownError(
          message: e.message ?? 'An unknown error occurred',
          code: e.code?.toString(),
          originalError: e,
          stackTrace: stack,
        ),
    };
  }
}
