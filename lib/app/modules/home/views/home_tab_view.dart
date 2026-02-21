import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';
import '../widgets/astrologers_section.dart';
import '../widgets/feature_icons_grid.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/today_mantra_card.dart';
import '../widgets/today_bhagwan_card.dart';
import '../../../global/widgets/banner_ad_widget.dart';

/// Home tab view with state preservation.
class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  static void _navigateToMantra() {
    Get.toNamed(AppRoutes.todayMantra);
  }

  static void _navigateToDeity() {
    Get.toNamed(AppRoutes.todayBhagwan);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.find<HomeController>();

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

                        // Today Mantra Card
                        Obx(() {
                          final mantra = controller.todaysMantra.value;
                          return TodayMantraCard(
                            mantra: mantra?.sanskrit ?? 'Om Namah Shivaya',
                            onViewDetails: _navigateToMantra,
                          );
                        }),
                        const SizedBox(height: AppDimensions.lg),

                        // Today's God Card
                        Obx(() {
                          final deity = controller.todaysDeity.value;
                          return TodayBhagwanCard(
                            deity: deity,
                            onViewDetails: _navigateToDeity,
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
                              onTap: _navigateToDeity,
                            ),
                            FeatureIconItem(
                              label: 'Numerology',
                              icon: Icons.numbers,
                              color: AppColors.aquariusColor,
                              onTap: () => Get.toNamed(AppRoutes.numerology),
                            ),
                            FeatureIconItem(
                              label: 'Palm Reading',
                              icon: Icons.back_hand_outlined,
                              color: AppColors.brown,
                              onTap: () => Get.toNamed(AppRoutes.palmistry),
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
                                child: CircularProgressIndicator(
                                    color: AppColors.primary),
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
