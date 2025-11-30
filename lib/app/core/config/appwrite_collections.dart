/// Centralized collection ID constants for Appwrite database.
/// Single source of truth - no hardcoded collection names in code.
///
/// Usage:
/// ```dart
/// await databases.createDocument(
///   databaseId: config.databaseId,
///   collectionId: AppwriteCollections.users,
///   documentId: userId,
///   data: userData,
/// );
/// ```
abstract class AppwriteCollections {
  AppwriteCollections._();

  /// User profiles collection
  static const String users = 'users';

  /// AI astrologer personas collection
  static const String astrologers = 'astrologers';

  /// Chat session metadata collection
  static const String chatSessions = 'chat_sessions';

  /// Chat messages collection
  static const String messages = 'messages';

  /// Daily/weekly/monthly horoscopes collection
  static const String horoscopes = 'horoscopes';

  /// Daily mantras and deity content collection
  static const String dailyContent = 'daily_content';

  /// User reviews for astrologers collection
  static const String reviews = 'reviews';

  /// User favorite astrologers collection
  static const String favorites = 'favorites';

  /// Frequently asked questions collection
  static const String faqs = 'faqs';

  /// User subscriptions collection
  static const String subscriptions = 'subscriptions';
}
