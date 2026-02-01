import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

import '../../../data/models/astrologer_model.dart';
import '../../../data/models/mantra_model.dart';
import '../../../data/models/deity_model.dart';
import '../../../data/models/faq_model.dart';
import '../../../data/repositories/astrologer_repository.dart';
import '../../../data/repositories/daily_content_repository.dart';
import '../../../data/repositories/faqs_repository.dart';

class HomeController extends GetxController {
  final AstrologerRepository _astrologerRepo = Get.find<AstrologerRepository>();
  final DailyContentRepository _dailyContentRepo = Get.find<DailyContentRepository>();
  final FAQsRepository _faqsRepo = Get.find<FAQsRepository>();

  final isLoading = true.obs;
  final currentLocation = 'New Delhi, India'.obs;
  final notificationCount = 2.obs;

  // Astrologers
  final selectedCategory = 'All'.obs;
  final categories = ['All', 'Career', 'Life', 'Love', 'Health'].obs;
  final allAstrologers = <AstrologerModel>[].obs;
  final astrologers = <AstrologerModel>[].obs;
  final isMoreLoading = false.obs;
  final int _limit = 10;

  // Daily Content
  final todaysMantra = Rxn<MantraModel>();
  final todaysDeity = Rxn<DeityModel>();
  final isMantraLoading = false.obs;
  final isDeityLoading = false.obs;

  // FAQs
  final mostAskedQuestions = <FAQModel>[].obs;
  final isFaqsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;

    // Fetch all data in parallel
    await Future.wait([
      _fetchAstrologers(),
      _fetchTodaysMantra(),
      _fetchTodaysDeity(),
      _fetchMostAskedQuestions(),
    ]);

    isLoading.value = false;
  }

  Future<void> _fetchAstrologers() async {
    final result = await _astrologerRepo.getAstrologers(limit: _limit, offset: 0);

    result.fold(
      onSuccess: (success) {
        allAstrologers.value = success;
        _applyFilters();
      },
      onFailure: (failure) {
        // Silently fail for astrologers, show empty list
        allAstrologers.clear();
        astrologers.clear();
      },
    );
  }

  Future<void> _fetchTodaysMantra() async {
    isMantraLoading.value = true;
    final result = await _dailyContentRepo.getTodaysMantra();

    result.fold(
      onSuccess: (mantra) {
        todaysMantra.value = mantra;
      },
      onFailure: (failure) {
        // Silently fail, mantra will be null
        todaysMantra.value = null;
      },
    );
    isMantraLoading.value = false;
  }

  Future<void> _fetchTodaysDeity() async {
    isDeityLoading.value = true;
    final result = await _dailyContentRepo.getTodaysBhagwan();

    result.fold(
      onSuccess: (deity) {
        todaysDeity.value = deity;
      },
      onFailure: (failure) {
        // Silently fail, deity will be null
        todaysDeity.value = null;
      },
    );
    isDeityLoading.value = false;
  }

  Future<void> _fetchMostAskedQuestions() async {
    isFaqsLoading.value = true;
    final result = await _faqsRepo.getMostAskedQuestions(limit: 5);

    result.fold(
      onSuccess: (faqs) {
        mostAskedQuestions.value = faqs;
      },
      onFailure: (failure) {
        // Silently fail, show empty list
        mostAskedQuestions.clear();
      },
    );
    isFaqsLoading.value = false;
  }

  void _applyFilters() {
    if (selectedCategory.value == 'All') {
      astrologers.value = allAstrologers;
    } else {
      astrologers.value = allAstrologers.where((a) {
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

    final result = await _astrologerRepo.getAstrologers(
      limit: 5,
      offset: allAstrologers.length,
    );

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

  void onMantraTap() {
    // TODO: Navigate to mantra detail or audio player
    print('Mantra tapped');
  }

  void onDeityTap() {
    // TODO: Navigate to deity detail
    print('Deity tapped');
  }

  void onFaqTap(FAQModel faq) {
    // TODO: Navigate to chat with this question pre-filled
    print('FAQ tapped: ${faq.questionEnglish}');
  }
}
