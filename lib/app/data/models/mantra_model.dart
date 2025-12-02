import 'package:equatable/equatable.dart';
import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
import 'core/model_extensions.dart';

class MantraModel extends Equatable {
  final String id;
  final String sanskrit;
  final String transliteration;
  final String meaning;
  final String meaningHindi;
  final List<String> benefits;
  final String? audioUrl;
  final String deity;
  final DateTime date;

  const MantraModel({
    required this.id,
    required this.sanskrit,
    required this.transliteration,
    required this.meaning,
    required this.meaningHindi,
    required this.benefits,
    this.audioUrl,
    required this.deity,
    required this.date,
  });

  factory MantraModel.fromMap(Map<String, dynamic> map) {
    return MantraModel(
      id: map.appwriteId,
      sanskrit: map.getString('sanskrit'),
      transliteration: map.getString('transliteration'),
      meaning: map.getString('meaning'),
      meaningHindi: map.getString('meaningHindi'),
      benefits: List<String>.from(map['benefits'] ?? []),
      audioUrl: map['audioUrl'] as String?,
      deity: map.getString('deity'),
      date: map.getDateTime('date') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sanskrit': sanskrit,
      'transliteration': transliteration,
      'meaning': meaning,
      'meaningHindi': meaningHindi,
      'benefits': benefits,
      'audioUrl': audioUrl,
      'deity': deity,
      'date': date.toIso8601String(),
    };
  }

  String getMeaning({bool isHindi = false}) => isHindi ? meaningHindi : meaning;

  @override
  List<Object?> get props => [
        id,
        sanskrit,
        transliteration,
        meaning,
        meaningHindi,
        benefits,
        audioUrl,
        deity,
        date,
      ];
}
