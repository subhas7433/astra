import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';

class FeatureIconItem {
  final String label;
  final IconData icon; // Using IconData for now, replace with assets later
  final Color color;
  final VoidCallback onTap;

  FeatureIconItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class FeatureIconsGrid extends StatelessWidget {
  final List<FeatureIconItem> items;

  const FeatureIconsGrid({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) => _buildFeatureItem(item)).toList(),
      ),
    );
  }

  Widget _buildFeatureItem(FeatureIconItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: item.color,
                width: 2,
              ),
            ),
            child: Icon(
              item.icon,
              color: item.color,
              size: 30,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            item.label,
            style: AppTypography.caption.copyWith(
              color: AppColors.primary, // Using primary color for text as per design feel
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
