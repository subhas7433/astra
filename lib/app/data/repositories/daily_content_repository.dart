import 'package:get/get.dart';

import '../models/daily_content_model.dart';
import '../models/deity_model.dart';
import '../models/mantra_model.dart';
import '../models/numerology_model.dart';
import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import '../../core/services/api_client.dart';

class DailyContentRepository {
  final ApiClient _api;

  DailyContentRepository() : _api = Get.find<ApiClient>();

  /// Get today's deity content from the API
  Future<Result<DeityModel, AppError>> getTodaysBhagwan() async {
    final result = await _api.get('/api/v1/daily-content/today',
        queryParameters: {'type': 'deity'});
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return Result.success(_generateFallbackDeity());
        }
        // The API returns TodayContentResponse which has a nested `content` field
        final content = data['content'] as Map<String, dynamic>?;
        if (content == null) {
          return Result.success(_generateFallbackDeity());
        }
        return Result.success(DeityModel.fromApiJson(content));
      },
      onFailure: (_) => Result.success(_generateFallbackDeity()),
    );
  }

  /// Get today's mantra content from the API
  Future<Result<MantraModel, AppError>> getTodaysMantra() async {
    final result = await _api.get('/api/v1/daily-content/today',
        queryParameters: {'type': 'mantra'});
    return result.fold(
      onSuccess: (body) {
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          return Result.success(_generateFallbackMantra());
        }
        final content = data['content'] as Map<String, dynamic>?;
        if (content == null) {
          return Result.success(_generateFallbackMantra());
        }
        return Result.success(MantraModel.fromApiJson(content));
      },
      onFailure: (_) => Result.success(_generateFallbackMantra()),
    );
  }

  /// Get all daily content items
  Future<Result<List<DailyContentModel>, AppError>> getAllContent({
    String? type,
    int limit = 50,
    int offset = 0,
  }) async {
    final params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (type != null) params['type'] = type;

    final result =
        await _api.get('/api/v1/daily-content', queryParameters: params);
    return result.fold(
      onSuccess: (body) {
        final list = body['data'] as List<dynamic>? ?? [];
        final items = list
            .map((e) =>
                DailyContentModel.fromApiJson(e as Map<String, dynamic>))
            .toList();
        return Result.success(items);
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  Future<Result<List<DeityModel>, AppError>> getAllDeities() async {
    final result = await getAllContent(type: 'deity');
    return result.fold(
      onSuccess: (items) {
        final deities = items
            .map((dc) => DeityModel(
                  id: dc.id,
                  name: dc.title,
                  nameHindi: dc.titleHi ?? '',
                  imageUrl: dc.imageUrl ?? '',
                  description: dc.description,
                  descriptionHindi: dc.descriptionHi ?? '',
                  significance: '',
                  mantra: '',
                  date: dc.validDate,
                ))
            .toList();
        return Result.success(deities);
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  Future<Result<List<MantraModel>, AppError>> getAllMantras() async {
    final result = await getAllContent(type: 'mantra');
    return result.fold(
      onSuccess: (items) {
        final mantras = items
            .map((dc) => MantraModel(
                  id: dc.id,
                  sanskrit: dc.title,
                  transliteration: dc.titleHi ?? '',
                  meaning: dc.description,
                  meaningHindi: dc.descriptionHi ?? '',
                  benefits: const [],
                  audioUrl: dc.audioUrl,
                  deity: '',
                  date: dc.validDate,
                ))
            .toList();
        return Result.success(mantras);
      },
      onFailure: (error) => Result.failure(error),
    );
  }

  Future<Result<NumerologyModel, AppError>> getNumerologyPrediction(
      int number) async {
    // Numerology is computed locally, no API fetch needed
    return Result.success(_generateNumerology(number));
  }

  MantraModel _generateFallbackMantra() {
    return MantraModel(
      id: 'fallback_mantra',
      sanskrit: 'Om Namah Shivaya',
      transliteration: 'Om Namah Shivaya',
      meaning:
          'I bow to Shiva. This mantra purifies the soul and connects you to divine consciousness.',
      meaningHindi:
          'Main Shiv ko naman karta hoon. Yeh mantra aatma ko shuddh karta hai aur aapko divya chetna se jodta hai.',
      benefits: ['Inner peace', 'Spiritual growth', 'Protection'],
      deity: 'Shiva',
      date: DateTime.now(),
    );
  }

  DeityModel _generateFallbackDeity() {
    return DeityModel(
      id: 'fallback_deity',
      name: 'Lord Ganesha',
      nameHindi: 'Bhagwan Ganesh',
      imageUrl: '',
      description:
          'The elephant-headed god of beginnings and remover of obstacles.',
      descriptionHindi: 'Aarambh ke devta aur vighnharta.',
      significance:
          'Worship Ganesha before starting any new venture for success and wisdom.',
      mantra: 'Om Gam Ganapataye Namaha',
      date: DateTime.now(),
    );
  }

  NumerologyModel _generateNumerology(int number) {
    final predictions = {
      1: {
        'title': 'The Leader',
        'description':
            'Number 1s are natural-born leaders. They are independent, ambitious, and determined.',
        'traits': 'Independent, Creative, Ambitious',
        'luckyColor': 'Gold',
        'luckyGem': 'Ruby',
        'rulingPlanet': 'Sun',
      },
      2: {
        'title': 'The Mediator',
        'description':
            'Number 2s are peacemakers. They are sensitive, diplomatic, and cooperative.',
        'traits': 'Diplomatic, Sensitive, Cooperative',
        'luckyColor': 'White',
        'luckyGem': 'Pearl',
        'rulingPlanet': 'Moon',
      },
      3: {
        'title': 'The Communicator',
        'description':
            'Number 3s are creative and expressive. They love to communicate and are very social.',
        'traits': 'Creative, Expressive, Social',
        'luckyColor': 'Yellow',
        'luckyGem': 'Yellow Sapphire',
        'rulingPlanet': 'Jupiter',
      },
      4: {
        'title': 'The Builder',
        'description':
            'Number 4s are practical and hard-working. They value stability and order.',
        'traits': 'Practical, Hard-working, Loyal',
        'luckyColor': 'Blue',
        'luckyGem': 'Hessonite',
        'rulingPlanet': 'Rahu',
      },
      5: {
        'title': 'The Adventurer',
        'description':
            'Number 5s love freedom and adventure. They are adaptable and curious.',
        'traits': 'Adventurous, Adaptable, Curious',
        'luckyColor': 'Green',
        'luckyGem': 'Emerald',
        'rulingPlanet': 'Mercury',
      },
      6: {
        'title': 'The Nurturer',
        'description':
            'Number 6s are caring and responsible. They value family and harmony.',
        'traits': 'Caring, Responsible, Protective',
        'luckyColor': 'Pink',
        'luckyGem': 'Diamond',
        'rulingPlanet': 'Venus',
      },
      7: {
        'title': 'The Seeker',
        'description':
            'Number 7s are analytical and spiritual. They seek truth and wisdom.',
        'traits': 'Analytical, Spiritual, Introspective',
        'luckyColor': 'Grey',
        'luckyGem': 'Cat\'s Eye',
        'rulingPlanet': 'Ketu',
      },
      8: {
        'title': 'The Powerhouse',
        'description':
            'Number 8s are ambitious and goal-oriented. They are often successful in business.',
        'traits': 'Ambitious, Organized, Practical',
        'luckyColor': 'Black',
        'luckyGem': 'Blue Sapphire',
        'rulingPlanet': 'Saturn',
      },
      9: {
        'title': 'The Humanitarian',
        'description':
            'Number 9s are compassionate and generous. They want to make the world a better place.',
        'traits': 'Compassionate, Generous, Idealistic',
        'luckyColor': 'Red',
        'luckyGem': 'Red Coral',
        'rulingPlanet': 'Mars',
      },
    };

    final data = predictions[number] ?? predictions[1]!;

    return NumerologyModel(
      number: number,
      title: data['title']!,
      description: data['description']!,
      traits: data['traits']!,
      luckyColor: data['luckyColor']!,
      luckyGem: data['luckyGem']!,
      rulingPlanet: data['rulingPlanet']!,
    );
  }
}
