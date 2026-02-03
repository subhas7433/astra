import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import 'splash_controller.dart';

/// Splash screen displayed on app launch.
///
/// Shows app branding while authentication is checked.
class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              child: Image.asset(
                'assets/images/app_logo.png',
                width: 120,
                height: 120,
              ),
            ),
            SizedBox(height: AppDimensions.xl),

            // App Name
            Text(
              'Astra AI',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: AppDimensions.xs),

            // Tagline
            Text(
              'Your AI Astrology Companion',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            SizedBox(height: AppDimensions.xxl),

            // Loading indicator
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
