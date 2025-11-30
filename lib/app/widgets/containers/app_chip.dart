import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/theme/app_decorations.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? labelColor;

  const AppChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.backgroundColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color finalBackgroundColor = backgroundColor ?? 
        (isSelected ? AppColors.primary : AppColors.chipBackground);
    final Color finalLabelColor = labelColor ?? 
        (isSelected ? AppColors.textOnPrimary : AppColors.textSecondary);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.chipHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
        decoration: BoxDecoration(
          color: finalBackgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: isSelected && backgroundColor == null 
              ? null // Default selected has no border
              : null, // Simplify for now, can add border logic if needed
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: AppDimensions.iconSm,
                color: finalLabelColor,
              ),
              const SizedBox(width: AppDimensions.xs),
            ],
            Text(
              label,
              style: AppTypography.chip.copyWith(
                color: finalLabelColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
