/// Categories for astrologer specialization.
enum AstrologerCategory {
  all,
  career,
  life,
  love;

  /// Convert to string for Appwrite storage.
  String get value => name;

  /// Display name for UI.
  String get displayName {
    return switch (this) {
      AstrologerCategory.all => 'All',
      AstrologerCategory.career => 'Career',
      AstrologerCategory.life => 'Life',
      AstrologerCategory.love => 'Love',
    };
  }

  /// Hindi display name.
  String get hindiName {
    return switch (this) {
      AstrologerCategory.all => 'Sabhi',
      AstrologerCategory.career => 'Karya',
      AstrologerCategory.life => 'Jeevan',
      AstrologerCategory.love => 'Prem',
    };
  }

  /// Check if this is the "All" category (no filter).
  bool get isAll => this == AstrologerCategory.all;

  /// Parse from Appwrite string value.
  /// Returns null if no match found.
  static AstrologerCategory? fromString(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return AstrologerCategory.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}
