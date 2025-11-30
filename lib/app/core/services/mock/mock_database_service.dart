import '../../result/result.dart';
import '../../result/app_error.dart';
import '../../utils/app_logger.dart';
import '../interfaces/i_database_service.dart';

/// Mock implementation of [IDatabaseService] for testing and offline development.
/// Simulates database operations with in-memory storage.
///
/// Features:
/// - In-memory document storage per collection
/// - Simulated delays for realistic behavior
/// - `forceError` flag to test error handling
/// - Query simulation (basic filtering)
///
/// Usage:
/// ```dart
/// final mockDb = MockDatabaseService();
/// mockDb.forceError = true; // Force errors for testing
/// ```
class MockDatabaseService implements IDatabaseService {
  static const String _tag = 'MockDatabaseService';
  static const Duration _simulatedDelay = Duration(milliseconds: 200);

  /// Flag to force errors for testing error handling
  bool forceError = false;

  /// Error to return when forceError is true
  AppError? forcedError;

  /// In-memory storage: collectionId -> documentId -> document data
  final Map<String, Map<String, Map<String, dynamic>>> _storage = {};

  /// Counter for unique IDs
  int _idCounter = 0;

  /// Generate unique document ID
  String _generateId() => 'mock_doc_${++_idCounter}';

  /// Get current timestamp string
  String _timestamp() => DateTime.now().toIso8601String();

  @override
  Future<Result<Map<String, dynamic>, AppError>> createDocument({
    required String collectionId,
    required Map<String, dynamic> data,
    String? documentId,
    List<String>? permissions,
  }) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Creating document in $collectionId', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    final id = documentId ?? _generateId();
    final collection = _storage.putIfAbsent(collectionId, () => {});

    if (collection.containsKey(id)) {
      return const Result.failure(DocumentAlreadyExistsError(
        message: 'Document already exists',
      ));
    }

    final now = _timestamp();
    final document = {
      '\$id': id,
      '\$collectionId': collectionId,
      '\$databaseId': 'mock_database',
      '\$createdAt': now,
      '\$updatedAt': now,
      '\$permissions': permissions ?? [],
      ...data,
    };

    collection[id] = document;
    return Result.success(document);
  }

  @override
  Future<Result<Map<String, dynamic>, AppError>> getDocument({
    required String collectionId,
    required String documentId,
  }) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Getting document $documentId from $collectionId', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    final collection = _storage[collectionId];
    if (collection == null || !collection.containsKey(documentId)) {
      return const Result.failure(DocumentNotFoundError(
        message: 'Document not found',
      ));
    }

    return Result.success(Map.from(collection[documentId]!));
  }

  @override
  Future<Result<Map<String, dynamic>, AppError>> updateDocument({
    required String collectionId,
    required String documentId,
    required Map<String, dynamic> data,
    List<String>? permissions,
  }) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Updating document $documentId in $collectionId', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    final collection = _storage[collectionId];
    if (collection == null || !collection.containsKey(documentId)) {
      return const Result.failure(DocumentNotFoundError(
        message: 'Document not found',
      ));
    }

    final existing = collection[documentId]!;
    final updated = {
      ...existing,
      ...data,
      '\$updatedAt': _timestamp(),
      if (permissions != null) '\$permissions': permissions,
    };

    collection[documentId] = updated;
    return Result.success(Map.from(updated));
  }

  @override
  Future<Result<void, AppError>> deleteDocument({
    required String collectionId,
    required String documentId,
  }) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Deleting document $documentId from $collectionId', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    final collection = _storage[collectionId];
    if (collection == null || !collection.containsKey(documentId)) {
      return const Result.failure(DocumentNotFoundError(
        message: 'Document not found',
      ));
    }

    collection.remove(documentId);
    return const Result.success(null);
  }

  @override
  Future<Result<PaginatedResult<Map<String, dynamic>>, AppError>> listDocuments({
    required String collectionId,
    QueryOptions? options,
  }) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Listing documents from $collectionId', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    final collection = _storage[collectionId] ?? {};
    var documents = collection.values.map((d) => Map<String, dynamic>.from(d)).toList();

    // Apply basic pagination
    final total = documents.length;
    final offset = options?.offset ?? 0;
    final limit = options?.limit ?? 25;

    if (offset > 0 && offset < documents.length) {
      documents = documents.skip(offset).toList();
    }

    if (limit > 0 && documents.length > limit) {
      documents = documents.take(limit).toList();
    }

    final cursor = documents.isNotEmpty ? documents.last['\$id'] as String? : null;

    return Result.success(PaginatedResult(
      documents: documents,
      total: total,
      cursor: cursor,
    ));
  }

  @override
  Future<Result<List<Map<String, dynamic>>, AppError>> batchCreate({
    required String collectionId,
    required List<Map<String, dynamic>> documents,
  }) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Batch creating ${documents.length} documents in $collectionId', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    final results = <Map<String, dynamic>>[];
    for (final data in documents) {
      final result = await createDocument(
        collectionId: collectionId,
        data: data,
      );

      final doc = result.valueOrNull;
      if (doc == null) {
        return Result.failure(result.errorOrNull ?? const UnknownError(
          message: 'Batch create failed',
        ));
      }
      results.add(doc);
    }

    return Result.success(results);
  }

  @override
  Future<Result<bool, AppError>> documentExists({
    required String collectionId,
    required String documentId,
  }) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Checking if document $documentId exists in $collectionId', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    final collection = _storage[collectionId];
    final exists = collection?.containsKey(documentId) ?? false;
    return Result.success(exists);
  }

  /// Reset mock state for testing
  void reset() {
    _storage.clear();
    _idCounter = 0;
    forceError = false;
    forcedError = null;
  }

  /// Seed mock data for testing
  void seedCollection(String collectionId, List<Map<String, dynamic>> documents) {
    final collection = _storage.putIfAbsent(collectionId, () => {});
    for (final data in documents) {
      final id = data['\$id'] as String? ?? _generateId();
      final now = _timestamp();
      collection[id] = {
        '\$id': id,
        '\$collectionId': collectionId,
        '\$databaseId': 'mock_database',
        '\$createdAt': data['\$createdAt'] ?? now,
        '\$updatedAt': data['\$updatedAt'] ?? now,
        '\$permissions': data['\$permissions'] ?? [],
        ...data,
      };
    }
  }

  /// Get all documents in a collection (for testing verification)
  List<Map<String, dynamic>> getCollectionData(String collectionId) {
    return _storage[collectionId]?.values.toList() ?? [];
  }
}
