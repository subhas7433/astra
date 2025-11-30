import 'package:get/get.dart';

import '../modules/auth/auth_controller.dart';

/// Binding for Authentication screens (Login, Register).
///
/// Uses lazyPut for efficient memory usage - controller is only
/// created when first accessed and disposed when route is popped.
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
