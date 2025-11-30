/// User gender for profile.
enum Gender {
  male,
  female,
  other;

  /// Convert to string for Appwrite storage.
  String get value => name;

  /// Display name for UI.
  String get displayName {
    return switch (this) {
      Gender.male => 'Male',
      Gender.female => 'Female',
      Gender.other => 'Other',
    };
  }

  /// Hindi display name.
  String get hindiName {
    return switch (this) {
      Gender.male => 'Purush',
      Gender.female => 'Mahila',
      Gender.other => 'Anya',
    };
  }

  /// Parse from Appwrite string value.
  /// Returns null if no match found.
  static Gender? fromString(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return Gender.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}
