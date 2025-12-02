# Week 4: Horoscope System - Implementation Sessions
## Astro GPT Flutter App
**Total Duration:** 24 hours (6 sessions x 4 hours)

---

## Executive Summary

### Week 4 Goal
Complete Horoscope feature with zodiac selection, time periods, and category breakdowns

### What We're Building
- Rashi/Zodiac picker screen (4x3 grid)
- Horoscope detail screen
- Time period tabs (Today/Weekly/Monthly/Yearly)
- Category sections (Love/Career/Health)
- Progress bar indicators for each category
- Like and Share functionality
- HoroscopeController with data management

### What We're NOT Building
- Kundli matching (Phase 2)
- Detailed birth chart (Phase 2)
- Compatibility calculator (Phase 2)
- Push notifications for daily horoscope

### Prerequisites (from Week 1-3)
- [x] HoroscopeModel defined
- [x] Feature icons navigation from Home
- [x] Theme system and base widgets
- [x] Share functionality patterns

---

## Session 1: Zodiac Picker Screen (4 hours)

### Objectives
1. Create Horoscope module structure
2. Build Zodiac picker grid (4x3)
3. Implement zodiac sign cards
4. Add selection and navigation
5. Store user's zodiac preference

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `horoscope/` module | Complete folder structure |
| `ZodiacPickerScreen` | Full screen zodiac grid |
| `ZodiacCard` | Individual sign card |
| `ZodiacController` | Selection, persistence |
| User preference storage | Remember selected sign |

### Module Structure
```
lib/app/modules/horoscope/
├── bindings/
│   ├── zodiac_picker_binding.dart
│   └── horoscope_detail_binding.dart
├── controllers/
│   ├── zodiac_picker_controller.dart
│   └── horoscope_detail_controller.dart
├── views/
│   ├── zodiac_picker_screen.dart
│   └── horoscope_detail_screen.dart
└── widgets/
    ├── zodiac_card.dart
    ├── time_period_tabs.dart
    ├── category_card.dart
    └── horoscope_content.dart
```

### Zodiac Grid Layout (from design)
```
┌─────────────────────────────────┐
│     Select Your Rashi          │
├─────────────────────────────────┤
│  ♈️       ♉️       ♊️       ♋️    │
│ Aries   Taurus  Gemini  Cancer │
│                                 │
│  ♌️       ♍️       ♎️       ♏️    │
│  Leo    Virgo   Libra  Scorpio │
│                                 │
│  ♐️       ♑️       ♒️       ♓️    │
│ Sagit.  Capri.  Aquar.  Pisces │
└─────────────────────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Module structure | 15 min | Folders + files |
| ZodiacPickerController | 40 min | Selection logic |
| ZodiacPickerScreen | 45 min | Grid layout |
| ZodiacCard widget | 50 min | Sign card with icon |
| Selection animation | 35 min | Visual feedback |
| Preference storage | 35 min | SharedPreferences |

### Zodiac Data (Centralized Constants)
```dart
// lib/app/core/constants/zodiac_constants.dart
class ZodiacConstants {
  static const List<ZodiacSign> signs = [
    ZodiacSign(
      id: 'aries',
      name: 'Aries',
      nameHindi: 'मेष',
      symbol: '♈️',
      icon: 'assets/icons/zodiac/aries.svg',
      dateRange: 'Mar 21 - Apr 19',
      element: 'Fire',
    ),
    // ... all 12 signs
  ];
}
```

### Acceptance Criteria
- [ ] Grid displays all 12 zodiac signs
- [ ] Cards show icon, name, and date range
- [ ] Selection highlights the card
- [ ] Tap navigates to horoscope detail
- [ ] User's sign persists between sessions
- [ ] Hindi names display when language is Hindi

---

## Session 2: Horoscope Detail Screen Structure (4 hours)

### Objectives
1. Build HoroscopeDetailScreen scaffold
2. Create header with zodiac info
3. Implement time period tabs
4. Set up HoroscopeDetailController
5. Add tab switching logic

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `HoroscopeDetailScreen` | Main detail screen |
| `HoroscopeDetailController` | Data fetching, tab state |
| `HoroscopeHeader` | Zodiac icon, name, date |
| `TimePeriodTabs` | Today/Weekly/Monthly/Yearly |
| Tab content switching | Show content per period |

### Screen Layout (from design)
```
┌─────────────────────────────────┐
│ ←  Aries ♈️                     │
│    Mar 21 - Apr 19              │
├─────────────────────────────────┤
│ [Today][Weekly][Monthly][Yearly]│  Tabs
├─────────────────────────────────┤
│                                 │
│  Today's Horoscope              │
│  Date: Nov 26, 2025             │
│                                 │
│  General prediction text...     │
│                                 │
├─────────────────────────────────┤
│  [Category Cards Below]         │
└─────────────────────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| HoroscopeDetailController | 60 min | Tab state, data fetch |
| HoroscopeDetailScreen | 45 min | Scaffold + structure |
| HoroscopeHeader | 40 min | Icon, name, dates |
| TimePeriodTabs | 50 min | Tab bar widget |
| Tab content switching | 35 min | TabBarView |
| Loading states | 30 min | Shimmer per tab |

### Controller Structure
```dart
class HoroscopeDetailController extends BaseController {
  final String zodiacSign;
  final HoroscopeRepository _repo;

  // Tab state
  final selectedPeriod = TimePeriod.today.obs;

  // Data per period
  final todayHoroscope = Rxn<HoroscopeModel>();
  final weeklyHoroscope = Rxn<HoroscopeModel>();
  final monthlyHoroscope = Rxn<HoroscopeModel>();
  final yearlyHoroscope = Rxn<HoroscopeModel>();

  // Methods
  void onPeriodChanged(TimePeriod period);
  Future<void> fetchHoroscope(TimePeriod period);
  HoroscopeModel? get currentHoroscope;
}

enum TimePeriod { today, weekly, monthly, yearly }
```

### Acceptance Criteria
- [ ] Header shows correct zodiac info
- [ ] All four tabs visible and tappable
- [ ] Tab switching changes content
- [ ] Data loads for each period
- [ ] Loading state shows while fetching
- [ ] Back navigation returns to picker

---

## Session 3: Category Cards & Progress (4 hours)

### Objectives
1. Build CategoryCard widget
2. Implement progress bar indicator
3. Create Love/Career/Health sections
4. Add category-specific icons
5. Display prediction text per category

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `CategoryCard` | Card with progress bar |
| `ProgressIndicator` | Custom progress bar |
| Love section | Heart icon + prediction |
| Career section | Briefcase icon + prediction |
| Health section | Heart pulse icon + prediction |

### Category Card Specs (from design)
```
┌─────────────────────────────────┐
│ ❤️ Love                    85%  │
│ ████████████░░░░                │
│                                 │
│ Venus aligns favorably with    │
│ your sign today, bringing      │
│ romantic opportunities...       │
└─────────────────────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| CategoryCard widget | 60 min | Complete card |
| ProgressIndicator | 45 min | Animated progress bar |
| Love category | 30 min | Icon + content |
| Career category | 30 min | Icon + content |
| Health category | 30 min | Icon + content |
| Card animations | 45 min | Fade in, progress animate |

### Progress Bar Specs
```dart
// Custom progress bar matching design
class HoroscopeProgressBar extends StatelessWidget {
  final double percentage; // 0.0 to 1.0
  final Color color;

  // Specs:
  // - Height: 8dp
  // - Border radius: 4dp
  // - Background: Grey 200
  // - Fill: Category color (animated)
  // - Animation duration: 800ms
}
```

### Category Colors (DRY)
```dart
// lib/app/core/constants/horoscope_constants.dart
class HoroscopeConstants {
  static const loveColor = Color(0xFFE91E63);    // Pink
  static const careerColor = Color(0xFF2196F3);  // Blue
  static const healthColor = Color(0xFF4CAF50);  // Green
}
```

### Acceptance Criteria
- [ ] Three category cards display correctly
- [ ] Progress bars animate on load
- [ ] Percentage shows correctly (0-100%)
- [ ] Prediction text readable and styled
- [ ] Icons match category theme
- [ ] Cards have consistent spacing

---

## Session 4: Horoscope Content & Actions (4 hours)

### Objectives
1. Build full horoscope content section
2. Implement Like functionality
3. Add Share functionality
4. Create lucky numbers/colors section
5. Add daily tip section

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `HoroscopeContent` | Full prediction text |
| Like button | Save to favorites |
| Share button | Share horoscope |
| `LuckySection` | Numbers, colors, time |
| `DailyTip` | Tip of the day |

### Content Layout
```
┌─────────────────────────────────┐
│ Today's Overview                │
│ Lorem ipsum prediction text... │
│                                 │
│ [❤️ Like]  [📤 Share]           │
├─────────────────────────────────┤
│ Lucky Numbers: 3, 7, 12         │
│ Lucky Color: Blue               │
│ Lucky Time: 2:00 PM - 4:00 PM   │
├─────────────────────────────────┤
│ 💡 Tip of the Day               │
│ Focus on communication today... │
└─────────────────────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| HoroscopeContent widget | 45 min | Text display |
| Like functionality | 40 min | Save to favorites |
| Share functionality | 40 min | Share sheet |
| LuckySection widget | 35 min | Numbers, colors |
| DailyTip widget | 30 min | Tip card |
| Action button states | 30 min | Liked/unliked |

### Share Content Format
```dart
String getShareContent(HoroscopeModel horoscope) {
  return '''
✨ ${horoscope.zodiacSign} Horoscope - ${horoscope.period}

${horoscope.overview}

❤️ Love: ${horoscope.lovePercentage}%
💼 Career: ${horoscope.careerPercentage}%
💪 Health: ${horoscope.healthPercentage}%

Lucky Numbers: ${horoscope.luckyNumbers.join(', ')}

📱 Get your daily horoscope on Astro GPT!
''';
}
```

### Acceptance Criteria
- [ ] Full prediction text displays
- [ ] Like button toggles state
- [ ] Liked state persists
- [ ] Share opens native share sheet
- [ ] Lucky section shows all items
- [ ] Tip displays with icon

---

## Session 5: Data Integration & Repository (4 hours)

### Objectives
1. Create HoroscopeRepository
2. Implement Appwrite integration
3. Add mock data fallback
4. Cache horoscope data locally
5. Handle offline scenarios

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `HoroscopeRepository` | Data access layer |
| Appwrite queries | Fetch by sign + period |
| Local caching | Store fetched horoscopes |
| Mock data | Fallback when offline |
| Offline handling | Show cached or error |

### Repository Structure
```dart
class HoroscopeRepository extends BaseRepository<HoroscopeModel> {
  final DatabaseService _db;
  final HoroscopeCache _cache;

  Future<HoroscopeModel?> getHoroscope({
    required String zodiacSign,
    required TimePeriod period,
    DateTime? date,
  });

  Future<List<HoroscopeModel>> getHoroscopeHistory({
    required String zodiacSign,
    required TimePeriod period,
    int limit = 7,
  });

  // Caching
  Future<void> _cacheHoroscope(HoroscopeModel horoscope);
  Future<HoroscopeModel?> _getCachedHoroscope(String key);
}
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| HoroscopeRepository | 60 min | Full repository |
| Appwrite queries | 45 min | Sign + period queries |
| Local cache | 50 min | SharedPreferences cache |
| Mock data service | 40 min | Fallback data |
| Offline handling | 30 min | Error states |
| Cache invalidation | 35 min | Daily refresh logic |

### Caching Strategy
```dart
// Cache key format: horoscope_{sign}_{period}_{date}
// Today: Refresh every 24 hours
// Weekly: Refresh every Monday
// Monthly: Refresh on 1st of month
// Yearly: Refresh on Jan 1st

class HoroscopeCache {
  Future<bool> isExpired(String key);
  Future<void> set(String key, HoroscopeModel data);
  Future<HoroscopeModel?> get(String key);
  Future<void> clear();
}
```

### Acceptance Criteria
- [ ] Horoscope fetches from Appwrite
- [ ] Data caches locally after fetch
- [ ] Cached data loads instantly
- [ ] Cache expires appropriately
- [ ] Offline shows cached or error
- [ ] Mock data works for testing

---

## Session 6: Polish, Testing + Backend Integration (4 hours)

### Objectives
1. Fix AppError.unknown bug in horoscope_repository.dart
2. Create AstrologerRepository for real Appwrite data
3. Replace MockAstrologer in home_controller.dart
4. Add animations and transitions
5. Implement pull-to-refresh
6. Write widget tests

### Key Deliverables

| Deliverable | Description | Type |
|-------------|-------------|------|
| Bug fix | Fix AppError.unknown in horoscope_repository | Backend |
| `AstrologerRepository` | Real Appwrite queries for astrologers | Backend |
| MockAstrologer removal | Replace in home_controller | Refactor |
| Animations | Smooth transitions | Frontend |
| Pull-to-refresh | Refresh horoscope | Frontend |
| Widget tests | All horoscope widgets | Testing |

### Tasks Breakdown
| Task | Duration | Type |
|------|----------|------|
| Fix AppError.unknown bug | 15 min | Bug Fix |
| Create AstrologerRepository | 45 min | Backend |
| Replace MockAstrologer in home_controller | 30 min | Refactor |
| Card animations | 40 min | Frontend |
| Progress animations | 35 min | Frontend |
| Pull-to-refresh | 25 min | Frontend |
| Analytics events | 35 min | Frontend |
| Widget tests | 35 min | Testing |

### Bug Fix: AppError.unknown
```dart
// File: lib/app/data/repositories/horoscope_repository.dart:47
// BEFORE: return Result.failure(AppError.unknown(message: e.toString()));
// AFTER:  return Result.failure(UnknownError(message: e.toString()));
```

### AstrologerRepository Structure
```dart
class AstrologerRepository {
  final IDatabaseService _db;

  Future<Result<List<AstrologerModel>, AppError>> getAstrologers({
    AstrologerCategory? category,
    int limit = 20,
    int offset = 0,
  });

  Future<Result<AstrologerModel, AppError>> getAstrologerById(String id);
  Future<Result<List<AstrologerModel>, AppError>> searchAstrologers(String query);
}
```

### Animations to Add
```dart
// Zodiac card selection
// - Scale down on tap
// - Checkmark fade in

// Progress bars
// - Animate from 0 to value
// - Duration: 800ms
// - Curve: easeOutCubic

// Tab switching
// - Fade transition
// - Duration: 200ms

// Content load
// - Fade in from bottom
// - Staggered delay per section
```

### Analytics Events
```dart
// Track these events:
// - horoscope_view: {sign, period}
// - horoscope_share: {sign, period}
// - horoscope_like: {sign, period}
// - zodiac_selected: {sign}
// - tab_changed: {from, to}
```

### Acceptance Criteria
- [ ] AppError.unknown bug fixed
- [ ] AstrologerRepository created and tested
- [ ] home_controller uses AstrologerModel (not MockAstrologer)
- [ ] Animations feel smooth and natural
- [ ] Pull-to-refresh works correctly
- [ ] Widget tests pass (>80% coverage)

---

## Week 4 Success Metrics

| Metric | Target |
|--------|--------|
| Screen load time | <500ms |
| Animation smoothness | 60fps |
| Cache hit rate | >90% repeat views |
| Widget test coverage | >80% |
| Crash rate | 0% |

## Reusable Components Created

| Component | Reuse Potential |
|-----------|-----------------|
| `ZodiacCard` | Zodiac selection anywhere |
| `ProgressBar` | Any percentage display |
| `CategoryCard` | Any category breakdown |
| `LuckySection` | Daily content sections |
| `TimePeriodTabs` | Any time-based content |

## HoroscopeModel Structure

```dart
class HoroscopeModel {
  final String id;
  final String zodiacSign;
  final TimePeriod period;
  final DateTime date;
  final String overview;

  // Categories
  final int lovePercentage;
  final String lovePrediction;
  final int careerPercentage;
  final String careerPrediction;
  final int healthPercentage;
  final String healthPrediction;

  // Lucky items
  final List<int> luckyNumbers;
  final String luckyColor;
  final String luckyTime;

  // Tip
  final String dailyTip;

  // Metadata
  final DateTime createdAt;
}
```

---

## Notes

### Content Generation (for Appwrite)
- Daily horoscopes should be pre-generated
- Consider using AI to generate content
- Store 7 days ahead for Today
- Store 4 weeks ahead for Weekly
- Monthly/Yearly can be static per sign

### Localization
- All zodiac names in Hindi and English
- Predictions should be bilingual
- Date formats localized
- Numbers localized (Hindi numerals option)
