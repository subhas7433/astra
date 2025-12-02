import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/services/subscription_service.dart';

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
                          'Unlock Premium',
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
    return InkWell(
      onTap: () async {
        final success = await controller.purchasePackage(package);
        if (success) {
          Get.back();
          Get.snackbar(
            'Success',
            'Welcome to Premium!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.title,
                    style: AppTypography.h3.copyWith(fontSize: 16),
                  ),
                  Text(
                    package.description,
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              package.priceString,
              style: AppTypography.h3.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
