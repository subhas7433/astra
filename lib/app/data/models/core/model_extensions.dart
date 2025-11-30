import 'model_utils.dart';

/// Extension on Map for Appwrite document parsing.
///
/// Provides convenient getters for common Appwrite document fields
/// and safe field extraction methods.
extension AppwriteMapExtension on Map<String, dynamic> {
  /// Get Appwrite document ID ($id or id).
  String get appwriteId => ModelUtils.extractId(this);

  /// Get Appwrite created timestamp ($createdAt or createdAt).
  DateTime? get appwriteCreatedAt {
    return ModelUtils.parseDateTime(this['\$createdAt'] ?? this['createdAt']);
  }

  /// Get Appwrite updated timestamp ($updatedAt or updatedAt).
  DateTime? get appwriteUpdatedAt {
    return ModelUtils.parseDateTime(this['\$updatedAt'] ?? this['updatedAt']);
  }

  /// Get a field with automatic $-prefix fallback.
  T? getField<T>(String fieldName) {
    final value = this[fieldName] ?? this['\$$fieldName'];
    if (value == null) return null;
    if (value is T) return value;
    return null;
  }

  /// Get a string field safely.
  String getString(String fieldName, {String defaultValue = ''}) {
    final value = this[fieldName];
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  /// Get an int field safely.
  int getInt(String fieldName, {int defaultValue = 0}) {
    return ModelUtils.parseInt(this[fieldName], defaultValue: defaultValue);
  }

  /// Get a double field safely.
  double getDouble(String fieldName, {double defaultValue = 0.0}) {
    return ModelUtils.parseDouble(this[fieldName], defaultValue: defaultValue);
  }

  /// Get a bool field safely.
  bool getBool(String fieldName, {bool defaultValue = false}) {
    return ModelUtils.parseBool(this[fieldName], defaultValue: defaultValue);
  }

  /// Get a DateTime field safely.
  DateTime? getDateTime(String fieldName) {
    return ModelUtils.parseDateTime(this[fieldName]);
  }

  /// Get a list of strings safely.
  List<String> getStringList(String fieldName) {
    return ModelUtils.extractStringList(this[fieldName]);
  }

  /// Prepare this map for sending to Appwrite (removes system fields).
  Map<String, dynamic> get appwriteData =>
      ModelUtils.prepareForAppwrite(this);
}

/// Extension on DateTime for common formatting.
extension DateTimeModelExtension on DateTime {
  /// Format to ISO8601 string for Appwrite.
  String toAppwriteString() => toIso8601String();

  /// Check if this date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if this date is in the past.
  bool get isPast => isBefore(DateTime.now());

  /// Check if this date is in the future.
  bool get isFuture => isAfter(DateTime.now());
}
