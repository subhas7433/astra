# Week 1: Foundation Layer - Implementation Sessions
## Astro GPT Flutter App
**Total Duration:** 24 hours (6 sessions x 4 hours)

---

## Executive Summary

### Week 1 Goal
Complete foundation infrastructure ready for feature development in Week 2+

### What We're Building
- Flutter project structure with feature-based architecture
- Centralized constants (DRY principle)
- Theme system with design tokens
- Appwrite service layer (Auth, Database, Storage)
- Core data models
- GetX architecture (routes, bindings, base controllers)
- Reusable base widgets
- Testing infrastructure

### What We're NOT Building
- Home screen UI (Week 2)
- Astrologer features (Week 2)
- Chat system (Week 3)
- Horoscope screens (Week 3)
- Monetization/Ads (Week 5)
- Production deployment (Week 6)

### Architecture Overview
```
lib/
├── main.dart
├── app/
│   ├── core/
│   │   ├── constants/         # Session 2
│   │   ├── theme/             # Session 2
│   │   ├── services/          # Session 3
│   │   └── utils/             # Session 1
│   ├── data/
│   │   ├── models/            # Session 4
│   │   ├── providers/         # Session 3
│   │   └── repositories/      # Session 4
│   ├── modules/               # Week 2+
│   ├── routes/                # Session 5
│   ├── bindings/              # Session 5
│   └── widgets/               # Session 6
└── l10n/                      # Session 2
```

---

## Session 1: Project Setup & Configuration (4 hours)

### Objectives
1. Initialize Flutter project with correct package name
2. Configure pubspec.yaml with all dependencies
3. Set up folder structure (feature-based)
4. Configure environment files (.env)
5. Set up main.dart entry point with GetX

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `pubspec.yaml` | All dependencies: GetX, Appwrite, AdMob, RevenueCat, etc. |
| Folder structure | Complete `lib/app/` architecture |
| `.env` files | Dev/Staging/Prod environment configs |
| `main.dart` | App entry with GetMaterialApp |
| `app/core/utils/` | Logger, validators, helpers |

### Dependencies to Add
```yaml
# State Management
get: ^4.6.6

# Backend
appwrite: ^12.0.0

# Ads & Monetization
google_mobile_ads: ^5.0.0
purchases_flutter: ^6.0.0

# UI
flutter_svg: ^2.0.0
cached_network_image: ^3.3.0
shimmer: ^3.0.0

# Storage
shared_preferences: ^2.2.0
flutter_secure_storage: ^9.0.0

# Utilities
intl: ^0.19.0
flutter_dotenv: ^5.1.0
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Create Flutter project | 15 min | Base project |
| Configure pubspec.yaml | 30 min | All dependencies |
| Create folder structure | 45 min | 15+ directories |
| Environment setup | 30 min | .env files + loader |
| Main.dart + App widget | 60 min | GetMaterialApp configured |
| Utility classes | 60 min | Logger, validators |

### Acceptance Criteria
- [ ] `flutter run` succeeds without errors
- [ ] All dependencies resolve
- [ ] Folder structure matches architecture diagram
- [ ] Environment variables load correctly
- [ ] App launches with placeholder screen

---

## Session 2: Constants & Theme System (4 hours)

### Objectives
1. Create centralized constants (DRY principle)
2. Implement complete theme system
3. Set up design tokens from specifications
4. Configure localization structure (Hindi/English)
5. Create asset management system

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `AppColors` | All colors from design system |
| `AppDimensions` | Spacing, radius, sizes |
| `AppTypography` | Text styles |
| `AppAssets` | Asset path constants |
| `AppTheme` | Complete ThemeData |
| `l10n/` | Localization setup |

### Design Tokens (from specs)
```dart
// Colors
primaryColor: Color(0xFFF26B4E)      // Coral/Orange
backgroundColor: Color(0xFFFFF5F0)   // Peach/Cream
cardColor: Colors.white
textPrimary: Color(0xFF1A1A2E)
textSecondary: Color(0xFF6B7280)

// Dimensions
borderRadius: 12.0
cardPadding: 16.0
screenPadding: 20.0
spacing: 8.0 / 12.0 / 16.0 / 24.0
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| AppColors class | 30 min | All color constants |
| AppDimensions class | 30 min | Spacing, radius constants |
| AppTypography class | 45 min | All text styles |
| AppAssets class | 20 min | Asset path management |
| AppTheme (light) | 60 min | Complete ThemeData |
| Localization setup | 45 min | ARB files structure |
| Asset folders | 30 min | images/, icons/, fonts/ |

### Acceptance Criteria
- [ ] Zero hardcoded colors/dimensions in codebase
- [ ] Theme applies correctly to MaterialApp
- [ ] Text styles cover all use cases
- [ ] Localization structure ready for strings
- [ ] Assets organized and accessible

### DRY Principle Enforcement
```dart
// WRONG - hardcoded values
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xFFF26B4E),
    borderRadius: BorderRadius.circular(12),
  ),
)

// CORRECT - centralized constants
Container(
  padding: EdgeInsets.all(AppDimensions.cardPadding),
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
  ),
)
```

---

## Session 3: Appwrite Service Layer (4 hours)

### Objectives
1. Configure Appwrite SDK client
2. Implement AuthService (login, register, session)
3. Implement DatabaseService (CRUD operations)
4. Implement StorageService (image uploads)
5. Set up error handling for all services

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `AppwriteClient` | Singleton client configuration |
| `AuthService` | Phone/Email auth, session management |
| `DatabaseService` | Generic CRUD for all collections |
| `StorageService` | Image upload/download |
| `AppwriteException` | Custom error handling |

### Appwrite Collections (Reference)
```
- users              # User profiles
- astrologers        # AI persona profiles
- chat_sessions      # Chat session metadata
- messages           # Chat messages
- horoscopes         # Daily/weekly/monthly content
- daily_content      # Mantras, deity content
- reviews            # User reviews
- favorites          # User favorites
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| AppwriteClient singleton | 30 min | Configured client |
| AuthService | 60 min | All auth methods |
| DatabaseService | 60 min | Generic CRUD |
| StorageService | 45 min | Upload/download |
| Error handling | 30 min | Custom exceptions |
| Service tests | 45 min | Unit tests |

### Service Pattern
```dart
// Base service pattern for DRY
abstract class BaseService {
  final AppwriteClient client;
  BaseService(this.client);

  Future<T> handleError<T>(Future<T> Function() operation);
}

// All services extend BaseService
class AuthService extends BaseService { ... }
class DatabaseService extends BaseService { ... }
```

### Acceptance Criteria
- [ ] Appwrite client connects successfully
- [ ] Auth flow works (register/login/logout)
- [ ] Database CRUD operations work
- [ ] Storage upload/download works
- [ ] Errors handled gracefully with user-friendly messages
- [ ] Unit tests pass for all services

---

## Session 4: Core Data Models (4 hours)

### Objectives
1. Create all data models with proper typing
2. Implement JSON serialization (fromJson/toJson)
3. Create repositories for data access patterns
4. Implement model validation
5. Write unit tests for all models

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `UserModel` | User profile with DOB, zodiac, preferences |
| `AstrologerModel` | AI persona with name, specialty, avatar |
| `HoroscopeModel` | Horoscope content with categories |
| `MessageModel` | Chat message with sender, content, timestamp |
| `ChatSessionModel` | Chat session metadata |
| `DailyContentModel` | Mantra and deity content |
| `BaseRepository` | Generic repository pattern |

### Model Structure (Reference)
```dart
// All models follow this pattern
class UserModel {
  final String id;
  final String name;
  final DateTime dob;
  final String zodiacSign;
  final DateTime createdAt;

  // Required methods
  factory UserModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
  UserModel copyWith({...});
}
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| UserModel | 30 min | Complete user model |
| AstrologerModel | 30 min | Astrologer with specialties, tags |
| HoroscopeModel | 40 min | With periods, categories, content |
| MessageModel + ChatSessionModel | 40 min | Chat data structures |
| DailyContentModel | 30 min | Mantra, deity models |
| BaseRepository | 40 min | Generic CRUD repository |
| Model unit tests | 50 min | Tests for all models |

### Repository Pattern (DRY)
```dart
// Generic repository - reused for all collections
abstract class BaseRepository<T> {
  final DatabaseService db;
  final String collectionId;

  Future<T> getById(String id);
  Future<List<T>> getAll({List<String>? queries});
  Future<T> create(T model);
  Future<T> update(String id, T model);
  Future<void> delete(String id);
}

// Specific repositories extend base
class UserRepository extends BaseRepository<UserModel> { ... }
class AstrologerRepository extends BaseRepository<AstrologerModel> { ... }
```

### Acceptance Criteria
- [ ] All models have fromJson/toJson methods
- [ ] All models have copyWith method
- [ ] Repository pattern implemented for all collections
- [ ] Unit tests cover serialization edge cases
- [ ] Null safety properly handled
- [ ] Models match Appwrite collection schemas

---

## Session 5: GetX Architecture & Routing (4 hours)

### Objectives
1. Define all app routes as constants
2. Configure GetPage for each screen
3. Create InitialBinding for global dependencies
4. Implement BaseController with common functionality
5. Set up navigation service with transitions

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `AppRoutes` | All route path constants |
| `AppPages` | GetPage configurations |
| `InitialBinding` | Global dependency injection |
| `BaseController` | Common controller functionality |
| `NavigationService` | Centralized navigation helper |

### Route Definitions (Reference)
```dart
abstract class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const home = '/home';
  static const astrologers = '/astrologers';
  static const astrologerDetail = '/astrologer/:id';
  static const chat = '/chat/:astrologerId';
  static const horoscope = '/horoscope';
  static const horoscopeDetail = '/horoscope/:sign';
  static const todayBhagwan = '/today-bhagwan';
  static const todayMantra = '/today-mantra';
  static const numerology = '/numerology';
  static const settings = '/settings';
  static const profile = '/profile';
}
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| AppRoutes constants | 20 min | All route paths |
| AppPages setup | 45 min | GetPage for each route |
| InitialBinding | 45 min | Global DI setup |
| BaseController | 60 min | Loading, error, common methods |
| NavigationService | 30 min | Navigation helpers |
| Route guards | 40 min | Auth middleware |

### BaseController Pattern (DRY)
```dart
// All controllers extend this
abstract class BaseController extends GetxController {
  final _isLoading = false.obs;
  final _error = Rxn<String>();

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  // Common methods
  void setLoading(bool value);
  void setError(String? message);
  void clearError();

  // Lifecycle hooks
  @override
  void onInit();
  @override
  void onClose();
}
```

### Acceptance Criteria
- [ ] All routes defined as constants (no hardcoded strings)
- [ ] Navigation works between all screens
- [ ] InitialBinding injects all global services
- [ ] BaseController reduces boilerplate in feature controllers
- [ ] Route guards protect authenticated routes
- [ ] Transitions configured for smooth UX

---

## Session 6: Base Widgets & Testing Infrastructure (4 hours)

### Objectives
1. Create reusable UI components (DRY)
2. Implement loading/error/empty states
3. Set up widget testing infrastructure
4. Write tests for all base widgets
5. Create widget documentation

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `AppButton` | Primary, secondary, outline, icon variants |
| `AppCard` | Standard card with configurable shadow |
| `AppTextField` | Input with validation, icons, states |
| `AppAvatar` | Circular image with placeholder/loading |
| `AppChip` | Category/tag chip component |
| `StateWidgets` | Loading, Error, Empty state widgets |
| Widget tests | Tests for all components |

### Widget Variants
```dart
// AppButton variants
AppButton.primary(text: 'Chat Now', onPressed: () {});
AppButton.secondary(text: 'Cancel', onPressed: () {});
AppButton.outline(text: 'View More', onPressed: () {});
AppButton.icon(icon: Icons.share, onPressed: () {});

// AppCard variants
AppCard(child: content);
AppCard.elevated(child: content);  // More shadow
AppCard.outlined(child: content);  // Border instead of shadow

// State widgets
LoadingWidget();
LoadingWidget.fullScreen();
ErrorWidget(message: 'Something went wrong', onRetry: () {});
EmptyWidget(message: 'No data found', icon: Icons.inbox);
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| AppButton (all variants) | 45 min | Reusable button component |
| AppCard | 25 min | Card with shadow/border |
| AppTextField | 40 min | Input with validation |
| AppAvatar | 25 min | Circular image component |
| AppChip | 20 min | Tag/category chip |
| State widgets | 35 min | Loading, Error, Empty |
| Widget tests | 50 min | Tests for all widgets |

### Widget Testing Pattern
```dart
// Test pattern for all widgets
void main() {
  group('AppButton', () {
    testWidgets('renders primary variant correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: AppButton.primary(text: 'Test', onPressed: () {})),
      );
      expect(find.text('Test'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('triggers onPressed callback', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(home: AppButton.primary(text: 'Test', onPressed: () => pressed = true)),
      );
      await tester.tap(find.byType(AppButton));
      expect(pressed, isTrue);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: AppButton.primary(text: 'Test', isLoading: true, onPressed: () {})),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

### Acceptance Criteria
- [ ] All widgets use AppColors, AppDimensions (no hardcoded values)
- [ ] Widgets are fully customizable via parameters
- [ ] Loading states work correctly
- [ ] Error states show retry option
- [ ] Widget tests achieve >90% coverage
- [ ] Widgets documented with usage examples

---

## Week 1 Success Metrics

| Metric | Target |
|--------|--------|
| Flutter analyze | 0 errors, 0 warnings |
| Test coverage | >80% for services |
| Dependencies | All resolve without conflicts |
| App launch | <2 seconds cold start |
| Code reuse | Zero hardcoded values |

## Dependencies for Week 2
Week 2 (Home & Astrologers) depends on:
- [x] Theme system (Session 2)
- [x] Appwrite services (Session 3)
- [x] Data models (Session 4)
- [x] Routing (Session 5)
- [x] Base widgets (Session 6)

---

## Testing Strategy (TDD)

### Unit Tests (Sessions 3-4)
- AuthService: login, register, logout, session
- DatabaseService: create, read, update, delete
- Models: fromJson, toJson, equality

### Widget Tests (Session 6)
- AppButton: tap events, loading state
- AppCard: renders correctly
- AppTextField: validation, error display

### Integration Tests (End of Week)
- Auth flow: register -> login -> home
- Service integration with Appwrite

---

## Notes

### Environment Setup Required
Before starting Session 1:
1. Appwrite project created
2. Collections created (can be empty)
3. Storage bucket created
4. API keys generated

### Commit Strategy
- Commit after each task completion
- Branch: `feature/week1-foundation`
- PR at end of week for review
