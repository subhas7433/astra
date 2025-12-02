import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';

class LuckySection extends StatelessWidget {
  final List<int> luckyNumbers;
  final String luckyColor;
  final String luckyTime;

  const LuckySection({
    super.key,
    required this.luckyNumbers,
    required this.luckyColor,
    required this.luckyTime,
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lucky For You',
            style: AppTypography.h3,
          ),
          const SizedBox(height: AppDimensions.md),
          _buildRow(Icons.format_list_numbered, 'Numbers', luckyNumbers.join(', ')),
          const Divider(height: AppDimensions.xl),
          _buildRow(Icons.palette, 'Color', luckyColor),
          const Divider(height: AppDimensions.xl),
          _buildRow(Icons.access_time, 'Time', luckyTime),
        ],
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: AppDimensions.sm),
        Text(
          label,
          style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTypography.body1.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
