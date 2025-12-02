import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/numerology_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class NumerologyScreen extends GetView<NumerologyController> {
  const NumerologyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Numerology'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Section
            Text(
              'Calculate Your Life Path Number',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMd),
            Text(
              'Enter your date of birth to discover your life path number and what it says about you.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXl),
            
            // Date Picker Field
            TextField(
              controller: controller.dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                hintText: 'DD/MM/YYYY',
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.primary,
                          onPrimary: Colors.white,
                          onSurface: AppColors.textPrimary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  controller.onDateSelected(date);
                }
              },
            ),
            
            const SizedBox(height: AppDimensions.xxl),
            
            // Result Section
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final prediction = controller.prediction.value;
              if (prediction == null) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  // Number Display
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingXl),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Text(
                      '${prediction.number}',
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLg),
                  
                  Text(
                    prediction.title,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.paddingXl),
                  
                  // Details Card
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingLg),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Traits', prediction.traits),
                        const Divider(height: AppDimensions.paddingXl),
                        _buildInfoRow('Lucky Color', prediction.luckyColor),
                        const Divider(height: AppDimensions.paddingXl),
                        _buildInfoRow('Lucky Gem', prediction.luckyGem),
                        const Divider(height: AppDimensions.paddingXl),
                        _buildInfoRow('Ruling Planet', prediction.rulingPlanet),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppDimensions.paddingXl),
                  
                  Text(
                    prediction.description,
                    style: AppTextStyles.bodyLarge.copyWith(
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
