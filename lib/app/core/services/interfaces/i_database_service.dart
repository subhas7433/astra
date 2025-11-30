import '../../result/result.dart';
import '../../result/app_error.dart';

/// Query options for list operations
class QueryOptions {
  /// Appwrite query strings (e.g., Query.equal('status', 'active'))
  final List<String>? queries;

  /// Maximum number of documents to return
  final int? limit;

  /// Number of documents to skip
  final int? offset;

  /// Cursor for pagination (document ID to start after)
  final String? cursor;

  const QueryOptions({
    this.queries,
    this.limit,
    this.offset,
    this.cursor,
  });

  /// Create empty options
  const QueryOptions.empty()
      : queries = null,
        limit = null,
        offset = null,
        cursor = null;
}

/// Paginated result wrapper
class PaginatedResult<T> {
  /// List of documents
  final List<T> documents;

  /// Total count of matching documents
  final int total;

  /// Cursor for next page (last document ID)
  final String? cursor;

  const PaginatedResult({
    required this.documents,
    required this.total,
    this.cursor,
  });

  /// Check if there are more documents to fetch
  bool get hasMore => documents.length < total;

  /// Check if result is empty
  bool get isEmpty => documents.isEmpty;

  /// Check if result has documents
  bool get isNotEmpty => documents.isNotEmpty;
}

/// Database service interface.
/// Defines the contract for CRUD operations on Appwrite collections.
///
/// Implementations:
/// - [AppwriteDatabaseService] - Real Appwrite SDK implementation
/// - [MockDatabaseService] - In-memory mock for testing
///
/// Usage:
/// ```dart
/// final dbService = Get.find<IDatabaseService>();
///
/// // Create document
/// final result = await dbService.createDocument(
///   collectionId: AppwriteCollections.users,
///   data: {'name': 'John', 'email': 'john@example.com'},
/// );
///
/// // Read document
/// final userResult = await dbService.getDocument(
///   collectionId: AppwriteCollections.users,
///   documentId: 'user123',
/// );
/// ```
abstract interface class IDatabaseService {
  /// Create a new document in a collection
  ///
  /// Returns the created document data with $id, $createdAt, $updatedAt
  /// - [collectionId] - Target collection ID
  /// - [data] - Document data
  /// - [documentId] - Optional custom ID (auto-generated if null)
  /// - [permissions] - Optional permission strings
  Future<Result<Map<String, dynamic>, AppError>> createDocument({
    required String collectionId,
    required Map<String, dynamic> data,
    String? documentId,
    List<String>? permissions,
  });

  /// Get a document by ID
  ///
  /// Returns the document data, or:
  /// - [DocumentNotFoundError] if document doesn't exist
  /// - [PermissionDeniedError] if user can't access
  Future<Result<Map<String, dynamic>, AppError>> getDocument({
    required String collectionId,
    required String documentId,
  });

  /// Update an existing document
  ///
  /// Returns the updated document data, or:
  /// - [DocumentNotFoundError] if document doesn't exist
  /// - [PermissionDeniedError] if user can't modify
  Future<Result<Map<String, dynamic>, AppError>> updateDocument({
    required String collectionId,
    required String documentId,
    required Map<String, dynamic> data,
    List<String>? permissions,
  });

  /// Delete a document
  ///
  /// Returns void on success, or:
  /// - [DocumentNotFoundError] if document doesn't exist
  /// - [PermissionDeniedError] if user can't delete
  Future<Result<void, AppError>> deleteDocument({
    required String collectionId,
    required String documentId,
  });

  /// List documents with optional queries
  ///
  /// Returns paginated results, or:
  /// - [PermissionDeniedError] if user can't access collection
  Future<Result<PaginatedResult<Map<String, dynamic>>, AppError>> listDocuments({
    required String collectionId,
    QueryOptions? options,
  });

  /// Batch create multiple documents
  ///
  /// Returns list of created documents, or:
  /// - Error if any creation fails (partial results not returned)
  Future<Result<List<Map<String, dynamic>>, AppError>> batchCreate({
    required String collectionId,
    required List<Map<String, dynamic>> documents,
  });

  /// Check if a document exists
  ///
  /// Returns true if exists, false otherwise
  Future<Result<bool, AppError>> documentExists({
    required String collectionId,
    required String documentId,
  });
}
