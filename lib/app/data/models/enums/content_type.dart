/// Type of daily spiritual content.
enum ContentType {
  mantra,
  deity;

  /// Convert to string for Appwrite storage.
  String get value => name;

  /// Display name for UI.
  String get displayName {
    return switch (this) {
      ContentType.mantra => 'Today\'s Mantra',
      ContentType.deity => 'Today\'s Bhagwan',
    };
  }

  /// Hindi display name.
  String get hindiName {
    return switch (this) {
      ContentType.mantra => 'Aaj Ka Mantra',
      ContentType.deity => 'Aaj Ke Bhagwan',
    };
  }

  /// Check if this is a mantra.
  bool get isMantra => this == ContentType.mantra;

  /// Check if this is a deity.
  bool get isDeity => this == ContentType.deity;

  /// Parse from Appwrite string value.
  /// Returns null if no match found.
  static ContentType? fromString(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return ContentType.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}
