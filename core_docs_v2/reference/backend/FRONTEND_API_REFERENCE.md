# Frontend API Reference - Astro GPT Backend

**Version:** 1.0
**Last Updated:** December 3, 2025
**Audience:** Flutter Frontend Developers

---

## Quick Reference

### Appwrite Configuration

```dart
// lib/app/core/config/appwrite_config.dart

class AppwriteConfig {
  static const String endpoint = 'https://fra.cloud.appwrite.io/v1';
  static const String projectId = '692c18270006e1438830';
  static const String databaseId = 'astro_gpt_db';
}
```

### Function IDs

```dart
class FunctionIds {
  static const String aiChatResponse = 'ai-chat-response';
  static const String generateDailyHoroscope = 'generate-daily-horoscope';
  static const String rotateDailyContent = 'rotate-daily-content';
  static const String subscriptionWebhook = 'subscription-webhook';
}
```

### Collection IDs

```dart
class CollectionIds {
  static const String users = 'users';
  static const String astrologers = 'astrologers';
  static const String messages = 'messages';
  static const String chatSessions = 'chat_sessions';
  static const String horoscopes = 'horoscopes';
  static const String dailyContent = 'daily_content';
  static const String todayContent = 'today_content';
  static const String subscriptions = 'subscriptions';
  static const String reviews = 'reviews';
  static const String favorites = 'favorites';
  static const String faqs = 'faqs';
}
```

---

## 1. AI Chat Response API

### Endpoint
```
POST https://fra.cloud.appwrite.io/v1/functions/ai-chat-response/executions
```

### Description
Sends a user message to an AI astrologer and receives a personalized response. Includes rate limiting based on subscription tier.

### Request Headers
```
Content-Type: application/json
X-Appwrite-Project: 692c18270006e1438830
X-Appwrite-Key: <API_KEY>  // Or user session JWT
```

### Request Body (Chat Message)

```json
{
  "path": "/",
  "method": "POST",
  "body": "{\"userId\": \"user-123\", \"astrologerId\": \"astrologer-001\", \"message\": \"What does my horoscope say?\", \"sessionId\": \"session-abc\"}"
}
```

#### Body Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| userId | string | Yes | User document ID |
| astrologerId | string | Yes | Astrologer document ID |
| message | string | Yes | User's message text |
| sessionId | string | No | Chat session ID (auto-created if not provided) |

### Response (Success - 200)

```json
{
  "success": true,
  "response": "Dear [Name], as a Taurus, the cosmic energies align in your favor today...",
  "messageId": "msg-xyz-123",
  "remainingCredits": 4,
  "resetTime": "2025-12-04T00:00:00+00:00"
}
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| success | boolean | Whether the request succeeded |
| response | string | AI-generated response text |
| messageId | string | ID of the created message document |
| remainingCredits | number | Messages remaining today (free tier) |
| resetTime | string | ISO timestamp when credits reset |

### Response (Rate Limited - 429)

```json
{
  "success": false,
  "error": "Daily message limit exceeded",
  "code": "RATE_LIMIT_EXCEEDED",
  "remainingCredits": 0,
  "resetTime": "2025-12-04T00:00:00+00:00"
}
```

### Response (Error - 400/500)

```json
{
  "success": false,
  "error": "User not found",
  "code": "USER_NOT_FOUND"
}
```

### Error Codes

| Code | Description | Action |
|------|-------------|--------|
| `RATE_LIMIT_EXCEEDED` | Daily free limit reached | Show upgrade prompt |
| `USER_NOT_FOUND` | Invalid userId | Check user exists |
| `ASTROLOGER_NOT_FOUND` | Invalid astrologerId | Check astrologer exists |
| `INVALID_MESSAGE` | Empty or invalid message | Validate input |
| `OPENAI_ERROR` | AI service error | Retry or show error |

---

### Greeting Endpoint

```
POST https://fra.cloud.appwrite.io/v1/functions/ai-chat-response/executions
```

### Request Body (Get Greeting)

```json
{
  "path": "/greeting",
  "method": "POST",
  "body": "{\"userId\": \"user-123\", \"astrologerId\": \"astrologer-001\"}"
}
```

### Response (Greeting)

```json
{
  "success": true,
  "greeting": "Namaste Test User! I am Mystic Maya, your guide through the cosmic realms...",
  "astrologerName": "Mystic Maya",
  "specialization": "Vedic Astrology"
}
```

---

### Rate Limits

| Subscription Tier | Daily Messages | Reset Time |
|------------------|----------------|------------|
| Free | 5 | Midnight UTC |
| Premium | Unlimited | N/A |
| VIP | Unlimited | N/A |

---

## 2. Horoscopes Collection

### Fetch Daily Horoscopes

Use Appwrite SDK directly to query horoscopes:

```dart
// Fetch today's horoscope for a zodiac sign
Future<List<HoroscopeModel>> getTodayHoroscope(String zodiacSign) async {
  final today = DateTime.now().toIso8601String().split('T')[0];

  final response = await databases.listDocuments(
    databaseId: AppwriteConfig.databaseId,
    collectionId: CollectionIds.horoscopes,
    queries: [
      Query.equal('zodiacSign', zodiacSign),
      Query.equal('periodType', 'daily'),
      Query.equal('validDate', today),
    ],
  );

  return response.documents
      .map((doc) => HoroscopeModel.fromJson(doc.data))
      .toList();
}
```

### Horoscope Document Schema

```json
{
  "$id": "horoscope-123",
  "zodiacSign": "aries",
  "periodType": "daily",
  "category": "love",
  "contentEn": "Today, the universe ignites your passion...",
  "contentHi": "आज, ब्रह्मांड आपके जुनून को प्रज्वलित करता है...",
  "tipText": null,
  "tipTextHi": null,
  "energyLevel": 50,
  "validDate": "2025-12-03",
  "createdAt": "2025-12-03T00:00:00.000+00:00"
}
```

### Available Fields

| Field | Type | Description |
|-------|------|-------------|
| zodiacSign | string | aries, taurus, gemini, cancer, leo, virgo, libra, scorpio, sagittarius, capricorn, aquarius, pisces |
| periodType | string | daily (weekly/monthly planned) |
| category | string | love, career, health |
| contentEn | string | English horoscope text |
| contentHi | string | Hindi horoscope text |
| tipText | string? | Optional tip in English |
| tipTextHi | string? | Optional tip in Hindi |
| energyLevel | number | 0-100 energy indicator |
| validDate | string | Date horoscope is valid for (YYYY-MM-DD) |

### Zodiac Signs Enum

```dart
enum ZodiacSign {
  aries,
  taurus,
  gemini,
  cancer,
  leo,
  virgo,
  libra,
  scorpio,
  sagittarius,
  capricorn,
  aquarius,
  pisces,
}
```

### Horoscope Categories

```dart
enum HoroscopeCategory {
  love,    // Relationships, romance
  career,  // Work, finance, business
  health,  // Physical and mental wellness
}
```

---

## 3. Astrologers Collection

### Fetch Active Astrologers

```dart
Future<List<AstrologerModel>> getAstrologers() async {
  final response = await databases.listDocuments(
    databaseId: AppwriteConfig.databaseId,
    collectionId: CollectionIds.astrologers,
    queries: [
      Query.equal('isActive', true),
      Query.orderAsc('displayOrder'),
    ],
  );

  return response.documents
      .map((doc) => AstrologerModel.fromJson(doc.data))
      .toList();
}
```

### Astrologer Document Schema

```json
{
  "$id": "astrologer-001",
  "name": "Mystic Maya",
  "photoUrl": "https://example.com/maya.jpg",
  "heroImageUrl": "https://example.com/maya-hero.jpg",
  "bio": "With over 15 years of experience in Vedic Astrology...",
  "specialization": "Vedic Astrology",
  "expertiseTags": ["Love", "Career", "Kundali"],
  "languages": ["English", "Hindi"],
  "rating": 4.8,
  "reviewCount": 1250,
  "chatCount": 5000,
  "category": "vedic",
  "isActive": true,
  "aiPersonaPrompt": "You are Mystic Maya, a warm and wise Vedic astrologer...",
  "displayOrder": 1,
  "createdAt": "2025-01-01T00:00:00.000+00:00"
}
```

### Astrologer Categories

```dart
enum AstrologerCategory {
  vedic,      // Traditional Indian astrology
  western,    // Western zodiac astrology
  tarot,      // Tarot card readings
  numerology, // Number-based predictions
  palmistry,  // Palm reading
}
```

---

## 4. Users Collection

### User Document Schema

```json
{
  "$id": "user-123",
  "userId": "user-123",
  "email": "user@example.com",
  "fullName": "Test User",
  "gender": "male",
  "dateOfBirth": "1990-05-15T00:00:00.000+00:00",
  "zodiacSign": "taurus",
  "preferredLanguage": "en",
  "profilePhotoUrl": null,
  "fcmToken": null,
  "createdAt": "2025-12-01T00:00:00.000+00:00",
  "updatedAt": "2025-12-01T00:00:00.000+00:00"
}
```

### Create User Profile

```dart
Future<void> createUserProfile({
  required String userId,
  required String email,
  required String fullName,
  required String gender,
  required DateTime dateOfBirth,
}) async {
  final zodiacSign = ZodiacUtils.getZodiacSign(dateOfBirth);

  await databases.createDocument(
    databaseId: AppwriteConfig.databaseId,
    collectionId: CollectionIds.users,
    documentId: userId,
    data: {
      'userId': userId,
      'email': email,
      'fullName': fullName,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'zodiacSign': zodiacSign,
      'preferredLanguage': 'en',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
  );
}
```

---

## 5. Subscriptions Collection

### Subscription Document Schema

```json
{
  "$id": "sub-123",
  "userId": "user-123",
  "tier": "free",
  "status": "active",
  "platform": "android",
  "productId": null,
  "transactionId": null,
  "startDate": "2025-12-01T00:00:00.000+00:00",
  "endDate": null,
  "chatCredits": 5,
  "adsRemoved": false,
  "createdAt": "2025-12-01T00:00:00.000+00:00",
  "updatedAt": "2025-12-01T00:00:00.000+00:00"
}
```

### Subscription Tiers

| Tier | Daily Messages | Ads | Price |
|------|---------------|-----|-------|
| free | 5 | Yes | $0 |
| premium | Unlimited | No | $4.99/mo |
| vip | Unlimited | No | $9.99/mo |

### Check User Subscription

```dart
Future<SubscriptionModel?> getUserSubscription(String userId) async {
  try {
    final response = await databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: CollectionIds.subscriptions,
      queries: [
        Query.equal('userId', userId),
        Query.equal('status', 'active'),
      ],
    );

    if (response.documents.isEmpty) return null;
    return SubscriptionModel.fromJson(response.documents.first.data);
  } catch (e) {
    return null;
  }
}
```

---

## 6. Messages Collection

### Message Document Schema

```json
{
  "$id": "msg-123",
  "sessionId": "session-abc",
  "senderType": "user",
  "content": "What does my horoscope say for today?",
  "isRead": false,
  "createdAt": "2025-12-03T10:30:00.000+00:00"
}
```

### Sender Types

```dart
enum SenderType {
  user,       // Message from user
  astrologer, // AI response
}
```

### Fetch Chat History

```dart
Future<List<MessageModel>> getChatHistory(String sessionId) async {
  final response = await databases.listDocuments(
    databaseId: AppwriteConfig.databaseId,
    collectionId: CollectionIds.messages,
    queries: [
      Query.equal('sessionId', sessionId),
      Query.orderAsc('createdAt'),
      Query.limit(100),
    ],
  );

  return response.documents
      .map((doc) => MessageModel.fromJson(doc.data))
      .toList();
}
```

### Subscribe to New Messages (Realtime)

```dart
void subscribeToMessages(String sessionId, Function(MessageModel) onMessage) {
  final subscription = realtime.subscribe([
    'databases.${AppwriteConfig.databaseId}.collections.${CollectionIds.messages}.documents'
  ]);

  subscription.stream.listen((event) {
    if (event.payload['sessionId'] == sessionId) {
      final message = MessageModel.fromJson(event.payload);
      onMessage(message);
    }
  });
}
```

---

## 7. Chat Sessions Collection

### Chat Session Document Schema

```json
{
  "$id": "session-abc",
  "userId": "user-123",
  "astrologerId": "astrologer-001",
  "lastMessageAt": "2025-12-03T10:30:00.000+00:00",
  "messageCount": 5,
  "isActive": true,
  "createdAt": "2025-12-03T10:00:00.000+00:00",
  "updatedAt": "2025-12-03T10:30:00.000+00:00"
}
```

### Get or Create Chat Session

```dart
Future<String> getOrCreateSession(String userId, String astrologerId) async {
  // Check for existing session
  final existing = await databases.listDocuments(
    databaseId: AppwriteConfig.databaseId,
    collectionId: CollectionIds.chatSessions,
    queries: [
      Query.equal('userId', userId),
      Query.equal('astrologerId', astrologerId),
    ],
  );

  if (existing.documents.isNotEmpty) {
    return existing.documents.first.$id;
  }

  // Create new session
  final session = await databases.createDocument(
    databaseId: AppwriteConfig.databaseId,
    collectionId: CollectionIds.chatSessions,
    documentId: ID.unique(),
    data: {
      'userId': userId,
      'astrologerId': astrologerId,
      'isActive': true,
      'messageCount': 0,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
  );

  return session.$id;
}
```

---

## 8. Daily Content Collection

### Daily Content Document Schema

```json
{
  "$id": "content-123",
  "type": "mantra",
  "title": "Om Namah Shivaya",
  "titleHi": "ॐ नमः शिवाय",
  "description": "This powerful mantra invokes Lord Shiva...",
  "descriptionHi": "यह शक्तिशाली मंत्र भगवान शिव का आह्वान करता है...",
  "imageUrl": "https://example.com/shiva.jpg",
  "audioUrl": "https://example.com/mantra.mp3",
  "validDate": "2025-12-03",
  "createdAt": "2025-12-03T00:05:00.000+00:00"
}
```

### Content Types

```dart
enum ContentType {
  mantra,  // Daily mantra
  god,     // Deity of the day
}
```

### Fetch Today's Content

```dart
Future<DailyContentModel?> getTodayContent(String type) async {
  final today = DateTime.now().toIso8601String().split('T')[0];

  final response = await databases.listDocuments(
    databaseId: AppwriteConfig.databaseId,
    collectionId: CollectionIds.todayContent,
    queries: [
      Query.equal('type', type),
      Query.equal('validDate', today),
    ],
  );

  if (response.documents.isEmpty) return null;

  // Get the actual content using contentId
  final contentId = response.documents.first.data['contentId'];
  final content = await databases.getDocument(
    databaseId: AppwriteConfig.databaseId,
    collectionId: CollectionIds.dailyContent,
    documentId: contentId,
  );

  return DailyContentModel.fromJson(content.data);
}
```

---

## 9. Error Handling

### Standard Error Response

```json
{
  "success": false,
  "error": "Error message",
  "code": "ERROR_CODE"
}
```

### Error Codes Reference

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 400 | Invalid request parameters |
| `USER_NOT_FOUND` | 404 | User document not found |
| `ASTROLOGER_NOT_FOUND` | 404 | Astrologer document not found |
| `SESSION_NOT_FOUND` | 404 | Chat session not found |
| `RATE_LIMIT_EXCEEDED` | 429 | Daily message limit reached |
| `OPENAI_ERROR` | 500 | AI service unavailable |
| `INTERNAL_ERROR` | 500 | Server error |

### Error Handling Example

```dart
Future<ChatResponse> sendMessage(String userId, String astrologerId, String message) async {
  try {
    final response = await functions.createExecution(
      functionId: FunctionIds.aiChatResponse,
      body: jsonEncode({
        'path': '/',
        'method': 'POST',
        'body': jsonEncode({
          'userId': userId,
          'astrologerId': astrologerId,
          'message': message,
        }),
      }),
    );

    final data = jsonDecode(response.responseBody);

    if (!data['success']) {
      switch (data['code']) {
        case 'RATE_LIMIT_EXCEEDED':
          throw RateLimitException(
            remainingCredits: data['remainingCredits'],
            resetTime: DateTime.parse(data['resetTime']),
          );
        case 'USER_NOT_FOUND':
          throw UserNotFoundException();
        default:
          throw ApiException(data['error']);
      }
    }

    return ChatResponse.fromJson(data);
  } on AppwriteException catch (e) {
    throw ApiException(e.message ?? 'Unknown error');
  }
}
```

---

## 10. Dart Models

### ChatResponse Model

```dart
class ChatResponse {
  final bool success;
  final String response;
  final String messageId;
  final int remainingCredits;
  final DateTime resetTime;

  ChatResponse({
    required this.success,
    required this.response,
    required this.messageId,
    required this.remainingCredits,
    required this.resetTime,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      success: json['success'],
      response: json['response'],
      messageId: json['messageId'],
      remainingCredits: json['remainingCredits'],
      resetTime: DateTime.parse(json['resetTime']),
    );
  }
}
```

### HoroscopeModel

```dart
class HoroscopeModel {
  final String id;
  final String zodiacSign;
  final String periodType;
  final String category;
  final String contentEn;
  final String? contentHi;
  final String? tipText;
  final String? tipTextHi;
  final int energyLevel;
  final DateTime validDate;

  HoroscopeModel({
    required this.id,
    required this.zodiacSign,
    required this.periodType,
    required this.category,
    required this.contentEn,
    this.contentHi,
    this.tipText,
    this.tipTextHi,
    this.energyLevel = 50,
    required this.validDate,
  });

  factory HoroscopeModel.fromJson(Map<String, dynamic> json) {
    return HoroscopeModel(
      id: json['\$id'],
      zodiacSign: json['zodiacSign'],
      periodType: json['periodType'],
      category: json['category'],
      contentEn: json['contentEn'],
      contentHi: json['contentHi'],
      tipText: json['tipText'],
      tipTextHi: json['tipTextHi'],
      energyLevel: json['energyLevel'] ?? 50,
      validDate: DateTime.parse(json['validDate']),
    );
  }

  String getContent(String locale) {
    if (locale == 'hi' && contentHi != null) {
      return contentHi!;
    }
    return contentEn;
  }
}
```

### SubscriptionModel

```dart
class SubscriptionModel {
  final String id;
  final String userId;
  final String tier;
  final String status;
  final String platform;
  final DateTime startDate;
  final DateTime? endDate;
  final int chatCredits;
  final bool adsRemoved;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.tier,
    required this.status,
    required this.platform,
    required this.startDate,
    this.endDate,
    this.chatCredits = 5,
    this.adsRemoved = false,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['\$id'],
      userId: json['userId'],
      tier: json['tier'],
      status: json['status'],
      platform: json['platform'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      chatCredits: json['chatCredits'] ?? 5,
      adsRemoved: json['adsRemoved'] ?? false,
    );
  }

  bool get isPremium => tier == 'premium' || tier == 'vip';
  bool get hasUnlimitedMessages => isPremium;
}
```

---

## 11. Environment Configuration

### .env File

```env
# Appwrite Configuration
APPWRITE_ENDPOINT=https://fra.cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=692c18270006e1438830
DATABASE_ID=astro_gpt_db

# AdMob (Test IDs - replace for production)
ADMOB_ANDROID_APP_ID=ca-app-pub-3940256099942544~3347511713
ADMOB_IOS_APP_ID=ca-app-pub-3940256099942544~1458002511
ADMOB_BANNER_ID=ca-app-pub-3940256099942544/6300978111
ADMOB_INTERSTITIAL_ID=ca-app-pub-3940256099942544/1033173712
ADMOB_REWARDED_ID=ca-app-pub-3940256099942544/5224354917

# RevenueCat
REVENUECAT_ANDROID_KEY=your_android_key
REVENUECAT_IOS_KEY=your_ios_key
```

---

## 12. Testing

### Test User Credentials

```dart
// Test data available in database
const testUser = {
  'id': 'test-user-001',
  'name': 'Test User',
  'zodiacSign': 'taurus',
  'gender': 'male',
};

const testAstrologer = {
  'id': 'test-astrologer-001',
  'name': 'Mystic Maya',
  'specialization': 'Vedic Astrology',
};
```

### Test API Call

```bash
curl -X POST "https://fra.cloud.appwrite.io/v1/functions/ai-chat-response/executions" \
  -H "Content-Type: application/json" \
  -H "X-Appwrite-Project: 692c18270006e1438830" \
  -H "X-Appwrite-Key: <API_KEY>" \
  -d '{
    "path": "/",
    "method": "POST",
    "body": "{\"userId\": \"test-user-001\", \"astrologerId\": \"test-astrologer-001\", \"message\": \"Hello\"}"
  }'
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-03 | Initial release with ai-chat-response, horoscopes, daily content |

---

**Maintained By:** Astro GPT Development Team
