# Week 5: Daily Content & Settings - Implementation Sessions
## Astro GPT Flutter App
**Total Duration:** 24 hours (6 sessions x 4 hours)

---

## Executive Summary

### Week 5 Goal
Complete daily content features (Bhagwan, Mantra, Numerology) and Settings module

### What We're Building
- Today's Bhagwan detail screen
- Today's Mantra detail screen
- Numerology feature screen
- Settings screen with all options
- Profile management
- Language switching (Hindi/English)
- Favorites management
- About, Feedback, Rate Us flows

### What We're NOT Building
- Push notification settings (Phase 2)
- Social login (Phase 2)
- Dark mode (Phase 2)

### Additional Features Added (Gap Coverage)
- Account Deletion (GDPR compliance, FR-009)
- FAQsRepository (for "Most Ask Questions", FR-014, FR-030)
- ReviewsRepository (for astrologer reviews, FR-031)

### Backend Integration (NEW)
- DailyContentRepository for Bhagwan/Mantra data
- ChatRepository for message persistence
- MockAstrologer replacement completion
- TODO items cleanup

### Prerequisites (from Week 1-4)
- [x] DailyContentModel defined
- [x] Feature icons navigation from Home
- [x] Localization infrastructure
- [x] Share functionality patterns
- [x] User model and repository

---

## Session 1: Today's Bhagwan Screen (4 hours)

### Objectives
1. Create daily content module structure
2. Build Today's Bhagwan detail screen
3. Implement deity card with image
4. Add description and significance
5. Create Copy and Share functionality

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `daily_content/` module | Shared module structure |
| `TodayBhagwanScreen` | Full deity screen |
| `TodayBhagwanController` | Data fetching, actions |
| `DeityCard` | Image + name + description |
| Copy/Share actions | Content sharing |

### Module Structure
```
lib/app/modules/daily_content/
├── bindings/
│   ├── today_bhagwan_binding.dart
│   ├── today_mantra_binding.dart
│   └── numerology_binding.dart
├── controllers/
│   ├── today_bhagwan_controller.dart
│   ├── today_mantra_controller.dart
│   └── numerology_controller.dart
├── views/
│   ├── today_bhagwan_screen.dart
│   ├── today_mantra_screen.dart
│   └── numerology_screen.dart
└── widgets/
    ├── deity_card.dart
    ├── mantra_card.dart
    ├── content_actions.dart
    └── numerology_result.dart
```

### Screen Layout (from design)
```
┌─────────────────────────────────┐
│ ←  Today's Bhagwan              │
├─────────────────────────────────┤
│  ┌─────────────────────────┐   │
│  │                         │   │
│  │    [Deity Image]        │   │
│  │                         │   │
│  └─────────────────────────┘   │
│                                 │
│  🙏 Lord Ganesha                │
│                                 │
│  Lord Ganesha, the remover of  │
│  obstacles, is worshipped at   │
│  the beginning of all new      │
│  ventures and journeys...      │
│                                 │
│  [📋 Copy]  [📤 Share]          │
└─────────────────────────────────┘
```

### Backend Tasks (NEW)
| Task | Duration | Type |
|------|----------|------|
| Create DailyContentRepository | 45 min | Backend |
| Create FAQsRepository | 30 min | Backend |

### DailyContentRepository Structure
```dart
class DailyContentRepository {
  final IDatabaseService _db;

  Future<Result<DeityModel, AppError>> getTodaysBhagwan();
  Future<Result<MantraModel, AppError>> getTodaysMantra();
  Future<Result<List<DeityModel>, AppError>> getAllDeities();
}
```

### FAQsRepository Structure (NEW - FR-014, FR-030)
```dart
class FAQsRepository {
  final IDatabaseService _db;

  Future<Result<List<FAQModel>, AppError>> getFAQs({String? category});
  Future<Result<List<FAQModel>, AppError>> getFAQsByAstrologer(String astrologerId);
  Future<Result<List<FAQModel>, AppError>> getMostAskedQuestions({int limit = 10});
}

class FAQModel {
  final String id;
  final String questionHindi;
  final String questionEnglish;
  final String? category;
  final String? astrologerId;
  final int displayOrder;
}
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Create DailyContentRepository | 45 min | Backend |
| Create FAQsRepository | 30 min | Backend |
| Module structure | 20 min | Folders + files |
| TodayBhagwanController | 40 min | Data + actions |
| TodayBhagwanScreen | 45 min | Full screen |
| DeityCard widget | 45 min | Image + info |
| Copy functionality | 20 min | Clipboard + toast |
| Share functionality | 25 min | Share sheet |

### Deity Model
```dart
class DeityModel {
  final String id;
  final String name;
  final String nameHindi;
  final String imageUrl;
  final String description;
  final String descriptionHindi;
  final String significance;
  final String mantra;
  final DateTime date;
}
```

### Acceptance Criteria
- [ ] Screen loads today's deity
- [ ] Image displays correctly (cached)
- [ ] Name shows in current language
- [ ] Description is readable
- [ ] Copy copies text to clipboard
- [ ] Share opens native share sheet

---

## Session 2: Today's Mantra Screen (4 hours)

### Objectives
1. Extend DailyContentRepository for mantras
2. Build Today's Mantra detail screen
3. Create mantra display with Sanskrit text
4. Add transliteration and meaning
5. Implement audio playback (optional)
6. Add Copy and Share functionality

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `TodayMantraScreen` | Full mantra screen |
| `TodayMantraController` | Data + audio control |
| `MantraDisplay` | Sanskrit + transliteration |
| `MantraMeaning` | Meaning section |
| Audio player | Play mantra (optional) |

### Screen Layout
```
┌─────────────────────────────────┐
│ ←  Today's Mantra               │
├─────────────────────────────────┤
│                                 │
│  ॐ गं गणपतये नमः                │  Sanskrit
│                                 │
│  Om Gam Ganapataye Namaha      │  Transliteration
│                                 │
│  [▶️ Play Audio]                │  Optional
│                                 │
├─────────────────────────────────┤
│  📖 Meaning                     │
│                                 │
│  This mantra is a salutation   │
│  to Lord Ganesha, invoking     │
│  his blessings for removing    │
│  obstacles from one's path...  │
│                                 │
├─────────────────────────────────┤
│  🌟 Benefits                    │
│  • Removes obstacles            │
│  • Brings wisdom                │
│  • Promotes success             │
│                                 │
│  [📋 Copy]  [📤 Share]          │
└─────────────────────────────────┘
```

### Backend Tasks (NEW)
| Task | Duration | Type |
|------|----------|------|
| Extend DailyContentRepository for mantras | 30 min | Backend |

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Extend DailyContentRepository | 30 min | Backend |
| TodayMantraController | 40 min | Data + state |
| TodayMantraScreen | 45 min | Full screen |
| MantraDisplay widget | 45 min | Sanskrit + roman |
| MantraMeaning widget | 35 min | Meaning section |
| Benefits list | 25 min | Bullet points |
| Copy/Share | 30 min | Actions |

### Mantra Model
```dart
class MantraModel {
  final String id;
  final String sanskrit;
  final String transliteration;
  final String meaning;
  final String meaningHindi;
  final List<String> benefits;
  final String? audioUrl;
  final String deity;
  final DateTime date;
}
```

### Acceptance Criteria
- [ ] Sanskrit text displays correctly
- [ ] Transliteration is readable
- [ ] Meaning section formatted well
- [ ] Benefits list displays
- [ ] Copy includes all text
- [ ] Share formats content nicely

---

## Session 3: Numerology Screen + MockAstrologer Replacement (4 hours)

### Objectives
1. Replace MockAstrologer in astrologer_list_controller
2. Replace MockAstrologer in astrologers_section
3. Build Numerology feature screen
4. Create birth date input
5. Implement numerology calculation
6. Display life path number
7. Show personality traits and predictions

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `NumerologyScreen` | Full numerology screen |
| `NumerologyController` | Calculation + state |
| `DatePickerInput` | Birth date selector |
| `NumerologyResult` | Number + meaning |
| `TraitsSection` | Personality traits |

### Refactoring Tasks (NEW)
| Task | Duration | Type |
|------|----------|------|
| Replace MockAstrologer in astrologer_list_controller | 25 min | Refactor |
| Replace MockAstrologer in astrologers_section | 15 min | Refactor |

### Screen Layout
```
┌─────────────────────────────────┐
│ ←  Numerology                   │
├─────────────────────────────────┤
│                                 │
│  Enter Your Birth Date          │
│  ┌─────────────────────────┐   │
│  │ DD / MM / YYYY     📅   │   │
│  └─────────────────────────┘   │
│                                 │
│  [ Calculate ]                  │
│                                 │
├─────────────────────────────────┤  After calculation
│                                 │
│  Your Life Path Number          │
│         ╔═══╗                   │
│         ║ 7 ║                   │
│         ╚═══╝                   │
│                                 │
│  The Seeker                     │
│                                 │
│  You are analytical, intuitive, │
│  and drawn to understanding     │
│  life's deeper mysteries...     │
│                                 │
├─────────────────────────────────┤
│  Personality Traits             │
│  • Introspective                │
│  • Spiritual                    │
│  • Independent                  │
│                                 │
├─────────────────────────────────┤
│  This Year's Prediction         │
│  2025 brings opportunities...   │
│                                 │
│  [📤 Share]                     │
└─────────────────────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Replace MockAstrologer in astrologer_list_controller | 25 min | Refactor |
| Replace MockAstrologer in astrologers_section | 15 min | Refactor |
| NumerologyController | 50 min | Calculation logic |
| NumerologyScreen | 40 min | Screen structure |
| DatePickerInput | 40 min | Date selector |
| NumerologyResult | 45 min | Number display |
| TraitsSection | 30 min | Traits list |
| Share functionality | 35 min | Share result |

### Numerology Calculation (Centralized)
```dart
// lib/app/core/utils/numerology_calculator.dart
class NumerologyCalculator {
  // Calculate life path number
  static int calculateLifePath(DateTime birthDate) {
    int sum = 0;
    String dateStr = '${birthDate.day}${birthDate.month}${birthDate.year}';
    for (var char in dateStr.split('')) {
      sum += int.parse(char);
    }
    // Reduce to single digit (except master numbers 11, 22, 33)
    while (sum > 9 && sum != 11 && sum != 22 && sum != 33) {
      sum = sum.toString().split('').map(int.parse).reduce((a, b) => a + b);
    }
    return sum;
  }
}
```

### Acceptance Criteria
- [ ] Date picker works correctly
- [ ] Calculate button triggers calculation
- [ ] Life path number displays prominently
- [ ] Traits match the number
- [ ] Prediction is relevant
- [ ] Share includes full result

---

## Session 4: Settings Screen + MockAstrologer Cleanup (4 hours)

### Objectives
1. Replace MockAstrologer in astrologer_profile_controller
2. Create Settings module structure
3. Build Settings screen with all options
4. Implement profile card section
5. Add navigation to sub-screens
6. Create Remove Ads entry point

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `settings/` module | Module structure |
| `SettingsScreen` | Main settings screen |
| `SettingsController` | Settings state |
| `ProfileCard` | User info card |
| `SettingsItem` | Reusable list item |

### Backend & Refactoring Tasks (NEW)
| Task | Duration | Type |
|------|----------|------|
| Create ReviewsRepository | 35 min | Backend |
| Replace MockAstrologer in astrologer_profile_controller | 20 min | Refactor |

### ReviewsRepository Structure (NEW - FR-031)
```dart
class ReviewsRepository {
  final IDatabaseService _db;

  Future<Result<List<ReviewModel>, AppError>> getReviewsByAstrologer(
    String astrologerId, {
    int limit = 10,
    int offset = 0,
  });
  Future<Result<ReviewModel, AppError>> createReview(ReviewModel review);
  Future<Result<double, AppError>> getAverageRating(String astrologerId);
}

class ReviewModel {
  final String id;
  final String astrologerId;
  final String userId;
  final String userName;
  final int rating; // 1-5
  final String text;
  final DateTime createdAt;
}
```

### Screen Layout (from design)
```
┌─────────────────────────────────┐
│ ←  Settings                     │
├─────────────────────────────────┤
│ ┌─────────────────────────────┐ │
│ │ 👤 User Name                │ │  Profile Card
│ │    user@email.com           │ │
│ │    [Edit Profile]           │ │
│ └─────────────────────────────┘ │
├─────────────────────────────────┤
│ ⭐ Remove Ads              →   │
├─────────────────────────────────┤
│ 🌐 Change Language         →   │
│ ❤️ Favorites               →   │
├─────────────────────────────────┤
│ ℹ️ About Us                →   │
│ 💬 Feedback                →   │
│ ⭐ Rate Us                 →   │
│ 💡 Request Feature         →   │
├─────────────────────────────────┤
│ 🚪 Logout                      │
│ 🗑️ Delete Account (red)       │  (GDPR - FR-009)
└─────────────────────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Create ReviewsRepository | 35 min | Backend |
| Replace MockAstrologer in astrologer_profile_controller | 20 min | Refactor |
| Module structure | 15 min | Folders + files |
| SettingsController | 30 min | State management |
| SettingsScreen | 40 min | Full screen |
| ProfileCard widget | 35 min | User info card |
| SettingsItem widget | 25 min | Reusable list item |
| Navigation wiring | 30 min | All sub-screens |
| Logout flow | 20 min | Logout + confirm |

### SettingsItem Widget (DRY)
```dart
class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? iconColor;

  // Reused for all settings options
}
```

### Acceptance Criteria
- [ ] Profile card shows user info
- [ ] All settings items display
- [ ] Navigation works for each item
- [ ] Remove Ads highlights premium
- [ ] Logout shows confirmation
- [ ] Back navigation works

---

## Session 5: Language & Profile Management + Chat Backend (4 hours)

### Objectives
1. Create ChatRepository for message persistence
2. Replace MockAstrologer in chat_controller
3. Build Language selection screen
4. Implement language switching
5. Create Profile edit screen
6. Add Favorites list screen
7. Persist user preferences

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `LanguageScreen` | Language selection |
| `LanguageController` | Switch language |
| `ProfileEditScreen` | Edit user info |
| `FavoritesScreen` | Saved horoscopes/content |
| Preference persistence | SharedPreferences |

### Backend Tasks (NEW)
| Task | Duration | Type |
|------|----------|------|
| Create ChatRepository | 45 min | Backend |
| Replace MockAstrologer in chat_controller | 25 min | Refactor |

### ChatRepository Structure
```dart
class ChatRepository {
  final IDatabaseService _db;

  Future<Result<ChatSession, AppError>> createSession(String astrologerId);
  Future<Result<void, AppError>> saveMessage(MessageModel message);
  Future<Result<List<MessageModel>, AppError>> getMessages(String sessionId);
  Future<Result<void, AppError>> syncMessages(String sessionId);
}
```

### Language Screen
```
┌─────────────────────────────────┐
│ ←  Change Language              │
├─────────────────────────────────┤
│                                 │
│  Select your preferred language │
│                                 │
│  ┌─────────────────────────┐   │
│  │ 🇬🇧 English          ✓  │   │
│  └─────────────────────────┘   │
│  ┌─────────────────────────┐   │
│  │ 🇮🇳 हिंदी               │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Create ChatRepository | 45 min | Backend |
| Replace MockAstrologer in chat_controller | 25 min | Refactor |
| LanguageScreen | 40 min | Selection UI |
| LanguageController | 35 min | Switch logic |
| ProfileEditScreen | 40 min | Edit form |
| FavoritesScreen | 35 min | List of favorites |
| Preference persistence | 35 min | SharedPreferences |

### Language Switching
```dart
class LanguageController extends GetxController {
  final currentLocale = const Locale('en').obs;

  void changeLanguage(String languageCode) {
    final locale = Locale(languageCode);
    currentLocale.value = locale;
    Get.updateLocale(locale);
    _savePreference(languageCode);
  }

  Future<void> _savePreference(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', code);
  }
}
```

### Acceptance Criteria
- [ ] Language options show correctly
- [ ] Selection changes app language
- [ ] Language persists on restart
- [ ] Profile edit saves changes
- [ ] Favorites list shows saved items
- [ ] Remove from favorites works

---

## Session 6: About & Feedback Flows + TODO Cleanup + Account Deletion (4 hours)

### Objectives
1. Fix navigation TODOs (notifications, settings, location)
2. Fix zodiac persistence TODO
3. Delete mock_astrologer.dart
4. Implement Account Deletion (GDPR compliance, FR-009)
5. Create About Us screen
6. Build Feedback screen with form
7. Implement Rate Us flow
8. Add Request Feature form
9. Final integration and testing

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `AboutScreen` | App info + credits |
| `FeedbackScreen` | Feedback form |
| Rate Us flow | Open app store |
| `RequestFeatureScreen` | Feature request form |
| Account Deletion | GDPR-compliant account removal (FR-009) |
| Widget tests | Settings components |

### Bug Fixes & Cleanup (NEW)
| Task | Duration | Type |
|------|----------|------|
| Fix navigation TODOs (notifications, settings, location) | 30 min | Bug Fix |
| Fix zodiac persistence TODO | 15 min | Bug Fix |
| Implement Account Deletion (GDPR) | 35 min | Feature |
| Delete mock_astrologer.dart | 10 min | Cleanup |

### Account Deletion Implementation (FR-009)
```dart
// In SettingsController
Future<void> deleteAccount() async {
  // 1. Show confirmation dialog with warning
  final confirmed = await Get.dialog<bool>(
    AlertDialog(
      title: Text('Delete Account'),
      content: Text('This will permanently delete your account and all data. This action cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Get.back(result: false), child: Text('Cancel')),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    // 2. Delete user data from Appwrite
    await _authService.deleteAccount();
    // 3. Clear local storage
    await _clearLocalData();
    // 4. Navigate to login
    Get.offAllNamed(Routes.LOGIN);
  }
}

// In AppwriteAuthService
Future<Result<void, AppError>> deleteAccount() async {
  try {
    // Delete user document from 'users' collection
    await _db.deleteDocument(databaseId: dbId, collectionId: 'users', documentId: userId);
    // Delete associated chat sessions and messages
    // Delete favorites
    // Delete the Appwrite account itself
    await _account.deleteSessions(); // Logout all sessions
    return Result.success(null);
  } catch (e) {
    return Result.failure(UnknownError(message: e.toString()));
  }
}
```

### TODOs to Fix
```dart
// home_controller.dart:110 - Navigate to notifications
// home_controller.dart:115 - Open location picker
// home_controller.dart:120 - Navigate to settings
// home_screen.dart:60 - Handle question tap
// zodiac_picker_controller.dart:18 - Persist zodiac sign
```

### About Us Screen
```
┌─────────────────────────────────┐
│ ←  About Us                     │
├─────────────────────────────────┤
│                                 │
│         [App Logo]              │
│                                 │
│        Astro GPT                │
│        Version 1.0.0            │
│                                 │
├─────────────────────────────────┤
│  Astro GPT is your personal AI  │
│  astrology companion, providing │
│  daily horoscopes, spiritual    │
│  guidance, and wisdom from the  │
│  stars...                       │
│                                 │
├─────────────────────────────────┤
│  📧 Contact: support@astro.com  │
│  🌐 Website: www.astrogpt.com   │
│  📱 Follow us on social media   │
│                                 │
├─────────────────────────────────┤
│  Made with ❤️ in India           │
│  © 2025 Astro GPT               │
└─────────────────────────────────┘
```

### Feedback Form
```
┌─────────────────────────────────┐
│ ←  Feedback                     │
├─────────────────────────────────┤
│                                 │
│  We'd love to hear from you!    │
│                                 │
│  Category                       │
│  [Bug ▼]                        │
│                                 │
│  Your Feedback                  │
│  ┌─────────────────────────┐   │
│  │                         │   │
│  │                         │   │
│  │                         │   │
│  └─────────────────────────┘   │
│                                 │
│  Email (optional)               │
│  [                         ]   │
│                                 │
│  [ Submit Feedback ]            │
└─────────────────────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Fix navigation TODOs | 25 min | Bug Fix |
| Fix zodiac persistence TODO | 15 min | Bug Fix |
| Implement Account Deletion (GDPR) | 35 min | Feature |
| AboutScreen | 35 min | Info screen |
| FeedbackScreen | 45 min | Form + validation |
| Rate Us flow | 20 min | Store redirect |
| Widget tests | 40 min | Settings tests |
| Delete mock_astrologer.dart | 10 min | Cleanup |

### Rate Us Implementation
```dart
void openAppStore() {
  final url = Platform.isIOS
      ? 'https://apps.apple.com/app/id123456789'
      : 'https://play.google.com/store/apps/details?id=com.astrogpt';
  launchUrl(Uri.parse(url));
}
```

### Acceptance Criteria
- [ ] Navigation TODOs fixed (notifications, settings, location work)
- [ ] Zodiac sign persists between sessions
- [ ] mock_astrologer.dart deleted
- [ ] Account deletion shows confirmation dialog
- [ ] Account deletion removes all user data from Appwrite
- [ ] Account deletion clears local storage and logs out
- [ ] About screen shows app info
- [ ] Feedback form validates input
- [ ] Rate Us opens correct store
- [ ] All widget tests pass

---

## Week 5 Success Metrics

| Metric | Target |
|--------|--------|
| Screen load time | <300ms |
| Language switch | Instant UI update |
| Form submission | <2s response |
| Widget test coverage | >75% |
| Offline support | Cached content works |

## Reusable Components Created

| Component | Reuse Potential |
|-----------|-----------------|
| `SettingsItem` | Any list settings |
| `ProfileCard` | User info display |
| `ContentActions` | Copy/Share anywhere |
| `DatePickerInput` | Any date input |
| `FeedbackForm` | Any form pattern |

## Localization Keys Added

```yaml
# lib/l10n/app_en.arb
{
  "settings": "Settings",
  "changeLanguage": "Change Language",
  "favorites": "Favorites",
  "aboutUs": "About Us",
  "feedback": "Feedback",
  "rateUs": "Rate Us",
  "requestFeature": "Request Feature",
  "logout": "Logout",
  "removeAds": "Remove Ads",
  "todayBhagwan": "Today's Bhagwan",
  "todayMantra": "Today's Mantra",
  "numerology": "Numerology"
}
```

---

## Notes

### Daily Content Strategy
- Content rotates daily from predefined pool
- Deity: 30+ deities in rotation
- Mantra: 50+ mantras in rotation
- Tied to Hindu calendar for special days

### Feedback Storage
- Option 1: Appwrite collection `feedback`
- Option 2: Email via mailto link
- Option 3: Firebase/third-party service

### Privacy Considerations
- Profile data stored locally + Appwrite
- Feedback can be anonymous
- No tracking without consent
