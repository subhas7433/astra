import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../controllers/home_controller.dart';
import '../widgets/astrologers_section.dart';
import '../widgets/feature_icons_grid.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/most_asked_section.dart';
import '../widgets/today_mantra_card.dart';
import '../../../global/widgets/banner_ad_widget.dart';
import '../../../routes/app_routes.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  static void _navigateToMantra() {
    Get.toNamed(AppRoutes.todayMantra);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const HomeAppBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshHome,
              color: AppColors.primary,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!controller.isMoreLoading.value &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 50) {
                    controller.loadMoreAstrologers();
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: AppDimensions.md),
                      
                      // Today Mantra
                      Obx(() {
                        final mantra = controller.todaysMantra.value;
                        return TodayMantraCard(
                          mantra: mantra?.sanskrit ?? 'Om Namah Shivaya',
                          onViewDetails: _navigateToMantra,
                        );
                      }),
                      const SizedBox(height: AppDimensions.lg),

                      // Most Asked Questions
                      Obx(() {
                        final faqs = controller.mostAskedQuestions;
                        return MostAskedSection(
                          questions: faqs.isEmpty
                              ? const [
                                  'Kaunse planets career me madad karenge?',
                                  'Mera career start hoga?',
                                  'Love life kaisi rahegi?',
                                  'Shadi kab hogi?',
                                ]
                              : faqs.map((f) => f.questionHindi).toList(),
                          onQuestionTap: (question) {
                            final faq = faqs.firstWhereOrNull(
                              (f) => f.questionHindi == question,
                            );
                            if (faq != null) {
                              controller.onFaqTap(faq);
                            }
                          },
                        );
                      }),
                      const SizedBox(height: AppDimensions.lg),

                      // Feature Icons
                      FeatureIconsGrid(
                        items: [
                          FeatureIconItem(
                            label: 'Horoscope',
                            icon: Icons.stars,
                            color: AppColors.ariesColor,
                            onTap: () => Get.toNamed(AppRoutes.horoscope),
                          ),
                          FeatureIconItem(
                            label: 'Today God',
                            icon: Icons.temple_hindu,
                            color: AppColors.primary,
                            onTap: () => Get.toNamed(AppRoutes.todayBhagwan),
                          ),
                          FeatureIconItem(
                            label: 'Numerology',
                            icon: Icons.numbers,
                            color: AppColors.aquariusColor,
                            onTap: () => Get.toNamed(AppRoutes.numerology),
                          ),
                          FeatureIconItem(
                            label: 'History',
                            icon: Icons.history,
                            color: AppColors.capricornColor,
                            onTap: () => print('History tapped'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.lg),

                      // Astrologers Section
                      Obx(() => AstrologersSection(
                        astrologers: controller.astrologers.toList(),
                        selectedCategory: controller.selectedCategory.value,
                        onCategorySelected: controller.onCategorySelected,
                        onViewAll: controller.onViewAll,
                        onAstrologerTap: (id) {
                          Get.toNamed(AppRoutes.astrologerProfileWithId(id));
                        },
                      )),
                      
                      // Pagination Loader
                      Obx(() => controller.isMoreLoading.value
                          ? const Padding(
                              padding: EdgeInsets.all(AppDimensions.paddingMd),
                              child: CircularProgressIndicator(color: AppColors.primary),
                            )
                          : const SizedBox.shrink()),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Banner Ad
          const SizedBox(height: AppDimensions.paddingMd),
          const Center(child: BannerAdWidget()),
          const SizedBox(height: AppDimensions.paddingMd),
          ],
        ),
      ),
    );
  }
}
