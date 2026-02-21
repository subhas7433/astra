import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/impl/subscription_service.dart';

class ProfileCard extends StatelessWidget {
  final VoidCallback onEditTap;

  const ProfileCard({
    super.key,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Obx(() {
      final user = userController.user.value;
      if (user == null) {
        return const SizedBox.shrink(); // Or loading state
      }

      return Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                image: user.hasProfilePhoto
                    ? DecorationImage(
                        image: NetworkImage(user.profilePhotoUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: !user.hasProfilePhoto
                  ? Center(
                      child: Text(
                        user.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: AppDimensions.paddingMd),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: AppTypography.h3,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: AppTypography.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Obx(() {
                    final isPro = Get.find<SubscriptionService>().isPro;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isPro ? AppColors.primary : AppColors.chipBackground,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isPro ? 'Pro' : 'Free',
                        style: AppTypography.caption.copyWith(
                          color: isPro ? Colors.white : AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            
            // Edit Button (paused for now)
            // IconButton(
            //   onPressed: onEditTap,
            //   icon: const Icon(
            //     Icons.edit_outlined,
            //     color: AppColors.primary,
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}
