import 'dart:io';
import 'package:flutter/material.dart';
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
      return false;
    }
    // On home tab, show exit confirmation
    final shouldExit = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Exit'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
    if (shouldExit == true) {
      exit(0);
    }
    return false;
  }
}
