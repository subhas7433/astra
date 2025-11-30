import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Appwrite configuration loaded from environment variables.
///
/// Usage:
/// ```dart
/// final config = AppwriteConfig.fromEnv();
/// print(config.endpoint); // https://cloud.appwrite.io/v1
/// print(config.projectId); // your_project_id
/// ```
class AppwriteConfig {
  /// Appwrite server endpoint URL
  final String endpoint;

  /// Appwrite project ID
  final String projectId;

  /// Database ID for this app
  final String databaseId;

  const AppwriteConfig({
    required this.endpoint,
    required this.projectId,
    required this.databaseId,
  });

  /// Load configuration from .env file
  factory AppwriteConfig.fromEnv() {
    return AppwriteConfig(
      endpoint: dotenv.env['APPWRITE_ENDPOINT'] ?? 'https://cloud.appwrite.io/v1',
      projectId: dotenv.env['APPWRITE_PROJECT_ID'] ?? '',
      databaseId: dotenv.env['APPWRITE_DATABASE_ID'] ?? 'astro_gpt_db',
    );
  }

  /// Create test configuration (for unit tests)
  factory AppwriteConfig.test() {
    return const AppwriteConfig(
      endpoint: 'https://test.appwrite.io/v1',
      projectId: 'test_project',
      databaseId: 'test_db',
    );
  }

  /// Check if configuration is valid (project ID is set)
  bool get isValid => projectId.isNotEmpty;

  @override
  String toString() =>
      'AppwriteConfig(endpoint: $endpoint, projectId: $projectId, databaseId: $databaseId)';
}
