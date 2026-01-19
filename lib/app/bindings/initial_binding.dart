import 'package:get/get.dart';

import '../core/utils/app_logger.dart';
import '../data/services/guest_service.dart';
import '../data/providers/appwrite_client_provider.dart';
import '../data/repositories/user_repository.dart';
import '../controllers/user_controller.dart';
import '../core/services/interfaces/i_ai_service.dart';
import '../core/services/impl/appwrite_ai_service.dart';
import '../core/services/mock/mock_ai_service.dart';

/// Initial binding for app-wide dependencies.
/// Called once when the app starts via GetMaterialApp.
///
/// Note: Core services (Auth, Database, Storage) are registered
/// via [ServiceLocator.init()] before runApp, not here.
/// This binding is for GetX controllers and other lazy-loaded dependencies.
///
/// Usage:
/// ```dart
/// GetMaterialApp(
///   initialBinding: InitialBinding(),
///   // ...
/// )
/// ```
class InitialBinding extends Bindings {
  static const String _tag = 'InitialBinding';

  @override
  void dependencies() {
    AppLogger.debug('Setting up initial bindings', tag: _tag);

    // Register app-wide controllers here
    Get.put(GuestService(), permanent: true);

    // Only register Appwrite-dependent services if provider is available (not in mock mode)
    if (Get.isRegistered<AppwriteClientProvider>()) {
      final clientProvider = Get.find<AppwriteClientProvider>();
      Get.put(UserRepository(clientProvider), permanent: true);

      // AI Service - only when Appwrite is available
      Get.put<IAIService>(AppwriteAIService(clientProvider), permanent: true);

      // UserController depends on UserRepository, only register when Appwrite is available
      Get.put(UserController(), permanent: true);
    } else {
      // Mock mode - register mock AI service
      Get.put<IAIService>(MockAIService(), permanent: true);
    }

    AppLogger.debug('Initial bindings complete', tag: _tag);
  }
}
