import 'package:get/get.dart';

/// Navigation controller for bottom navigation bar.
///
/// Manages:
/// - Current tab index
/// - Tab switching
/// - Back button behavior (home tab exit, other tabs return to home)
class NavigationController extends GetxController {
  /// Current selected tab index
  final currentIndex = 0.obs;

  /// Change to a specific tab
  void changeTab(int index) {
    currentIndex.value = index;
  }

  /// Handle system back button
  /// Returns true to allow exit, false to prevent
  Future<bool> onWillPop() async {
    if (currentIndex.value != 0) {
      // Not on home tab, switch to home tab
      currentIndex.value = 0;
      return false; // Prevent app exit
    }
    // On home tab, allow app exit
    return true;
  }
}
