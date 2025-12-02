import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import 'horoscope_progress_bar.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int percentage;
  final String prediction;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.percentage,
    required this.prediction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Title + Percentage
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: AppDimensions.sm),
              Text(
                title,
                style: AppTypography.h3.copyWith(fontSize: 18),
              ),
              const Spacer(),
              Text(
                '$percentage%',
                style: AppTypography.h3.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          
          // Progress Bar
          HoroscopeProgressBar(
            percentage: percentage / 100,
            color: color,
          ),
          const SizedBox(height: AppDimensions.md),
          
          // Prediction Text
          Text(
            prediction,
            style: AppTypography.body2.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
