import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';

class PanditBanner extends StatelessWidget {
  const PanditBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
      height: 140,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFB74D), // Light Orange
            Color(0xFFFF9800), // Orange
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Stack(
        children: [
          // Content
          Positioned(
            left: 120, // Space for image
            right: AppDimensions.paddingMd,
            top: AppDimensions.paddingMd,
            bottom: AppDimensions.paddingMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PANDIT JI',
                  style: AppTypography.h2.copyWith(
                    color: const Color(0xFF1565C0), // Blue color from design
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  'Pandit Ji Astro App - Bharosa bhi,\nsamadhan bhi!',
                  style: AppTypography.caption.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // Pandit Image Placeholder
          Positioned(
            left: AppDimensions.paddingMd,
            bottom: 0,
            child: Container(
              width: 100,
              height: 120,
              alignment: Alignment.bottomCenter,
              child: Image.network(
                'https://cdn-icons-png.flaticon.com/512/3996/3996879.png', // Placeholder Monk/Pandit icon
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.brown,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
