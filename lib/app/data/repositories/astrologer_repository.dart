import '../models/astrologer_model.dart';
import '../models/enums/astrologer_category.dart';
import '../../core/result/result.dart';
import '../../core/result/app_error.dart';

class AstrologerRepository {
  // final Databases _databases = Get.find<Databases>(); // Uncomment when Appwrite is fully set up

  // Collection ID (Replace with actual ID)
  static const String collectionId = 'astrologers';
  static const String databaseId = 'astra_db';

  Future<Result<List<AstrologerModel>, AppError>> getAstrologers({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Mock data for now - Uncomment Appwrite code when backend is ready
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

      final mockAstrologers = _generateMockAstrologers();
      final paginatedList = mockAstrologers.skip(offset).take(limit).toList();

      return Result.success(paginatedList);
    } catch (e, stack) {
      return Result.failure(UnknownError(
        message: 'Unexpected error: $e',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  Future<Result<AstrologerModel, AppError>> getAstrologerById(String id) async {
    try {
      // Mock data for now
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay

      final mockAstrologers = _generateMockAstrologers();
      final astrologer = mockAstrologers.firstWhere(
        (a) => a.id == id,
        orElse: () => mockAstrologers.first,
      );

      return Result.success(astrologer);
    } catch (e, stack) {
      return Result.failure(UnknownError(
        message: 'Unexpected error: $e',
        originalError: e,
        stackTrace: stack,
      ));
    }
  }

  List<AstrologerModel> _generateMockAstrologers() {
    // Using real astrologer IDs from Appwrite database
    return [
      AstrologerModel(
        id: 'test-astrologer',
        name: 'Pandit Sharma',
        photoUrl: 'https://example.com/photo.jpg',
        bio: 'Expert Vedic astrologer with 20 years of experience in horoscope reading and spiritual guidance.',
        specialization: 'Vedic Astrology',
        expertiseTags: ['Vedic', 'Career', 'Love'],
        languages: ['Hindi', 'English'],
        rating: 4.8,
        reviewCount: 150,
        chatCount: 500,
        category: AstrologerCategory.life,
        isActive: true,
        displayOrder: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      AstrologerModel(
        id: 'test-astrologer-001',
        name: 'Mystic Maya',
        photoUrl: 'https://example.com/maya.jpg',
        bio: 'A gifted astrologer with 15 years of experience in Vedic astrology. Specializes in relationship guidance and career predictions.',
        specialization: 'Vedic Astrology',
        expertiseTags: ['Relationships', 'Career', 'Guidance'],
        languages: ['Hindi', 'English'],
        rating: 4.9,
        reviewCount: 0,
        chatCount: 0,
        category: AstrologerCategory.love,
        isActive: true,
        displayOrder: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
      ),
    ];
  }
}
