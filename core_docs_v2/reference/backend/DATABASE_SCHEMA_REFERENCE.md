# Database Schema Reference - Astro GPT

**Version:** 1.0
**Last Updated:** December 3, 2025
**Database:** Appwrite Cloud (Frankfurt)

---

## Quick Reference

```
Project ID: 692c18270006e1438830
Database ID: astro_gpt_db
Region: Frankfurt (fra.cloud.appwrite.io)
```

---

## Collections Overview

| Collection | Description | Records |
|------------|-------------|---------|
| users | User profiles | Dynamic |
| astrologers | AI astrologer personas | ~10 |
| messages | Chat messages | Dynamic |
| chat_sessions | Chat session metadata | Dynamic |
| horoscopes | Daily horoscope content | 36/day |
| daily_content | Mantra/God content pool | ~100+ |
| today_content | Today's selected content | 2/day |
| subscriptions | User subscription status | 1/user |
| reviews | Astrologer reviews | Dynamic |
| favorites | User favorites | Dynamic |
| faqs | Quick questions | ~50 |

---

## 1. Users Collection

**Collection ID:** `users`

### Schema

| Attribute | Type | Size | Required | Default | Description |
|-----------|------|------|----------|---------|-------------|
| userId | string | 36 | Yes | - | Appwrite Auth user ID |
| email | string | 255 | Yes | - | User email |
| fullName | string | 100 | Yes | - | Display name |
| gender | string | 10 | Yes | - | male/female/other |
| dateOfBirth | datetime | - | Yes | - | Birth date |
| zodiacSign | string | 20 | No | - | Calculated from DOB |
| preferredLanguage | string | 5 | No | "en" | en/hi |
| profilePhotoUrl | string | 500 | No | - | Profile image URL |
| fcmToken | string | 500 | No | - | Push notification token |
| createdAt | datetime | - | Yes | - | Creation timestamp |
| updatedAt | datetime | - | Yes | - | Last update timestamp |

### Indexes

| Index | Type | Attributes |
|-------|------|------------|
| userId_idx | unique | [userId] |
| email_idx | unique | [email] |

### Example Document

```json
{
  "$id": "test-user-001",
  "userId": "test-user-001",
  "email": "test@example.com",
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

### Dart Model

```dart
class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String gender;
  final DateTime dateOfBirth;
  final String? zodiacSign;
  final String preferredLanguage;
  final String? profilePhotoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['\$id'],
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
}
```

---

## 2. Astrologers Collection

**Collection ID:** `astrologers`

### Schema

| Attribute | Type | Size | Required | Default | Description |
|-----------|------|------|----------|---------|-------------|
| name | string | 100 | Yes | - | Astrologer name |
| photoUrl | string | 500 | Yes | - | Profile photo URL |
| heroImageUrl | string | 500 | No | - | Full-size hero image |
| bio | string | 1000 | Yes | - | Biography text |
| specialization | string | 100 | Yes | - | Main expertise area |
| expertiseTags | string[] | 500 | No | [] | Skill tags |
| languages | string[] | 100 | No | [] | Supported languages |
| rating | double | - | No | 0 | Average rating (1-5) |
| reviewCount | integer | - | No | 0 | Total reviews |
| chatCount | integer | - | No | 0 | Total chats |
| category | string | 20 | Yes | - | vedic/western/tarot/etc |
| isActive | boolean | - | No | true | Availability status |
| aiPersonaPrompt | string | 5000 | No | - | AI personality prompt |
| displayOrder | integer | - | No | 0 | Sort order |
| createdAt | datetime | - | Yes | - | Creation timestamp |

### Indexes

| Index | Type | Attributes |
|-------|------|------------|
| category_idx | key | [category] |
| isActive_idx | key | [isActive] |
| displayOrder_idx | key | [displayOrder] |

### Example Document

```json
{
  "$id": "test-astrologer-001",
  "name": "Mystic Maya",
  "photoUrl": "https://example.com/maya.jpg",
  "heroImageUrl": "https://example.com/maya-hero.jpg",
  "bio": "With over 15 years of experience in Vedic Astrology, Mystic Maya brings ancient wisdom to modern seekers...",
  "specialization": "Vedic Astrology",
  "expertiseTags": ["Love", "Career", "Kundali", "Marriage"],
  "languages": ["English", "Hindi"],
  "rating": 4.8,
  "reviewCount": 1250,
  "chatCount": 5000,
  "category": "vedic",
  "isActive": true,
  "aiPersonaPrompt": "You are Mystic Maya, a warm and wise Vedic astrologer. You speak with compassion and ancient wisdom...",
  "displayOrder": 1,
  "createdAt": "2025-01-01T00:00:00.000+00:00"
}
```

### Categories Enum

```dart
enum AstrologerCategory {
  vedic,      // Vedic/Indian astrology
  western,    // Western zodiac
  tarot,      // Tarot card reading
  numerology, // Numerology
  palmistry,  // Palm reading
  vastu,      // Vastu Shastra
}
```

---

## 3. Messages Collection

**Collection ID:** `messages`

### Schema

| Attribute | Type | Size | Required | Default | Description |
|-----------|------|------|----------|---------|-------------|
| sessionId | string | 36 | Yes | - | Chat session reference |
| senderType | string | 20 | Yes | - | user/astrologer |
| content | string | 5000 | Yes | - | Message text |
| isRead | boolean | - | No | false | Read status |
| createdAt | datetime | - | Yes | - | Send timestamp |

### Indexes

| Index | Type | Attributes |
|-------|------|------------|
| sessionId_idx | key | [sessionId] |
| sessionId_createdAt_idx | key | [sessionId, createdAt] |

### Example Document

```json
{
  "$id": "msg-123456",
  "sessionId": "session-abc",
  "senderType": "user",
  "content": "What does my horoscope say about my career today?",
  "isRead": true,
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

---

## 4. Chat Sessions Collection

**Collection ID:** `chat_sessions`

### Schema

| Attribute | Type | Size | Required | Default | Description |
|-----------|------|------|----------|---------|-------------|
| userId | string | 36 | Yes | - | User reference |
| astrologerId | string | 36 | Yes | - | Astrologer reference |
| lastMessageAt | datetime | - | No | - | Last message timestamp |
| messageCount | integer | - | No | 0 | Total messages |
| isActive | boolean | - | No | true | Session active status |
| createdAt | datetime | - | Yes | - | Session start time |
| updatedAt | datetime | - | Yes | - | Last update time |

### Indexes

| Index | Type | Attributes |
|-------|------|------------|
| userId_idx | key | [userId] |
| userId_astrologerId_idx | unique | [userId, astrologerId] |

### Example Document

```json
{
  "$id": "session-abc",
  "userId": "test-user-001",
  "astrologerId": "test-astrologer-001",
  "lastMessageAt": "2025-12-03T10:35:00.000+00:00",
  "messageCount": 10,
  "isActive": true,
  "createdAt": "2025-12-03T10:00:00.000+00:00",
  "updatedAt": "2025-12-03T10:35:00.000+00:00"
}
```

---

## 5. Horoscopes Collection

**Collection ID:** `horoscopes`

### Schema

| Attribute | Type | Size | Required | Default | Description |
|-----------|------|------|----------|---------|-------------|
| zodiacSign | string | 20 | Yes | - | Zodiac sign (lowercase) |
| periodType | string | 10 | Yes | - | daily/weekly/monthly |
| category | string | 20 | Yes | - | love/career/health |
| contentEn | string | 2000 | Yes | - | English content |
| contentHi | string | 2000 | No | - | Hindi content |
| tipText | string | 500 | No | - | English tip |
| tipTextHi | string | 500 | No | - | Hindi tip |
| energyLevel | integer | - | No | 50 | Energy indicator (0-100) |
| validDate | string | 10 | Yes | - | Date (YYYY-MM-DD) |
| createdAt | datetime | - | No | - | Generation timestamp |

### Indexes

| Index | Type | Attributes |
|-------|------|------------|
| zodiac_period_date_idx | key | [zodiacSign, periodType, validDate] |
| validDate_idx | key | [validDate] |

### Example Document

```json
{
  "$id": "horoscope-aries-love-20251203",
  "zodiacSign": "aries",
  "periodType": "daily",
  "category": "love",
  "contentEn": "On this vibrant day, the universe ignites your passion, encouraging you to express your feelings with boldness and authenticity...",
  "contentHi": "इस जीवंत दिन पर, सृष्टि आपकी भावनाओं को जागृत करती है...",
  "tipText": null,
  "tipTextHi": null,
  "energyLevel": 75,
  "validDate": "2025-12-03",
  "createdAt": "2025-12-03T00:00:00.000+00:00"
}
```

### Zodiac Signs

```dart
enum ZodiacSign {
  aries,       // Mar 21 - Apr 19
  taurus,      // Apr 20 - May 20
  gemini,      // May 21 - Jun 20
  cancer,      // Jun 21 - Jul 22
  leo,         // Jul 23 - Aug 22
  virgo,       // Aug 23 - Sep 22
  libra,       // Sep 23 - Oct 22
  scorpio,     // Oct 23 - Nov 21
  sagittarius, // Nov 22 - Dec 21
  capricorn,   // Dec 22 - Jan 19
  aquarius,    // Jan 20 - Feb 18
  pisces,      // Feb 19 - Mar 20
}
```

### Categories

```dart
enum HoroscopeCategory {
  love,   // Relationships, romance, family
  career, // Work, finance, business
  health, // Physical and mental wellness
}
```

### Daily Generation

- **CRON:** `0 0 * * *` (Midnight UTC)
- **Total:** 36 horoscopes/day (12 signs x 3 categories)
- **Languages:** English + Hindi (bilingual)

---

## 6. Daily Content Collection

**Collection ID:** `daily_content`

### Schema

| Attribute | Type | Size | Required | Default | Description |
|-----------|------|------|----------|---------|-------------|
| type | string | 20 | Yes | - | mantra/god |
| title | string | 100 | Yes | - | English title |
| titleHi | string | 100 | No | - | Hindi title |
| description | string | 2000 | Yes | - | English description |
| descriptionHi | string | 2000 | No | - | Hindi description |
| imageUrl | string | 500 | No | - | Content image |
| audioUrl | string | 500 | No | - | Audio file (mantra) |
| isActive | boolean | - | No | true | Availability |
| createdAt | datetime | - | Yes | - | Creation time |

### Content Types

```dart
enum ContentType {
  mantra, // Daily mantra with audio
  god,    // Deity of the day
}
```

### Example Document (Mantra)

```json
{
  "$id": "mantra-001",
  "type": "mantra",
  "title": "Om Namah Shivaya",
  "titleHi": "ॐ नमः शिवाय",
  "description": "This powerful mantra invokes Lord Shiva and brings peace, protection, and spiritual growth...",
  "descriptionHi": "यह शक्तिशाली मंत्र भगवान शिव का आह्वान करता है...",
  "imageUrl": "https://storage.example.com/mantras/shiva.jpg",
  "audioUrl": "https://storage.example.com/mantras/om-namah-shivaya.mp3",
  "isActive": true,
  "createdAt": "2025-01-01T00:00:00.000+00:00"
}
```

---

## 7. Today Content Collection

**Collection ID:** `today_content`

### Schema

| Attribute | Type | Size | Required | Default | Description |
|-----------|------|------|----------|---------|-------------|
| type | string | 20 | Yes | - | mantra/god |
| contentId | string | 36 | Yes | - | Reference to daily_content |
| validDate | string | 10 | Yes | - | Date (YYYY-MM-DD) |
| createdAt | datetime | - | Yes | - | Selection timestamp |

### Indexes

| Index | Type | Attributes |
|-------|------|------------|
| type_date_idx | unique | [type, validDate] |

### Example Document

```json
{
  "$id": "today-mantra-20251203",
  "type": "mantra",
  "contentId": "mantra-001",
  "validDate": "2025-12-03",
  "createdAt": "2025-12-03T00:05:00.000+00:00"
}
```

### Daily Rotation

- **CRON:** `5 0 * * *` (00:05 UTC)
- **Logic:** Random selection, avoids yesterday's pick

---

## 8. Subscriptions Collection

**Collection ID:** `subscriptions`

### Schema

| Attribute | Type | Size | Required | Default | Description |
|-----------|------|------|----------|---------|-------------|
| userId | string | 36 | Yes | - | User reference |
| tier | string | 20 | Yes | - | free/premium/vip |
| status | string | 20 | Yes | - | active/cancelled/expired |
| platform | string | 10 | Yes | - | android/ios |
| productId | string | 100 | No | - | Store product ID |
| transactionId | string | 100 | No | - | Store transaction ID |
| startDate | datetime | - | Yes | - | Subscription start |
| endDate | datetime | - | No | - | Subscription end |
| chatCredits | integer | - | No | 5 | Daily message limit |
| adsRemoved | boolean | - | No | false | Ad-free status |
| createdAt | datetime | - | Yes | - | Creation timestamp |
| updatedAt | datetime | - | Yes | - | Last update |

### Indexes

| Index | Type | Attributes |
|-------|------|------------|
| userId_idx | unique | [userId] |

### Subscription Tiers

| Tier | Daily Messages | Ads | Monthly Price |
|------|---------------|-----|---------------|
| free | 5 | Yes | $0 |
| premium | Unlimited | No | $4.99 |
| vip | Unlimited | No | $9.99 |

### Example Document

```json
{
  "$id": "sub-user-001",
  "userId": "test-user-001",
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

### RevenueCat Events

| Event | Action |
|-------|--------|
| INITIAL_PURCHASE | Create/update subscription, set tier |
| RENEWAL | Extend endDate, refresh credits |
| CANCELLATION | Mark status=cancelled |
| EXPIRATION | Reset to free tier |
| BILLING_ISSUE | Mark for warning |

---

## 9. Reviews Collection

**Collection ID:** `reviews`

### Schema

| Attribute | Type | Size | Required | Default | Description |
|-----------|------|------|----------|---------|-------------|
| astrologerId | string | 36 | Yes | - | Astrologer reference |
| userId | string | 36 | Yes | - | User reference |
| userName | string | 100 | Yes | - | Display name |
| rating | integer | - | Yes | - | 1-5 stars |
| text | string | 500 | No | - | Review text |
| createdAt | datetime | - | Yes | - | Review timestamp |

### Indexes

| Index | Type | Attributes |
|-------|------|------------|
| astrologerId_idx | key | [astrologerId] |
| userId_astrologerId_idx | unique | [userId, astrologerId] |

---

## 10. Favorites Collection

**Collection ID:** `favorites`

### Schema

| Attribute | Type | Size | Required | Default | Description |
|-----------|------|------|----------|---------|-------------|
| userId | string | 36 | Yes | - | User reference |
| astrologerId | string | 36 | Yes | - | Astrologer reference |
| createdAt | datetime | - | Yes | - | Favorite timestamp |

### Indexes

| Index | Type | Attributes |
|-------|------|------------|
| userId_idx | key | [userId] |
| userId_astrologerId_idx | unique | [userId, astrologerId] |

---

## 11. FAQs Collection

**Collection ID:** `faqs`

### Schema

| Attribute | Type | Size | Required | Default | Description |
|-----------|------|------|----------|---------|-------------|
| questionEn | string | 500 | Yes | - | English question |
| questionHi | string | 500 | Yes | - | Hindi question |
| category | string | 20 | Yes | - | Question category |
| astrologerId | string | 36 | No | - | Specific astrologer |
| displayOrder | integer | - | No | 0 | Sort order |
| isActive | boolean | - | No | true | Visibility |

### Categories

- `general` - General astrology questions
- `love` - Love and relationship questions
- `career` - Career and finance questions
- `health` - Health-related questions

---

## Query Patterns

### Get Today's Horoscopes for User

```dart
Query.equal('zodiacSign', userZodiacSign),
Query.equal('periodType', 'daily'),
Query.equal('validDate', todayDate),
```

### Get Active Astrologers

```dart
Query.equal('isActive', true),
Query.orderAsc('displayOrder'),
```

### Get Chat History

```dart
Query.equal('sessionId', sessionId),
Query.orderAsc('createdAt'),
Query.limit(100),
```

### Get User Subscription

```dart
Query.equal('userId', userId),
Query.equal('status', 'active'),
Query.limit(1),
```

### Get Today's Content

```dart
Query.equal('type', contentType),
Query.equal('validDate', todayDate),
```

---

## Data Retention

| Collection | Retention | Notes |
|------------|-----------|-------|
| users | Permanent | Until account deletion |
| messages | 90 days | Auto-cleanup planned |
| chat_sessions | Permanent | Session metadata |
| horoscopes | 7 days | Only keep recent |
| today_content | 30 days | Historical tracking |
| subscriptions | Permanent | Billing records |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-03 | Initial release |

---

**Maintained By:** Astro GPT Development Team
