import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/favorites_controller.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ideally put in binding, but for now lazy put here
    Get.lazyPut(() => FavoritesController());
    final controller = Get.find<FavoritesController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Favorites', style: AppTextStyles.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          if (controller.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border, size: 64, color: AppColors.textSecondary),
                const SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          itemCount: controller.favorites.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.paddingMd),
          itemBuilder: (context, index) {
            final item = controller.favorites[index];
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: Text(item.title ?? item.id, style: AppTextStyles.titleMedium),
                subtitle: Text(item.type, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                onTap: () {
                  // TODO: Navigate to details based on type
                },
              ),
            );
          },
          );
        }),
      ),
    );
  }
}
