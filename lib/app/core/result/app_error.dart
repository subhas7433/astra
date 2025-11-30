/// Base class for all application errors.
/// Provides user-friendly messages and error codes for debugging.
///
/// Usage:
/// ```dart
/// Result<User, AppError> result = await authService.login(email, password);
/// result.fold(
///   onSuccess: (user) => navigateToHome(),
///   onFailure: (error) {
///     showSnackbar(error.message);
///     AppLogger.error(error.message, tag: 'Auth', error: error.originalError);
///   },
/// );
/// ```
sealed class AppError {
  /// User-friendly error message
  final String message;

  /// Error code for debugging/logging
  final String? code;

  /// Original error object (for logging)
  final Object? originalError;

  /// Stack trace (for logging)
  final StackTrace? stackTrace;

  const AppError({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppError(code: $code, message: $message)';
}

// ==================== AUTHENTICATION ERRORS ====================

/// Base class for authentication-related errors
sealed class AuthError extends AppError {
  const AuthError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Invalid email or password
final class InvalidCredentialsError extends AuthError {
  const InvalidCredentialsError({
    super.message = 'Invalid email or password',
    super.code = 'invalid_credentials',
    super.originalError,
    super.stackTrace,
  });
}

/// User account not found
final class UserNotFoundError extends AuthError {
  const UserNotFoundError({
    super.message = 'User not found',
    super.code = 'user_not_found',
    super.originalError,
    super.stackTrace,
  });
}

/// Session has expired, user needs to re-login
final class SessionExpiredError extends AuthError {
  const SessionExpiredError({
    super.message = 'Session expired. Please login again.',
    super.code = 'session_expired',
    super.originalError,
    super.stackTrace,
  });
}

/// Email is already registered
final class EmailAlreadyExistsError extends AuthError {
  const EmailAlreadyExistsError({
    super.message = 'An account with this email already exists',
    super.code = 'email_exists',
    super.originalError,
    super.stackTrace,
  });
}

/// Password is too weak
final class WeakPasswordError extends AuthError {
  const WeakPasswordError({
    super.message = 'Password is too weak. Use at least 8 characters.',
    super.code = 'weak_password',
    super.originalError,
    super.stackTrace,
  });
}

/// General authentication error
final class GeneralAuthError extends AuthError {
  const GeneralAuthError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

// ==================== DATABASE ERRORS ====================

/// Base class for database-related errors
sealed class DatabaseError extends AppError {
  const DatabaseError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Document not found in collection
final class DocumentNotFoundError extends DatabaseError {
  const DocumentNotFoundError({
    super.message = 'Document not found',
    super.code = 'document_not_found',
    super.originalError,
    super.stackTrace,
  });
}

/// User doesn't have permission for this operation
final class PermissionDeniedError extends DatabaseError {
  const PermissionDeniedError({
    super.message = 'Permission denied',
    super.code = 'permission_denied',
    super.originalError,
    super.stackTrace,
  });
}

/// Document already exists (unique constraint violation)
final class DocumentAlreadyExistsError extends DatabaseError {
  const DocumentAlreadyExistsError({
    super.message = 'Document already exists',
    super.code = 'document_exists',
    super.originalError,
    super.stackTrace,
  });
}

/// Invalid data format or validation error
final class ValidationError extends DatabaseError {
  const ValidationError({
    super.message = 'Validation error',
    super.code = 'validation_error',
    super.originalError,
    super.stackTrace,
  });
}

/// General database error
final class GeneralDatabaseError extends DatabaseError {
  const GeneralDatabaseError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

// ==================== STORAGE ERRORS ====================

/// Base class for storage-related errors
sealed class StorageError extends AppError {
  const StorageError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// File not found in storage
final class FileNotFoundError extends StorageError {
  const FileNotFoundError({
    super.message = 'File not found',
    super.code = 'file_not_found',
    super.originalError,
    super.stackTrace,
  });
}

/// File exceeds maximum allowed size
final class FileTooLargeError extends StorageError {
  const FileTooLargeError({
    super.message = 'File exceeds maximum allowed size',
    super.code = 'file_too_large',
    super.originalError,
    super.stackTrace,
  });
}

/// Invalid file type
final class InvalidFileTypeError extends StorageError {
  const InvalidFileTypeError({
    super.message = 'Invalid file type',
    super.code = 'invalid_file_type',
    super.originalError,
    super.stackTrace,
  });
}

/// General storage error
final class GeneralStorageError extends StorageError {
  const GeneralStorageError({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

// ==================== NETWORK ERRORS ====================

/// Network connection error
final class NetworkError extends AppError {
  const NetworkError({
    super.message = 'Network connection error',
    super.code = 'network_error',
    super.originalError,
    super.stackTrace,
  });
}

/// No internet connection
final class NoConnectionError extends AppError {
  const NoConnectionError({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'no_connection',
    super.originalError,
    super.stackTrace,
  });
}

/// Request timed out
final class TimeoutError extends AppError {
  const TimeoutError({
    super.message = 'Request timed out. Please try again.',
    super.code = 'timeout',
    super.originalError,
    super.stackTrace,
  });
}

/// Server returned an error
final class ServerError extends AppError {
  /// HTTP status code
  final int? statusCode;

  const ServerError({
    this.statusCode,
    super.message = 'Server error. Please try again later.',
    super.code = 'server_error',
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'ServerError(statusCode: $statusCode, message: $message)';
}

/// Too many requests (rate limiting)
final class RateLimitError extends AppError {
  const RateLimitError({
    super.message = 'Too many requests. Please wait and try again.',
    super.code = 'rate_limit',
    super.originalError,
    super.stackTrace,
  });
}

// ==================== GENERIC ERRORS ====================

/// Unknown or unexpected error
final class UnknownError extends AppError {
  const UnknownError({
    super.message = 'An unexpected error occurred',
    super.code = 'unknown',
    super.originalError,
    super.stackTrace,
  });
}

/// Operation was cancelled
final class CancelledError extends AppError {
  const CancelledError({
    super.message = 'Operation was cancelled',
    super.code = 'cancelled',
    super.originalError,
    super.stackTrace,
  });
}
