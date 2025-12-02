import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/horoscope_constants.dart';
import '../controllers/horoscope_detail_controller.dart';
import '../widgets/horoscope_header.dart';
import '../widgets/time_period_tabs.dart';
import '../widgets/category_card.dart';
import '../widgets/lucky_section.dart';
import '../widgets/daily_tip_card.dart';
import '../../../widgets/ads/banner_ad_widget.dart';

class HoroscopeDetailScreen extends GetView<HoroscopeDetailController> {
  const HoroscopeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            HoroscopeHeader(sign: controller.zodiacSign),
            
            // Tabs
            Obx(() => TimePeriodTabs(
              selectedPeriod: controller.selectedPeriod.value,
              onPeriodChanged: controller.onPeriodChanged,
            )),
            
            // Content Area
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final horoscope = controller.currentHoroscope.value;
                if (horoscope == null) {
                  return const Center(child: Text('Failed to load horoscope'));
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshHoroscope,
                  color: AppColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // General Prediction
                          Text(
                            'Today\'s Overview',
                            style: AppTypography.h3,
                          ),
                          const SizedBox(height: AppDimensions.sm),
                          Text(
                            horoscope.predictionText,
                            style: AppTypography.body1.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.xl),

                          // Banner Ad
            const SizedBox(height: AppDimensions.paddingMd),
            const Center(child: BannerAdWidget()),
            const SizedBox(height: AppDimensions.paddingMd),

            // Category Cards
                          CategoryCard(
                            title: 'Love',
                            icon: Icons.favorite,
                            color: HoroscopeConstants.loveColor,
                            percentage: horoscope.lovePercentage,
                            prediction: horoscope.lovePrediction,
                          ),
                          CategoryCard(
                            title: 'Career',
                            icon: Icons.work,
                            color: HoroscopeConstants.careerColor,
                            percentage: horoscope.careerPercentage,
                            prediction: horoscope.careerPrediction,
                          ),
                          CategoryCard(
                            title: 'Health',
                            icon: Icons.favorite_border, // Or another health icon
                            color: HoroscopeConstants.healthColor,
                            percentage: horoscope.healthPercentage,
                            prediction: horoscope.healthPrediction,
                          ),
                          const SizedBox(height: AppDimensions.xl),

                          // Lucky Section
                          LuckySection(
                            luckyNumbers: horoscope.luckyNumbers,
                            luckyColor: horoscope.luckyColor,
                            luckyTime: horoscope.luckyTime,
                          ),
                          const SizedBox(height: AppDimensions.xl),

                          // Daily Tip
                          if (horoscope.hasTip)
                            DailyTipCard(tip: horoscope.getTip()!),
                          
                          const SizedBox(height: AppDimensions.xl),

                          // Actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Obx(() => _buildActionButton(
                                icon: controller.isLiked.value ? Icons.favorite : Icons.favorite_border,
                                label: 'Like',
                                color: controller.isLiked.value ? Colors.red : AppColors.textSecondary,
                                onTap: controller.toggleLike,
                              )),
                              _buildActionButton(
                                icon: Icons.share,
                                label: 'Share',
                                color: AppColors.textSecondary,
                                onTap: controller.shareHoroscope,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.xxl),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingSm,
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppDimensions.xs),
            Text(
              label,
              style: AppTypography.body2.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
