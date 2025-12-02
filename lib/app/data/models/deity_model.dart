import 'package:equatable/equatable.dart';
import '../../core/result/result.dart';
import '../../core/result/app_error.dart';
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

  factory DeityModel.fromMap(Map<String, dynamic> map) {
    return DeityModel(
      id: map.appwriteId,
      name: map.getString('name'),
      nameHindi: map.getString('nameHindi'),
      imageUrl: map.getString('imageUrl'),
      description: map.getString('description'),
      descriptionHindi: map.getString('descriptionHindi'),
      significance: map.getString('significance'),
      mantra: map.getString('mantra'),
      date: map.getDateTime('date') ?? DateTime.now(),
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
