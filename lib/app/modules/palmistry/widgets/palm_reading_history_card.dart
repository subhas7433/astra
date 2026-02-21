import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/palm_reading_session_model.dart';
import '../../../widgets/containers/app_card.dart';

class PalmReadingHistoryCard extends StatelessWidget {
  final PalmReadingSessionModel reading;
  final VoidCallback onTap;

  const PalmReadingHistoryCard({
    super.key,
    required this.reading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          // Overlapping palm thumbnails
          _buildOverlappingThumbnails(),
          const SizedBox(width: AppDimensions.md),

          // Title + metadata
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vedic Palm Reading',
                  style: AppTypography.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _buildSubtitle(),
                  style: AppTypography.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlappingThumbnails() {
    const double size = 48.0;
    const double overlap = 16.0;

    return SizedBox(
      width: size + overlap,
      height: size,
      child: Stack(
        children: [
          // Left palm (behind)
          Positioned(
            left: 0,
            child: _buildThumbnail(reading.leftPalmImageUrl, size),
          ),
          // Right palm (in front, overlapping)
          Positioned(
            left: overlap,
            child: _buildThumbnail(reading.rightPalmImageUrl, size),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(String imageUrl, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(
          color: AppColors.surface,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm - 1),
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: size,
            height: size,
            color: AppColors.cardBackground,
            child: const Icon(
              Icons.back_hand_outlined,
              color: AppColors.textHint,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  String _buildSubtitle() {
    final parts = <String>[];

    if (reading.hasMessages) {
      parts.add('${reading.formattedMessageCount} messages');
    } else {
      parts.add('No messages');
    }

    final relative = reading.lastActivityRelative;
    if (relative != null) {
      parts.add(relative);
    }

    return parts.join(' - ');
  }

}
