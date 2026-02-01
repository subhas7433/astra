import 'package:get/get.dart';

import '../config/appwrite_config.dart';
import '../utils/app_logger.dart';
import '../../data/providers/appwrite_client_provider.dart';
import 'api_client.dart';
import 'interfaces/i_auth_service.dart';
import 'interfaces/i_database_service.dart';
import 'interfaces/i_storage_service.dart';
import 'impl/appwrite_auth_service.dart';
import 'impl/appwrite_database_service.dart';
import 'impl/appwrite_storage_service.dart';
import 'impl/ad_service.dart';
import 'impl/subscription_service.dart';
import 'mock/mock_auth_service.dart';
import 'mock/mock_database_service.dart';
import 'mock/mock_storage_service.dart';

/// Service locator for dependency injection.
/// Configures and registers all app services with GetX.
///
/// Usage:
/// ```dart
/// // In main.dart before runApp
/// await ServiceLocator.init();
///
/// // Or for testing
/// await ServiceLocator.init(useMocks: true);
///
/// // Access services anywhere
/// final authService = Get.find<IAuthService>();
/// ```
class ServiceLocator {
  static const String _tag = 'ServiceLocator';

  /// Prevent instantiation
  ServiceLocator._();

  /// Initialize all services
  ///
  /// - [useMocks] - Use mock implementations for testing/offline mode
  /// - [config] - Custom Appwrite config (defaults to env)
  static Future<void> init({
    bool useMocks = false,
    AppwriteConfig? config,
  }) async {
    AppLogger.info(
      'Initializing services (mocks: $useMocks)',
      tag: _tag,
    );

    if (useMocks) {
      await _registerMockServices();
    } else {
      await _registerAppwriteServices(config);
    }
    
    // Register feature services (Ads, Subscriptions)
    await registerFeatureServices();

    AppLogger.info('Services initialized successfully', tag: _tag);
  }

  /// Register real Appwrite service implementations
  static Future<void> _registerAppwriteServices(AppwriteConfig? config) async {
    // Load config from environment
    final appwriteConfig = config ?? AppwriteConfig.fromEnv();

    if (!appwriteConfig.isValid) {
      AppLogger.warning(
        'Appwrite config invalid - falling back to mocks',
        tag: _tag,
      );
      await _registerMockServices();
      return;
    }

    // Initialize Appwrite client provider
    final clientProvider = AppwriteClientProvider(appwriteConfig);
    Get.put<AppwriteClientProvider>(clientProvider, permanent: true);

    // Initialize REST API client (Dio + JWT)
    final apiClient = ApiClient.init(clientProvider, appwriteConfig);
    Get.put<ApiClient>(apiClient, permanent: true);

    // Register services as GetxService (permanent by default)
    Get.put<IAuthService>(
      AppwriteAuthService.init(clientProvider),
      permanent: true,
    );

    Get.put<IDatabaseService>(
      AppwriteDatabaseService.init(clientProvider, appwriteConfig),
      permanent: true,
    );

    Get.put<IStorageService>(
      AppwriteStorageService.init(clientProvider),
      permanent: true,
    );

    AppLogger.debug('Appwrite services registered', tag: _tag);
  }

  /// Register mock service implementations
  static Future<void> _registerMockServices() async {
    Get.put<IAuthService>(
      MockAuthService(),
      permanent: true,
    );

    Get.put<IDatabaseService>(
      MockDatabaseService(),
      permanent: true,
    );

    Get.put<IStorageService>(
      MockStorageService(),
      permanent: true,
    );

    AppLogger.debug('Mock services registered', tag: _tag);
  }

  /// Register app-level feature services
  static Future<void> registerFeatureServices() async {
     Get.put(SubscriptionService(), permanent: true);
     Get.put(AdService(), permanent: true);
     AppLogger.debug('Feature services registered', tag: _tag);
  }

  /// Reset all services (for testing)
  static void reset() {
    AppLogger.debug('Resetting all services', tag: _tag);

    // Delete existing services
    if (Get.isRegistered<ApiClient>()) {
      Get.delete<ApiClient>(force: true);
    }
    if (Get.isRegistered<IAuthService>()) {
      Get.delete<IAuthService>(force: true);
    }
    if (Get.isRegistered<IDatabaseService>()) {
      Get.delete<IDatabaseService>(force: true);
    }
    if (Get.isRegistered<IStorageService>()) {
      Get.delete<IStorageService>(force: true);
    }

    // Reset Appwrite client provider singleton
    AppwriteClientProvider.reset();
  }

  /// Check if services are initialized
  static bool get isInitialized =>
      Get.isRegistered<IAuthService>() &&
      Get.isRegistered<IDatabaseService>() &&
      Get.isRegistered<IStorageService>();

  /// Convenience getters for services
  /// Convenience getters for services
  static ApiClient get api => Get.find<ApiClient>();
  static IAuthService get auth => Get.find<IAuthService>();
  static IDatabaseService get database => Get.find<IDatabaseService>();
  static IStorageService get storage => Get.find<IStorageService>();
  static AdService get ad => Get.find<AdService>();
  static SubscriptionService get subscription => Get.find<SubscriptionService>();
}
