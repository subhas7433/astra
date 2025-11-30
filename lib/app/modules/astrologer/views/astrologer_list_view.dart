import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../routes/app_routes.dart';
import '../../home/widgets/astrologer_card.dart';
import '../../home/widgets/category_chips.dart';
import '../controllers/astrologer_list_controller.dart';

class AstrologerListView extends GetView<AstrologerListController> {
  const AstrologerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Search
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppColors.primary,
            title: Text('Astrologers', style: AppTypography.h3.copyWith(color: Colors.white)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: TextField(
                    onChanged: controller.onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Search astrologers...',
                      prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Filters
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
              child: Obx(() => CategoryChips(
                categories: controller.categories,
                selectedCategory: controller.selectedCategory.value,
                onCategorySelected: controller.onCategorySelected,
              )),
            ),
          ),

          // List
          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
              );
            }

            if (controller.displayedAstrologers.isEmpty) {
              return const SliverFillRemaining(
                child: Center(child: Text('No astrologers found')),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final astrologer = controller.displayedAstrologers[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.paddingMd),
                      child: AstrologerCard(
                        name: astrologer.name,
                        specialty: astrologer.specialty,
                        rating: astrologer.rating,
                        reviewCount: astrologer.reviewCount,
                        imageUrl: astrologer.imageUrl,
                        onTap: () => Get.toNamed(AppRoutes.astrologerProfileWithId(astrologer.id)),
                      ),
                    );
                  },
                  childCount: controller.displayedAstrologers.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
