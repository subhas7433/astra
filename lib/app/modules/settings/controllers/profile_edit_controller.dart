import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user_controller.dart';

class ProfileEditController extends GetxController {
  final _userController = Get.find<UserController>();
  
  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController(); // Note: Not in UserModel, might need to add or ignore for now
  
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }
  
  void _loadUserProfile() {
    final user = _userController.user.value;
    if (user != null) {
      nameController.text = user.fullName;
      emailController.text = user.email;
      // phoneController.text = user.phone; // UserModel doesn't have phone? Check model.
    }
  }

  Future<void> saveProfile() async {
    final currentUser = _userController.user.value;
    if (currentUser == null) return;

    isLoading.value = true;
    
    final updatedUser = currentUser.copyWith(
      fullName: nameController.text.trim(),
      // email: emailController.text.trim(), // Usually email is not editable or requires re-verify
    );

    await _userController.updateProfile(updatedUser);
    
    isLoading.value = false;
  }
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
