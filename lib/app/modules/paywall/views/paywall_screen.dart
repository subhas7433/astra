import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../controllers/paywall_controller.dart';
import '../widgets/subscription_card.dart';

class PaywallScreen extends GetView<PaywallController> {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isPurchaseLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingLg),
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.md),
                // Hero Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.diamond_outlined,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),

                // Title
                Text(
                  'Unlock Premium',
                  style: AppTypography.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  'Get unlimited AI chat, removing all ads, and access daily personalized content.',
                  style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.xxl),

                // Features List
                _buildFeatureRow('No Advertisements'),
                _buildFeatureRow('Unlimited AI Chat'),
                _buildFeatureRow('Detailed Horoscopes'),
                _buildFeatureRow('Priority Support'),
                const SizedBox(height: AppDimensions.xxl),

                // Subscription Options
                if (controller.isLoading.value)
                  const CircularProgressIndicator()
                else
                  ...controller.packages.map((package) {
                    final isYearly = package.identifier.contains('year');
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.md),
                      child: SubscriptionCard(
                        package: package,
                        isPopular: isYearly,
                        onTap: () => controller.purchase(package),
                      ),
                    );
                  }),

                const SizedBox(height: AppDimensions.lg),

                // Restore Button
                TextButton(
                  onPressed: controller.restore,
                  child: Text(
                    'Restore Purchases',
                    style: AppTypography.body2.copyWith(
                      decoration: TextDecoration.underline,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                
                 const SizedBox(height: AppDimensions.sm),
                 Text(
                   'Recurring billing. Cancel anytime.',
                   style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                 ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 24),
          const SizedBox(width: 12),
          Text(text, style: AppTypography.body1),
        ],
      ),
    );
  }
}
