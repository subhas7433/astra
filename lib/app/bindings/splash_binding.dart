import 'package:get/get.dart';

import '../modules/splash/splash_controller.dart';

/// Binding for Splash screen.
///
/// Registers [SplashController] when splash route is accessed.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
