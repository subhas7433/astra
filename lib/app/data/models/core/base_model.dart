import 'package:equatable/equatable.dart';

import '../../../core/result/result.dart';
import '../../../core/result/app_error.dart';

/// Abstract base model with common fields and methods.
///
/// All data models should extend this class to ensure consistency:
/// - Common fields: id, createdAt, updatedAt
/// - Required methods: toMap(), validate(), copyWith()
/// - Equatable integration for value equality
///
/// Usage:
/// ```dart
/// class UserModel extends BaseModel {
///   final String email;
///
///   const UserModel({
///     required super.id,
///     required this.email,
///     required super.createdAt,
///     required super.updatedAt,
///   });
///
///   @override
///   Map<String, dynamic> toMap() => {...super.toMap(), 'email': email};
///
///   @override
///   Result<void, AppError> validate() {
///     if (email.isEmpty) return Result.failure(ValidationError(message: 'Email required'));
///     return const Result.success(null);
///   }
///
///   @override
///   List<Object?> get props => [...super.props, email];
/// }
/// ```
abstract class BaseModel extends Equatable {
  /// Document ID from Appwrite ($id).
  final String id;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Last update timestamp.
  final DateTime updatedAt;

  const BaseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert model to Map for Appwrite.
  /// Subclasses should call super.toMap() and add their fields.
  Map<String, dynamic> toMap();

  /// Validate model data.
  /// Returns Result.success(null) if valid, Result.failure(AppError) if invalid.
  Result<void, AppError> validate();

  /// Base validation for common fields.
  /// Subclasses can call this as part of their validate() implementation.
  Result<void, AppError> validateBase() {
    if (id.isEmpty) {
      return Result.failure(
        const ValidationError(message: 'Document ID is required'),
      );
    }
    return const Result.success(null);
  }

  /// Props for Equatable equality checking.
  /// Subclasses should override and include [...super.props, ...theirProps].
  @override
  List<Object?> get props => [id, createdAt, updatedAt];

  /// Standard toString for debugging.
  @override
  String toString() => '$runtimeType(id: $id)';
}
