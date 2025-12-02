import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/models/astrologer_model.dart';
import '../../../data/models/review_model.dart';
import '../../../data/repositories/astrologer_repository.dart';
import '../../../data/repositories/reviews_repository.dart';

class AstrologerProfileController extends GetxController {
  final AstrologerRepository _astrologerRepository = Get.find<AstrologerRepository>();
  final ReviewsRepository _reviewsRepository = Get.find<ReviewsRepository>();

  final isLoading = true.obs;
  final isFavorite = false.obs;
  final astrologer = Rxn<AstrologerModel>();
  final reviews = <ReviewModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final id = Get.parameters['id'];
    if (id != null) {
      loadProfile(id);
    }
  }

  Future<void> loadProfile(String id) async {
    isLoading.value = true;
    
    // Fetch Astrologer Details
    // Note: AstrologerRepository doesn't have getById yet, so we'll simulate it or add it.
    // For now, we'll assume we can pass the object or fetch from list if cached.
    // Since we don't have getById, we'll fetch list and find (inefficient but works for now)
    // Or better, we can add getById to repository.
    
    // Let's assume we pass the object via arguments if available, or fetch.
    if (Get.arguments is AstrologerModel) {
      astrologer.value = Get.arguments as AstrologerModel;
    } else {
      // Fallback: Fetch list and find (temporary solution until getById is added)
      final result = await _astrologerRepository.getAstrologers(limit: 100);
      result.fold(
        onSuccess: (list) {
          astrologer.value = list.firstWhereOrNull((a) => a.id == id);
        },
        onFailure: (error) => Get.snackbar('Error', error.message),
      );
    }

    // Fetch Reviews
    if (astrologer.value != null) {
      final reviewsResult = await _reviewsRepository.getReviewsByAstrologer(id);
      reviewsResult.fold(
        onSuccess: (list) => reviews.value = list,
        onFailure: (error) => print('Failed to load reviews: ${error.message}'),
      );
    }
    
    isLoading.value = false;
  }

  void toggleFavorite() {
    isFavorite.toggle();
  }

  void startChat() {
    if (astrologer.value != null) {
      Get.toNamed(AppRoutes.chatWithAstrologer(astrologer.value!.id));
    }
  }
}
