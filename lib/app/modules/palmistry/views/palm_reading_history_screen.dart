import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/state/state_widgets.dart';
import '../controllers/palm_reading_history_controller.dart';
import '../widgets/palm_reading_history_card.dart';

class PalmReadingHistoryScreen
    extends GetView<PalmReadingHistoryController> {
  const PalmReadingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Reading History', style: AppTextStyles.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const LoadingView(message: 'Loading readings...');
        }

        // Error state
        if (controller.hasError.value) {
          return ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.loadReadings,
          );
        }

        // Empty state
        if (controller.readings.isEmpty) {
          return const EmptyView(
            message: 'No palm readings yet',
            icon: Icons.back_hand_outlined,
          );
        }

        // Data state with pull-to-refresh
        return RefreshIndicator(
          onRefresh: controller.loadReadings,
          color: AppColors.primary,
          child: ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            itemCount: controller.readings.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppDimensions.paddingSm),
            itemBuilder: (context, index) {
              final reading = controller.readings[index];
              return PalmReadingHistoryCard(
                reading: reading,
                onTap: () => controller.onReadingTap(reading),
              );
            },
          ),
        );
      }),
    );
  }
}
