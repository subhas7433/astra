import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/impl/subscription_service.dart';

class SubscriptionCard extends StatelessWidget {
  final PaywallPackage package;
  final bool isSelected;
  final bool isPopular;
  final VoidCallback onTap;

  const SubscriptionCard({
    super.key,
    required this.package,
    required this.onTap,
    this.isSelected = false,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.title,
                        style: AppTypography.h3.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        package.description,
                        style: AppTypography.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      package.priceString,
                      style: AppTypography.h3.copyWith(color: AppColors.primary),
                    ),
                    if (package.identifier.contains('year')) 
                       Text(
                        'Best Value',
                        style: AppTypography.caption.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (isPopular)
            Positioned(
              top: -12,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'MOST POPULAR',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
