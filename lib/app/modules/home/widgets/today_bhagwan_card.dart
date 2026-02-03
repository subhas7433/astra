import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/deity_model.dart';

class TodayBhagwanCard extends StatefulWidget {
  final DeityModel? deity;
  final VoidCallback? onViewDetails;

  const TodayBhagwanCard({
    super.key,
    required this.deity,
    this.onViewDetails,
  });

  @override
  State<TodayBhagwanCard> createState() => _TodayBhagwanCardState();
}

class _TodayBhagwanCardState extends State<TodayBhagwanCard> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _copyMantra() {
    if (widget.deity?.mantra != null) {
      Clipboard.setData(ClipboardData(text: widget.deity!.mantra));
      Get.snackbar(
        'Copied',
        'Mantra copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.surface,
        colorText: AppColors.textPrimary,
        margin: const EdgeInsets.all(AppDimensions.md),
      );
    }
  }

  void _shareDeity() {
    Get.snackbar(
      'Share',
      'Sharing "${widget.deity?.name ?? 'Today\'s God'}"...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surface,
      colorText: AppColors.textPrimary,
      margin: const EdgeInsets.all(AppDimensions.md),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deity = widget.deity;
    final deityName = deity?.name ?? 'Lord Shiva';

    return Column(
      children: [
        // Header (Always visible)
        GestureDetector(
          onTap: _toggleExpand,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingLg,
              vertical: AppDimensions.paddingMd,
            ),
            decoration: BoxDecoration(
              color: AppColors.mantraBackground,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Temple Icon
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.temple_hindu,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Text(
                      'Today\'s God',
                      style: AppTypography.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),

        // Expanded Content
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            margin: const EdgeInsets.only(
              left: AppDimensions.paddingMd,
              right: AppDimensions.paddingMd,
              top: AppDimensions.paddingSm,
            ),
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            child: Column(
              children: [
                // Deity Name
                Text(
                  deityName,
                  style: AppTypography.h2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.sm),

                // Mantra
                if (deity?.mantra != null)
                  Text(
                    deity!.mantra,
                    style: AppTypography.body1.copyWith(
                      color: Colors.white,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: AppDimensions.lg),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      icon: Icons.copy,
                      label: 'Copy',
                      onTap: _copyMantra,
                    ),
                    const SizedBox(width: AppDimensions.xl),
                    _buildActionButton(
                      icon: Icons.share,
                      label: 'Share',
                      onTap: _shareDeity,
                    ),
                  ],
                ),

                // View Full Details
                if (widget.onViewDetails != null) ...[
                  const SizedBox(height: AppDimensions.lg),
                  GestureDetector(
                    onTap: widget.onViewDetails,
                    child: Text(
                      'View Full Details',
                      style: AppTypography.button.copyWith(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingSm,
        ),
        decoration: BoxDecoration(
          color: AppColors.brown,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.button.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
