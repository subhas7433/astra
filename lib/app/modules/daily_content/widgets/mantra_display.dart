import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class MantraDisplay extends StatelessWidget {
  final String sanskrit;
  final String transliteration;
  final bool isPlaying;
  final VoidCallback onPlayTap;

  const MantraDisplay({
    super.key,
    required this.sanskrit,
    required this.transliteration,
    required this.isPlaying,
    required this.onPlayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingXl),
      decoration: BoxDecoration(
        color: AppColors.mantraBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Sanskrit Text
          Text(
            sanskrit,
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.5,
              fontSize: 24,
            ),
          ),
          
          const SizedBox(height: AppDimensions.paddingLg),
          
          // Transliteration
          Text(
            transliteration,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontStyle: FontStyle.italic,
            ),
          ),
          
          const SizedBox(height: AppDimensions.paddingXl),
          
          // Play Button
          GestureDetector(
            onTap: onPlayTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLg,
                vertical: AppDimensions.paddingSm,
              ),
              decoration: BoxDecoration(
                color: isPlaying ? AppColors.error : AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(width: AppDimensions.paddingSm),
                  Text(
                    isPlaying ? 'Stop Audio' : 'Play Audio',
                    style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
