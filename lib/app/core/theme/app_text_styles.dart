import 'package:flutter/material.dart';
import '../constants/app_typography.dart';

/// Centralized text styles for the app.
/// Maps AppTypography to Material 3 text styles.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get headlineLarge => AppTypography.h1;
  static TextStyle get headlineMedium => AppTypography.h2;
  static TextStyle get headlineSmall => AppTypography.h3;

  static TextStyle get titleLarge => AppTypography.h3;
  static TextStyle get titleMedium => AppTypography.body1.copyWith(fontWeight: FontWeight.bold);
  static TextStyle get titleSmall => AppTypography.body2.copyWith(fontWeight: FontWeight.bold);

  static TextStyle get bodyLarge => AppTypography.body1;
  static TextStyle get bodyMedium => AppTypography.body2;
  static TextStyle get bodySmall => AppTypography.caption;

  static TextStyle get labelLarge => AppTypography.button;
  static TextStyle get labelMedium => AppTypography.chip;
  static TextStyle get labelSmall => AppTypography.caption;
}
