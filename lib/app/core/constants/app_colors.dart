import 'package:flutter/material.dart';

/// Centralized color constants for Astro GPT
/// All colors used throughout the app should be defined here
/// to maintain consistency and enable easy theme updates.
abstract class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFFF26B4E);
  static const Color primaryLight = Color(0xFFFF8A70);
  static const Color primaryDark = Color(0xFFD84A30);

  // Background Colors
  static const Color background = Color(0xFFFFF5F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFAE5DC);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textHint = Color(0xFFBDBDBD);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);

  // UI Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color chipBackground = Color(0xFFE8E8E8);
  static const Color starRating = Color(0xFFFFD700);
  static const Color scaffoldDark = Color(0xFF2D2D2D);

  // Gradient Colors
  static const Color gradientStart = Color(0xFFF26B4E);
  static const Color gradientEnd = Color(0xFFFF8A70);

  // Shadow Colors
  static Color get shadowLight => const Color(0x0D000000);
  static Color get shadowMedium => const Color(0x1A000000);

  // Zodiac Colors (basic - full ZodiacConstants in Session 4)
  static const Color ariesColor = Color(0xFFE91E63);
  static const Color taurusColor = Color(0xFFFFF8E1);
  static const Color geminiColor = Color(0xFFFFD700);
  static const Color cancerColor = Color(0xFFFFEB3B);
  static const Color leoColor = Color(0xFFFFC107);
  static const Color virgoColor = Color(0xFF4CAF50);
  static const Color libraColor = Color(0xFF8BC34A);
  static const Color scorpioColor = Color(0xFF009688);
  static const Color sagittariusColor = Color(0xFF2196F3);
  static const Color capricornColor = Color(0xFF9C27B0);
  static const Color aquariusColor = Color(0xFF673AB7);
  static const Color piscesColor = Color(0xFFE91E63);

  // Settings Icon Colors
  static const Color removeAdsIcon = Color(0xFFE53935);
  static const Color feedbackIcon = Color(0xFF64B5F6);
  static const Color rateIcon = Color(0xFFFFB74D);

  // Dark Theme Prep
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);

  // Convenience: Primary gradient
  static LinearGradient get primaryGradient => const LinearGradient(
        colors: [gradientStart, gradientEnd],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  // New Design Colors (Session 7 Refinement)
  static const Color brown = Color(0xFFA0522D); // For Copy button, Chips
  static const Color tan = Color(0xFFD2B48C); // For Chip backgrounds
  
  // Pastel Colors for Settings
  static const Color pastelRed = Color(0xFFFFEBEE);
  static const Color pastelBlue = Color(0xFFE3F2FD);
  static const Color pastelOrange = Color(0xFFFFF3E0);
  static const Color pastelGreen = Color(0xFFE8F5E9);
  static const Color pastelPurple = Color(0xFFF3E5F5);

  // Session 2 Colors
  static const Color mantraBackground = Color(0xFF0F172A); // Dark Blue/Black
  static const LinearGradient questionCardGradient = LinearGradient(
    colors: [Color(0xFFFF8A65), Color(0xFFFF7043)], // Coral/Orange
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shimmer
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Surface Variant
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  
  // Border
  static const Color border = Color(0xFFE0E0E0);
}
