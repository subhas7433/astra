import 'package:equatable/equatable.dart';

/// Palm reading eligibility status model.
class PalmStatusModel extends Equatable {
  final bool hasFreeReadingAvailable;
  final int totalReadings;

  const PalmStatusModel({
    required this.hasFreeReadingAvailable,
    this.totalReadings = 0,
  });

  /// Create PalmStatusModel from FastAPI REST response (snake_case).
  factory PalmStatusModel.fromApiJson(Map<String, dynamic> json) {
    return PalmStatusModel(
      hasFreeReadingAvailable:
          json['has_free_reading_available'] as bool? ?? false,
      totalReadings: (json['total_readings'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        hasFreeReadingAvailable,
        totalReadings,
      ];

  @override
  String toString() =>
      'PalmStatusModel(free: $hasFreeReadingAvailable, total: $totalReadings)';
}
