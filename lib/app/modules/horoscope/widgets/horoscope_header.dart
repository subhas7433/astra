import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/zodiac_constants.dart';

class HoroscopeHeader extends StatelessWidget {
  final ZodiacSign sign;

  const HoroscopeHeader({
    super.key,
    required this.sign,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
          const SizedBox(width: AppDimensions.sm),
          
          // Zodiac Icon
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingSm),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              sign.symbol,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          
          // Name and Dates
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sign.name,
                style: AppTypography.h3,
              ),
              Text(
                sign.dateRange,
                style: AppTypography.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
