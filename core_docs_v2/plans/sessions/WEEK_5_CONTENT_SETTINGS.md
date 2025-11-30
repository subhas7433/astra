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
- Account deletion (Phase 2)
- Social login (Phase 2)
- Dark mode (Phase 2)

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

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Module structure | 20 min | Folders + files |
| TodayBhagwanController | 45 min | Data + actions |
| TodayBhagwanScreen | 50 min | Full screen |
| DeityCard widget | 50 min | Image + info |
| Copy functionality | 25 min | Clipboard + toast |
| Share functionality | 30 min | Share sheet |

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
1. Build Today's Mantra detail screen
2. Create mantra display with Sanskrit text
3. Add transliteration and meaning
4. Implement audio playback (optional)
5. Add Copy and Share functionality

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

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
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

## Session 3: Numerology Screen (4 hours)

### Objectives
1. Build Numerology feature screen
2. Create birth date input
3. Implement numerology calculation
4. Display life path number
5. Show personality traits and predictions

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `NumerologyScreen` | Full numerology screen |
| `NumerologyController` | Calculation + state |
| `DatePickerInput` | Birth date selector |
| `NumerologyResult` | Number + meaning |
| `TraitsSection` | Personality traits |

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

## Session 4: Settings Screen (4 hours)

### Objectives
1. Create Settings module structure
2. Build Settings screen with all options
3. Implement profile card section
4. Add navigation to sub-screens
5. Create Remove Ads entry point

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `settings/` module | Module structure |
| `SettingsScreen` | Main settings screen |
| `SettingsController` | Settings state |
| `ProfileCard` | User info card |
| `SettingsItem` | Reusable list item |

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
└─────────────────────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Module structure | 15 min | Folders + files |
| SettingsController | 35 min | State management |
| SettingsScreen | 45 min | Full screen |
| ProfileCard widget | 40 min | User info card |
| SettingsItem widget | 30 min | Reusable list item |
| Navigation wiring | 35 min | All sub-screens |
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

## Session 5: Language & Profile Management (4 hours)

### Objectives
1. Build Language selection screen
2. Implement language switching
3. Create Profile edit screen
4. Add Favorites list screen
5. Persist user preferences

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `LanguageScreen` | Language selection |
| `LanguageController` | Switch language |
| `ProfileEditScreen` | Edit user info |
| `FavoritesScreen` | Saved horoscopes/content |
| Preference persistence | SharedPreferences |

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
| LanguageScreen | 40 min | Selection UI |
| LanguageController | 45 min | Switch logic |
| Locale change | 40 min | GetX locale update |
| ProfileEditScreen | 50 min | Edit form |
| FavoritesScreen | 45 min | List of favorites |
| Preference persistence | 40 min | SharedPreferences |

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

## Session 6: About & Feedback Flows (4 hours)

### Objectives
1. Create About Us screen
2. Build Feedback screen with form
3. Implement Rate Us flow
4. Add Request Feature form
5. Final integration and testing

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `AboutScreen` | App info + credits |
| `FeedbackScreen` | Feedback form |
| Rate Us flow | Open app store |
| `RequestFeatureScreen` | Feature request form |
| Widget tests | Settings components |

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
| AboutScreen | 40 min | Info screen |
| FeedbackScreen | 50 min | Form + validation |
| Feedback submission | 35 min | Appwrite or email |
| Rate Us flow | 25 min | Store redirect |
| RequestFeatureScreen | 40 min | Form + submit |
| Widget tests | 50 min | Settings tests |

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
- [ ] About screen shows app info
- [ ] Feedback form validates input
- [ ] Feedback submits successfully
- [ ] Rate Us opens correct store
- [ ] Request Feature submits
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
