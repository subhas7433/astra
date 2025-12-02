import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../widgets/display/app_avatar.dart';

import '../../../data/models/astrologer_model.dart';

class AstrologerCard extends StatelessWidget {
  final AstrologerModel astrologer;
  final VoidCallback onTap;

  const AstrologerCard({
    super.key,
    required this.astrologer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.primary, // Red/Orange background
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        child: Row(
          children: [
            // Avatar
            AppAvatar(
              imageUrl: astrologer.photoUrl,
              size: AppAvatarSize.lg,
              showBorder: true,
              borderColor: Colors.white,
            ),
            const SizedBox(width: AppDimensions.md),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    astrologer.name,
                    style: AppTypography.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    astrologer.specialization,
                    style: AppTypography.body2.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${astrologer.formattedRating} (${astrologer.formattedReviewCount} reviews)',
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
