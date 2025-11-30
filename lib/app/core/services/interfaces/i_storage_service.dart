import 'dart:typed_data';

import '../../result/result.dart';
import '../../result/app_error.dart';

/// File upload result metadata
class FileUploadResult {
  /// Unique file ID
  final String fileId;

  /// Bucket where file is stored
  final String bucketId;

  /// Original file name
  final String name;

  /// File size in bytes
  final int size;

  /// MIME type (e.g., 'image/jpeg')
  final String mimeType;

  const FileUploadResult({
    required this.fileId,
    required this.bucketId,
    required this.name,
    required this.size,
    required this.mimeType,
  });

  @override
  String toString() =>
      'FileUploadResult(fileId: $fileId, name: $name, size: $size)';
}

/// Storage service interface.
/// Defines the contract for file upload/download operations.
///
/// Implementations:
/// - [AppwriteStorageService] - Real Appwrite SDK implementation
/// - [MockStorageService] - In-memory mock for testing
///
/// Usage:
/// ```dart
/// final storageService = Get.find<IStorageService>();
///
/// // Upload file
/// final result = await storageService.uploadFile(
///   bucketId: AppwriteBuckets.profileImages,
///   fileName: 'profile.jpg',
///   fileBytes: imageBytes,
/// );
///
/// // Get preview URL
/// final urlResult = storageService.getFilePreviewUrl(
///   bucketId: AppwriteBuckets.profileImages,
///   fileId: result.valueOrNull!.fileId,
///   width: 200,
///   height: 200,
/// );
/// ```
abstract interface class IStorageService {
  /// Upload a file to storage
  ///
  /// Returns file metadata on success, or:
  /// - [FileTooLargeError] if file exceeds limit
  /// - [InvalidFileTypeError] if file type not allowed
  /// - [PermissionDeniedError] if user can't upload
  Future<Result<FileUploadResult, AppError>> uploadFile({
    required String bucketId,
    required String fileName,
    required Uint8List fileBytes,
    String? fileId,
    List<String>? permissions,
  });

  /// Get direct download URL for a file
  ///
  /// Returns the URL string (synchronous - no network call)
  Result<String, AppError> getFileUrl({
    required String bucketId,
    required String fileId,
  });

  /// Get preview URL for an image with optional transformations
  ///
  /// Returns the URL string (synchronous - no network call)
  /// - [width] - Resize width in pixels
  /// - [height] - Resize height in pixels
  /// - [gravity] - Crop gravity ('center', 'top', 'bottom', etc.)
  /// - [quality] - JPEG quality (1-100)
  Result<String, AppError> getFilePreviewUrl({
    required String bucketId,
    required String fileId,
    int? width,
    int? height,
    String? gravity,
    int? quality,
  });

  /// Delete a file from storage
  ///
  /// Returns void on success, or:
  /// - [FileNotFoundError] if file doesn't exist
  /// - [PermissionDeniedError] if user can't delete
  Future<Result<void, AppError>> deleteFile({
    required String bucketId,
    required String fileId,
  });

  /// Download file as bytes
  ///
  /// Returns file bytes, or:
  /// - [FileNotFoundError] if file doesn't exist
  /// - [PermissionDeniedError] if user can't access
  Future<Result<Uint8List, AppError>> downloadFile({
    required String bucketId,
    required String fileId,
  });

  /// Get file metadata without downloading
  ///
  /// Returns file info, or:
  /// - [FileNotFoundError] if file doesn't exist
  Future<Result<FileUploadResult, AppError>> getFileInfo({
    required String bucketId,
    required String fileId,
  });
}
