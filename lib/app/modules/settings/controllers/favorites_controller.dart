import 'package:get/get.dart';
import '../../../data/services/storage_service.dart';

class FavoriteItem {
  final String id;
  final String type;
  /// Optional title for display in list
  final String? title; 
  /// Optional subtitle
  final String? subtitle;

  FavoriteItem({required this.id, required this.type, this.title, this.subtitle});
}

class FavoritesController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final RxList<FavoriteItem> favorites = <FavoriteItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    // In a real app we might fetch metadata.
    // Here we load IDs from storage and maybe can only display IDs unless we have metadata.
    // For MVP, we simply show "Horoscope (ID)" or assume metadata is somehow available or not displayed.
    
    // However, the screen needs to show something.
    // If we only store IDs, we can't show titles.
    // We might need to store title along with ID or fetch it.
    
    // For now, let's load what we have.
    final horoscopeIds = _storageService.getLikedItems('horoscope');
    final mantraIds = _storageService.getLikedItems('mantra');
    
    favorites.clear();
    for (var id in horoscopeIds) {
      favorites.add(FavoriteItem(id: id, type: 'Horoscope', title: 'Horoscope ($id)')); 
    }
    for (var id in mantraIds) {
       favorites.add(FavoriteItem(id: id, type: 'Mantra', title: 'Mantra ($id)'));
    }
  }
}
