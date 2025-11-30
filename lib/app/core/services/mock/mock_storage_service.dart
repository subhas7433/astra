import 'dart:typed_data';

import '../../result/result.dart';
import '../../result/app_error.dart';
import '../../utils/app_logger.dart';
import '../interfaces/i_storage_service.dart';

/// Mock implementation of [IStorageService] for testing and offline development.
/// Simulates file storage operations with in-memory storage.
///
/// Features:
/// - In-memory file storage per bucket
/// - Simulated delays for realistic behavior
/// - `forceError` flag to test error handling
/// - File size limits simulation
///
/// Usage:
/// ```dart
/// final mockStorage = MockStorageService();
/// mockStorage.forceError = true; // Force errors for testing
/// ```
class MockStorageService implements IStorageService {
  static const String _tag = 'MockStorageService';
  static const Duration _simulatedDelay = Duration(milliseconds: 250);

  /// Maximum file size in bytes (10MB default)
  static const int maxFileSize = 10 * 1024 * 1024;

  /// Flag to force errors for testing error handling
  bool forceError = false;

  /// Error to return when forceError is true
  AppError? forcedError;

  /// In-memory storage: bucketId -> fileId -> file data
  final Map<String, Map<String, _MockFile>> _storage = {};

  /// Counter for unique IDs
  int _idCounter = 0;

  /// Generate unique file ID
  String _generateId() => 'mock_file_${++_idCounter}';

  @override
  Future<Result<FileUploadResult, AppError>> uploadFile({
    required String bucketId,
    required String fileName,
    required Uint8List fileBytes,
    String? fileId,
    List<String>? permissions,
  }) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Uploading file $fileName to bucket $bucketId', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    // Check file size
    if (fileBytes.length > maxFileSize) {
      return const Result.failure(FileTooLargeError(
        message: 'File exceeds maximum size of 10MB',
      ));
    }

    final id = fileId ?? _generateId();
    final bucket = _storage.putIfAbsent(bucketId, () => {});

    final mimeType = _guessMimeType(fileName);
    final mockFile = _MockFile(
      id: id,
      bucketId: bucketId,
      name: fileName,
      bytes: fileBytes,
      mimeType: mimeType,
      permissions: permissions ?? [],
    );

    bucket[id] = mockFile;

    return Result.success(FileUploadResult(
      fileId: id,
      bucketId: bucketId,
      name: fileName,
      size: fileBytes.length,
      mimeType: mimeType,
    ));
  }

  @override
  Result<String, AppError> getFileUrl({
    required String bucketId,
    required String fileId,
  }) {
    AppLogger.debug('Mock: Getting file URL for $fileId in bucket $bucketId', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    // Return a mock URL (synchronous - no validation)
    return Result.success(
      'https://mock.appwrite.io/v1/storage/buckets/$bucketId/files/$fileId/download',
    );
  }

  @override
  Result<String, AppError> getFilePreviewUrl({
    required String bucketId,
    required String fileId,
    int? width,
    int? height,
    String? gravity,
    int? quality,
  }) {
    AppLogger.debug('Mock: Getting file preview URL for $fileId', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    // Build mock preview URL with parameters
    final params = <String>[];
    if (width != null) params.add('width=$width');
    if (height != null) params.add('height=$height');
    if (gravity != null) params.add('gravity=$gravity');
    if (quality != null) params.add('quality=$quality');

    final queryString = params.isNotEmpty ? '?${params.join('&')}' : '';

    return Result.success(
      'https://mock.appwrite.io/v1/storage/buckets/$bucketId/files/$fileId/preview$queryString',
    );
  }

  @override
  Future<Result<void, AppError>> deleteFile({
    required String bucketId,
    required String fileId,
  }) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Deleting file $fileId from bucket $bucketId', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    final bucket = _storage[bucketId];
    if (bucket == null || !bucket.containsKey(fileId)) {
      return const Result.failure(FileNotFoundError(
        message: 'File not found',
      ));
    }

    bucket.remove(fileId);
    return const Result.success(null);
  }

  @override
  Future<Result<Uint8List, AppError>> downloadFile({
    required String bucketId,
    required String fileId,
  }) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Downloading file $fileId from bucket $bucketId', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    final bucket = _storage[bucketId];
    if (bucket == null || !bucket.containsKey(fileId)) {
      return const Result.failure(FileNotFoundError(
        message: 'File not found',
      ));
    }

    return Result.success(bucket[fileId]!.bytes);
  }

  @override
  Future<Result<FileUploadResult, AppError>> getFileInfo({
    required String bucketId,
    required String fileId,
  }) async {
    await Future.delayed(_simulatedDelay);
    AppLogger.debug('Mock: Getting file info for $fileId in bucket $bucketId', tag: _tag);

    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError(
        message: 'Simulated network error',
      ));
    }

    final bucket = _storage[bucketId];
    if (bucket == null || !bucket.containsKey(fileId)) {
      return const Result.failure(FileNotFoundError(
        message: 'File not found',
      ));
    }

    final file = bucket[fileId]!;
    return Result.success(FileUploadResult(
      fileId: file.id,
      bucketId: file.bucketId,
      name: file.name,
      size: file.bytes.length,
      mimeType: file.mimeType,
    ));
  }

  /// Guess MIME type from file extension
  String _guessMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'svg' => 'image/svg+xml',
      'pdf' => 'application/pdf',
      'json' => 'application/json',
      'txt' => 'text/plain',
      _ => 'application/octet-stream',
    };
  }

  /// Reset mock state for testing
  void reset() {
    _storage.clear();
    _idCounter = 0;
    forceError = false;
    forcedError = null;
  }

  /// Seed mock file for testing
  void seedFile({
    required String bucketId,
    required String fileId,
    required String fileName,
    required Uint8List bytes,
    String? mimeType,
  }) {
    final bucket = _storage.putIfAbsent(bucketId, () => {});
    bucket[fileId] = _MockFile(
      id: fileId,
      bucketId: bucketId,
      name: fileName,
      bytes: bytes,
      mimeType: mimeType ?? _guessMimeType(fileName),
      permissions: [],
    );
  }

  /// Check if file exists (for testing verification)
  bool fileExists(String bucketId, String fileId) {
    return _storage[bucketId]?.containsKey(fileId) ?? false;
  }

  /// Get all files in a bucket (for testing verification)
  List<String> getBucketFileIds(String bucketId) {
    return _storage[bucketId]?.keys.toList() ?? [];
  }
}

/// Internal class to store mock file data
class _MockFile {
  final String id;
  final String bucketId;
  final String name;
  final Uint8List bytes;
  final String mimeType;
  final List<String> permissions;

  _MockFile({
    required this.id,
    required this.bucketId,
    required this.name,
    required this.bytes,
    required this.mimeType,
    required this.permissions,
  });
}
