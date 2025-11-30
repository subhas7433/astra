import 'package:flutter/material.dart';

/// Centralized dimension constants for Astro GPT
/// All spacing, sizing, and radius values should be defined here
/// to maintain consistent spacing system (4dp base unit).
abstract class AppDimensions {
  AppDimensions._();

  // Spacing (4dp base unit)
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  // Padding (same as spacing, for clarity in padding contexts)
  static const double paddingXs = xs;
  static const double paddingSm = sm;
  static const double paddingMd = md;
  static const double paddingLg = lg;
  static const double paddingXl = xl;
  static const double paddingXxl = xxl;

  // Screen Padding
  static const double screenPadding = 16.0;
  static const EdgeInsets screenInsets = EdgeInsets.all(16.0);

  // Card
  static const double cardPadding = 16.0;
  static const double cardMargin = 8.0;

  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  // Component Heights
  static const double appBarHeight = 56.0;
  static const double buttonHeight = 48.0;
  static const double buttonHeightSm = 40.0;
  static const double inputHeight = 48.0;
  static const double chipHeight = 40.0;
  static const double bottomBarHeight = 72.0;

  // Icons
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;

  // Avatars
  static const double avatarSm = 36.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 80.0;

  // Cards
  static const double astrologerCardHeight = 120.0;
  static const double questionCardWidth = 200.0;
  static const double questionCardHeight = 100.0;

  // Progress
  static const double progressBarHeight = 8.0;

  // Shadows
  static const Offset shadowOffset1 = Offset(0, 2);
  static const Offset shadowOffset2 = Offset(0, 4);
  static const double blurRadius1 = 8.0;
  static const double blurRadius2 = 16.0;

  // Touch Targets
  static const double minTouchTarget = 48.0;

  // Convenience Methods
  static EdgeInsets paddingH(double v) => EdgeInsets.symmetric(horizontal: v);
  static EdgeInsets paddingV(double v) => EdgeInsets.symmetric(vertical: v);
  static EdgeInsets paddingAll(double v) => EdgeInsets.all(v);
  static BorderRadius radius(double v) => BorderRadius.circular(v);
}
