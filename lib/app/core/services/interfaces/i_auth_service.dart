import '../../result/result.dart';
import '../../result/app_error.dart';

/// Authentication service interface.
/// Defines the contract for authentication operations.
///
/// Implementations:
/// - [AppwriteAuthService] - Real Appwrite SDK implementation
/// - [MockAuthService] - In-memory mock for testing
///
/// Usage:
/// ```dart
/// final authService = Get.find<IAuthService>();
///
/// final result = await authService.loginWithEmail(
///   email: 'user@example.com',
///   password: 'password123',
/// );
///
/// result.fold(
///   onSuccess: (userId) => navigateToHome(),
///   onFailure: (error) => showError(error.message),
/// );
/// ```
abstract interface class IAuthService {
  /// Current authenticated user ID, null if not logged in
  String? get currentUserId;

  /// Stream of auth state changes
  /// Emits user ID when logged in, null when logged out
  Stream<String?> get authStateChanges;

  /// Register a new user with email and password
  ///
  /// Returns the user ID on success, or:
  /// - [EmailAlreadyExistsError] if email is taken
  /// - [WeakPasswordError] if password is too weak
  /// - [NetworkError] if connection failed
  Future<Result<String, AppError>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  });

  /// Login with email and password
  ///
  /// Returns the user ID on success, or:
  /// - [InvalidCredentialsError] if email/password is wrong
  /// - [UserNotFoundError] if user doesn't exist
  /// - [NetworkError] if connection failed
  Future<Result<String, AppError>> loginWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with Google
  ///
  /// Returns the user ID on success, or:
  /// - [AuthError] if sign-in cancelled or failed
  /// - [NetworkError] if connection failed
  Future<Result<String, AppError>> signInWithGoogle();

  /// Logout the current user
  ///
  /// Returns void on success, or:
  /// - [SessionExpiredError] if already logged out
  /// - [NetworkError] if connection failed
  Future<Result<void, AppError>> logout();

  /// Check if there's a valid session
  ///
  /// Returns true if logged in, false otherwise
  Future<Result<bool, AppError>> checkSession();

  /// Delete the current user's account
  ///
  /// Returns void on success, or:
  /// - [SessionExpiredError] if not logged in
  /// - [NetworkError] if connection failed
  Future<Result<void, AppError>> deleteAccount();

  /// Send password recovery email
  ///
  /// Returns void on success, or:
  /// - [UserNotFoundError] if email not registered
  /// - [NetworkError] if connection failed
  Future<Result<void, AppError>> sendPasswordRecovery(String email);

  /// Update the current user's password
  ///
  /// Returns void on success, or:
  /// - [InvalidCredentialsError] if old password is wrong
  /// - [WeakPasswordError] if new password is too weak
  /// - [SessionExpiredError] if not logged in
  Future<Result<void, AppError>> updatePassword({
    required String oldPassword,
    required String newPassword,
  });

  /// Update the current user's name
  ///
  /// Returns void on success, or:
  /// - [SessionExpiredError] if not logged in
  /// - [NetworkError] if connection failed
  Future<Result<void, AppError>> updateName(String name);

  /// Dispose resources (close streams)
  void dispose();
}
