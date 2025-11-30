import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../controllers/home_controller.dart';
import '../widgets/astrologers_section.dart';
import '../widgets/feature_icons_grid.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/most_asked_section.dart';
import '../widgets/pandit_banner.dart';
import '../widgets/today_mantra_card.dart';
import '../../../routes/app_routes.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const HomeAppBar(),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!controller.isMoreLoading.value &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  controller.loadMoreAstrologers();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: controller.refreshHome,
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: AppDimensions.md),
                      
                      // Today Mantra
                      const TodayMantraCard(
                        mantra: 'Om Namah Shivaya', // Mock data
                      ),
                      const SizedBox(height: AppDimensions.lg),

                      // Most Asked Questions
                      MostAskedSection(
                        questions: const [
                          'Kaunse planets career me madad karenge?',
                          'Mera career start hoga?',
                          'Love life kaisi rahegi?',
                          'Shadi kab hogi?',
                        ],
                        onQuestionTap: (question) {
                          // TODO: Handle question tap
                          print('Question tapped: $question');
                        },
                      ),
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
                            onTap: () => print('Today God tapped'),
                          ),
                          FeatureIconItem(
                            label: 'Numerology',
                            icon: Icons.numbers,
                            color: AppColors.aquariusColor,
                            onTap: () => print('Numerology tapped'),
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

                      // Pandit Banner
                      const PanditBanner(),
                      const SizedBox(height: AppDimensions.lg),

                      // Astrologers Section
                      Obx(() => AstrologersSection(
                        astrologers: controller.astrologers.value,
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
        ],
      ),
    );
  }
}
