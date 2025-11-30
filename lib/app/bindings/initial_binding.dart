import 'package:get/get.dart';

import '../core/utils/app_logger.dart';

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
    // Example:
    // Get.put(AppController(), permanent: true);
    // Get.put(ConnectivityController(), permanent: true);

    AppLogger.debug('Initial bindings complete', tag: _tag);
  }
}
