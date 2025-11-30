/// Utility functions for model serialization and data conversion.
///
/// Provides common helpers for:
/// - Extracting Appwrite document IDs
/// - Parsing DateTime values safely
/// - Converting between enums and strings
/// - Safe list extraction
abstract class ModelUtils {
  // Private constructor to prevent instantiation
  ModelUtils._();

  /// Extract Appwrite document ID from JSON.
  /// Handles both '$id' (Appwrite response) and 'id' (custom format).
  static String extractId(Map<String, dynamic> json) {
    return (json['\$id'] ?? json['id'] ?? '') as String;
  }

  /// Parse DateTime safely from various formats.
  /// Returns null if parsing fails.
  static DateTime? parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Format DateTime to ISO8601 string (Appwrite standard).
  /// Returns null if date is null.
  static String? formatDateTime(DateTime? date) {
    return date?.toIso8601String();
  }

  /// Safely extract a list of strings from JSON.
  /// Returns empty list if value is null or not a list.
  static List<String> extractStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return List<String>.from(value.whereType<String>());
    }
    return [];
  }

  /// Safely parse an integer from JSON.
  /// Returns defaultValue if parsing fails.
  static int parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  /// Safely parse a double from JSON.
  /// Returns defaultValue if parsing fails.
  static double parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  /// Safely parse a boolean from JSON.
  /// Returns defaultValue if parsing fails.
  static bool parseBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    if (value is int) return value != 0;
    return defaultValue;
  }

  /// Convert enum to string value (name only).
  static String enumToString(Enum? enumValue) {
    if (enumValue == null) return '';
    return enumValue.name;
  }

  /// Parse enum from string value.
  /// Returns null if no match found.
  static T? stringToEnum<T extends Enum>(String? value, List<T> values) {
    if (value == null || value.isEmpty) return null;
    try {
      return values.firstWhere(
        (e) => e.name == value,
      );
    } catch (_) {
      return null;
    }
  }

  /// Prepare data for Appwrite: removes $-prefixed system fields.
  /// Use this before sending data to Appwrite.
  static Map<String, dynamic> prepareForAppwrite(Map<String, dynamic> data) {
    return Map.fromEntries(
      data.entries.where((entry) => !entry.key.startsWith('\$')),
    );
  }
}
