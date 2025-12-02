# Backend Integration Summary
## Astro GPT Flutter App

This document provides a consolidated view of all backend integration work distributed across Week 4-6 sessions.

---

## Appwrite Functions

| Function | Trigger | Session | Purpose |
|----------|---------|---------|---------|
| ai-chat-response | HTTP | W6-S1 | OpenAI GPT-4 chat responses |
| subscription-webhook | HTTP | W6-S6 | RevenueCat subscription sync |
| generate-daily-horoscope | CRON | Future | Auto-generate horoscopes |
| rotate-daily-content | CRON | Future | Daily deity/mantra rotation |

### ai-chat-response Function
```javascript
// Trigger: HTTP
// Runtime: Node.js 18
// Input: { userId, astrologerId, message, sessionId }

// Logic:
// 1. Fetch astrologer's aiPersonaPrompt from database
// 2. Fetch last 10 messages for context
// 3. Build GPT-4 prompt (system + history + user message)
// 4. Call OpenAI API
// 5. Save both messages to Appwrite
// 6. Return response
```

### subscription-webhook Function
```javascript
// Trigger: HTTP (RevenueCat webhook)
// Runtime: Node.js 18
// Purpose: Sync subscription status to Appwrite
// Events: INITIAL_PURCHASE, RENEWAL, CANCELLATION, EXPIRATION
```

---

## New Repositories

| Repository | Session | Purpose |
|------------|---------|---------|
| AstrologerRepository | W4-S6 | Real astrologer data from Appwrite |
| DailyContentRepository | W5-S1 | Bhagwan/Mantra content |
| FAQsRepository | W5-S1 | "Most Ask Questions" for home & profile (FR-014, FR-030) |
| ReviewsRepository | W5-S4 | Astrologer reviews (FR-031) |
| ChatRepository | W5-S5 | Message persistence |

### Repository Structures

```dart
// AstrologerRepository (W4-S6)
class AstrologerRepository {
  Future<Result<List<AstrologerModel>, AppError>> getAstrologers({
    AstrologerCategory? category,
    int limit = 20,
    int offset = 0,
  });
  Future<Result<AstrologerModel, AppError>> getAstrologerById(String id);
  Future<Result<List<AstrologerModel>, AppError>> searchAstrologers(String query);
}

// DailyContentRepository (W5-S1)
class DailyContentRepository {
  Future<Result<DeityModel, AppError>> getTodaysBhagwan();
  Future<Result<MantraModel, AppError>> getTodaysMantra();
  Future<Result<List<DeityModel>, AppError>> getAllDeities();
}

// FAQsRepository (W5-S1) - FR-014, FR-030
class FAQsRepository {
  Future<Result<List<FAQModel>, AppError>> getFAQs({String? category});
  Future<Result<List<FAQModel>, AppError>> getFAQsByAstrologer(String astrologerId);
  Future<Result<List<FAQModel>, AppError>> getMostAskedQuestions({int limit = 10});
}

// ReviewsRepository (W5-S4) - FR-031
class ReviewsRepository {
  Future<Result<List<ReviewModel>, AppError>> getReviewsByAstrologer(String astrologerId, {int limit, int offset});
  Future<Result<ReviewModel, AppError>> createReview(ReviewModel review);
  Future<Result<double, AppError>> getAverageRating(String astrologerId);
}

// ChatRepository (W5-S5)
class ChatRepository {
  Future<Result<ChatSession, AppError>> createSession(String astrologerId);
  Future<Result<void, AppError>> saveMessage(MessageModel message);
  Future<Result<List<MessageModel>, AppError>> getMessages(String sessionId);
  Future<Result<void, AppError>> syncMessages(String sessionId);
}
```

---

## AI Service Architecture

| File | Session | Purpose |
|------|---------|---------|
| `i_ai_service.dart` | W6-S1 | Interface definition |
| `appwrite_ai_service.dart` | W6-S1 | Calls Appwrite Function |
| `mock_ai_service.dart` | W6-S1 | Template-based fallback |

```dart
// IAIService Interface
abstract class IAIService {
  Future<Result<String, AppError>> generateResponse({
    required String userId,
    required String astrologerId,
    required String message,
    required String sessionId,
  });
}

// AppwriteAIService - Calls Appwrite Function
class AppwriteAIService implements IAIService {
  final Functions _functions;

  Future<Result<String, AppError>> generateResponse({...}) async {
    final execution = await _functions.createExecution(
      functionId: 'ai-chat-response',
      body: jsonEncode({
        'userId': userId,
        'astrologerId': astrologerId,
        'message': message,
        'sessionId': sessionId,
      }),
    );
    return Result.success(jsonDecode(execution.responseBody)['response']);
  }
}
```

---

## Authentication Enhancements (Gap Coverage)

| Feature | Session | FR Reference | Description |
|---------|---------|--------------|-------------|
| Google Sign-In | W6-S6 | FR-002 | OAuth integration with Appwrite |
| Guest Mode | W6-S6 | FR-004 | Limited app access without auth |
| Account Deletion | W5-S6 | FR-009 | GDPR-compliant account removal |

### Implementation Notes

```dart
// Google Sign-In (FR-002) - W6-S6
// Package: google_sign_in: ^6.2.1
// Uses Appwrite OAuth2 session with 'google' provider

// Guest Mode (FR-004) - W6-S6
// GuestService manages limited access:
// - 3 total chat messages allowed
// - No favorites or history saving
// - No purchases
// - Prompts registration after limits hit

// Account Deletion (FR-009) - W5-S6
// Full data removal from Appwrite:
// - User document from 'users' collection
// - Associated chat sessions and messages
// - Favorites
// - Appwrite account sessions
```

---

## Content Moderation (FR-116-119)

Applied in ai-chat-response Appwrite Function:

```javascript
// Added to system prompt before OpenAI API call
const contentModerationRules = `
IMPORTANT CONTENT MODERATION RULES:
- NEVER provide medical advice or diagnose health conditions (FR-116)
- NEVER provide specific financial investment advice (FR-117)
- For harmful or distressing queries, respond with empathy and redirect to professional help (FR-118)
- If user reports feeling suicidal or in crisis, provide helpline numbers
- Keep responses spiritually uplifting and positive
`;
```

---

## MockAstrologer Removal Schedule

| File | Session | Status |
|------|---------|--------|
| home_controller.dart | W4-S6 | Pending |
| astrologer_list_controller.dart | W5-S3 | Pending |
| astrologers_section.dart | W5-S3 | Pending |
| astrologer_profile_controller.dart | W5-S4 | Pending |
| chat_controller.dart | W5-S5 | Pending |
| mock_astrologer.dart (DELETE) | W5-S6 | Pending |

---

## Bug Fixes

| Bug | File | Line | Session | Description |
|-----|------|------|---------|-------------|
| AppError.unknown | horoscope_repository.dart | 47 | W4-S6 | Change to `UnknownError(message: ...)` |

---

## TODO Items Resolution

| TODO | File | Session | Resolution |
|------|------|---------|------------|
| Navigate to notifications | home_controller.dart:110 | W5-S6 | Wire navigation |
| Open location picker | home_controller.dart:115 | W5-S6 | Wire navigation |
| Navigate to settings | home_controller.dart:120 | W5-S6 | Wire navigation |
| Handle question tap | home_screen.dart:60 | W5-S6 | Wire navigation |
| Persist zodiac sign | zodiac_picker_controller.dart:18 | W5-S6 | Use SharedPreferences |
| Implement IAP | chat_controller.dart:146 | W6-S4 | Wire SubscriptionService |
| Persist like state | horoscope_detail_controller.dart:83 | W6-S5 | Use SharedPreferences |
| Implement sharing | horoscope_detail_controller.dart:89 | W6-S5 | Use share_plus |
| Configure reset URL | appwrite_auth_service.dart:232 | W6-S6 | Set reset URL |

---

## Environment Variables Required

```bash
# OpenAI (for Appwrite Function)
OPENAI_API_KEY=sk-your_openai_api_key

# Appwrite
APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your_project_id
APPWRITE_DATABASE_ID=astro_gpt_db
APPWRITE_API_KEY=your_server_api_key  # For Functions

# RevenueCat
REVENUECAT_API_KEY=your_revenuecat_key
REVENUECAT_WEBHOOK_SECRET=your_webhook_secret

# Flutter app
USE_MOCKS=false
```

---

## Files to Create (Flutter)

1. `lib/app/data/repositories/astrologer_repository.dart`
2. `lib/app/data/repositories/chat_repository.dart`
3. `lib/app/data/repositories/daily_content_repository.dart`
4. `lib/app/data/repositories/faqs_repository.dart` (NEW - FR-014, FR-030)
5. `lib/app/data/repositories/reviews_repository.dart` (NEW - FR-031)
6. `lib/app/core/services/interfaces/i_ai_service.dart`
7. `lib/app/core/services/impl/appwrite_ai_service.dart`
8. `lib/app/core/services/mock/mock_ai_service.dart`
9. `lib/app/core/services/guest_service.dart` (NEW - FR-004)

## Files to Modify (Flutter)

1. `lib/app/data/repositories/horoscope_repository.dart` - Fix AppError.unknown
2. `lib/app/modules/home/controllers/home_controller.dart` - Use AstrologerModel
3. `lib/app/modules/chat/controllers/chat_controller.dart` - Full refactor
4. `lib/app/modules/astrologer_profile/controllers/astrologer_profile_controller.dart`
5. `lib/app/modules/home/widgets/astrologers_section.dart`
6. `lib/app/modules/astrologer/controllers/astrologer_list_controller.dart`
7. `lib/app/core/services/service_locator.dart` - Add AI service + repositories + GuestService
8. `lib/app/core/services/impl/appwrite_auth_service.dart` - Fix reset URL + Google Sign-In + Account Deletion
9. `lib/app/modules/horoscope/controllers/zodiac_picker_controller.dart`
10. `lib/app/modules/horoscope/controllers/horoscope_detail_controller.dart`
11. `lib/app/modules/auth/views/login_screen.dart` - Add Google Sign-In button + Guest Mode button
12. `lib/app/modules/settings/controllers/settings_controller.dart` - Add Account Deletion

## Files to Delete

1. `lib/app/data/models/mock_astrologer.dart`

---

## Appwrite Functions Folder Structure

```
functions/
  ai-chat-response/
    src/index.js
    package.json
  generate-daily-horoscope/
    src/index.js
    package.json
  rotate-daily-content/
    src/index.js
    package.json
  subscription-webhook/
    src/index.js
    package.json
```

---

## Pre-Session: Data Seeding (2-3 hours)

**Must complete BEFORE Week 4 Session 6**

### Collections to Seed

| Collection | Records | Priority |
|------------|---------|----------|
| `astrologers` | 10-20 profiles with AI persona prompts | Critical |
| `daily_content` (deities) | 30+ with images, names (EN/HI), descriptions | High |
| `daily_content` (mantras) | 50+ with Sanskrit, transliteration, meaning | High |
| `horoscopes` | 12 signs x 4 periods (48 records) | Medium |
| `faqs` | 10-15 common questions | Low |

### Astrologer Data Format
```json
{
  "name": "Pandit Sharma",
  "photoUrl": "https://...",
  "bio": "25 years of Vedic astrology experience...",
  "specialization": ["Vedic", "Numerology"],
  "expertiseTags": ["Career", "Marriage", "Health"],
  "languages": ["Hindi", "English"],
  "rating": 4.8,
  "reviewCount": 1250,
  "isActive": true,
  "aiPersonaPrompt": "You are Pandit Sharma, a wise and compassionate Vedic astrologer with 25 years of experience. You speak warmly but with authority, often referencing planetary positions and ancient scriptures..."
}
```

---

## Execution Order

1. **Pre-Session**: Seed Appwrite collections (2-3h)
2. **Week 4 Session 6**: Bug fix + AstrologerRepository + first MockAstrologer replacement
3. **Week 5 Sessions 1-2**: DailyContentRepository + Bhagwan/Mantra screens
4. **Week 5 Sessions 3-4**: Complete MockAstrologer replacement
5. **Week 5 Sessions 5-6**: ChatRepository + TODO fixes
6. **Week 6 Session 1**: Deploy ai-chat-response Appwrite Function + AdMob
7. **Week 6 Sessions 2-3**: Ads + Chat integration with real AI
8. **Week 6 Sessions 4-5**: RevenueCat + TODOs
9. **Week 6 Session 6**: Final testing + subscription-webhook + cleanup

---

## Summary

| Category | Count |
|----------|-------|
| Flutter Files to Create | 9 |
| Flutter Files to Modify | 12 |
| Flutter Files to Delete | 1 |
| Appwrite Functions to Create | 2 (+ 2 future) |
| TODOs to Fix | 9 |
| Bug Fixes | 1 |
| New Features (Gap Coverage) | 4 (Google Sign-In, Guest Mode, Account Deletion, Content Moderation) |
| New Repositories | 5 (Astrologer, DailyContent, FAQs, Reviews, Chat) |
| Data Seeding (Pre-work) | 2-3h |
| Additional Backend Hours | ~10-12h distributed |

**Approach**: Hybrid - Backend work integrated into existing sessions rather than separate backend-only sessions. This reduces context switching and ensures features are complete end-to-end within each session.

---

## Functional Specifications Coverage

All Phase 1 functional requirements are now covered in the session plans:

| FR Reference | Feature | Session |
|--------------|---------|---------|
| FR-001 | Email Registration | W1-S2 |
| FR-002 | Google Sign-In | W6-S6 |
| FR-003 | Apple Sign-In | Phase 2 (Out of scope) |
| FR-004 | Guest Mode | W6-S6 |
| FR-009 | Account Deletion (GDPR) | W5-S6 |
| FR-014, FR-030 | Most Ask Questions | W5-S1 (FAQsRepository) |
| FR-031 | Astrologer Reviews | W5-S4 (ReviewsRepository) |
| FR-116-119 | Content Moderation | W6-S1 (AI Service) |

**Note**: Consumable Credit Packs (FR-102-104) remain Phase 2 per original "What We're NOT Building" in Week 6.
