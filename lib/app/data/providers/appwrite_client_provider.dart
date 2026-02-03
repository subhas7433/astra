import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/config/appwrite_config.dart';
import '../../core/utils/app_logger.dart';

/// Singleton provider for Appwrite SDK client instances.
/// Provides access to Account, Databases, Storage, and Realtime services.
///
/// Usage:
/// ```dart
/// final config = AppwriteConfig.fromEnv();
/// final provider = AppwriteClientProvider(config);
///
/// // Access Appwrite services
/// final user = await provider.account.get();
/// final docs = await provider.databases.listDocuments(...);
/// ```
class AppwriteClientProvider {
  /// Singleton instance
  static AppwriteClientProvider? _instance;

  /// Appwrite configuration
  final AppwriteConfig config;

  /// Raw Appwrite client (not final to allow reinitialize)
  late Client client;

  /// Account service for authentication (not final to allow reinitialize)
  late Account account;

  /// Databases service for CRUD operations (not final to allow reinitialize)
  late Databases databases;

  /// Storage service for file operations (not final to allow reinitialize)
  late Storage storage;

  /// Realtime service for subscriptions (not final to allow reinitialize)
  late Realtime realtime;

  /// Functions service for serverless functions (not final to allow reinitialize)
  late Functions functions;

  /// Private constructor
  AppwriteClientProvider._internal(this.config) {
    _initClient();
  }

  /// Get or create singleton instance
  factory AppwriteClientProvider(AppwriteConfig config) {
    _instance ??= AppwriteClientProvider._internal(config);
    return _instance!;
  }

  /// Initialize the Appwrite client
  void _initClient() {
    AppLogger.info(
      'Initializing Appwrite client: ${config.endpoint}',
      tag: 'AppwriteClient',
    );

    client = Client()
      ..setEndpoint(config.endpoint)
      ..setProject(config.projectId);

    // Initialize all services
    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
    realtime = Realtime(client);
    functions = Functions(client);

    AppLogger.info(
      'Appwrite client initialized successfully',
      tag: 'AppwriteClient',
    );
  }

  /// Reset singleton instance (for testing)
  static void reset() {
    _instance = null;
    AppLogger.debug('AppwriteClientProvider reset', tag: 'AppwriteClient');
  }

  /// Reinitialize the client to clear local session/cookie state.
  /// This is needed when the user's session becomes invalid (e.g., blocked user)
  /// and the SDK's local cookie jar needs to be cleared.
  Future<void> reinitialize() async {
    AppLogger.info(
      'Reinitializing Appwrite client to clear session state',
      tag: 'AppwriteClient',
    );

    // Clear all possible cookie locations
    await clearAllCookies();

    // Recreate the client
    _initClient();
  }

  /// Clear ALL possible cookie storage locations.
  /// The SDK may store cookies in different places depending on platform/version.
  Future<void> clearAllCookies() async {
    AppLogger.info('Clearing all possible cookie locations', tag: 'AppwriteClient');

    final directories = <Directory>[];

    try {
      directories.add(await getApplicationDocumentsDirectory());
    } catch (e) {
      AppLogger.warning('Failed to get app documents dir: $e', tag: 'AppwriteClient');
    }

    try {
      directories.add(await getApplicationSupportDirectory());
    } catch (e) {
      AppLogger.warning('Failed to get app support dir: $e', tag: 'AppwriteClient');
    }

    try {
      directories.add(await getTemporaryDirectory());
    } catch (e) {
      AppLogger.warning('Failed to get temp dir: $e', tag: 'AppwriteClient');
    }

    for (final dir in directories) {
      final cookieDir = Directory('${dir.path}/.cookies');
      AppLogger.debug('Checking: ${cookieDir.path}', tag: 'AppwriteClient');

      try {
        if (await cookieDir.exists()) {
          await cookieDir.delete(recursive: true);
          AppLogger.info('Cleared cookies at ${cookieDir.path}', tag: 'AppwriteClient');
        }
      } catch (e) {
        AppLogger.warning('Failed to clear ${cookieDir.path}: $e', tag: 'AppwriteClient');
      }
    }
  }

  /// Check if client is properly configured
  bool get isConfigured => config.isValid;
}
