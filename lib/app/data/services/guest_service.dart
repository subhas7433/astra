import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class GuestService extends GetxService {
  static GuestService get to => Get.find();

  final isGuest = false.obs;
  final guestChatCount = 0.obs;
  static const maxGuestChats = 3;

  void enterGuestMode() {
    isGuest.value = true;
    guestChatCount.value = 0;
    // Navigate to home with limited access
    Get.offAllNamed(Routes.HOME);
  }

  bool canGuestChat() {
    if (!isGuest.value) return true;
    return guestChatCount.value < maxGuestChats;
  }

  void incrementGuestChat() {
    if (!isGuest.value) return;
    
    guestChatCount.value++;
    if (guestChatCount.value >= maxGuestChats) {
      _showRegisterPrompt();
    }
  }

  void _showRegisterPrompt() {
    Get.dialog(
      AlertDialog(
        title: const Text('Create an Account'),
        content: const Text('Sign up to continue chatting and unlock all features!'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed(Routes.REGISTER);
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
  
  /// Reset guest mode (e.g. on login)
  void exitGuestMode() {
    isGuest.value = false;
    guestChatCount.value = 0;
  }
}
