import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../widgets/profile_card.dart';
import '../widgets/settings_item.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/impl/subscription_service.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            ProfileCard(onEditTap: controller.onProfileEdit),
            const SizedBox(height: AppDimensions.paddingMd),

            // Subscription Status Card
            Obx(() {
              final isPro = Get.find<SubscriptionService>().isPro;
              return GestureDetector(
                onTap: () => SubscriptionService.to.showPaywall(),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMd),
                  decoration: BoxDecoration(
                    gradient: isPro ? null : AppColors.primaryGradient,
                    color: isPro ? AppColors.surface : null,
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
                      Icon(
                        isPro ? Icons.check_circle : Icons.star,
                        color: isPro ? AppColors.success : Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: AppDimensions.paddingSm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isPro ? 'Pro Member' : 'Upgrade to Pro',
                              style: AppTypography.body1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isPro ? AppColors.textPrimary : Colors.white,
                              ),
                            ),
                            if (!isPro) ...[
                              const SizedBox(height: 2),
                              Text(
                                'No ads, 100 credits/day',
                                style: AppTypography.caption.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (!isPro)
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: AppDimensions.paddingXl),

            // Activity Section
            Text(
              'Activity',
              style: AppTypography.h3.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSm),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
              child: Column(
                children: [
                  SettingsItem(
                    icon: Icons.back_hand_outlined,
                    title: 'Palm Reading History',
                    onTap: controller.onPalmReadingHistory,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.paddingXl),

            // General Settings (hidden for now)
            // Text(
            //   'General',
            //   style: AppTypography.h3.copyWith(
            //     color: AppColors.textSecondary,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: AppDimensions.paddingSm),
            // Container(
            //   decoration: BoxDecoration(
            //     color: AppColors.surface,
            //     borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            //   ),
            //   child: Column(
            //     children: [
            //       SettingsItem(
            //         icon: Icons.language,
            //         title: 'Change Language',
            //         onTap: controller.onChangeLanguage,
            //       ),
            //       const Divider(height: 1),
            //       SettingsItem(
            //         icon: Icons.favorite_border,
            //         title: 'Favorites',
            //         onTap: controller.onFavorites,
            //         iconColor: Colors.red,
            //       ),
            //     ],
            //   ),
            // ),
            //
            // const SizedBox(height: AppDimensions.paddingXl),

            // Support & Feedback
            Text(
              'Support',
              style: AppTypography.h3.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSm),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
              child: Column(
                children: [
                  SettingsItem(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: controller.onAboutUs,
                  ),
                  const Divider(height: 1),
                  SettingsItem(
                    icon: Icons.chat_bubble_outline,
                    title: 'Feedback',
                    onTap: controller.onFeedback,
                  ),
                  const Divider(height: 1),
                  SettingsItem(
                    icon: Icons.thumb_up_outlined,
                    title: 'Rate Us',
                    onTap: controller.onRateUs,
                  ),
                  const Divider(height: 1),
                  SettingsItem(
                    icon: Icons.lightbulb_outline,
                    title: 'Request Feature',
                    onTap: controller.onRequestFeature,
                  ),
                  const Divider(height: 1),
                  SettingsItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: controller.onPrivacy,
                  ),
                  const Divider(height: 1),
                  SettingsItem(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: controller.onTerms,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.paddingXl),

            // Account Actions
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
              child: Column(
                children: [
                  SettingsItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: controller.onLogout,
                    iconColor: AppColors.textSecondary,
                  ),
                  // Hidden for now - delete account functionality
                  // const Divider(height: 1),
                  // SettingsItem(
                  //   icon: Icons.delete_outline,
                  //   title: 'Delete Account',
                  //   onTap: controller.onDeleteAccount,
                  //   iconColor: AppColors.error,
                  //   textColor: AppColors.error,
                  //   trailing: const SizedBox.shrink(), // No arrow for delete
                  // ),
                ],
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingXl),
            
            // Version Info
            Center(
              child: Text(
                'Version 1.0.0',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLg),
            ],
          ),
        ),
      ),
    );
  }
}
