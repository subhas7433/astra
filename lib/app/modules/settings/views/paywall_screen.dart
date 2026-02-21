import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/impl/subscription_service.dart';

class PaywallScreen extends GetView<SubscriptionService> {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Design
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.paddingLg),
                    child: Column(
                      children: [
                        // Icon/Image
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingLg),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.diamond_outlined,
                            size: 64,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xl),

                        // Title
                        Text(
                          'Unlock Pro',
                          style: AppTypography.h2.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.sm),

                        // Subtitle
                        Text(
                          'Get unlimited access to all features',
                          style: AppTypography.body1.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.xl),

                        // Features List
                        _buildFeatureItem(Icons.block, 'No Ads'),
                        _buildFeatureItem(Icons.chat_bubble_outline, 'Unlimited Chat'),
                        _buildFeatureItem(Icons.auto_awesome, 'Advanced Insights'),
                        const SizedBox(height: AppDimensions.xl),

                        // Packages
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final packages = controller.packages;
                          if (packages.isEmpty) {
                            return const Text('No packages available');
                          }

                          return Column(
                            children: packages.map((package) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppDimensions.md),
                                child: _buildPackageCard(package),
                              );
                            }).toList(),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                // Restore Purchases
                TextButton(
                  onPressed: () async {
                    await controller.restorePurchases();
                    Get.snackbar('Success', 'Purchases restored');
                  },
                  child: Text(
                    'Restore Purchases',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                
                // Terms & Privacy
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {}, // TODO: Open Terms
                        child: Text('Terms', style: AppTypography.caption),
                      ),
                      const Text('•', style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: () {}, // TODO: Open Privacy
                        child: Text('Privacy', style: AppTypography.caption),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: AppDimensions.md),
          Text(
            text,
            style: AppTypography.body1.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(PaywallPackage package) {
    // Styling based on Tier
    final isPro = package.tier == SubscriptionTier.pro;

    Color borderColor = AppColors.primary.withOpacity(0.3);
    Color backgroundColor = Colors.white;
    double borderWidth = 1;

    if (isPro) {
      borderColor = AppColors.primary;
      borderWidth = 2;
      backgroundColor = AppColors.primary.withOpacity(0.05);
    }

    return Stack(
      children: [
        InkWell(
          onTap: () async {
            final success = await controller.purchasePackage(package);
            if (success) {
              Get.back();
              Get.snackbar(
                'Success',
                'Welcome to ${package.title}!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 12), // Space for badge
            padding: const EdgeInsets.all(AppDimensions.paddingMd),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: borderWidth),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              color: backgroundColor,
              boxShadow: isPro ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ] : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            package.title,
                            style: AppTypography.h3.copyWith(fontSize: 16),
                          ),
                          if (isPro) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.star, size: 16, color: AppColors.primary),
                          ]
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        package.description,
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      package.priceString,
                      style: AppTypography.h3.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (isPro)
          Positioned(
            top: 0,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'MOST POPULAR',
                style: AppTypography.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
