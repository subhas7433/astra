import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

import '../../../data/models/astrologer_model.dart';
import '../../../data/repositories/astrologer_repository.dart';

class HomeController extends GetxController {
  final AstrologerRepository _repository = Get.find<AstrologerRepository>();

  final isLoading = true.obs;
  final currentLocation = 'New Delhi, India'.obs;
  final notificationCount = 2.obs;

  final selectedCategory = 'All'.obs;
  final categories = ['All', 'Career', 'Life', 'Love', 'Health'].obs;
  final allAstrologers = <AstrologerModel>[].obs; // Store all loaded
  final astrologers = <AstrologerModel>[].obs; // Displayed list
  final isMoreLoading = false.obs;
  int _page = 1;
  final int _limit = 10;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    _page = 1;
    
    final result = await _repository.getAstrologers(limit: _limit, offset: 0);

    result.fold(
      onSuccess: (success) {
        allAstrologers.value = success;
        _applyFilters();
      },
      onFailure: (failure) {
        Get.snackbar('Error', failure.message);
      },
    );
    
    isLoading.value = false;
  }

  void _applyFilters() {
    if (selectedCategory.value == 'All') {
      astrologers.value = allAstrologers;
    } else {
      astrologers.value = allAstrologers.where((a) {
        // Filter by specialization or category
        // This is a simple string match for now
        return a.specialization.contains(selectedCategory.value) || 
               a.expertiseTags.any((tag) => tag.contains(selectedCategory.value));
      }).toList();
    }
  }

  void onCategorySelected(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  Future<void> loadMoreAstrologers() async {
    if (isMoreLoading.value) return;
    isMoreLoading.value = true;
    
    // Simulate pagination by fetching more mock data
    // In real app, use offset based on current list length
    final result = await _repository.getAstrologers(limit: 5, offset: allAstrologers.length);
    
    result.fold(
      onSuccess: (success) {
        allAstrologers.addAll(success);
        _applyFilters();
      },
      onFailure: (failure) {
        Get.snackbar('Error', failure.message);
      },
    );

    isMoreLoading.value = false;
  }

  Future<void> refreshHome() async {
    await fetchHomeData();
  }


  void onViewAll() {
    Get.toNamed(AppRoutes.astrologerList);
  }

  void onNotificationTap() {
    // TODO: Navigate to notifications
    print('Notification tapped');
  }

  void onLocationTap() {
    // TODO: Open location picker
    print('Location tapped');
  }
  
  void onSettingsTap() {
    Get.toNamed(AppRoutes.settings);
  }
}
