import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../controllers/home_controller.dart';

class HomeAppBar extends GetView<HomeController> {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: AppDimensions.paddingMd,
        right: AppDimensions.paddingMd,
        bottom: AppDimensions.paddingMd,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusLg),
          bottomRight: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Empty SizedBox to balance the row if we want centered title
          // But design shows title might be centered or left. 
          // Let's assume centered title for "Astro GPT" based on typical app patterns
          // and the screenshot uploaded_image_0 which shows it quite central.
          
          // Actually, looking at uploaded_image_0, "Astro GPT" is centered.
          // There is no left icon.
          const SizedBox(width: 48), // Placeholder for balance

          Text(
            'Astro GPT',
            style: AppTypography.h2.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w300, // Thin font as per design
            ),
          ),

          IconButton(
            onPressed: controller.onSettingsTap,
            icon: const Icon(
              Icons.hexagon_outlined,
              color: AppColors.textOnPrimary,
              size: AppDimensions.iconLg,
            ),
          ),
        ],
      ),
    );
  }
}
