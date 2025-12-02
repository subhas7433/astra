import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/language_controller.dart';

class LanguageScreen extends GetView<LanguageController> {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Language', style: AppTextStyles.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        itemCount: controller.languages.length,
        separatorBuilder: (context, index) => const Divider(color: AppColors.surface),
        itemBuilder: (context, index) {
          final language = controller.languages[index];
          final locale = language['locale'] as Locale;
          
          return Obx(() {
            final isSelected = controller.selectedLocale.value == locale;
            
            return ListTile(
              title: Text(
                language['name'] as String,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () => controller.updateLocale(locale),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              tileColor: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
            );
          });
        },
      ),
    );
  }
}
