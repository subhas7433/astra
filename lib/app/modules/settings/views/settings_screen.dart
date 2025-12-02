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
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            ProfileCard(onEditTap: controller.onProfileEdit),
            
            const SizedBox(height: AppDimensions.paddingXl),

            // Premium Banner
            Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.paddingXl),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6A1B9A).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.toNamed('/settings/paywall'),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingLg),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingSm),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.diamond_outlined, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: AppDimensions.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upgrade to Premium',
                                style: AppTypography.h3.copyWith(color: Colors.white, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Remove ads & unlimited chat',
                                style: AppTypography.caption.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // General Settings
            Text(
              'General',
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
                    icon: Icons.star_border,
                    title: 'Remove Ads',
                    onTap: controller.onRemoveAds,
                    iconColor: Colors.amber,
                  ),
                  const Divider(height: 1),
                  SettingsItem(
                    icon: Icons.language,
                    title: 'Change Language',
                    onTap: controller.onChangeLanguage,
                  ),
                  const Divider(height: 1),
                  SettingsItem(
                    icon: Icons.favorite_border,
                    title: 'Favorites',
                    onTap: controller.onFavorites,
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingXl),
            
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
                  const Divider(height: 1),
                  SettingsItem(
                    icon: Icons.delete_outline,
                    title: 'Delete Account',
                    onTap: controller.onDeleteAccount,
                    iconColor: AppColors.error,
                    textColor: AppColors.error,
                    trailing: const SizedBox.shrink(), // No arrow for delete
                  ),
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
    );
  }
}
