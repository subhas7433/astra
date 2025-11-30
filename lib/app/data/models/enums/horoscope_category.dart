/// Categories for horoscope predictions.
enum HoroscopeCategory {
  love,
  career,
  health;

  /// Convert to string for Appwrite storage.
  String get value => name;

  /// Display name for UI.
  String get displayName {
    return switch (this) {
      HoroscopeCategory.love => 'Love & Relationships',
      HoroscopeCategory.career => 'Career & Finance',
      HoroscopeCategory.health => 'Health & Wellness',
    };
  }

  /// Hindi display name.
  String get hindiName {
    return switch (this) {
      HoroscopeCategory.love => 'Prem & Sambandh',
      HoroscopeCategory.career => 'Karya & Vitta',
      HoroscopeCategory.health => 'Swasthya',
    };
  }

  /// Icon name for this category.
  String get iconName {
    return switch (this) {
      HoroscopeCategory.love => 'heart',
      HoroscopeCategory.career => 'briefcase',
      HoroscopeCategory.health => 'person',
    };
  }

  /// Parse from Appwrite string value.
  /// Returns null if no match found.
  static HoroscopeCategory? fromString(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return HoroscopeCategory.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}
