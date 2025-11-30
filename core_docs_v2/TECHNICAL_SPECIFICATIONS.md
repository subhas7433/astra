# Technical Specifications
## Astro GPT - AI-Powered Astrology Companion

**Version:** 1.0
**Date:** November 25, 2025

---

## 1. TECHNOLOGY STACK

### 1.1 Frontend (Flutter)
- **Framework:** Flutter 3.x (Latest stable)
- **Language:** Dart 3.x
- **State Management:** GetX 4.x
- **HTTP Client:** Dio (for custom API calls)
- **Local Storage:** GetStorage / SharedPreferences
- **Image Caching:** cached_network_image
- **Animations:** flutter_animate
- **Icons:** cupertino_icons, flutter_svg
- **UI Components:** Custom widgets following Material 3

### 1.2 Backend (Appwrite Cloud)
- **Platform:** Appwrite Cloud (managed)
- **Authentication:** Appwrite Auth (Email, OAuth)
- **Database:** Appwrite Database (NoSQL documents)
- **Storage:** Appwrite Storage (images, assets)
- **Realtime:** Appwrite Realtime (chat updates)
- **Functions:** Appwrite Functions (serverless)

### 1.3 AI Chat (Phase 1 - Mock)
- **Implementation:** Local mock responses
- **Future:** Custom AI backend integration

### 1.4 Monetization
- **Ads:** Google AdMob (google_mobile_ads)
- **In-App Purchases:** RevenueCat or in_app_purchase
- **Analytics:** Firebase Analytics

### 1.5 Development Tools
- **IDE:** Android Studio / VS Code
- **Version Control:** Git + GitHub
- **CI/CD:** GitHub Actions / Codemagic
- **Code Quality:** flutter_lints, dart_code_metrics
- **Testing:** flutter_test, integration_test

---

## 2. SYSTEM ARCHITECTURE

```
+----------------------------------------------------------+
|                    ASTRO GPT MOBILE APP                   |
|                      (Flutter + GetX)                     |
+----------------------------------------------------------+
|  Presentation Layer                                       |
|  +------------------------------------------------------+ |
|  | Screens (Pages)    | Widgets      | Controllers      | |
|  | - HomeScreen       | - AstrologerCard               | |
|  | - ChatScreen       | - HoroscopeCard                | |
|  | - HoroscopeScreen  | - MessageBubble                | |
|  | - ProfileScreen    | - ZodiacGrid                   | |
|  | - SettingsScreen   | - CategoryChip                 | |
|  +------------------------------------------------------+ |
+----------------------------------------------------------+
|  Business Logic Layer (GetX Controllers)                  |
|  +------------------------------------------------------+ |
|  | AuthController     | ChatController                  | |
|  | HomeController     | HoroscopeController             | |
|  | AstrologerController | SettingsController            | |
|  +------------------------------------------------------+ |
+----------------------------------------------------------+
|  Data Layer                                               |
|  +------------------------------------------------------+ |
|  | Repositories       | Providers        | Models       | |
|  | - AuthRepository   | - AppwriteProvider             | |
|  | - ChatRepository   | - AdMobProvider                | |
|  | - HoroscopeRepo    | - StorageProvider              | |
|  +------------------------------------------------------+ |
+----------------------------------------------------------+
                            |
                            v
+----------------------------------------------------------+
|                    EXTERNAL SERVICES                      |
+----------------------------------------------------------+
|  +----------------+  +----------------+  +-------------+  |
|  | Appwrite Cloud |  | Google AdMob   |  | RevenueCat  |  |
|  |                |  |                |  |             |  |
|  | - Auth         |  | - Rewarded Ads |  | - Subs      |  |
|  | - Database     |  | - Interstitial |  | - IAP       |  |
|  | - Storage      |  | - Banner Ads   |  |             |  |
|  | - Realtime     |  +----------------+  +-------------+  |
|  | - Functions    |                                       |
|  +----------------+                                       |
+----------------------------------------------------------+
```

---

## 3. FLUTTER PROJECT STRUCTURE

```
lib/
├── main.dart                          # App entry point
├── app/
│   ├── bindings/
│   │   ├── initial_binding.dart       # Initial dependencies
│   │   ├── home_binding.dart
│   │   ├── chat_binding.dart
│   │   ├── horoscope_binding.dart
│   │   └── settings_binding.dart
│   │
│   ├── controllers/
│   │   ├── auth_controller.dart       # Authentication logic
│   │   ├── home_controller.dart       # Home screen logic
│   │   ├── chat_controller.dart       # Chat functionality
│   │   ├── astrologer_controller.dart # Astrologer data
│   │   ├── horoscope_controller.dart  # Horoscope logic
│   │   ├── daily_content_controller.dart
│   │   ├── settings_controller.dart
│   │   └── subscription_controller.dart
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── astrologer_model.dart
│   │   │   ├── chat_session_model.dart
│   │   │   ├── message_model.dart
│   │   │   ├── horoscope_model.dart
│   │   │   ├── daily_content_model.dart
│   │   │   ├── review_model.dart
│   │   │   └── subscription_model.dart
│   │   │
│   │   ├── providers/
│   │   │   ├── appwrite_provider.dart  # Appwrite SDK wrapper
│   │   │   ├── admob_provider.dart     # AdMob integration
│   │   │   ├── storage_provider.dart   # Local storage
│   │   │   └── ai_provider.dart        # AI chat (mock)
│   │   │
│   │   └── repositories/
│   │       ├── auth_repository.dart
│   │       ├── user_repository.dart
│   │       ├── astrologer_repository.dart
│   │       ├── chat_repository.dart
│   │       ├── horoscope_repository.dart
│   │       └── daily_content_repository.dart
│   │
│   ├── modules/
│   │   ├── splash/
│   │   │   ├── splash_screen.dart
│   │   │   └── splash_controller.dart
│   │   │
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   └── onboarding_screen.dart
│   │   │
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── mantra_section.dart
│   │   │       ├── faq_section.dart
│   │   │       ├── feature_icons.dart
│   │   │       └── astrologer_list.dart
│   │   │
│   │   ├── astrologer/
│   │   │   ├── astrologer_list_screen.dart
│   │   │   ├── astrologer_profile_screen.dart
│   │   │   └── widgets/
│   │   │       ├── astrologer_card.dart
│   │   │       └── review_card.dart
│   │   │
│   │   ├── chat/
│   │   │   ├── chat_screen.dart
│   │   │   └── widgets/
│   │   │       ├── message_bubble.dart
│   │   │       ├── typing_indicator.dart
│   │   │       ├── chat_input.dart
│   │   │       └── ad_dialog.dart
│   │   │
│   │   ├── horoscope/
│   │   │   ├── rashi_selection_screen.dart
│   │   │   ├── horoscope_detail_screen.dart
│   │   │   └── widgets/
│   │   │       ├── zodiac_card.dart
│   │   │       └── horoscope_category_card.dart
│   │   │
│   │   ├── daily_content/
│   │   │   ├── today_bhagwan_screen.dart
│   │   │   └── numerology_screen.dart
│   │   │
│   │   └── settings/
│   │       ├── settings_screen.dart
│   │       ├── profile_edit_screen.dart
│   │       └── language_screen.dart
│   │
│   ├── routes/
│   │   ├── app_pages.dart             # Route definitions
│   │   └── app_routes.dart            # Route names
│   │
│   ├── theme/
│   │   ├── app_theme.dart             # ThemeData
│   │   ├── app_colors.dart            # Color constants
│   │   ├── app_text_styles.dart       # Typography
│   │   └── app_decorations.dart       # BoxDecorations
│   │
│   ├── widgets/
│   │   ├── custom_app_bar.dart
│   │   ├── category_chip.dart
│   │   ├── loading_indicator.dart
│   │   ├── error_widget.dart
│   │   └── cached_image.dart
│   │
│   └── utils/
│       ├── constants.dart             # App constants
│       ├── validators.dart            # Form validators
│       ├── date_utils.dart            # Date helpers
│       ├── zodiac_utils.dart          # Zodiac calculations
│       └── extensions.dart            # Dart extensions
│
├── l10n/
│   ├── app_en.arb                     # English strings
│   └── app_hi.arb                     # Hindi strings
│
└── assets/
    ├── images/
    │   ├── logo.png
    │   ├── zodiac/
    │   │   ├── aries.svg
    │   │   ├── taurus.svg
    │   │   └── ...
    │   └── icons/
    ├── fonts/
    └── animations/
```

---

## 4. APPWRITE CONFIGURATION

### 4.1 Project Setup
```dart
// lib/app/data/providers/appwrite_provider.dart

import 'package:appwrite/appwrite.dart';

class AppwriteProvider {
  static const String endpoint = 'https://cloud.appwrite.io/v1';
  static const String projectId = 'YOUR_PROJECT_ID';

  // Database IDs
  static const String databaseId = 'astro_gpt_db';

  // Collection IDs
  static const String usersCollection = 'users';
  static const String astrologersCollection = 'astrologers';
  static const String chatSessionsCollection = 'chat_sessions';
  static const String messagesCollection = 'messages';
  static const String horoscopesCollection = 'horoscopes';
  static const String dailyContentCollection = 'daily_content';
  static const String reviewsCollection = 'reviews';
  static const String favoritesCollection = 'favorites';
  static const String faqsCollection = 'faqs';
  static const String subscriptionsCollection = 'subscriptions';

  // Storage Bucket IDs
  static const String profileImagesBucket = 'profile_images';
  static const String astrologerImagesBucket = 'astrologer_images';
  static const String deityImagesBucket = 'deity_images';

  late Client client;
  late Account account;
  late Databases databases;
  late Storage storage;
  late Realtime realtime;

  AppwriteProvider() {
    client = Client()
      ..setEndpoint(endpoint)
      ..setProject(projectId)
      ..setSelfSigned(status: true);

    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
    realtime = Realtime(client);
  }
}
```

### 4.2 Database Collections Schema

#### Users Collection
```json
{
  "collection_id": "users",
  "name": "Users",
  "attributes": [
    {"key": "userId", "type": "string", "size": 36, "required": true},
    {"key": "email", "type": "string", "size": 255, "required": true},
    {"key": "fullName", "type": "string", "size": 100, "required": true},
    {"key": "gender", "type": "string", "size": 10, "required": true},
    {"key": "dateOfBirth", "type": "datetime", "required": true},
    {"key": "zodiacSign", "type": "string", "size": 20, "required": false},
    {"key": "preferredLanguage", "type": "string", "size": 5, "required": false, "default": "en"},
    {"key": "profilePhotoUrl", "type": "string", "size": 500, "required": false},
    {"key": "fcmToken", "type": "string", "size": 500, "required": false},
    {"key": "createdAt", "type": "datetime", "required": true},
    {"key": "updatedAt", "type": "datetime", "required": true}
  ],
  "indexes": [
    {"key": "userId_idx", "type": "unique", "attributes": ["userId"]},
    {"key": "email_idx", "type": "unique", "attributes": ["email"]}
  ]
}
```

#### Astrologers Collection
```json
{
  "collection_id": "astrologers",
  "name": "Astrologers",
  "attributes": [
    {"key": "name", "type": "string", "size": 100, "required": true},
    {"key": "photoUrl", "type": "string", "size": 500, "required": true},
    {"key": "heroImageUrl", "type": "string", "size": 500, "required": false},
    {"key": "bio", "type": "string", "size": 1000, "required": true},
    {"key": "specialization", "type": "string", "size": 100, "required": true},
    {"key": "expertiseTags", "type": "string", "size": 500, "required": false, "array": true},
    {"key": "languages", "type": "string", "size": 100, "required": false, "array": true},
    {"key": "rating", "type": "double", "required": false, "default": 0},
    {"key": "reviewCount", "type": "integer", "required": false, "default": 0},
    {"key": "chatCount", "type": "integer", "required": false, "default": 0},
    {"key": "category", "type": "string", "size": 20, "required": true},
    {"key": "isActive", "type": "boolean", "required": false, "default": true},
    {"key": "aiPersonaPrompt", "type": "string", "size": 5000, "required": false},
    {"key": "displayOrder", "type": "integer", "required": false, "default": 0},
    {"key": "createdAt", "type": "datetime", "required": true}
  ],
  "indexes": [
    {"key": "category_idx", "type": "key", "attributes": ["category"]},
    {"key": "isActive_idx", "type": "key", "attributes": ["isActive"]},
    {"key": "displayOrder_idx", "type": "key", "attributes": ["displayOrder"]}
  ]
}
```

#### Chat Sessions Collection
```json
{
  "collection_id": "chat_sessions",
  "name": "Chat Sessions",
  "attributes": [
    {"key": "userId", "type": "string", "size": 36, "required": true},
    {"key": "astrologerId", "type": "string", "size": 36, "required": true},
    {"key": "lastMessageAt", "type": "datetime", "required": false},
    {"key": "messageCount", "type": "integer", "required": false, "default": 0},
    {"key": "isActive", "type": "boolean", "required": false, "default": true},
    {"key": "createdAt", "type": "datetime", "required": true},
    {"key": "updatedAt", "type": "datetime", "required": true}
  ],
  "indexes": [
    {"key": "userId_idx", "type": "key", "attributes": ["userId"]},
    {"key": "userId_astrologerId_idx", "type": "unique", "attributes": ["userId", "astrologerId"]}
  ]
}
```

#### Messages Collection
```json
{
  "collection_id": "messages",
  "name": "Messages",
  "attributes": [
    {"key": "sessionId", "type": "string", "size": 36, "required": true},
    {"key": "senderType", "type": "string", "size": 20, "required": true},
    {"key": "content", "type": "string", "size": 5000, "required": true},
    {"key": "isRead", "type": "boolean", "required": false, "default": false},
    {"key": "createdAt", "type": "datetime", "required": true}
  ],
  "indexes": [
    {"key": "sessionId_idx", "type": "key", "attributes": ["sessionId"]},
    {"key": "sessionId_createdAt_idx", "type": "key", "attributes": ["sessionId", "createdAt"]}
  ]
}
```

#### Horoscopes Collection
```json
{
  "collection_id": "horoscopes",
  "name": "Horoscopes",
  "attributes": [
    {"key": "zodiacSign", "type": "string", "size": 20, "required": true},
    {"key": "periodType", "type": "string", "size": 10, "required": true},
    {"key": "category", "type": "string", "size": 20, "required": true},
    {"key": "predictionText", "type": "string", "size": 1000, "required": true},
    {"key": "predictionTextHi", "type": "string", "size": 1000, "required": false},
    {"key": "tipText", "type": "string", "size": 200, "required": false},
    {"key": "tipTextHi", "type": "string", "size": 200, "required": false},
    {"key": "energyLevel", "type": "integer", "required": false, "default": 50},
    {"key": "validDate", "type": "datetime", "required": true},
    {"key": "createdAt", "type": "datetime", "required": true}
  ],
  "indexes": [
    {"key": "zodiac_period_date_idx", "type": "key", "attributes": ["zodiacSign", "periodType", "validDate"]},
    {"key": "validDate_idx", "type": "key", "attributes": ["validDate"]}
  ]
}
```

#### Daily Content Collection
```json
{
  "collection_id": "daily_content",
  "name": "Daily Content",
  "attributes": [
    {"key": "type", "type": "string", "size": 20, "required": true},
    {"key": "title", "type": "string", "size": 100, "required": true},
    {"key": "titleHi", "type": "string", "size": 100, "required": false},
    {"key": "description", "type": "string", "size": 2000, "required": true},
    {"key": "descriptionHi", "type": "string", "size": 2000, "required": false},
    {"key": "imageUrl", "type": "string", "size": 500, "required": false},
    {"key": "audioUrl", "type": "string", "size": 500, "required": false},
    {"key": "validDate", "type": "datetime", "required": true},
    {"key": "createdAt", "type": "datetime", "required": true}
  ],
  "indexes": [
    {"key": "type_date_idx", "type": "unique", "attributes": ["type", "validDate"]}
  ]
}
```

#### Reviews Collection
```json
{
  "collection_id": "reviews",
  "name": "Reviews",
  "attributes": [
    {"key": "astrologerId", "type": "string", "size": 36, "required": true},
    {"key": "userId", "type": "string", "size": 36, "required": true},
    {"key": "userName", "type": "string", "size": 100, "required": true},
    {"key": "rating", "type": "integer", "required": true, "min": 1, "max": 5},
    {"key": "text", "type": "string", "size": 500, "required": false},
    {"key": "createdAt", "type": "datetime", "required": true}
  ],
  "indexes": [
    {"key": "astrologerId_idx", "type": "key", "attributes": ["astrologerId"]},
    {"key": "userId_astrologerId_idx", "type": "unique", "attributes": ["userId", "astrologerId"]}
  ]
}
```

#### Favorites Collection
```json
{
  "collection_id": "favorites",
  "name": "Favorites",
  "attributes": [
    {"key": "userId", "type": "string", "size": 36, "required": true},
    {"key": "astrologerId", "type": "string", "size": 36, "required": true},
    {"key": "createdAt", "type": "datetime", "required": true}
  ],
  "indexes": [
    {"key": "userId_idx", "type": "key", "attributes": ["userId"]},
    {"key": "userId_astrologerId_idx", "type": "unique", "attributes": ["userId", "astrologerId"]}
  ]
}
```

#### FAQs Collection
```json
{
  "collection_id": "faqs",
  "name": "FAQs",
  "attributes": [
    {"key": "questionEn", "type": "string", "size": 500, "required": true},
    {"key": "questionHi", "type": "string", "size": 500, "required": true},
    {"key": "category", "type": "string", "size": 20, "required": true},
    {"key": "astrologerId", "type": "string", "size": 36, "required": false},
    {"key": "displayOrder", "type": "integer", "required": false, "default": 0},
    {"key": "isActive", "type": "boolean", "required": false, "default": true}
  ],
  "indexes": [
    {"key": "category_idx", "type": "key", "attributes": ["category"]},
    {"key": "astrologerId_idx", "type": "key", "attributes": ["astrologerId"]}
  ]
}
```

#### Subscriptions Collection
```json
{
  "collection_id": "subscriptions",
  "name": "Subscriptions",
  "attributes": [
    {"key": "userId", "type": "string", "size": 36, "required": true},
    {"key": "tier", "type": "string", "size": 20, "required": true},
    {"key": "status", "type": "string", "size": 20, "required": true},
    {"key": "platform", "type": "string", "size": 10, "required": true},
    {"key": "transactionId", "type": "string", "size": 100, "required": false},
    {"key": "startDate", "type": "datetime", "required": true},
    {"key": "endDate", "type": "datetime", "required": false},
    {"key": "chatCredits", "type": "integer", "required": false, "default": 0},
    {"key": "adsRemoved", "type": "boolean", "required": false, "default": false},
    {"key": "createdAt", "type": "datetime", "required": true},
    {"key": "updatedAt", "type": "datetime", "required": true}
  ],
  "indexes": [
    {"key": "userId_idx", "type": "unique", "attributes": ["userId"]}
  ]
}
```

---

## 5. DATA MODELS (Dart)

### 5.1 User Model
```dart
// lib/app/data/models/user_model.dart

class UserModel {
  final String id;
  final String? odiacSign;
  final String email;
  final String fullName;
  final String gender;
  final DateTime dateOfBirth;
  final String? z
  final String preferredLanguage;
  final String? profilePhotoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    this.zodiacSign,
    this.preferredLanguage = 'en',
    this.profilePhotoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['\$id'] ?? json['userId'],
      email: json['email'],
      fullName: json['fullName'],
      gender: json['gender'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      zodiacSign: json['zodiacSign'],
      preferredLanguage: json['preferredLanguage'] ?? 'en',
      profilePhotoUrl: json['profilePhotoUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'email': email,
      'fullName': fullName,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'zodiacSign': zodiacSign,
      'preferredLanguage': preferredLanguage,
      'profilePhotoUrl': profilePhotoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
```

### 5.2 Astrologer Model
```dart
// lib/app/data/models/astrologer_model.dart

class AstrologerModel {
  final String id;
  final String name;
  final String photoUrl;
  final String? heroImageUrl;
  final String bio;
  final String specialization;
  final List<String> expertiseTags;
  final List<String> languages;
  final double rating;
  final int reviewCount;
  final int chatCount;
  final String category;
  final bool isActive;
  final String? aiPersonaPrompt;
  final int displayOrder;
  final DateTime createdAt;

  AstrologerModel({
    required this.id,
    required this.name,
    required this.photoUrl,
    this.heroImageUrl,
    required this.bio,
    required this.specialization,
    this.expertiseTags = const [],
    this.languages = const [],
    this.rating = 0,
    this.reviewCount = 0,
    this.chatCount = 0,
    required this.category,
    this.isActive = true,
    this.aiPersonaPrompt,
    this.displayOrder = 0,
    required this.createdAt,
  });

  factory AstrologerModel.fromJson(Map<String, dynamic> json) {
    return AstrologerModel(
      id: json['\$id'],
      name: json['name'],
      photoUrl: json['photoUrl'],
      heroImageUrl: json['heroImageUrl'],
      bio: json['bio'],
      specialization: json['specialization'],
      expertiseTags: List<String>.from(json['expertiseTags'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      chatCount: json['chatCount'] ?? 0,
      category: json['category'],
      isActive: json['isActive'] ?? true,
      aiPersonaPrompt: json['aiPersonaPrompt'],
      displayOrder: json['displayOrder'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  String get formattedReviewCount {
    if (reviewCount >= 1000) {
      return '${(reviewCount / 1000).toStringAsFixed(1)}K+ reviews';
    }
    return '$reviewCount+ reviews';
  }

  String get formattedChatCount {
    if (chatCount >= 1000) {
      return '${(chatCount / 1000).toStringAsFixed(1)}K Chats';
    }
    return '$chatCount Chats';
  }
}
```

### 5.3 Message Model
```dart
// lib/app/data/models/message_model.dart

enum SenderType { user, astrologer }

class MessageModel {
  final String id;
  final String sessionId;
  final SenderType senderType;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.sessionId,
    required this.senderType,
    required this.content,
    this.isRead = false,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['\$id'],
      sessionId: json['sessionId'],
      senderType: json['senderType'] == 'user'
          ? SenderType.user
          : SenderType.astrologer,
      content: json['content'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'senderType': senderType == SenderType.user ? 'user' : 'astrologer',
      'content': content,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isFromUser => senderType == SenderType.user;
  bool get isFromAstrologer => senderType == SenderType.astrologer;
}
```

### 5.4 Horoscope Model
```dart
// lib/app/data/models/horoscope_model.dart

enum ZodiacSign {
  aries, taurus, gemini, cancer, leo, virgo,
  libra, scorpio, sagittarius, capricorn, aquarius, pisces
}

enum PeriodType { daily, weekly, monthly, yearly }
enum HoroscopeCategory { love, career, health }

class HoroscopeModel {
  final String id;
  final ZodiacSign zodiacSign;
  final PeriodType periodType;
  final HoroscopeCategory category;
  final String predictionText;
  final String? predictionTextHi;
  final String? tipText;
  final String? tipTextHi;
  final int energyLevel;
  final DateTime validDate;
  final DateTime createdAt;

  HoroscopeModel({
    required this.id,
    required this.zodiacSign,
    required this.periodType,
    required this.category,
    required this.predictionText,
    this.predictionTextHi,
    this.tipText,
    this.tipTextHi,
    this.energyLevel = 50,
    required this.validDate,
    required this.createdAt,
  });

  factory HoroscopeModel.fromJson(Map<String, dynamic> json) {
    return HoroscopeModel(
      id: json['\$id'],
      zodiacSign: ZodiacSign.values.firstWhere(
        (e) => e.name == json['zodiacSign'],
      ),
      periodType: PeriodType.values.firstWhere(
        (e) => e.name == json['periodType'],
      ),
      category: HoroscopeCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      predictionText: json['predictionText'],
      predictionTextHi: json['predictionTextHi'],
      tipText: json['tipText'],
      tipTextHi: json['tipTextHi'],
      energyLevel: json['energyLevel'] ?? 50,
      validDate: DateTime.parse(json['validDate']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  String getPrediction(String locale) {
    if (locale == 'hi' && predictionTextHi != null) {
      return predictionTextHi!;
    }
    return predictionText;
  }

  String? getTip(String locale) {
    if (locale == 'hi' && tipTextHi != null) {
      return tipTextHi;
    }
    return tipText;
  }
}
```

---

## 6. GETX CONTROLLERS

### 6.1 Auth Controller
```dart
// lib/app/controllers/auth_controller.dart

import 'package:get/get.dart';
import 'package:appwrite/appwrite.dart';

class AuthController extends GetxController {
  final AppwriteProvider _appwrite = Get.find<AppwriteProvider>();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final session = await _appwrite.account.get();
      if (session != null) {
        await loadUserProfile(session.$id);
        isLoggedIn.value = true;
      }
    } catch (e) {
      isLoggedIn.value = false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _appwrite.account.createEmailSession(
        email: email,
        password: password,
      );
      final user = await _appwrite.account.get();
      await loadUserProfile(user.$id);
      isLoggedIn.value = true;
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String gender,
    required DateTime dateOfBirth,
  }) async {
    try {
      isLoading.value = true;

      // Create account
      final account = await _appwrite.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: fullName,
      );

      // Login
      await _appwrite.account.createEmailSession(
        email: email,
        password: password,
      );

      // Create user profile
      final userModel = UserModel(
        id: account.$id,
        email: email,
        fullName: fullName,
        gender: gender,
        dateOfBirth: dateOfBirth,
        zodiacSign: ZodiacUtils.getZodiacSign(dateOfBirth),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _appwrite.databases.createDocument(
        databaseId: AppwriteProvider.databaseId,
        collectionId: AppwriteProvider.usersCollection,
        documentId: account.$id,
        data: userModel.toJson(),
      );

      currentUser.value = userModel;
      isLoggedIn.value = true;
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _appwrite.account.deleteSession(sessionId: 'current');
      currentUser.value = null;
      isLoggedIn.value = false;
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> loadUserProfile(String userId) async {
    try {
      final doc = await _appwrite.databases.getDocument(
        databaseId: AppwriteProvider.databaseId,
        collectionId: AppwriteProvider.usersCollection,
        documentId: userId,
      );
      currentUser.value = UserModel.fromJson(doc.data);
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }
}
```

### 6.2 Chat Controller
```dart
// lib/app/controllers/chat_controller.dart

import 'package:get/get.dart';

class ChatController extends GetxController {
  final AppwriteProvider _appwrite = Get.find<AppwriteProvider>();
  final AIProvider _aiProvider = Get.find<AIProvider>();

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isTyping = false.obs;
  final RxString currentSessionId = ''.obs;

  late AstrologerModel currentAstrologer;
  late UserModel currentUser;

  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  Future<void> initChat(AstrologerModel astrologer) async {
    currentAstrologer = astrologer;
    currentUser = Get.find<AuthController>().currentUser.value!;

    // Get or create session
    await getOrCreateSession();

    // Load existing messages
    await loadMessages();

    // Subscribe to realtime updates
    subscribeToMessages();

    // Send welcome message if first time
    if (messages.isEmpty) {
      await sendWelcomeMessage();
    }
  }

  Future<void> getOrCreateSession() async {
    try {
      final sessions = await _appwrite.databases.listDocuments(
        databaseId: AppwriteProvider.databaseId,
        collectionId: AppwriteProvider.chatSessionsCollection,
        queries: [
          Query.equal('userId', currentUser.id),
          Query.equal('astrologerId', currentAstrologer.id),
        ],
      );

      if (sessions.documents.isNotEmpty) {
        currentSessionId.value = sessions.documents.first.$id;
      } else {
        final newSession = await _appwrite.databases.createDocument(
          databaseId: AppwriteProvider.databaseId,
          collectionId: AppwriteProvider.chatSessionsCollection,
          documentId: ID.unique(),
          data: {
            'userId': currentUser.id,
            'astrologerId': currentAstrologer.id,
            'isActive': true,
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          },
        );
        currentSessionId.value = newSession.$id;
      }
    } catch (e) {
      print('Error getting/creating session: $e');
    }
  }

  Future<void> loadMessages() async {
    try {
      isLoading.value = true;
      final docs = await _appwrite.databases.listDocuments(
        databaseId: AppwriteProvider.databaseId,
        collectionId: AppwriteProvider.messagesCollection,
        queries: [
          Query.equal('sessionId', currentSessionId.value),
          Query.orderAsc('createdAt'),
          Query.limit(100),
        ],
      );

      messages.value = docs.documents
          .map((doc) => MessageModel.fromJson(doc.data))
          .toList();

      scrollToBottom();
    } catch (e) {
      print('Error loading messages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    inputController.clear();

    // Add user message
    final userMessage = MessageModel(
      id: ID.unique(),
      sessionId: currentSessionId.value,
      senderType: SenderType.user,
      content: content,
      createdAt: DateTime.now(),
    );

    messages.add(userMessage);
    scrollToBottom();

    // Save to database
    await _appwrite.databases.createDocument(
      databaseId: AppwriteProvider.databaseId,
      collectionId: AppwriteProvider.messagesCollection,
      documentId: userMessage.id,
      data: userMessage.toJson(),
    );

    // Generate AI response
    await generateAIResponse(content);
  }

  Future<void> generateAIResponse(String userMessage) async {
    isTyping.value = true;

    try {
      // Mock delay for typing effect
      await Future.delayed(const Duration(seconds: 2));

      // Generate response (mock for now)
      final response = await _aiProvider.generateResponse(
        astrologer: currentAstrologer,
        user: currentUser,
        userMessage: userMessage,
        conversationHistory: messages.map((m) => m.content).toList(),
      );

      // Add astrologer message
      final astrologerMessage = MessageModel(
        id: ID.unique(),
        sessionId: currentSessionId.value,
        senderType: SenderType.astrologer,
        content: response,
        createdAt: DateTime.now(),
      );

      messages.add(astrologerMessage);

      // Save to database
      await _appwrite.databases.createDocument(
        databaseId: AppwriteProvider.databaseId,
        collectionId: AppwriteProvider.messagesCollection,
        documentId: astrologerMessage.id,
        data: astrologerMessage.toJson(),
      );

      scrollToBottom();
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate response');
    } finally {
      isTyping.value = false;
    }
  }

  Future<void> sendWelcomeMessage() async {
    final greeting = _aiProvider.generateGreeting(
      astrologer: currentAstrologer,
      user: currentUser,
    );

    final welcomeMessage = MessageModel(
      id: ID.unique(),
      sessionId: currentSessionId.value,
      senderType: SenderType.astrologer,
      content: greeting,
      createdAt: DateTime.now(),
    );

    messages.add(welcomeMessage);

    await _appwrite.databases.createDocument(
      databaseId: AppwriteProvider.databaseId,
      collectionId: AppwriteProvider.messagesCollection,
      documentId: welcomeMessage.id,
      data: welcomeMessage.toJson(),
    );
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void subscribeToMessages() {
    _appwrite.realtime.subscribe([
      'databases.${AppwriteProvider.databaseId}.collections.${AppwriteProvider.messagesCollection}.documents'
    ]).stream.listen((event) {
      if (event.payload['sessionId'] == currentSessionId.value) {
        final message = MessageModel.fromJson(event.payload);
        if (!messages.any((m) => m.id == message.id)) {
          messages.add(message);
          scrollToBottom();
        }
      }
    });
  }

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
```

---

## 7. AI PROVIDER (Mock Implementation)

```dart
// lib/app/data/providers/ai_provider.dart

class AIProvider {
  // Mock responses for different categories
  static const Map<String, List<String>> mockResponses = {
    'career': [
      'Based on your planetary positions, I see significant career growth opportunities in the coming months. Focus on networking and skill development.',
      'Your career path shows promising signs. The alignment of Jupiter suggests new opportunities are on the horizon. Stay patient and prepared.',
      'I sense that you are at a crossroads in your career. Trust your instincts and take calculated risks.',
    ],
    'love': [
      'Venus is favorably positioned for you. This is a good time for expressing your feelings to your loved ones.',
      'Your romantic life is about to experience positive changes. Keep your heart open to new connections.',
      'The stars indicate that communication is key in your relationships right now. Be honest and vulnerable.',
    ],
    'life': [
      'Your life path number suggests you are destined for great things. Trust the journey.',
      'The cosmic energy is aligning in your favor. This is a time for personal growth and self-discovery.',
      'Balance is essential right now. Focus on harmonizing different aspects of your life.',
    ],
    'general': [
      'I sense positive energy surrounding you. The universe is working in your favor.',
      'Your aura shows resilience and determination. Keep moving forward with confidence.',
      'The stars reveal that patience will be your greatest ally in the coming days.',
    ],
  };

  String generateGreeting({
    required AstrologerModel astrologer,
    required UserModel user,
  }) {
    return 'Namaste ${user.fullName}! This is ${astrologer.name}. What brings you here, brave warrior from the future?';
  }

  Future<String> generateResponse({
    required AstrologerModel astrologer,
    required UserModel user,
    required String userMessage,
    required List<String> conversationHistory,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Determine category from message
    final category = _detectCategory(userMessage);

    // Get random response from category
    final responses = mockResponses[category] ?? mockResponses['general']!;
    final randomIndex = DateTime.now().millisecond % responses.length;

    // Personalize response
    String response = responses[randomIndex];
    response = _personalizeResponse(response, user, astrologer);

    return response;
  }

  String _detectCategory(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('career') ||
        lowerMessage.contains('job') ||
        lowerMessage.contains('work') ||
        lowerMessage.contains('business')) {
      return 'career';
    }

    if (lowerMessage.contains('love') ||
        lowerMessage.contains('relationship') ||
        lowerMessage.contains('marriage') ||
        lowerMessage.contains('partner')) {
      return 'love';
    }

    if (lowerMessage.contains('life') ||
        lowerMessage.contains('future') ||
        lowerMessage.contains('destiny')) {
      return 'life';
    }

    return 'general';
  }

  String _personalizeResponse(
    String response,
    UserModel user,
    AstrologerModel astrologer,
  ) {
    // Add zodiac-specific context
    if (user.zodiacSign != null) {
      response = 'As a ${user.zodiacSign}, $response';
    }

    return response;
  }
}
```

---

## 8. ROUTING (GetX)

```dart
// lib/app/routes/app_routes.dart

abstract class AppRoutes {
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const ONBOARDING = '/onboarding';
  static const HOME = '/home';
  static const ASTROLOGER_PROFILE = '/astrologer/:id';
  static const CHAT = '/chat/:astrologerId';
  static const HOROSCOPE_SELECTION = '/horoscope';
  static const HOROSCOPE_DETAIL = '/horoscope/:sign';
  static const TODAY_BHAGWAN = '/today-bhagwan';
  static const NUMEROLOGY = '/numerology';
  static const SETTINGS = '/settings';
  static const PROFILE_EDIT = '/profile-edit';
}

// lib/app/routes/app_pages.dart

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.ASTROLOGER_PROFILE,
      page: () => const AstrologerProfileScreen(),
      binding: AstrologerBinding(),
    ),
    GetPage(
      name: AppRoutes.CHAT,
      page: () => const ChatScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.HOROSCOPE_SELECTION,
      page: () => const RashiSelectionScreen(),
      binding: HoroscopeBinding(),
    ),
    GetPage(
      name: AppRoutes.HOROSCOPE_DETAIL,
      page: () => const HoroscopeDetailScreen(),
      binding: HoroscopeBinding(),
    ),
    GetPage(
      name: AppRoutes.TODAY_BHAGWAN,
      page: () => const TodayBhagwanScreen(),
      binding: DailyContentBinding(),
    ),
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
  ];
}
```

---

## 9. THEME & STYLING

```dart
// lib/app/theme/app_colors.dart

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFF26B4E);
  static const Color primaryLight = Color(0xFFFF8A70);
  static const Color primaryDark = Color(0xFFD84A30);

  // Background Colors
  static const Color background = Color(0xFFFFF5F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFAE5DC);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Accent Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);

  // Zodiac Icon Colors
  static const Color ariesColor = Color(0xFFE91E63);
  static const Color taurusColor = Color(0xFFFFF8E1);
  static const Color geminiColor = Color(0xFFFFD700);
  static const Color cancerColor = Color(0xFFFFEB3B);
  static const Color leoColor = Color(0xFFFFC107);
  static const Color virgoColor = Color(0xFF4CAF50);
  static const Color libraColor = Color(0xFF8BC34A);
  static const Color scorpioColor = Color(0xFF009688);
  static const Color sagittariusColor = Color(0xFF2196F3);
  static const Color capricornColor = Color(0xFF9C27B0);
  static const Color aquariusColor = Color(0xFF673AB7);
  static const Color piscesColor = Color(0xFFE91E63);
}

// lib/app/theme/app_theme.dart

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
        background: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
```

---

## 10. ADMOB INTEGRATION

```dart
// lib/app/data/providers/admob_provider.dart

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobProvider {
  // Test Ad Unit IDs (Replace with real IDs in production)
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await loadRewardedAd();
    await loadInterstitialAd();
  }

  Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  Future<bool> showRewardedAd({
    required Function onRewardEarned,
  }) async {
    if (_rewardedAd == null) {
      await loadRewardedAd();
      return false;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewardedAd();
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onRewardEarned();
      },
    );

    return true;
  }

  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    if (_interstitialAd == null) return;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitialAd();
      },
    );

    await _interstitialAd!.show();
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
  }
}
```

---

## 11. ZODIAC UTILITIES

```dart
// lib/app/utils/zodiac_utils.dart

class ZodiacUtils {
  static const Map<ZodiacSign, Map<String, dynamic>> zodiacData = {
    ZodiacSign.aries: {
      'name': 'Aries',
      'nameHi': 'Mesh',
      'symbol': 'Ram',
      'element': 'Fire',
      'startMonth': 3, 'startDay': 21,
      'endMonth': 4, 'endDay': 19,
      'color': AppColors.ariesColor,
    },
    ZodiacSign.taurus: {
      'name': 'Taurus',
      'nameHi': 'Vrishabh',
      'symbol': 'Bull',
      'element': 'Earth',
      'startMonth': 4, 'startDay': 20,
      'endMonth': 5, 'endDay': 20,
      'color': AppColors.taurusColor,
    },
    // ... (remaining zodiac signs)
  };

  static ZodiacSign? getZodiacSignFromDate(DateTime date) {
    final month = date.month;
    final day = date.day;

    for (final entry in zodiacData.entries) {
      final data = entry.value;
      final startMonth = data['startMonth'] as int;
      final startDay = data['startDay'] as int;
      final endMonth = data['endMonth'] as int;
      final endDay = data['endDay'] as int;

      if ((month == startMonth && day >= startDay) ||
          (month == endMonth && day <= endDay)) {
        return entry.key;
      }
    }

    return null;
  }

  static String getZodiacSign(DateTime dateOfBirth) {
    final sign = getZodiacSignFromDate(dateOfBirth);
    return sign?.name ?? 'unknown';
  }

  static Color getZodiacColor(ZodiacSign sign) {
    return zodiacData[sign]?['color'] ?? AppColors.primary;
  }

  static String getZodiacEmoji(ZodiacSign sign) {
    const emojis = {
      ZodiacSign.aries: 'ram',
      ZodiacSign.taurus: 'ox',
      ZodiacSign.gemini: 'gemini',
      ZodiacSign.cancer: 'crab',
      ZodiacSign.leo: 'lion',
      ZodiacSign.virgo: 'woman',
      ZodiacSign.libra: 'balance_scale',
      ZodiacSign.scorpio: 'scorpion',
      ZodiacSign.sagittarius: 'bow_and_arrow',
      ZodiacSign.capricorn: 'goat',
      ZodiacSign.aquarius: 'aquarius',
      ZodiacSign.pisces: 'pisces',
    };
    return emojis[sign] ?? '';
  }
}
```

---

## 12. PERFORMANCE REQUIREMENTS

| Metric | Target | Measurement |
|--------|--------|-------------|
| App Launch (Cold) | < 3 seconds | Time to first frame |
| App Launch (Warm) | < 1 second | Time to interactive |
| Screen Transition | < 300ms | Animation complete |
| List Scroll | 60 FPS | Jank-free scrolling |
| Image Load | < 1 second | Placeholder to image |
| Chat Response | < 3 seconds | User message to AI response |
| API Response | < 500ms | Appwrite query time |
| Memory Usage | < 150MB | Peak usage |
| APK Size | < 30MB | Release build |

---

## 13. SECURITY REQUIREMENTS

### 13.1 Authentication
- Passwords hashed using bcrypt (Appwrite default)
- JWT tokens for session management
- Session expiry: 30 days
- Force logout on security breach

### 13.2 Data Protection
- All API calls over HTTPS
- Sensitive data encrypted at rest (Appwrite)
- No PII in logs
- Secure local storage for tokens

### 13.3 Input Validation
- Server-side validation for all inputs
- SQL injection prevention (Appwrite ORM)
- XSS prevention in chat messages
- Rate limiting on API endpoints

### 13.4 Privacy
- GDPR-compliant data handling
- User data deletion on request
- Privacy policy in settings
- Consent for data collection

---

## 14. TESTING STRATEGY

### 14.1 Unit Tests
- All utility functions
- Data models (fromJson, toJson)
- Business logic in controllers
- Zodiac calculations

### 14.2 Widget Tests
- Custom widgets
- Screen layouts
- Navigation flows
- Form validation

### 14.3 Integration Tests
- Authentication flow
- Chat flow
- Purchase flow
- End-to-end user journey

### 14.4 Manual Testing
- UI/UX review
- Accessibility
- Performance profiling
- Device compatibility

---

## 15. DEPLOYMENT

### 15.1 Android
- Target SDK: 34
- Min SDK: 21
- Signing: Release keystore
- ProGuard: Enabled
- Distribution: Google Play Store

### 15.2 iOS
- Min iOS: 13.0
- Signing: App Store Distribution
- Bitcode: Disabled
- Distribution: Apple App Store

### 15.3 CI/CD Pipeline
```yaml
# .github/workflows/flutter.yml
name: Flutter CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --release
```

---

## 16. DEPENDENCIES (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  get: ^4.6.6
  get_storage: ^2.1.1

  # Appwrite
  appwrite: ^11.0.0

  # UI
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  flutter_animate: ^4.3.0
  shimmer: ^3.0.0

  # Ads & Monetization
  google_mobile_ads: ^4.0.0
  in_app_purchase: ^3.1.13

  # Firebase (Analytics only)
  firebase_core: ^2.24.2
  firebase_analytics: ^10.8.0

  # Utilities
  intl: ^0.18.1
  share_plus: ^7.2.1
  url_launcher: ^6.2.2
  package_info_plus: ^5.0.1

  # Localization
  flutter_localizations:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  integration_test:
    sdk: flutter
```

---

**END OF TECHNICAL SPECIFICATIONS**
