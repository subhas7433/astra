import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class DeityCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String mantra;

  const DeityCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.mantra,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radiusLg),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColors.shimmerBase,
                highlightColor: AppColors.shimmerHighlight,
                child: Container(
                  height: 250,
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 250,
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.broken_image, color: AppColors.textSecondary),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMd,
                    vertical: AppDimensions.paddingSm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Text(
                    mantra,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
