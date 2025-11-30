import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart'; // Using MockAstrologer from Home

class AstrologerListController extends GetxController {
  final isLoading = true.obs;
  final allAstrologers = <MockAstrologer>[].obs;
  final displayedAstrologers = <MockAstrologer>[].obs;
  
  final selectedCategory = 'All'.obs;
  final categories = ['All', 'Vedic', 'Numerology', 'Tarot', 'Prashna', 'Psychic'].obs;
  
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAstrologers();
  }

  Future<void> fetchAstrologers() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    
    // Generate more mock data for the full list
    allAstrologers.value = List.generate(50, (index) => MockAstrologer(
      id: 'list_$index',
      name: 'Astrologer ${index + 1}',
      specialty: _getSpecialty(index),
      rating: 4.0 + (index % 10) * 0.1,
      reviewCount: 50 + index * 20,
      imageUrl: 'https://randomuser.me/api/portraits/${index % 2 == 0 ? "women" : "men"}/$index.jpg',
    ));
    
    _applyFilters();
    isLoading.value = false;
  }

  String _getSpecialty(int index) {
    final types = ['Vedic', 'Numerology', 'Tarot', 'Prashna', 'Psychic'];
    return types[index % types.length];
  }

  void onCategorySelected(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = allAstrologers.toList();

    // Category Filter
    if (selectedCategory.value != 'All') {
      filtered = filtered.where((a) => a.specialty.contains(selectedCategory.value)).toList();
    }

    // Search Filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((a) => 
        a.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        a.specialty.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }

    displayedAstrologers.value = filtered;
  }
}
