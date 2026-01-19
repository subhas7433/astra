import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('About Us', style: AppTypography.h2),
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
             const SizedBox(height: AppDimensions.paddingXl),
             
             // App Logo
             Container(
               width: 100,
               height: 100,
               decoration: BoxDecoration(
                 color: AppColors.primary.withOpacity(0.1),
                 shape: BoxShape.circle,
               ),
               child: const Center(
                 child: Icon(Icons.auto_awesome, size: 60, color: AppColors.primary),
               ),
             ),
             
             const SizedBox(height: AppDimensions.paddingMd),
             
             Text(
               'Astro GPT',
               style: AppTypography.h1.copyWith(color: AppColors.primary),
             ),
             
             Text(
               'Version 1.0.0',
               style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
             ),
             
             const SizedBox(height: AppDimensions.paddingXl),
             
             Container(
               padding: const EdgeInsets.all(AppDimensions.paddingLg),
               decoration: BoxDecoration(
                 color: AppColors.surface,
                 borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
               ),
               child: Column(
                 children: [
                   Text(
                     'Personal AI Astrology Companion',
                     style: AppTypography.h3,
                     textAlign: TextAlign.center,
                   ),
                   const SizedBox(height: AppDimensions.paddingMd),
                   Text(
                     'Astro GPT combines ancient Vedic astrology wisdom with modern AI to provide personalized guidance, horoscopes, and spiritual insights tailored just for you.',
                     style: AppTypography.body1,
                     textAlign: TextAlign.center,
                   ),
                 ],
               ),
             ),
             
             const SizedBox(height: AppDimensions.paddingXl),
             
             _buildContactInfo(Icons.email_outlined, 'support@astrogpt.com', 'Email Us'),
             const SizedBox(height: AppDimensions.paddingSm),
             _buildContactInfo(Icons.language, 'www.astrogpt.com', 'Visit Website'),
             
             const SizedBox(height: AppDimensions.paddingXl * 2),
             
             Text(
               'Made with ❤️ in India',
               style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
             ),
             const SizedBox(height: 4),
             Text(
               '© 2025 Technoava',
               style: AppTypography.caption.copyWith(color: AppColors.textHint),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text, String label) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppDimensions.paddingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.caption.copyWith(color: AppColors.textHint)),
                Text(text, style: AppTypography.body1),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
