import 'package:equatable/equatable.dart';

class NumerologyModel extends Equatable {
  final int number;
  final String title;
  final String description;
  final String traits;
  final String luckyColor;
  final String luckyGem;
  final String rulingPlanet;

  const NumerologyModel({
    required this.number,
    required this.title,
    required this.description,
    required this.traits,
    required this.luckyColor,
    required this.luckyGem,
    required this.rulingPlanet,
  });

  @override
  List<Object?> get props => [
        number,
        title,
        description,
        traits,
        luckyColor,
        luckyGem,
        rulingPlanet,
      ];
}
