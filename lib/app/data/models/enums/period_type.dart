/// Time periods for horoscope predictions.
enum PeriodType {
  daily,
  weekly,
  monthly,
  yearly;

  /// Convert to string for Appwrite storage.
  String get value => name;

  /// Display name for UI.
  String get displayName {
    return switch (this) {
      PeriodType.daily => 'Today',
      PeriodType.weekly => 'Weekly',
      PeriodType.monthly => 'Monthly',
      PeriodType.yearly => 'Yearly',
    };
  }

  /// Hindi display name.
  String get hindiName {
    return switch (this) {
      PeriodType.daily => 'Aaj',
      PeriodType.weekly => 'Saptahik',
      PeriodType.monthly => 'Masik',
      PeriodType.yearly => 'Varshik',
    };
  }

  /// Parse from Appwrite string value.
  /// Returns null if no match found.
  static PeriodType? fromString(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return PeriodType.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}
