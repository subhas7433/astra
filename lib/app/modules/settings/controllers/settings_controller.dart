import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/repositories/feedback_repository.dart';
import '../../../core/services/interfaces/i_auth_service.dart';

class SettingsController extends GetxController {
  
  void onProfileEdit() {
    Get.toNamed(AppRoutes.profileEdit);
  }

  void onRemoveAds() {
    Get.toNamed(AppRoutes.paywall);
  }

  void onChangeLanguage() {
    Get.toNamed(AppRoutes.language);
  }

  void onFavorites() {
    Get.toNamed(AppRoutes.favorites);
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

  void onRateUs() async {
    // Placeholder for store URLs
    // final url = Platform.isAndroid 
    //   ? 'market://details?id=com.technoava.astra' 
    //   : 'https://apps.apple.com/app/id...';
    // if (await canLaunch(url)) await launch(url);
    
    Get.snackbar(
      'Rate Us', 
      'Thank you for your interest! Store links will be available soon.',
      snackPosition: SnackPosition.BOTTOM,
    );
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
      onConfirm: () async {
        Get.back(); // Close dialog
        
        // Show loading
        Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
        
        final authService = Get.find<IAuthService>();
        await authService.logout();
        
        Get.back(); // Close loading
        Get.offAllNamed(AppRoutes.login);
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
        
        // Show loading
        Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
        
        final authService = Get.find<IAuthService>();
        final result = await authService.deleteAccount();
        
        Get.back(); // Close loading
        
        result.fold(
          onSuccess: (_) {
             Get.snackbar('Account Deleted', 'Your account has been deleted.');
             Get.offAllNamed(AppRoutes.login);
          },
          onFailure: (error) {
             Get.snackbar('Error', 'Failed to delete account: ${error.message}', backgroundColor: Colors.red, colorText: Colors.white);
          },
        );
      },
    );
  }
}
