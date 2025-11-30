import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

import '../../config/appwrite_config.dart';
import '../../result/result.dart';
import '../../result/app_error.dart';
import '../../utils/app_logger.dart';
import '../../../data/providers/appwrite_client_provider.dart';
import '../interfaces/i_database_service.dart';

/// Appwrite implementation of [IDatabaseService].
/// Handles CRUD operations using Appwrite Databases SDK.
///
/// Usage:
/// ```dart
/// final dbService = Get.find<IDatabaseService>();
/// final result = await dbService.createDocument(
///   collectionId: AppwriteCollections.users,
///   data: {'name': 'John', 'email': 'john@example.com'},
/// );
/// ```
class AppwriteDatabaseService extends GetxService implements IDatabaseService {
  static const String _tag = 'DatabaseService';

  final AppwriteClientProvider _clientProvider;
  final AppwriteConfig _config;

  Databases get _databases => _clientProvider.databases;
  String get _databaseId => _config.databaseId;

  /// Private constructor for dependency injection
  AppwriteDatabaseService(this._clientProvider, this._config);

  /// Factory method for GetX initialization
  static AppwriteDatabaseService init(
    AppwriteClientProvider provider,
    AppwriteConfig config,
  ) {
    return AppwriteDatabaseService(provider, config);
  }

  @override
  Future<Result<Map<String, dynamic>, AppError>> createDocument({
    required String collectionId,
    required Map<String, dynamic> data,
    String? documentId,
    List<String>? permissions,
  }) async {
    AppLogger.debug(
      'Creating document in $collectionId',
      tag: _tag,
    );

    try {
      final document = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: collectionId,
        documentId: documentId ?? ID.unique(),
        data: data,
        permissions: permissions,
      );

      AppLogger.info(
        'Document created: ${document.$id} in $collectionId',
        tag: _tag,
      );

      return Result.success(_documentToMap(document));
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Create document failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Create document failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, AppError>> getDocument({
    required String collectionId,
    required String documentId,
  }) async {
    AppLogger.debug(
      'Getting document $documentId from $collectionId',
      tag: _tag,
    );

    try {
      final document = await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );

      return Result.success(_documentToMap(document));
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Get document failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Get document failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, AppError>> updateDocument({
    required String collectionId,
    required String documentId,
    required Map<String, dynamic> data,
    List<String>? permissions,
  }) async {
    AppLogger.debug(
      'Updating document $documentId in $collectionId',
      tag: _tag,
    );

    try {
      final document = await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: data,
        permissions: permissions,
      );

      AppLogger.info(
        'Document updated: ${document.$id} in $collectionId',
        tag: _tag,
      );

      return Result.success(_documentToMap(document));
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Update document failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Update document failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<void, AppError>> deleteDocument({
    required String collectionId,
    required String documentId,
  }) async {
    AppLogger.debug(
      'Deleting document $documentId from $collectionId',
      tag: _tag,
    );

    try {
      await _databases.deleteDocument(
        databaseId: _databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );

      AppLogger.info(
        'Document deleted: $documentId from $collectionId',
        tag: _tag,
      );

      return const Result.success(null);
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Delete document failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Delete document failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<PaginatedResult<Map<String, dynamic>>, AppError>> listDocuments({
    required String collectionId,
    QueryOptions? options,
  }) async {
    AppLogger.debug(
      'Listing documents from $collectionId',
      tag: _tag,
    );

    try {
      // Build queries list
      final queries = <String>[
        ...?options?.queries,
        if (options?.limit != null) Query.limit(options!.limit!),
        if (options?.offset != null) Query.offset(options!.offset!),
        if (options?.cursor != null) Query.cursorAfter(options!.cursor!),
      ];

      final result = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: collectionId,
        queries: queries.isNotEmpty ? queries : null,
      );

      final documents = result.documents.map(_documentToMap).toList();
      final cursor = documents.isNotEmpty ? documents.last['\$id'] as String? : null;

      AppLogger.debug(
        'Listed ${documents.length} documents from $collectionId (total: ${result.total})',
        tag: _tag,
      );

      return Result.success(PaginatedResult(
        documents: documents,
        total: result.total,
        cursor: cursor,
      ));
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('List documents failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'List documents failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<List<Map<String, dynamic>>, AppError>> batchCreate({
    required String collectionId,
    required List<Map<String, dynamic>> documents,
  }) async {
    AppLogger.debug(
      'Batch creating ${documents.length} documents in $collectionId',
      tag: _tag,
    );

    try {
      final results = <Map<String, dynamic>>[];

      // Appwrite doesn't have native batch create, so we create sequentially
      // Consider using Appwrite Functions for true batch operations
      for (final data in documents) {
        final document = await _databases.createDocument(
          databaseId: _databaseId,
          collectionId: collectionId,
          documentId: ID.unique(),
          data: data,
        );
        results.add(_documentToMap(document));
      }

      AppLogger.info(
        'Batch created ${results.length} documents in $collectionId',
        tag: _tag,
      );

      return Result.success(results);
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Batch create failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Batch create failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<bool, AppError>> documentExists({
    required String collectionId,
    required String documentId,
  }) async {
    AppLogger.debug(
      'Checking if document $documentId exists in $collectionId',
      tag: _tag,
    );

    try {
      await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
      return const Result.success(true);
    } on AppwriteException catch (e, _) {
      // 404 means document doesn't exist
      if (e.code == 404) {
        return const Result.success(false);
      }
      return Result.failure(_mapAppwriteException(e, StackTrace.current));
    } catch (e, stack) {
      AppLogger.error('Document exists check failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Document exists check failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  /// Convert Appwrite Document to Map including system fields
  Map<String, dynamic> _documentToMap(dynamic document) {
    return {
      '\$id': document.$id,
      '\$collectionId': document.$collectionId,
      '\$databaseId': document.$databaseId,
      '\$createdAt': document.$createdAt,
      '\$updatedAt': document.$updatedAt,
      '\$permissions': document.$permissions,
      ...document.data,
    };
  }

  /// Map Appwrite exceptions to typed AppError
  AppError _mapAppwriteException(AppwriteException e, StackTrace stack) {
    AppLogger.warning(
      'Appwrite error: ${e.code} - ${e.message}',
      tag: _tag,
    );

    return switch (e.code) {
      // Document errors
      404 => DocumentNotFoundError(
          message: e.message ?? 'Document not found',
          originalError: e,
          stackTrace: stack,
        ),
      409 => DocumentAlreadyExistsError(
          message: e.message ?? 'Document already exists',
          originalError: e,
          stackTrace: stack,
        ),

      // Permission errors
      401 || 403 => PermissionDeniedError(
          message: e.message ?? 'Permission denied',
          originalError: e,
          stackTrace: stack,
        ),

      // Validation errors
      400 => ValidationError(
          message: e.message ?? 'Invalid data',
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
