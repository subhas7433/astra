import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('About Us', style: AppTextStyles.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: AppDimensions.lg),
            
            // App Name & Version
            Text('Astra', style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppDimensions.xs),
            Text(
              'Version 1.0.0',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.xl),
            
            // Description
            Text(
              'Astra is your personal guide to the stars. We provide accurate horoscopes, numerology readings, and direct access to experienced astrologers to help you navigate life\'s journey.',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.xl),
            
            // Links
            _buildLinkItem('Privacy Policy', () => Get.toNamed(AppRoutes.privacy)),
            const Divider(),
            _buildLinkItem('Terms of Service', () => Get.toNamed(AppRoutes.terms)),
            const Divider(),
            
            const SizedBox(height: AppDimensions.xl),
            
            // Copyright
            Text(
              '© 2025 Technoava. All rights reserved.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: AppTextStyles.bodyLarge),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
