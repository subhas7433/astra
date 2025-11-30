import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:get/get.dart';

import '../../result/result.dart';
import '../../result/app_error.dart';
import '../../utils/app_logger.dart';
import '../../../data/providers/appwrite_client_provider.dart';
import '../interfaces/i_storage_service.dart';

/// Appwrite implementation of [IStorageService].
/// Handles file upload/download operations using Appwrite Storage SDK.
///
/// Usage:
/// ```dart
/// final storageService = Get.find<IStorageService>();
/// final result = await storageService.uploadFile(
///   bucketId: AppwriteBuckets.profileImages,
///   fileName: 'profile.jpg',
///   fileBytes: imageBytes,
/// );
/// ```
class AppwriteStorageService extends GetxService implements IStorageService {
  static const String _tag = 'StorageService';

  final AppwriteClientProvider _clientProvider;

  Storage get _storage => _clientProvider.storage;

  /// Private constructor for dependency injection
  AppwriteStorageService(this._clientProvider);

  /// Factory method for GetX initialization
  static AppwriteStorageService init(AppwriteClientProvider provider) {
    return AppwriteStorageService(provider);
  }

  @override
  Future<Result<FileUploadResult, AppError>> uploadFile({
    required String bucketId,
    required String fileName,
    required Uint8List fileBytes,
    String? fileId,
    List<String>? permissions,
  }) async {
    AppLogger.debug(
      'Uploading file: $fileName to bucket: $bucketId',
      tag: _tag,
    );

    try {
      final file = await _storage.createFile(
        bucketId: bucketId,
        fileId: fileId ?? ID.unique(),
        file: InputFile.fromBytes(bytes: fileBytes, filename: fileName),
        permissions: permissions,
      );

      AppLogger.info(
        'File uploaded: ${file.$id} (${file.sizeOriginal} bytes)',
        tag: _tag,
      );

      return Result.success(FileUploadResult(
        fileId: file.$id,
        bucketId: bucketId,
        name: file.name,
        size: file.sizeOriginal,
        mimeType: file.mimeType,
      ));
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('File upload failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'File upload failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Result<String, AppError> getFileUrl({
    required String bucketId,
    required String fileId,
  }) {
    try {
      final url = _storage.getFileDownload(
        bucketId: bucketId,
        fileId: fileId,
      );

      return Result.success(url.toString());
    } catch (e, stack) {
      AppLogger.error('Get file URL failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Get file URL failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
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
    try {
      final url = _storage.getFilePreview(
        bucketId: bucketId,
        fileId: fileId,
        width: width,
        height: height,
        gravity: _parseGravity(gravity),
        quality: quality,
      );

      return Result.success(url.toString());
    } catch (e, stack) {
      AppLogger.error('Get file preview URL failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Get file preview URL failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<void, AppError>> deleteFile({
    required String bucketId,
    required String fileId,
  }) async {
    AppLogger.debug(
      'Deleting file: $fileId from bucket: $bucketId',
      tag: _tag,
    );

    try {
      await _storage.deleteFile(
        bucketId: bucketId,
        fileId: fileId,
      );

      AppLogger.info('File deleted: $fileId', tag: _tag);
      return const Result.success(null);
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('File delete failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'File delete failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<Uint8List, AppError>> downloadFile({
    required String bucketId,
    required String fileId,
  }) async {
    AppLogger.debug(
      'Downloading file: $fileId from bucket: $bucketId',
      tag: _tag,
    );

    try {
      final bytes = await _storage.getFileDownload(
        bucketId: bucketId,
        fileId: fileId,
      );

      AppLogger.info('File downloaded: $fileId (${bytes.length} bytes)', tag: _tag);
      return Result.success(bytes);
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('File download failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'File download failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  @override
  Future<Result<FileUploadResult, AppError>> getFileInfo({
    required String bucketId,
    required String fileId,
  }) async {
    AppLogger.debug(
      'Getting file info: $fileId from bucket: $bucketId',
      tag: _tag,
    );

    try {
      final file = await _storage.getFile(
        bucketId: bucketId,
        fileId: fileId,
      );

      return Result.success(FileUploadResult(
        fileId: file.$id,
        bucketId: bucketId,
        name: file.name,
        size: file.sizeOriginal,
        mimeType: file.mimeType,
      ));
    } on AppwriteException catch (e, stack) {
      return Result.failure(_mapAppwriteException(e, stack));
    } catch (e, stack) {
      AppLogger.error('Get file info failed', error: e, stackTrace: stack, tag: _tag);
      return Result.failure(UnknownError(
        message: 'Get file info failed: ${e.toString()}',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  /// Parse gravity string to Appwrite ImageGravity enum
  ImageGravity? _parseGravity(String? gravity) {
    if (gravity == null) return null;

    return switch (gravity.toLowerCase()) {
      'center' => ImageGravity.center,
      'top' => ImageGravity.top,
      'bottom' => ImageGravity.bottom,
      'left' => ImageGravity.left,
      'right' => ImageGravity.right,
      'topleft' || 'top-left' => ImageGravity.topLeft,
      'topright' || 'top-right' => ImageGravity.topRight,
      'bottomleft' || 'bottom-left' => ImageGravity.bottomLeft,
      'bottomright' || 'bottom-right' => ImageGravity.bottomRight,
      _ => ImageGravity.center,
    };
  }

  /// Map Appwrite exceptions to typed AppError
  AppError _mapAppwriteException(AppwriteException e, StackTrace stack) {
    AppLogger.warning(
      'Appwrite error: ${e.code} - ${e.message}',
      tag: _tag,
    );

    return switch (e.code) {
      // File errors
      404 => FileNotFoundError(
          message: e.message ?? 'File not found',
          originalError: e,
          stackTrace: stack,
        ),

      // Permission errors
      401 || 403 => PermissionDeniedError(
          message: e.message ?? 'Permission denied',
          originalError: e,
          stackTrace: stack,
        ),

      // File size errors
      413 => FileTooLargeError(
          message: e.message ?? 'File too large',
          originalError: e,
          stackTrace: stack,
        ),

      // Invalid file type
      400 when e.type == 'storage_invalid_file_size' => FileTooLargeError(
          message: e.message ?? 'File size exceeds limit',
          originalError: e,
          stackTrace: stack,
        ),
      400 when e.type == 'storage_invalid_content_range' ||
          e.type == 'storage_invalid_file' => InvalidFileTypeError(
          message: e.message ?? 'Invalid file type',
          originalError: e,
          stackTrace: stack,
        ),
      400 => ValidationError(
          message: e.message ?? 'Invalid request',
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
