import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/settings_controller.dart';

class FeedbackScreen extends GetView<SettingsController> {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final feedbackController = TextEditingController();
    final rating = 5.0.obs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Feedback', style: AppTextStyles.headlineSmall),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How was your experience?',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: AppDimensions.md),
            
            // Rating Stars
            Center(
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating.value ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                    onPressed: () => rating.value = index + 1.0,
                  );
                }),
              )),
            ),
            const SizedBox(height: AppDimensions.xl),
            
            // Feedback Input
            Text('Tell us more', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppDimensions.sm),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.submitFeedback(
                    feedbackController.text,
                    rating.value,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                child: const Text('Submit Feedback', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
