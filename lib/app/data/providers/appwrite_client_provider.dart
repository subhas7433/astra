import 'package:appwrite/appwrite.dart';

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

  /// Raw Appwrite client
  late final Client client;

  /// Account service for authentication
  late final Account account;

  /// Databases service for CRUD operations
  late final Databases databases;

  /// Storage service for file operations
  late final Storage storage;

  /// Realtime service for subscriptions
  late final Realtime realtime;

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

  /// Check if client is properly configured
  bool get isConfigured => config.isValid;
}
