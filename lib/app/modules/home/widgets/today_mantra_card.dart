import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../widgets/buttons/icon_button_circle.dart';

class TodayMantraCard extends StatefulWidget {
  final String mantra;
  final String title;

  const TodayMantraCard({
    super.key,
    required this.mantra,
    this.title = 'Today Mantra',
  });

  @override
  State<TodayMantraCard> createState() => _TodayMantraCardState();
}

class _TodayMantraCardState extends State<TodayMantraCard> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.mantra));
    Get.snackbar(
      'Copied',
      'Mantra copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surface,
      colorText: AppColors.textPrimary,
      margin: const EdgeInsets.all(AppDimensions.md),
    );
  }

  void _shareMantra() {
    // Mock share functionality
    Get.snackbar(
      'Share',
      'Sharing "${widget.mantra}"...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surface,
      colorText: AppColors.textPrimary,
      margin: const EdgeInsets.all(AppDimensions.md),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              borderRadius: BorderRadius.circular(30), // Pill shape
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Om Icon (Placeholder)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.self_improvement,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Text(
                      widget.title,
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
                Text(
                  widget.mantra,
                  style: AppTypography.body1.copyWith(
                    color: Colors.white,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      icon: Icons.copy,
                      label: 'Copy',
                      onTap: _copyToClipboard,
                    ),
                    const SizedBox(width: AppDimensions.xl),
                    _buildActionButton(
                      icon: Icons.share,
                      label: 'Share',
                      onTap: _shareMantra,
                    ),
                  ],
                ),
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
