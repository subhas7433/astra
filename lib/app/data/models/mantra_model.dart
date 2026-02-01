import 'package:equatable/equatable.dart';
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

  /// Create MantraModel from FastAPI REST response (snake_case).
  factory MantraModel.fromApiJson(Map<String, dynamic> json) {
    return MantraModel(
      id: json['id']?.toString() ?? '',
      sanskrit:
          json['title']?.toString() ?? json['sanskrit']?.toString() ?? '',
      transliteration: json['transliteration']?.toString() ??
          json['title_hi']?.toString() ??
          '',
      meaning: json['description']?.toString() ??
          json['meaning']?.toString() ??
          '',
      meaningHindi: json['description_hi']?.toString() ??
          json['meaning_hindi']?.toString() ??
          '',
      benefits: List<String>.from(json['benefits'] ?? []),
      audioUrl: json['audio_url']?.toString(),
      deity: json['deity']?.toString() ?? '',
      date: DateTime.tryParse(json['valid_date']?.toString() ?? '') ??
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  /// Create MantraModel from Appwrite document map.
  /// Supports both Appwrite field names (title/description) and model field names (sanskrit/meaning).
  factory MantraModel.fromMap(Map<String, dynamic> map) {
    // Handle field name mapping: Appwrite uses title/description, model uses sanskrit/meaning
    // For mantras, title contains the mantra name, description contains the full text with mantra
    final sanskrit = map.getField<String>('sanskrit') ??
                     map.getField<String>('title') ??
                     '';
    final meaning = map.getField<String>('meaning') ??
                    map.getField<String>('description') ??
                    '';
    final meaningHindi = map.getField<String>('meaningHindi') ??
                         map.getField<String>('descriptionHi') ??
                         '';

    return MantraModel(
      id: map.appwriteId,
      sanskrit: sanskrit,
      transliteration: map.getString('transliteration'),
      meaning: meaning,
      meaningHindi: meaningHindi,
      benefits: List<String>.from(map['benefits'] ?? []),
      audioUrl: map['audioUrl'] as String?,
      deity: map.getString('deity'),
      date: map.getDateTime('date') ?? map.appwriteCreatedAt ?? DateTime.now(),
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
