/// A Result type that represents either success or failure.
/// Forces explicit handling of both cases - no silent failures.
///
/// Usage:
/// ```dart
/// Future<Result<User, AppError>> login(String email, String password) async {
///   try {
///     final user = await auth.login(email, password);
///     return Result.success(user);
///   } catch (e) {
///     return Result.failure(InvalidCredentialsError());
///   }
/// }
///
/// // Handling the result
/// final result = await login(email, password);
/// result.fold(
///   onSuccess: (user) => navigateToHome(),
///   onFailure: (error) => showError(error.message),
/// );
/// ```
sealed class Result<T, E> {
  const Result();

  /// Create a success result
  const factory Result.success(T value) = Success<T, E>;

  /// Create a failure result
  const factory Result.failure(E error) = Failure<T, E>;

  /// Check if this is a success
  bool get isSuccess;

  /// Check if this is a failure
  bool get isFailure;

  /// Get the value or null if failure
  T? get valueOrNull;

  /// Get the error or null if success
  E? get errorOrNull;

  /// Transform the success value
  Result<U, E> map<U>(U Function(T value) transform);

  /// Chain another operation that returns Result
  Result<U, E> flatMap<U>(Result<U, E> Function(T value) transform);

  /// Handle both cases
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(E error) onFailure,
  });

  /// Get value or throw the error
  T getOrThrow();

  /// Get value or return default
  T getOrElse(T defaultValue);
}

/// Success case of Result
final class Success<T, E> extends Result<T, E> {
  /// The success value
  final T value;

  const Success(this.value);

  @override
  bool get isSuccess => true;

  @override
  bool get isFailure => false;

  @override
  T? get valueOrNull => value;

  @override
  E? get errorOrNull => null;

  @override
  Result<U, E> map<U>(U Function(T value) transform) {
    return Result.success(transform(value));
  }

  @override
  Result<U, E> flatMap<U>(Result<U, E> Function(T value) transform) {
    return transform(value);
  }

  @override
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(E error) onFailure,
  }) {
    return onSuccess(value);
  }

  @override
  T getOrThrow() => value;

  @override
  T getOrElse(T defaultValue) => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T, E> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// Failure case of Result
final class Failure<T, E> extends Result<T, E> {
  /// The error value
  final E error;

  const Failure(this.error);

  @override
  bool get isSuccess => false;

  @override
  bool get isFailure => true;

  @override
  T? get valueOrNull => null;

  @override
  E? get errorOrNull => error;

  @override
  Result<U, E> map<U>(U Function(T value) transform) {
    return Result.failure(error);
  }

  @override
  Result<U, E> flatMap<U>(Result<U, E> Function(T value) transform) {
    return Result.failure(error);
  }

  @override
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(E error) onFailure,
  }) {
    return onFailure(error);
  }

  @override
  T getOrThrow() => throw error as Object;

  @override
  T getOrElse(T defaultValue) => defaultValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T, E> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}

/// Extension for async Result operations
extension ResultFutureExtension<T, E> on Future<Result<T, E>> {
  /// Transform the success value asynchronously
  Future<Result<U, E>> mapAsync<U>(U Function(T value) transform) async {
    return (await this).map(transform);
  }

  /// Chain another async operation that returns Result
  Future<Result<U, E>> flatMapAsync<U>(
    Future<Result<U, E>> Function(T value) transform,
  ) async {
    final result = await this;
    return result.fold(
      onSuccess: transform,
      onFailure: (e) async => Result.failure(e),
    );
  }
}
