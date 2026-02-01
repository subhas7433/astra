import 'package:equatable/equatable.dart';
import 'core/model_extensions.dart';

class DeityModel extends Equatable {
  final String id;
  final String name;
  final String nameHindi;
  final String imageUrl;
  final String description;
  final String descriptionHindi;
  final String significance;
  final String mantra;
  final DateTime date;

  const DeityModel({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.imageUrl,
    required this.description,
    required this.descriptionHindi,
    required this.significance,
    required this.mantra,
    required this.date,
  });

  /// Create DeityModel from FastAPI REST response (snake_case).
  /// Maps from DailyContentResponse fields to deity-specific fields.
  factory DeityModel.fromApiJson(Map<String, dynamic> json) {
    return DeityModel(
      id: json['id']?.toString() ?? '',
      name: json['title']?.toString() ?? json['name']?.toString() ?? '',
      nameHindi:
          json['title_hi']?.toString() ?? json['name_hindi']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      descriptionHindi: json['description_hi']?.toString() ?? '',
      significance: json['significance']?.toString() ?? '',
      mantra: json['mantra']?.toString() ?? '',
      date: DateTime.tryParse(json['valid_date']?.toString() ?? '') ??
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  /// Create DeityModel from Appwrite document map.
  /// Supports both Appwrite field names (title/titleHi) and model field names (name/nameHindi).
  factory DeityModel.fromMap(Map<String, dynamic> map) {
    // Handle field name mapping: Appwrite uses title/titleHi, model uses name/nameHindi
    final name = map.getField<String>('name') ??
                 map.getField<String>('title') ??
                 '';
    final nameHindi = map.getField<String>('nameHindi') ??
                      map.getField<String>('titleHi') ??
                      '';
    final descriptionHindi = map.getField<String>('descriptionHindi') ??
                             map.getField<String>('descriptionHi') ??
                             '';

    return DeityModel(
      id: map.appwriteId,
      name: name,
      nameHindi: nameHindi,
      imageUrl: map.getString('imageUrl'),
      description: map.getString('description'),
      descriptionHindi: descriptionHindi,
      significance: map.getString('significance'),
      mantra: map.getString('mantra'),
      date: map.getDateTime('date') ?? map.appwriteCreatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameHindi': nameHindi,
      'imageUrl': imageUrl,
      'description': description,
      'descriptionHindi': descriptionHindi,
      'significance': significance,
      'mantra': mantra,
      'date': date.toIso8601String(),
    };
  }
  
  String getName({bool isHindi = false}) => isHindi ? nameHindi : name;
  String getDescription({bool isHindi = false}) => isHindi ? descriptionHindi : description;

  @override
  List<Object?> get props => [
        id,
        name,
        nameHindi,
        imageUrl,
        description,
        descriptionHindi,
        significance,
        mantra,
        date,
      ];
}
