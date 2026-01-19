import 'package:appwrite/appwrite.dart';
import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../../core/utils/app_logger.dart';
import '../../data/providers/appwrite_client_provider.dart';
import '../models/user_model.dart';

class UserRepository {
  static const String _tag = 'UserRepository';
  static const String _collectionId = 'users';

  final AppwriteClientProvider _provider;

  UserRepository(this._provider);

  Databases get _databases => _provider.databases;
  String get _databaseId => _provider.config.databaseId;

  /// Get user profile by ID
  Future<Result<UserModel, AppError>> getUser(String userId) async {
    try {
      final document = await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: userId,
      );

      final user = UserModel.fromMap(document.data);
      return Result.success(user);
    } on AppwriteException catch (e, stack) {
      AppLogger.error('Failed to get user: $userId', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Failed to get user: $userId', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Failed to get user',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  /// Create or update user profile
  Future<Result<UserModel, AppError>> saveUser(UserModel user) async {
    try {
      // Check if document exists
      try {
        await _databases.getDocument(
          databaseId: _databaseId,
          collectionId: _collectionId,
          documentId: user.id,
        );
        
        // Update existing
        final document = await _databases.updateDocument(
          databaseId: _databaseId,
          collectionId: _collectionId,
          documentId: user.id,
          data: user.toMap(),
        );
        return Result.success(UserModel.fromMap(document.data));
      } on AppwriteException catch (e) {
        if (e.code == 404) {
          // Create new
          final document = await _databases.createDocument(
            databaseId: _databaseId,
            collectionId: _collectionId,
            documentId: user.id,
            data: user.toMap(),
          );
          return Result.success(UserModel.fromMap(document.data));
        }
        rethrow;
      }
    } on AppwriteException catch (e, stack) {
      AppLogger.error('Failed to save user: ${user.id}', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Failed to save user: ${user.id}', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Failed to save user',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  AppError _mapAppwriteException(AppwriteException e, StackTrace stack) {
    if (e.code == 404) {
      return UserNotFoundError(message: 'User not found', originalError: e, stackTrace: stack);
    }
    return UnknownError(message: e.message ?? 'Unknown Appwrite error', originalError: e, stackTrace: stack);
  }
}
