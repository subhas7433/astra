import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Centralized BoxDecoration presets for Astro GPT
/// Contains reusable decorations for cards, containers, buttons,
/// and other UI elements to ensure consistent styling.
abstract class AppDecorations {
  AppDecorations._();

  // ==================== CARDS ====================

  /// Standard card decoration with subtle shadow
  static BoxDecoration get card => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [cardShadow],
      );

  /// Elevated card decoration with stronger shadow
  static BoxDecoration get cardElevated => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [elevatedShadow],
      );

  /// Astrologer card with gradient background
  static BoxDecoration get astrologerCard => BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      );

  /// Horoscope card with cream background
  static BoxDecoration get horoscopeCard => BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      );

  // ==================== CHAT ====================

  /// Chat input container (dark bar at bottom)
  static BoxDecoration get chatInputContainer => BoxDecoration(
        color: AppColors.scaffoldDark,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      );

  /// Astrologer message bubble (coral with specific radius)
  static BoxDecoration get messageBubbleAstrologer => const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(4),
        ),
      );

  /// User message bubble (white with border)
  static BoxDecoration get messageBubbleUser => BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.divider),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(4),
        ),
      );

  // ==================== CHIPS ====================

  /// Selected chip decoration (primary border)
  static BoxDecoration get chipSelected => BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      );

  /// Unselected chip decoration (gray background)
  static BoxDecoration get chipUnselected => BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      );

  // ==================== NAVIGATION ====================

  /// Bottom bar decoration with top shadow
  static BoxDecoration get bottomBar => BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      );

  // ==================== SPECIAL ELEMENTS ====================

  /// Mantra bar decoration (dark rounded rectangle)
  static BoxDecoration get mantraBar => BoxDecoration(
        color: AppColors.scaffoldDark,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      );

  /// Progress bar background
  static BoxDecoration get progressBackground => BoxDecoration(
        color: AppColors.divider,
        borderRadius:
            BorderRadius.circular(AppDimensions.progressBarHeight / 2),
      );

  /// Progress bar fill
  static BoxDecoration get progressFill => BoxDecoration(
        color: AppColors.primary,
        borderRadius:
            BorderRadius.circular(AppDimensions.progressBarHeight / 2),
      );

  /// Avatar container decoration
  static BoxDecoration get avatarContainer => BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2),
      );

  // ==================== SHADOWS ====================

  /// Light shadow for cards
  static BoxShadow get cardShadow => BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: AppDimensions.blurRadius1,
        offset: AppDimensions.shadowOffset1,
      );

  /// Elevated shadow for prominent elements
  static BoxShadow get elevatedShadow => BoxShadow(
        color: AppColors.shadowMedium,
        blurRadius: AppDimensions.blurRadius2,
        offset: AppDimensions.shadowOffset2,
      );

  // ==================== HELPER METHODS ====================

  /// Creates a card decoration with custom color
  static BoxDecoration cardWithColor(Color color) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [cardShadow],
      );

  /// Creates a rounded container with custom radius
  static BoxDecoration rounded(double radius, {Color? color}) => BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
      );
}
