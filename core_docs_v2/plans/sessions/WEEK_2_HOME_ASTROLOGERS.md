# Week 2: Home & Astrologers - Implementation Sessions
## Astro GPT Flutter App
**Total Duration:** 24 hours (6 sessions x 4 hours)

---

## Executive Summary

### Week 2 Goal
Complete Home Dashboard and Astrologers feature with full UI implementation

### What We're Building
- Home screen with all sections (from screenshots)
- Today's Mantra card component
- Most Asked Questions section
- Feature icons grid (6 icons)
- Pandit Ji promotional banner
- Category filter chips
- Astrologers horizontal list
- Astrologers full list screen with filters
- Astrologer profile/detail screen
- Controllers for Home and Astrologers

### What We're NOT Building
- Chat functionality (Week 3)
- Horoscope screens (Week 3)
- Today's Bhagwan detail (Week 4)
- Settings/Profile (Week 4)
- Monetization/Ads (Week 5)

### Prerequisites (from Week 1)
- [x] Theme system (AppColors, AppDimensions)
- [x] Appwrite services configured
- [x] Data models (AstrologerModel)
- [x] Base widgets (AppCard, AppButton, AppAvatar)
- [x] Routing infrastructure

---

## Session 1: Home Screen Structure (4 hours)

### Objectives
1. Create Home module folder structure
2. Implement HomeController with data fetching
3. Build Home screen scaffold with AppBar
4. Implement pull-to-refresh functionality
5. Set up HomeBinding for dependency injection

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `home/` module | Complete folder structure |
| `HomeController` | State management, data fetching |
| `HomeBinding` | Dependency injection |
| `HomeScreen` | Scaffold with custom AppBar |
| `HomeAppBar` | Location selector, notification icon |

### Module Structure
```
lib/app/modules/home/
├── bindings/
│   └── home_binding.dart
├── controllers/
│   └── home_controller.dart
├── views/
│   └── home_screen.dart
└── widgets/
    ├── home_app_bar.dart
    ├── today_mantra_card.dart
    ├── most_asked_section.dart
    ├── feature_icons_grid.dart
    ├── pandit_banner.dart
    ├── category_chips.dart
    └── astrologers_section.dart
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Create module folders | 15 min | Folder structure |
| HomeController | 60 min | Data state, fetch methods |
| HomeBinding | 20 min | DI setup |
| HomeScreen scaffold | 45 min | ScrollView structure |
| HomeAppBar widget | 50 min | Location, notifications |
| Pull-to-refresh | 30 min | RefreshIndicator |

### HomeController Structure
```dart
class HomeController extends BaseController {
  // Observables
  final mantraOfDay = Rxn<MantraModel>();
  final featuredAstrologers = <AstrologerModel>[].obs;
  final categories = <String>[].obs;
  final selectedCategory = ''.obs;

  // Repositories
  final AstrologerRepository _astrologerRepo;
  final DailyContentRepository _contentRepo;

  // Methods
  Future<void> fetchHomeData();
  Future<void> refreshHome();
  void onCategorySelected(String category);
}
```

### Acceptance Criteria
- [ ] Home screen loads without errors
- [ ] AppBar displays location and notification icon
- [ ] Pull-to-refresh triggers data reload
- [ ] Loading state shows shimmer/skeleton
- [ ] Error state shows retry option

---

## Session 2: Home Widgets Part 1 (4 hours)

### Objectives
1. Implement Today's Mantra card
2. Build Most Asked Questions section
3. Create Feature Icons grid (6 icons)
4. Add navigation from feature icons
5. Implement shimmer loading states

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `TodayMantraCard` | Gradient card with mantra text, copy/share |
| `MostAskedSection` | Horizontal scrollable question chips |
| `FeatureIconsGrid` | 2x3 grid of feature icons |
| Shimmer variants | Loading states for each widget |

### Widget Specifications (from design)

**Today's Mantra Card:**
- Gradient background (coral to orange)
- White text, centered
- Copy and Share icon buttons
- Border radius: 16dp
- Padding: 20dp

**Most Asked Questions:**
- Horizontal scroll
- Chip style buttons
- Example: "Will I get a job?", "Love life prediction"

**Feature Icons Grid:**
- 2 rows x 3 columns
- Icons: Horoscope, Numerology, Today Bhagwan, Mantra, Kundli, Compatibility
- Circular icon container
- Label below icon

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| TodayMantraCard | 60 min | Complete widget with actions |
| MostAskedSection | 45 min | Horizontal scroll chips |
| FeatureIconsGrid | 60 min | 6 icons with navigation |
| Shimmer loading states | 45 min | Skeleton for each widget |
| Navigation wiring | 30 min | Route to feature screens |

### Acceptance Criteria
- [ ] Mantra card displays correctly with gradient
- [ ] Copy button copies text to clipboard
- [ ] Share button opens share sheet
- [ ] Feature icons navigate to correct screens
- [ ] Shimmer shows while loading

---

## Session 3: Home Widgets Part 2 (4 hours)

### Objectives
1. Build Pandit Ji promotional banner
2. Implement Category filter chips
3. Create Astrologers horizontal section
4. Add "View All" navigation
5. Connect widgets to HomeController

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `PanditBanner` | Promotional card with illustration |
| `CategoryChips` | Horizontal filter chips |
| `AstrologersSection` | Title + horizontal list + View All |
| `AstrologerMiniCard` | Compact card for horizontal list |

### Widget Specifications (from design)

**Pandit Ji Banner:**
- Full width card
- Illustration on right
- "Chat with Pandit Ji" text
- CTA button
- Background: Light gradient or pattern

**Category Chips:**
- Horizontal scroll
- Categories: All, Love, Career, Health, Finance, Family
- Selected state: Primary color fill
- Unselected: Outline style

**Astrologers Section:**
- Section title "Top Astrologers"
- "View All" link on right
- Horizontal scroll of AstrologerMiniCards
- Card: Avatar, Name, Specialty, Rating

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| PanditBanner | 50 min | Promotional widget |
| CategoryChips | 45 min | Filter with selection state |
| AstrologersSection header | 20 min | Title + View All |
| AstrologerMiniCard | 60 min | Compact card design |
| Horizontal list | 30 min | ListView.builder |
| Controller integration | 35 min | Wire up data |

### Acceptance Criteria
- [ ] Banner displays with correct layout
- [ ] Category selection filters astrologers
- [ ] Astrologer cards show correct data
- [ ] "View All" navigates to Astrologers list
- [ ] Horizontal scroll works smoothly

---

## Session 4: Astrologers List Screen (4 hours)

### Objectives
1. Create Astrologers module structure
2. Implement AstrologersController with filtering
3. Build full Astrologers list screen
4. Add search functionality
5. Implement pagination/infinite scroll

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `astrologers/` module | Complete folder structure |
| `AstrologersController` | List state, filtering, search |
| `AstrologersScreen` | Full list with filters |
| `AstrologerCard` | Full-size list card |
| Search & Filter UI | Search bar + category filters |

### Screen Layout (from design)
```
┌─────────────────────────┐
│ ← Astrologers           │  AppBar
├─────────────────────────┤
│ [Search...         🔍]  │  Search bar
├─────────────────────────┤
│ [All][Love][Career]...  │  Category chips
├─────────────────────────┤
│ ┌─────────────────────┐ │
│ │ 👤 Name             │ │  AstrologerCard
│ │ ⭐ 4.8 (120 reviews)│ │
│ │ Specialty tags      │ │
│ │ [Chat Now]          │ │
│ └─────────────────────┘ │
│ ┌─────────────────────┐ │
│ │ ...                 │ │
│ └─────────────────────┘ │
└─────────────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Module structure | 15 min | Folders + files |
| AstrologersController | 60 min | State, filter, search |
| AstrologersBinding | 15 min | DI setup |
| Search bar widget | 30 min | With debounce |
| Category filter bar | 30 min | Reuse CategoryChips |
| AstrologerCard | 50 min | Full card design |
| List with pagination | 40 min | Infinite scroll |

### Controller Features
```dart
class AstrologersController extends BaseController {
  final astrologers = <AstrologerModel>[].obs;
  final filteredAstrologers = <AstrologerModel>[].obs;
  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;
  final isLoadingMore = false.obs;

  void onSearchChanged(String query);
  void onCategoryChanged(String category);
  Future<void> loadMore();
  void _applyFilters();
}
```

### Acceptance Criteria
- [ ] List displays all astrologers
- [ ] Search filters by name
- [ ] Category filters work correctly
- [ ] Infinite scroll loads more
- [ ] Empty state when no results
- [ ] Card tap navigates to profile

---

## Session 5: Astrologer Profile Screen (4 hours)

### Objectives
1. Build Astrologer profile/detail screen
2. Implement hero image with gradient overlay
3. Create bio, tags, and stats sections
4. Build FAQ accordion section
5. Add reviews section with rating summary
6. Implement "Chat Now" sticky button

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `AstrologerDetailScreen` | Full profile screen |
| `AstrologerDetailController` | Profile data, reviews |
| `ProfileHeader` | Hero image, name, rating |
| `ProfileBio` | Bio text with "Read more" |
| `ProfileTags` | Specialty tags |
| `ProfileFAQ` | Expandable FAQ items |
| `ProfileReviews` | Rating summary + review list |
| Sticky Chat Button | Fixed bottom CTA |

### Screen Layout (from design)
```
┌─────────────────────────┐
│ [Hero Image with        │
│  gradient overlay]      │
│  ← Back                 │
│         Pandit Name     │
│         ⭐ 4.8 (120)    │
├─────────────────────────┤
│ Bio text...             │
│ [Read more]             │
├─────────────────────────┤
│ [Love] [Career] [Vedic] │  Tags
├─────────────────────────┤
│ ▼ How accurate are...   │  FAQ
│ ▼ What languages...     │
├─────────────────────────┤
│ Reviews (120)           │
│ ⭐⭐⭐⭐⭐ 4.8           │
│ [Review card]           │
│ [Review card]           │
├─────────────────────────┤
│ [    Chat Now    ]      │  Sticky button
└─────────────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Screen structure | 20 min | CustomScrollView |
| ProfileHeader (hero) | 50 min | Image + gradient + info |
| ProfileBio | 25 min | Expandable text |
| ProfileTags | 20 min | Wrap of chips |
| ProfileFAQ | 45 min | ExpansionTile list |
| ProfileReviews | 50 min | Summary + cards |
| Sticky Chat button | 30 min | Fixed position button |

### Acceptance Criteria
- [ ] Hero image loads with gradient overlay
- [ ] Back button navigates correctly
- [ ] Bio expands on "Read more"
- [ ] FAQ items expand/collapse
- [ ] Reviews show rating summary
- [ ] "Chat Now" navigates to chat (placeholder for Week 3)

---

## Session 6: Integration & Testing (4 hours)

### Objectives
1. Integrate all home widgets in HomeScreen
2. Wire up all navigation flows
3. Add loading and error states
4. Write widget tests for key components
5. Performance optimization (lazy loading)

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| Complete HomeScreen | All sections integrated |
| Navigation flows | Home → Astrologers → Profile → Chat |
| Loading states | Shimmer for all sections |
| Error handling | Error widgets with retry |
| Widget tests | Tests for main components |

### Navigation Flow
```
Home
├── Feature Icons
│   ├── Horoscope → HoroscopeScreen (Week 3)
│   ├── Numerology → NumerologyScreen (Week 4)
│   ├── Today Bhagwan → TodayBhagwanScreen (Week 4)
│   └── ...
├── Pandit Banner → AstrologerDetail (featured)
├── View All Astrologers → AstrologersScreen
│   └── AstrologerCard → AstrologerDetailScreen
│       └── Chat Now → ChatScreen (Week 3)
└── Category Chips → Filter astrologers
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| HomeScreen integration | 45 min | All widgets composed |
| Navigation wiring | 40 min | All routes connected |
| Loading states | 35 min | Shimmer throughout |
| Error states | 30 min | Error + retry |
| Widget tests | 60 min | Key component tests |
| Performance review | 30 min | Lazy loading, const |

### Testing Checklist
```dart
// Key tests to write
- HomeScreen renders all sections
- TodayMantraCard copy/share works
- FeatureIconsGrid navigation
- AstrologersScreen filtering
- AstrologerCard tap navigation
- AstrologerDetailScreen sections render
```

### Acceptance Criteria
- [ ] Home screen fully functional
- [ ] All navigation works correctly
- [ ] No hardcoded strings (use localization keys)
- [ ] No hardcoded colors/dimensions
- [ ] Widget tests pass
- [ ] Smooth scrolling performance

---

## Week 2 Success Metrics

| Metric | Target |
|--------|--------|
| Flutter analyze | 0 errors, 0 warnings |
| Widget test coverage | >70% for new widgets |
| Screen load time | <1 second |
| Scroll performance | 60fps |
| Code reuse | All widgets use base components |

## Reusable Components Created

| Component | Used In |
|-----------|---------|
| `AstrologerMiniCard` | Home, Search results |
| `AstrologerCard` | Astrologers list |
| `CategoryChips` | Home, Astrologers list |
| `RatingStars` | Cards, Profile |
| `ExpandableText` | Bio sections |
| `SectionHeader` | Home sections |

## Dependencies for Week 3
Week 3 (Chat & Horoscope) depends on:
- [x] AstrologerDetailScreen (for Chat entry)
- [x] Feature icons navigation (for Horoscope)
- [x] AstrologerModel with all fields
- [x] Category system

---

## Notes

### Mock Data Strategy
Until Appwrite is populated:
- Use mock JSON files in `assets/mock/`
- MockAstrologerRepository for testing
- Flag to switch: `AppConfig.useMockData`

### Image Handling
- Use `CachedNetworkImage` for all remote images
- Placeholder: Shimmer or icon
- Error: Default avatar icon
- Hero images: Use `fit: BoxFit.cover`

### Accessibility
- All images have semanticLabel
- Buttons have tooltip
- Sufficient color contrast
- Touch targets minimum 48x48dp
