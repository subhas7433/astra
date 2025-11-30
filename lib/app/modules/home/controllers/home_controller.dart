import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

// Temporary inline model until import issues are resolved
class MockAstrologer {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final String imageUrl;

  MockAstrologer({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
  });
}

class HomeController extends GetxController {
  final isLoading = true.obs;
  final currentLocation = 'New Delhi, India'.obs;
  final notificationCount = 2.obs;

  final selectedCategory = 'All'.obs;
  final categories = ['All', 'Career', 'Life', 'Love', 'Health'].obs;
  final allAstrologers = <MockAstrologer>[].obs; // Store all loaded
  final astrologers = <MockAstrologer>[].obs; // Displayed list
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
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock Data Generation
    allAstrologers.value = List.generate(20, (index) => MockAstrologer(
      id: '$index',
      name: 'Astrologer ${index + 1}',
      specialty: index % 2 == 0 ? 'Vedic, Numerology' : 'Tarot, Career',
      rating: 4.5 + (index % 5) * 0.1,
      reviewCount: 100 + index * 10,
      imageUrl: 'https://randomuser.me/api/portraits/${index % 2 == 0 ? "women" : "men"}/$index.jpg',
    ));
    
    _applyFilters();
    isLoading.value = false;
  }

  void _applyFilters() {
    if (selectedCategory.value == 'All') {
      astrologers.value = allAstrologers;
    } else {
      astrologers.value = allAstrologers.where((a) {
        // Simple mock filtering logic
        if (selectedCategory.value == 'Career') return a.specialty.contains('Career');
        if (selectedCategory.value == 'Love') return a.specialty.contains('Tarot'); // Mock mapping
        return true;
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
    await Future.delayed(const Duration(seconds: 1));
    
    // Add more mock data
    final moreAstrologers = List.generate(5, (index) => MockAstrologer(
      id: 'more_$index',
      name: 'New Astrologer $index',
      specialty: 'Vedic',
      rating: 4.0,
      reviewCount: 50,
      imageUrl: 'https://randomuser.me/api/portraits/women/${index + 50}.jpg',
    ));
    
    allAstrologers.addAll(moreAstrologers);
    _applyFilters();
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
    // TODO: Navigate to settings
    print('Settings tapped');
  }
}
