import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Centralized typography styles for Astro GPT
/// All text styles used throughout the app should be defined here
/// for consistent typography across the application.
abstract class AppTypography {
  AppTypography._();

  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Special
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    height: 1.2,
  );

  static const TextStyle chip = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // White variants (for use on dark/primary backgrounds)
  static TextStyle get h1White => h1.copyWith(color: AppColors.textOnPrimary);
  static TextStyle get h2White => h2.copyWith(color: AppColors.textOnPrimary);
  static TextStyle get h3White => h3.copyWith(color: AppColors.textOnPrimary);
  static TextStyle get body1White => body1.copyWith(color: AppColors.textOnPrimary);
  static TextStyle get body2White => body2.copyWith(color: AppColors.textOnPrimary);
}
