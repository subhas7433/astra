/// Centralized storage bucket ID constants for Appwrite storage.
/// Single source of truth - no hardcoded bucket names in code.
///
/// Usage:
/// ```dart
/// await storage.createFile(
///   bucketId: AppwriteBuckets.profileImages,
///   fileId: userId,
///   file: InputFile.fromPath(path: imagePath),
/// );
/// ```
abstract class AppwriteBuckets {
  AppwriteBuckets._();

  /// User profile images bucket
  static const String profileImages = 'profile_images';

  /// Astrologer profile and hero images bucket
  static const String astrologerImages = 'astrologer_images';

  /// Deity/god images for daily content bucket
  static const String deityImages = 'deity_images';
}
