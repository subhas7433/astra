import 'package:get/get.dart';
import '../../../data/models/astrologer_model.dart';
import '../../../data/repositories/astrologer_repository.dart';

class AstrologerListController extends GetxController {
  final isLoading = true.obs;
  final allAstrologers = <AstrologerModel>[].obs;
  final displayedAstrologers = <AstrologerModel>[].obs;
  
  final selectedCategory = 'All'.obs;
  final categories = ['All', 'Vedic', 'Numerology', 'Tarot', 'Prashna', 'Psychic'].obs;
  
  final searchQuery = ''.obs;

  final AstrologerRepository _repository = Get.find<AstrologerRepository>();

  @override
  void onInit() {
    super.onInit();
    fetchAstrologers();
  }

  Future<void> fetchAstrologers() async {
    isLoading.value = true;
    
    final result = await _repository.getAstrologers(limit: 50);
    
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
      filtered = filtered.where((a) => a.specialization.contains(selectedCategory.value)).toList();
    }

    // Search Filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((a) => 
        a.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        a.specialization.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }

    displayedAstrologers.value = filtered;
  }
}
