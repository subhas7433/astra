import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  void saveMessages(String chatId, List<Map<String, dynamic>> messages) {
    _box.write(chatId, messages);
  }

  List<Map<String, dynamic>> getMessages(String chatId) {
    final data = _box.read(chatId);
    if (data != null) {
      return List<Map<String, dynamic>>.from(data);
    }
    return [];
  }

  void clearMessages(String chatId) {
    _box.remove(chatId);
  }
}
