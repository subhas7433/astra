import 'package:get/get.dart';

import '../controllers/navigation_controller.dart';
import '../../home/bindings/home_binding.dart';
import '../../horoscope/bindings/zodiac_picker_binding.dart';
import '../../daily_content/bindings/numerology_binding.dart';
import '../../settings/bindings/settings_binding.dart';

/// Navigation binding for main shell.
///
/// Initializes:
/// - NavigationController
/// - All tab bindings (Home, Horoscope, Numerology, Settings)
class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize navigation controller
    Get.lazyPut<NavigationController>(
      () => NavigationController(),
    );

    // Initialize all tab bindings
    HomeBinding().dependencies();
    ZodiacPickerBinding().dependencies();
    NumerologyBinding().dependencies();
    SettingsBinding().dependencies();
  }
}
