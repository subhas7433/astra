import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';

class SpecialtyChip extends StatelessWidget {
  final String label;

  const SpecialtyChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCCBC), // Light Peach/Orange
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: AppTypography.body2.copyWith(
          color: Colors.brown,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
