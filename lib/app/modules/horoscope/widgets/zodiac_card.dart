import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/zodiac_constants.dart';

class ZodiacCard extends StatelessWidget {
  final ZodiacSign sign;
  final bool isSelected;
  final VoidCallback onTap;

  const ZodiacCard({
    super.key,
    required this.sign,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingSm),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.grey.shade100,
              ),
              child: Text(
                sign.symbol,
                style: TextStyle(
                  fontSize: 24,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              // Note: Using Text emoji for now as SVGs might not be present yet.
              // If SVGs are available, swap with:
              // SvgPicture.asset(
              //   sign.icon,
              //   width: 32,
              //   height: 32,
              //   color: isSelected ? Colors.white : AppColors.primary,
              // ),
            ),
            const SizedBox(height: AppDimensions.sm),
            
            // Name
            Text(
              sign.name,
              style: AppTypography.body1.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            
            // Date Range
            Text(
              sign.dateRange,
              style: AppTypography.caption.copyWith(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
