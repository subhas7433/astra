import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/profile_edit_controller.dart';

class ProfileEditScreen extends GetView<ProfileEditController> {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ideally use Bindings, but for now lazy put here if not bound globally/route
    Get.lazyPut(() => ProfileEditController());
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Edit Profile', style: AppTextStyles.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => controller.isLoading.value 
            ? const Center(child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              ))
            : TextButton(
                onPressed: controller.saveProfile,
                child: Text('Save', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary)),
              )
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                        onPressed: () {
                          // TODO: Pick image
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.xl),

            // Fields
            _buildTextField('Name', controller.nameController),
            const SizedBox(height: AppDimensions.lg),
            _buildTextField('Email', controller.emailController, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: AppDimensions.lg),
            _buildTextField('Phone', controller.phoneController, keyboardType: TextInputType.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController textController, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppDimensions.xs),
        TextFormField(
          controller: textController,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMd,
              vertical: AppDimensions.paddingSm,
            ),
          ),
        ),
      ],
    );
  }
}
