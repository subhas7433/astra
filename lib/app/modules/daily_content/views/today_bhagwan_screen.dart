import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/today_bhagwan_controller.dart';
import '../widgets/deity_card.dart';
import '../widgets/content_actions.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class TodayBhagwanScreen extends GetView<TodayBhagwanController> {
  const TodayBhagwanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Today's Bhagwan"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final deity = controller.deity.value;
        if (deity == null) {
          return const Center(child: Text('No content available for today'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Deity Card
              DeityCard(
                imageUrl: deity.imageUrl,
                name: deity.getName(isHindi: controller.isHindi.value),
                mantra: deity.mantra,
              ),
              
              const SizedBox(height: AppDimensions.paddingXl),
              
              // Description
              Text(
                'About',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSm),
              Text(
                deity.getDescription(isHindi: controller.isHindi.value),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: AppDimensions.paddingLg),
              
              // Significance
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: AppColors.primary),
                        const SizedBox(width: AppDimensions.paddingSm),
                        Text(
                          'Significance',
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.paddingSm),
                    Text(
                      deity.significance,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppDimensions.paddingXl),
              
              // Actions
              ContentActions(
                onCopy: controller.copyContent,
                onShare: controller.shareContent,
              ),
              
              const SizedBox(height: AppDimensions.paddingXl),
            ],
          ),
        );
      }),
    );
  }
}
