import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../home/controllers/home_controller.dart'; // Import to access MockAstrologer

class AstrologerProfileController extends GetxController {
  final isLoading = true.obs;
  final isFavorite = false.obs;
  final astrologer = Rxn<MockAstrologer>();

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
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    
    // Mock Data - In real app, fetch by ID
    astrologer.value = MockAstrologer(
      id: id,
      name: 'Nikki Diwan',
      specialty: 'Vedic, Vastu',
      rating: 4.8,
      reviewCount: 800,
      imageUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
    );
    
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
