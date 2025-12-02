import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class MantraMeaning extends StatelessWidget {
  final String meaning;
  final List<String> benefits;

  const MantraMeaning({
    super.key,
    required this.meaning,
    required this.benefits,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Meaning Section
        _buildSectionHeader('Meaning', Icons.menu_book_rounded),
        const SizedBox(height: AppDimensions.paddingSm),
        Text(
          meaning,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            height: 1.6,
          ),
        ),
        
        const SizedBox(height: AppDimensions.paddingXl),
        
        // Benefits Section
        _buildSectionHeader('Benefits', Icons.stars_rounded),
        const SizedBox(height: AppDimensions.paddingMd),
        ...benefits.map((benefit) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.paddingSm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.paddingSm),
              Expanded(
                child: Text(
                  benefit,
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: AppDimensions.paddingSm),
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
