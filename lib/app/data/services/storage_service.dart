import 'dart:ui';
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

  // Horoscope Caching
  void saveHoroscope(String key, Map<String, dynamic> data) {
    _box.write(key, data);
  }

  Map<String, dynamic>? getHoroscope(String key) {
    final data = _box.read(key);
    if (data != null) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  // User Preferences
  void saveZodiac(String zodiacId) {
    _box.write('user_zodiac_sign', zodiacId);
  }

  String? getZodiac() {
    return _box.read('user_zodiac_sign');
  }

  // Locale
  void saveLocale(Locale locale) {
    _box.write('language_code', locale.languageCode);
    _box.write('country_code', locale.countryCode);
  }

  Locale? getLocale() {
    final lang = _box.read('language_code');
    final country = _box.read('country_code');
    if (lang != null && country != null) {
      return Locale(lang, country);
    }
    return null;
  }

  // Horoscope Likes
  // Favorites / Likes
  
  List<String> getLikedItems(String type) {
    final list = _box.read('liked_$type');
    if (list != null) {
      return List<String>.from(list);
    }
    return [];
  }

  bool isItemLiked(String type, String id) {
    final list = getLikedItems(type);
    return list.contains(id);
  }

  void toggleItemLike(String type, String id) {
    final list = getLikedItems(type);
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    _box.write('liked_$type', list);
  }

  // Deprecated: methods for backward compatibility if needed, but safe to remove if unused
  List<String> getLikedHoroscopes() => getLikedItems('horoscope');
  bool isHoroscopeLiked(String id) => isItemLiked('horoscope', id);
  void toggleHoroscopeLike(String id) => toggleItemLike('horoscope', id);
}
