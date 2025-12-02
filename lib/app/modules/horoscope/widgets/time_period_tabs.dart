import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../controllers/horoscope_detail_controller.dart';

class TimePeriodTabs extends StatelessWidget {
  final TimePeriod selectedPeriod;
  final Function(TimePeriod) onPeriodChanged;

  const TimePeriodTabs({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.md),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
        itemCount: TimePeriod.values.length,
        itemBuilder: (context, index) {
          final period = TimePeriod.values[index];
          final isSelected = period == selectedPeriod;
          
          return GestureDetector(
            onTap: () => onPeriodChanged(period),
            child: Container(
              margin: const EdgeInsets.only(right: AppDimensions.md),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLg,
                vertical: AppDimensions.paddingSm,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                period.name.toUpperCase(),
                style: AppTypography.button.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
