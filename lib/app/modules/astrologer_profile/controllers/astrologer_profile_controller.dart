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

    // Fetch Astrologer Details from Appwrite
    if (Get.arguments is AstrologerModel) {
      // If passed as argument, use it immediately but still fetch fresh data
      astrologer.value = Get.arguments as AstrologerModel;
    }

    // Fetch fresh data from Appwrite
    final result = await _astrologerRepository.getAstrologerById(id);
    result.fold(
      onSuccess: (fetchedAstrologer) {
        astrologer.value = fetchedAstrologer;
      },
      onFailure: (error) {
        Get.snackbar('Error', error.message);
        // If fetch fails and we don't have cached data, set null
        if (Get.arguments is! AstrologerModel) {
          astrologer.value = null;
        }
      },
    );

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
