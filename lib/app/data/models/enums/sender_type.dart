/// Type of message sender in chat.
enum SenderType {
  user,
  astrologer;

  /// Convert to string for Appwrite storage.
  String get value => name;

  /// Display name for UI.
  String get displayName {
    return switch (this) {
      SenderType.user => 'You',
      SenderType.astrologer => 'Astrologer',
    };
  }

  /// Check if this is a user message.
  bool get isUser => this == SenderType.user;

  /// Check if this is an astrologer message.
  bool get isAstrologer => this == SenderType.astrologer;

  /// Parse from Appwrite string value.
  /// Returns null if no match found.
  static SenderType? fromString(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return SenderType.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}
