import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../widgets/profile_card.dart';
import '../widgets/settings_item.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';

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
