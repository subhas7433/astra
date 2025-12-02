import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/repositories/feedback_repository.dart';

class SettingsController extends GetxController {
  
  void onProfileEdit() {
    // TODO: Navigate to Profile Edit (Session 5)
    Get.snackbar('Coming Soon', 'Profile Edit will be available in Session 5');
  }

  void onRemoveAds() {
    // TODO: Implement In-App Purchase
    Get.snackbar('Coming Soon', 'Premium features coming soon!');
  }

  void onChangeLanguage() {
    // TODO: Navigate to Language Screen (Session 5)
    Get.snackbar('Coming Soon', 'Language settings will be available in Session 5');
  }

  void onFavorites() {
    // TODO: Navigate to Favorites (Session 5)
    Get.snackbar('Coming Soon', 'Favorites will be available in Session 5');
  }

  final FeedbackRepository _feedbackRepository = FeedbackRepository();

  void onAboutUs() {
    Get.toNamed(AppRoutes.about);
  }

  void onFeedback() {
    Get.toNamed(AppRoutes.feedback);
  }

  Future<void> submitFeedback(String feedback, double rating) async {
    if (feedback.isEmpty) {
      Get.snackbar('Error', 'Please enter your feedback', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    
    final result = await _feedbackRepository.submitFeedback(
      feedback: feedback,
      rating: rating,
    );
    
    Get.back(); // Close loading

    result.fold(
      onSuccess: (_) {
        Get.back(); // Close feedback screen
        Get.snackbar('Success', 'Thank you for your feedback!', backgroundColor: Colors.green, colorText: Colors.white);
      },
      onFailure: (error) {
        Get.snackbar('Error', error.message, backgroundColor: Colors.red, colorText: Colors.white);
      },
    );
  }

  void onHelp() {
    // TODO: Implement help
    print('Help tapped');
  }

  void onRateUs() {
    // TODO: Implement Store Redirect
    Get.snackbar('Coming Soon', 'Rate Us will be available when app is live');
  }

  void onRequestFeature() {
    Get.toNamed(AppRoutes.feedback); // Reuse feedback for feature request
  }

  void onLogout() {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textConfirm: 'Logout',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        // TODO: Implement logout
        Get.back();
        Get.offAllNamed(AppRoutes.home);
      },
    );
  }

  void onDeleteAccount() {
    Get.defaultDialog(
      title: 'Delete Account',
      middleText: 'This will permanently delete your account and all data. This action cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back(); // Close dialog
        
        // Simulate API call
        Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
        await Future.delayed(const Duration(seconds: 2));
        Get.back(); // Close loading
        
        Get.snackbar('Account Deleted', 'Your account has been deleted.');
        Get.offAllNamed(AppRoutes.login);
      },
    );
  }
}
