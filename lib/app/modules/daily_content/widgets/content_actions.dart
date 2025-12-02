import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class ContentActions extends StatelessWidget {
  final VoidCallback onCopy;
  final VoidCallback onShare;

  const ContentActions({
    super.key,
    required this.onCopy,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onCopy,
            icon: const Icon(Icons.copy_rounded, size: 20),
            label: const Text('Copy'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMd),
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingMd),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onShare,
            icon: const Icon(Icons.share_rounded, size: 20),
            label: const Text('Share'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMd),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
