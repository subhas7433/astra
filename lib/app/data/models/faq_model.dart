import 'package:equatable/equatable.dart';
import 'core/model_extensions.dart';

class FAQModel extends Equatable {
  final String id;
  final String questionEnglish;
  final String questionHindi;
  final String? category;
  final String? astrologerId;
  final int displayOrder;
  final bool isActive;

  const FAQModel({
    required this.id,
    required this.questionEnglish,
    required this.questionHindi,
    this.category,
    this.astrologerId,
    this.displayOrder = 0,
    this.isActive = true,
  });

  /// Create FAQModel from FastAPI REST response (snake_case).
  factory FAQModel.fromApiJson(Map<String, dynamic> json) {
    return FAQModel(
      id: json['id']?.toString() ?? '',
      questionEnglish: json['question_en']?.toString() ?? '',
      questionHindi: json['question_hi']?.toString() ?? '',
      category: json['category']?.toString(),
      astrologerId: json['astrologer_id']?.toString(),
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  /// Create FAQModel from Appwrite document map.
  /// Supports both Appwrite field names (questionEn/questionHi) and model field names.
  factory FAQModel.fromMap(Map<String, dynamic> map) {
    // Handle field name mapping: Appwrite uses questionEn/questionHi
    final questionEnglish = map.getField<String>('questionEnglish') ??
                            map.getField<String>('questionEn') ??
                            '';
    final questionHindi = map.getField<String>('questionHindi') ??
                          map.getField<String>('questionHi') ??
                          '';

    return FAQModel(
      id: map.appwriteId,
      questionEnglish: questionEnglish,
      questionHindi: questionHindi,
      category: map.getField<String>('category'),
      astrologerId: map.getField<String>('astrologerId'),
      displayOrder: map.getInt('displayOrder', defaultValue: 0),
      isActive: map.getBool('isActive', defaultValue: true),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionEn': questionEnglish,
      'questionHi': questionHindi,
      'category': category,
      'astrologerId': astrologerId,
      'displayOrder': displayOrder,
      'isActive': isActive,
    };
  }

  String getQuestion({bool isHindi = false}) =>
      isHindi ? questionHindi : questionEnglish;

  @override
  List<Object?> get props => [
        id,
        questionEnglish,
        questionHindi,
        category,
        astrologerId,
        displayOrder,
        isActive,
      ];
}
