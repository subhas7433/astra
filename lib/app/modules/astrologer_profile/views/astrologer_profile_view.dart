import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../controllers/astrologer_profile_controller.dart';
import '../widgets/profile_info_sheet.dart';

class AstrologerProfileView extends GetView<AstrologerProfileController> {
  const AstrologerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // Match sheet background
      body: Stack(
        children: [
          // 1. Background Image (Top Half)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: Get.height * 0.5,
            child: Obx(() {
              final imageUrl = controller.astrologer.value?.imageUrl;
              if (imageUrl == null) return const SizedBox();
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.brown),
              );
            }),
          ),

          // 2. Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: AppDimensions.paddingMd,
            child: CircleAvatar(
              backgroundColor: Colors.black26,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ),

          // 3. Info Sheet (Scrollable)
          Positioned.fill(
            top: Get.height * 0.4, // Start from 40% down
            child: ProfileInfoSheet(controller: controller),
          ),

          // 4. Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              color: const Color(0xFFFFF3E0), // Match background
              child: Row(
                children: [
                  // Chat Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.startChat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat_bubble_outline, color: Colors.white),
                          const SizedBox(width: AppDimensions.sm),
                          Text(
                            'Chat',
                            style: AppTypography.button.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),

                  // Favorite Button
                  Obx(() => IconButton(
                    onPressed: controller.toggleFavorite,
                    icon: Icon(
                      controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
