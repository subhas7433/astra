import 'package:get/get.dart';
import '../../core/result/result.dart';
import '../../core/result/app_error.dart';

class FAQModel {
  final String id;
  final String questionHindi;
  final String questionEnglish;
  final String? category;
  final String? astrologerId;
  final int displayOrder;

  FAQModel({
    required this.id,
    required this.questionHindi,
    required this.questionEnglish,
    this.category,
    this.astrologerId,
    this.displayOrder = 0,
  });
}

class FAQsRepository {
  // final Databases _databases = Get.find<Databases>(); // Uncomment when Appwrite is fully set up

  Future<Result<List<FAQModel>, AppError>> getFAQs({String? category}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Result.success(_generateMockFAQs());
    } catch (e) {
      return Result.failure(UnknownError(message: e.toString()));
    }
  }

  Future<Result<List<FAQModel>, AppError>> getMostAskedQuestions({int limit = 10}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Result.success(_generateMockFAQs().take(limit).toList());
    } catch (e) {
      return Result.failure(UnknownError(message: e.toString()));
    }
  }

  List<FAQModel> _generateMockFAQs() {
    return [
      FAQModel(
        id: 'faq_1',
        questionEnglish: 'When will I get married?',
        questionHindi: 'मेरी शादी कब होगी?',
        category: 'Marriage',
      ),
      FAQModel(
        id: 'faq_2',
        questionEnglish: 'Will I get a government job?',
        questionHindi: 'क्या मुझे सरकारी नौकरी मिलेगी?',
        category: 'Career',
      ),
      FAQModel(
        id: 'faq_3',
        questionEnglish: 'Is my partner loyal?',
        questionHindi: 'क्या मेरा साथी वफादार है?',
        category: 'Love',
      ),
      FAQModel(
        id: 'faq_4',
        questionEnglish: 'When will I buy a house?',
        questionHindi: 'मैं घर कब खरीदूंगा?',
        category: 'Wealth',
      ),
    ];
  }
}
