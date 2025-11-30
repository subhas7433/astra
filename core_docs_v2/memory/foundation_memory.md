# Foundation Module - Development Memory

## Module Overview
**Module**: Core Foundation (lib/app/core/)
**Purpose**: Shared utilities, constants, theme, and services used across all features
**Status**: Session 1-5 Complete, Session 6 Pending
**Last Updated**: November 26, 2025

---

## Session 1: Project Setup & Configuration

### Date: November 26, 2025
### Duration: ~4 hours
### Status: Complete

#### Objectives Completed
1. Initialize Flutter project with correct package name
2. Configure pubspec.yaml with all dependencies
3. Set up folder structure (feature-based)
4. Configure environment files (.env)
5. Set up main.dart entry point with GetX
6. Create utility classes

#### Files Created

**Utility Classes (lib/app/core/utils/)**

| File | Purpose | Key Features |
|------|---------|--------------|
| `app_logger.dart` | Centralized logging | debug/info/warning/error levels, environment-aware, tag support |
| `validators.dart` | Form validation | email, password, strongPassword, required, name, phone, minLength, maxLength, combine |
| `date_utils.dart` | Date operations | formatDate, formatTime, getRelativeTime, calculateAge, isToday, startOfDay, endOfDay |
| `extensions.dart` | Dart extensions | StringExtensions, ContextExtensions, DateTimeExtensions, ListExtensions, NullableStringExtensions |

**Configuration Files**

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Dependencies: GetX, Appwrite, AdMob, RevenueCat, flutter_svg, cached_network_image, shimmer, etc. |
| `.env` | Environment variables with Appwrite, AdMob placeholders |
| `.env.example` | Template for other developers |
| `.gitignore` | Updated to exclude .env files |

**App Entry**

| File | Purpose |
|------|---------|
| `lib/main.dart` | GetMaterialApp with GetX, env loading, system UI config, placeholder screen |

#### Folder Structure Created

```
lib/app/
  core/
    constants/     # Session 2: AppColors, AppDimensions, AppTypography
    theme/         # Session 2: AppTheme
    services/      # Session 3: BaseService, AppwriteClient
    utils/         # DONE: AppLogger, Validators, DateUtils, Extensions
  data/
    models/        # Session 4: UserModel, AstrologerModel, etc.
    providers/     # Session 3: AppwriteProvider, AdMobProvider
    repositories/  # Session 4: BaseRepository, UserRepository, etc.
  modules/
    splash/        # Week 2+
    auth/          # Week 2+
    home/          # Week 2
    astrologer/    # Week 2
    chat/          # Week 3
    horoscope/     # Week 4
    daily_content/ # Week 5
    settings/      # Week 5
  routes/          # Session 5: AppRoutes, AppPages
  bindings/        # Session 5: InitialBinding, feature bindings
  widgets/         # Session 6: AppButton, AppCard, AppTextField, etc.

assets/
  images/
  icons/zodiac/
  fonts/

l10n/              # Session 2: app_en.arb, app_hi.arb
```

#### Dependencies Added (pubspec.yaml)

```yaml
# State Management
get: ^4.6.6
get_storage: ^2.1.1

# Backend
appwrite: ^12.0.0

# Ads & Monetization
google_mobile_ads: ^5.0.0
purchases_flutter: ^6.0.0

# UI
flutter_svg: ^2.0.10
cached_network_image: ^3.3.1
shimmer: ^3.0.0

# Storage
shared_preferences: ^2.2.3
flutter_secure_storage: ^9.2.2

# Utilities
intl: ^0.20.2  # Note: Must match flutter_localizations pinned version
flutter_dotenv: ^5.1.0

# Localization
flutter_localizations: sdk
```

#### Problems Encountered & Solutions

**Problem 1: intl version conflict**
```
Because every version of flutter_localizations from sdk depends on intl 0.20.2
and astra depends on intl ^0.19.0, flutter_localizations from sdk is forbidden.
```
- **Solution**: Changed `intl: ^0.19.0` to `intl: ^0.20.2`
- **Learning**: Always check flutter_localizations pinned versions before specifying intl

**Problem 2: macOS metadata files**
```
Failed to decode data using encoding 'utf-8', path = 'test/._widget_test.dart'
```
- **Solution**: `find . -name "._*" -type f -delete`
- **Learning**: External drives on macOS create hidden metadata files that break Dart

**Problem 3: Test referencing old class**
```
error: The name 'MyApp' isn't a class
```
- **Solution**: Updated test to use `AstroGptApp` and `dotenv.testLoad()`
- **Learning**: Always update tests when refactoring main app class

---

## Session 2: Constants & Theme System

### Date: November 26, 2025
### Status: Complete

#### Objectives Completed
1. Create centralized color constants (AppColors)
2. Create spacing/sizing constants (AppDimensions)
3. Create typography styles (AppTypography)
4. Create asset path constants (AppAssets)
5. Create animation duration constants (AppDurations)
6. Create Material 3 ThemeData (AppTheme)
7. Create reusable BoxDecorations (AppDecorations)
8. Set up localization with flutter gen-l10n

#### Files Created

**Constants (lib/app/core/constants/)**

| File | Purpose | Key Features |
|------|---------|--------------|
| `app_colors.dart` | All color constants | Primary (#F26B4E), Background (#FFF5F0), 12 zodiac colors, dark theme prep |
| `app_dimensions.dart` | Spacing/sizing | 4dp base spacing (xxs=4 to xxl=32), radius (8/12/16/24), component heights |
| `app_typography.dart` | Text styles | h1-h3, body1-2, caption, button, chip with white variants |
| `app_assets.dart` | Asset paths | Images, icons, zodiacIcon() helper method |
| `app_durations.dart` | Animation timing | fastest=100ms to slow=400ms, specific use case durations |

**Theme (lib/app/core/theme/)**

| File | Purpose | Key Features |
|------|---------|--------------|
| `app_theme.dart` | ThemeData config | Material 3, light theme complete, dark theme prepared |
| `app_decorations.dart` | BoxDecorations | Cards, chat bubbles, chips, progress bars, shadows |

**Localization**

| File | Purpose |
|------|---------|
| `l10n.yaml` | Localization configuration |
| `l10n/app_en.arb` | English strings (~10) |
| `l10n/app_hi.arb` | Hindi strings (~10) |
| `lib/generated/` | Auto-generated localization classes |

#### Design Tokens Implemented

```dart
// Colors
AppColors.primary = Color(0xFFF26B4E)      // Coral/Orange
AppColors.background = Color(0xFFFFF5F0)   // Peach/Cream
AppColors.surface = Color(0xFFFFFFFF)      // White
AppColors.textPrimary = Color(0xFF2D2D2D)
AppColors.textSecondary = Color(0xFF757575)

// Spacing (4dp base)
AppDimensions.xxs = 4.0
AppDimensions.xs = 8.0
AppDimensions.sm = 12.0
AppDimensions.md = 16.0
AppDimensions.lg = 20.0
AppDimensions.xl = 24.0
AppDimensions.xxl = 32.0

// Border Radius
AppDimensions.radiusSm = 8.0
AppDimensions.radiusMd = 12.0
AppDimensions.radiusLg = 16.0
```

#### Problems Encountered & Solutions

**Problem 1: CardTheme type error**
```
error: The argument type 'CardTheme' can't be assigned to the parameter type 'CardThemeData?'
```
- **Solution**: Changed `CardTheme(...)` to `CardThemeData(...)`
- **Learning**: Flutter SDK uses `CardThemeData` class name

**Problem 2: Deprecated l10n option**
```
l10n.yaml: The argument "synthetic-package" no longer has any effect
```
- **Solution**: Removed `synthetic-package: false` from l10n.yaml
- **Learning**: Check Flutter deprecation warnings for l10n options

---

## Session 3: Appwrite Service Layer

### Date: November 26, 2025
### Status: Complete

#### Objectives Completed
1. Create Result<T, E> sealed class for explicit error handling
2. Create typed AppError hierarchy (AuthError, DatabaseError, StorageError, NetworkError)
3. Configure Appwrite SDK client with environment-based configuration
4. Implement service interfaces (IAuthService, IDatabaseService, IStorageService)
5. Implement real Appwrite services extending GetxService
6. Implement mock services for testing/offline development
7. Create ServiceLocator for dependency injection
8. Create InitialBinding for GetX
9. Unit tests for mock services (55 tests)

#### Architecture Decisions Made

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Service Pattern | GetxService | Lifecycle management with Get.put/Get.find, reactive state ready |
| Error Handling | Result<T, E> sealed class | Explicit success/failure, no exception overhead, compile-time safety |
| Testing Strategy | Comprehensive (Interfaces + Mocks) | Full offline testing, dependency injection, TDD support |

#### Files Created

**Result Types (lib/app/core/result/)**

| File | Lines | Purpose |
|------|-------|---------|
| `result.dart` | 85 | Result<T, E> sealed class with Success/Failure, map, fold, getOrElse |
| `app_error.dart` | 305 | Typed error hierarchy (Auth, Database, Storage, Network errors) |

**Appwrite Configuration (lib/app/core/config/)**

| File | Lines | Purpose |
|------|-------|---------|
| `appwrite_config.dart` | 55 | Environment-based configuration loader |
| `appwrite_collections.dart` | 35 | Collection ID constants |
| `appwrite_buckets.dart` | 24 | Bucket ID constants |

**Service Interfaces (lib/app/core/services/interfaces/)**

| File | Lines | Purpose |
|------|-------|---------|
| `i_auth_service.dart` | 103 | Auth contract (register, login, logout, session) |
| `i_database_service.dart` | 156 | CRUD contract with QueryOptions, PaginatedResult |
| `i_storage_service.dart` | 130 | File operations contract (upload, download, preview) |

**Service Implementations (lib/app/core/services/impl/)**

| File | Lines | Purpose |
|------|-------|---------|
| `appwrite_auth_service.dart` | 320 | Real auth with GetxService, exception mapping |
| `appwrite_database_service.dart` | 325 | Real CRUD with GetxService |
| `appwrite_storage_service.dart` | 320 | Real storage with GetxService |

**Mock Services (lib/app/core/services/mock/)**

| File | Lines | Purpose |
|------|-------|---------|
| `mock_auth_service.dart` | 270 | In-memory auth with forceError support |
| `mock_database_service.dart` | 220 | In-memory CRUD with seedCollection |
| `mock_storage_service.dart` | 250 | In-memory files with forceError support |

**Dependency Injection**

| File | Lines | Purpose |
|------|-------|---------|
| `service_locator.dart` | 120 | Factory for real/mock service registration |
| `initial_binding.dart` | 25 | GetX initial binding placeholder |

**Tests**

| File | Tests | Purpose |
|------|-------|---------|
| `test/core/result/result_test.dart` | 15 | Result and AppError tests |
| `test/core/services/mock_auth_service_test.dart` | 22 | Auth service tests |
| `test/core/services/mock_database_service_test.dart` | 18 | Database service tests |

**Total New Code**: ~1,200 lines (14 files + 3 test files)

#### Problems Encountered & Solutions

**Problem 1: AppError constructor signatures mismatched**
```
error: The named parameter 'message' isn't defined
error: 1 positional argument expected by 'DocumentNotFoundError.new', but 0 found
```
- **Root Cause**: Original error classes had specific positional parameters (e.g., `DocumentNotFoundError(documentId)`), but service implementations used named `message` parameter
- **Solution**: Rewrote all error classes with flexible named parameters and default messages
- **Files**: `lib/app/core/result/app_error.dart`

**Problem 2: ImageGravity enum not found**
```
error: Undefined class 'ImageGravity'
```
- **Root Cause**: Appwrite SDK 12.0.1 may not export ImageGravity from main package
- **Solution**: Added `import 'package:appwrite/enums.dart'` and simplified storage service
- **Files**: `lib/app/core/services/impl/appwrite_storage_service.dart`

**Problem 3: AppLogger using dotenv in tests**
```
Instance of 'NotInitializedError'
package:flutter_dotenv/src/dotenv.dart 41:7 DotEnv.env
```
- **Root Cause**: AppLogger._isDebug accessed dotenv.env which throws if not initialized (tests don't load .env)
- **Solution**: Wrapped dotenv access in try/catch, default to `true` in tests
- **Files**: `lib/app/core/utils/app_logger.dart`

**Problem 4: macOS metadata files (recurring)**
- **Problem**: `._*` files on external drive causing UTF-8 decode errors
- **Solution**: `find test -name '._*' -delete` before running tests
- **Learning**: Always clean before testing on external volumes

#### Code Patterns Established

**Result Pattern**
```dart
Future<Result<String, AppError>> loginWithEmail({
  required String email,
  required String password,
}) async {
  try {
    // ... Appwrite call
    return Result.success(userId);
  } on AppwriteException catch (e, stack) {
    return Result.failure(_mapAppwriteException(e, stack));
  }
}

// Usage
final result = await authService.loginWithEmail(...);
result.fold(
  onSuccess: (userId) => navigateToHome(),
  onFailure: (error) => showError(error.message),
);
```

**Service Interface Pattern**
```dart
abstract interface class IAuthService {
  String? get currentUserId;
  Stream<String?> get authStateChanges;
  Future<Result<String, AppError>> loginWithEmail({...});
  void dispose();
}
```

**Mock with forceError Pattern**
```dart
class MockAuthService implements IAuthService {
  bool forceError = false;
  AppError? forcedError;

  @override
  Future<Result<String, AppError>> loginWithEmail({...}) async {
    if (forceError) {
      return Result.failure(forcedError ?? const NetworkError());
    }
    // ... normal logic
  }
}
```

**ServiceLocator Pattern**
```dart
// Initialize in main.dart
await ServiceLocator.init(useMocks: false);

// Access anywhere
final authService = Get.find<IAuthService>();
// or
final authService = ServiceLocator.auth;
```

#### Verification Results
- `flutter analyze`: No issues found
- `flutter test test/core/`: 55 tests passed
- All mock services working with forceError testing support

---

## Session 4: Core Data Models

### Date: November 26, 2025
### Status: Complete

#### Objectives Completed
1. Create core model infrastructure (ModelUtils, ModelExtensions, BaseModel)
2. Create 7 type-safe enums for domain types
3. Create 6 data models with Appwrite serialization
4. Implement Result-based validation for all models
5. Comprehensive test coverage (~210 tests)

#### Architecture Decisions Made

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Model Pattern | Equatable + copyWith | Value equality, immutability, easy state management |
| Serialization | fromMap/toMap | Direct Appwrite document compatibility, handles $prefixed fields |
| Validation | Result<void, AppError> | Consistent with Session 3 error handling, explicit failure cases |
| Enums | Type-safe with extensions | Compile-time safety, display names, Hindi names, parsing utilities |

#### Files Created

**Core Infrastructure (lib/app/data/models/core/)**

| File | Lines | Purpose |
|------|-------|---------|
| `model_utils.dart` | 95 | Centralized serialization helpers (extractId, parseDateTime, parseInt, etc.) |
| `model_extensions.dart` | 105 | Map & DateTime extensions for Appwrite parsing |
| `base_model.dart` | 45 | Abstract base class with Equatable (not actively used, kept for future) |

**Enums (lib/app/data/models/enums/)**

| File | Lines | Purpose |
|------|-------|---------|
| `zodiac_sign.dart` | 95 | 12 zodiac signs with Hindi names, symbols, date ranges, elements |
| `period_type.dart` | 50 | daily/weekly/monthly/yearly with days calculation |
| `horoscope_category.dart` | 48 | love/career/health with icons |
| `sender_type.dart` | 34 | user/astrologer for chat messages |
| `content_type.dart` | 42 | mantra/deity for daily content |
| `gender.dart` | 39 | male/female/other with Hindi names |
| `astrologer_category.dart` | 45 | all/career/life/love for filtering |

**Data Models (lib/app/data/models/)**

| File | Lines | Tests | Purpose |
|------|-------|-------|---------|
| `user_model.dart` | 165 | 34 | User profile with DOB, zodiac, language preference |
| `astrologer_model.dart` | 245 | 39 | AI astrologer with rating, tags, persona prompt |
| `horoscope_model.dart` | 195 | 32 | Prediction with Hindi text, energy level, validity |
| `message_model.dart` | 135 | 31 | Chat message with sender type, read status |
| `chat_session_model.dart` | 175 | 36 | Session with message count, activity tracking |
| `daily_content_model.dart` | 195 | 38 | Mantra/deity with bilingual support, media URLs |

**Tests (test/core/data/models/)**

| File | Tests | Purpose |
|------|-------|---------|
| `user_model_test.dart` | 34 | Constructor, fromMap, toMap, validate, copyWith, computed properties |
| `astrologer_model_test.dart` | 39 | Full CRUD testing, URL validation, formatted counts |
| `horoscope_model_test.dart` | 32 | Language fallback, energy levels, validity checking |
| `message_model_test.dart` | 31 | Sender type, preview, relative time |
| `chat_session_model_test.dart` | 36 | Session operations, activity tracking |
| `daily_content_model_test.dart` | 38 | Bilingual content, media URLs |

**Total New Code**: ~1,700 lines (17 files) + 800 lines tests (6 test files)
**Total Tests**: ~210 tests (all passing)

#### Model Features Summary

| Model | Key Features |
|-------|--------------|
| UserModel | Auto zodiac from DOB, age calculation, initials, language preference |
| AstrologerModel | Formatted counts (1.5k), URL validation, expertise tags, AI persona |
| HoroscopeModel | Bilingual getPrediction(), energy description, validity by period |
| MessageModel | Preview truncation, relative time, formatted time |
| ChatSessionModel | recordNewMessage(), deactivate/reactivate, activity tracking |
| DailyContentModel | Bilingual getTitle/getDescription(), media presence checks |

#### Problems Encountered & Solutions

**Problem 1: Unused import warning**
```
warning: Unused import: 'core/model_utils.dart'
```
- **Solution**: Removed unused import from user_model.dart
- **Learning**: Model extensions provide all needed parsing, ModelUtils only needed for edge cases

**Problem 2: macOS metadata files (recurring)**
```
Failed to decode data using encoding 'utf-8', path = 'test/core/data/models/._user_model_test.dart'
```
- **Solution**: `find test/core/data/models -name '._*' -delete`
- **Learning**: External drives on macOS need cleanup before test runs

**Problem 3: Result.fold signature**
```
error: Too many positional arguments: 0 allowed, but 2 found
```
- **Root Cause**: Tests used positional arguments instead of named parameters
- **Solution**: Changed `result.fold((v) => ..., (e) => ...)` to use `result.errorOrNull?.message`
- **Learning**: Result.fold uses named parameters: `onSuccess:` and `onFailure:`

#### Code Patterns Established

**Model fromMap Pattern**
```dart
factory UserModel.fromMap(Map<String, dynamic> map) {
  return UserModel(
    id: map.appwriteId,
    email: map.getString('email'),
    dateOfBirth: map.getDateTime('dateOfBirth') ?? DateTime.now(),
    gender: Gender.fromString(map.getString('gender')) ?? Gender.other,
    createdAt: map.appwriteCreatedAt ?? DateTime.now(),
  );
}
```

**Model Validation Pattern**
```dart
Result<void, AppError> validate() {
  if (id.isEmpty) {
    return Result.failure(
      const ValidationError(message: 'User ID is required'),
    );
  }
  // ... more validations
  return const Result.success(null);
}
```

**Enum with fromString Pattern**
```dart
enum ZodiacSign {
  aries, taurus, ...;

  static ZodiacSign? fromString(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return ZodiacSign.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}
```

**Bilingual Content Pattern**
```dart
String getTitle({bool hindi = false}) {
  if (hindi && titleHi != null && titleHi!.isNotEmpty) {
    return titleHi!;
  }
  return title;
}
```

#### Verification Results
- `flutter analyze`: No issues found
- `flutter test test/core/data/models/`: ~210 tests passed
- All models follow consistent patterns

---

## Session 5: GetX Architecture & Routing

### Date: November 26, 2025
### Status: Complete

#### Objectives Completed
1. Create route constants (AppRoutes) for type-safe navigation
2. Create BaseController with ViewState management pattern
3. Create GetPage definitions (AppPages) with transitions and bindings
4. Implement Splash module (controller, screen, binding)
5. Implement Auth module (controller, login/register screens, binding)
6. Update main.dart with GetX routing configuration
7. Comprehensive test coverage (84 tests, 82 passing)

#### Architecture Decisions Made

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Route Pattern | Centralized constants | Type-safe navigation, easy refactoring, parameterized route helpers |
| Controller Pattern | BaseController with ViewState | Consistent state management, Result integration, lifecycle logging |
| Binding Pattern | Lazy injection with Get.lazyPut | On-demand instantiation, memory efficient |
| Page Transitions | Configurable per-route | Fade for auth flow, rightToLeft for details |

#### Files Created

**Routes (lib/app/routes/)**

| File | Lines | Purpose |
|------|-------|---------|
| `app_routes.dart` | 78 | Route constants (splash, login, register, home, etc.) with parameterized helpers |
| `app_pages.dart` | 278 | GetPage definitions for all routes with bindings and transitions |

**Controllers (lib/app/controllers/)**

| File | Lines | Purpose |
|------|-------|---------|
| `base_controller.dart` | 207 | Abstract base with ViewState enum, setLoading/setLoaded/setError, executeWithState |

**Splash Module (lib/app/modules/splash/)**

| File | Lines | Purpose |
|------|-------|---------|
| `splash_controller.dart` | 68 | Auth check on startup, navigation to home/login |
| `splash_screen.dart` | 85 | Animated splash with logo and loading indicator |

**Auth Module (lib/app/modules/auth/)**

| File | Lines | Purpose |
|------|-------|---------|
| `auth_controller.dart` | 229 | Login/register logic, form validation, navigation |
| `login_screen.dart` | 203 | Email/password form with error display, register link |
| `register_screen.dart` | 251 | Full registration form with password confirmation |

**Bindings (lib/app/bindings/)**

| File | Lines | Purpose |
|------|-------|---------|
| `splash_binding.dart` | 15 | Lazy injection of SplashController |
| `auth_binding.dart` | 15 | Lazy injection of AuthController |

**Tests**

| File | Tests | Purpose |
|------|-------|---------|
| `test/routes/app_routes_test.dart` | 20 | Route constants, helpers, uniqueness |
| `test/controllers/base_controller_test.dart` | 24 | ViewState, executeWithState, handleResult |
| `test/modules/splash/splash_controller_test.dart` | 11 | Auth check, navigation routes |
| `test/modules/auth/auth_controller_test.dart` | 29 | Login/register validation, form state |

**Total New Code**: ~1,100 lines (10 files) + 400 lines tests (4 test files)
**Total Tests**: 84 tests (82 passing, 2 skipped due to GetX isolation in parallel runs)

#### Key Code Patterns Established

**Route Constants Pattern**
```dart
abstract class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String astrologerProfile = '/astrologer/:id';

  // Parameterized route helpers
  static String astrologerProfileWithId(String id) => '/astrologer/$id';
}
```

**BaseController Pattern**
```dart
enum ViewState { initial, loading, loaded, error }

abstract class BaseController extends GetxController {
  final Rx<ViewState> viewState = ViewState.initial.obs;
  final RxString errorMessage = ''.obs;

  bool get isLoading => viewState.value == ViewState.loading;
  bool get hasError => viewState.value == ViewState.error;

  Future<T?> executeWithState<T>({
    required Future<Result<T, AppError>> Function() operation,
    void Function(T value)? onSuccess,
    void Function(AppError error)? onError,
  }) async {
    setLoading();
    try {
      final result = await operation();
      return result.fold(
        onSuccess: (value) { setLoaded(); onSuccess?.call(value); return value; },
        onFailure: (error) { setError(error.message); onError?.call(error); return null; },
      );
    } catch (e) {
      setError(e.toString());
      return null;
    }
  }
}
```

**GetPage Definition Pattern**
```dart
GetPage(
  name: AppRoutes.login,
  page: () => const LoginScreen(),
  binding: AuthBinding(),
  transition: Transition.fadeIn,
  transitionDuration: const Duration(milliseconds: 250),
),
```

**Binding Pattern**
```dart
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
```

#### Problems Encountered & Solutions

**Problem 1: withOpacity deprecated**
```
warning: 'withOpacity' is deprecated. Use withValues.
```
- **Solution**: Changed `color.withOpacity(0.1)` to `color.withValues(alpha: 0.1)`
- **Files**: login_screen.dart, register_screen.dart, app_pages.dart

**Problem 2: surfaceVariant undefined**
```
error: The getter 'surfaceVariant' isn't defined for the type 'AppColors'
```
- **Solution**: Changed `AppColors.surfaceVariant` to `AppColors.chipBackground`
- **Files**: app_pages.dart

**Problem 3: HTML in doc comments**
```
info: Angle brackets will be interpreted as HTML
```
- **Solution**: Removed generic type notation `<T, E>` from doc comments
- **Files**: base_controller.dart

**Problem 4: GetX test isolation**
```
LateInitializationError: Field '_authService' has already been initialized
```
- **Root Cause**: `Get.put()` automatically calls `onInit()`, calling it again manually causes double-initialization
- **Solution**: Removed manual `controller.onInit()` calls in tests, use `Get.reset()` in tearDown
- **Learning**: GetX controllers initialize automatically via `Get.put()`

#### Verification Results
- `flutter analyze`: No issues found
- `flutter test test/routes/ test/controllers/ test/modules/`: 82/84 tests passed (2 skipped due to parallel execution isolation)
- Navigation flow working: Splash -> Auth check -> Login/Home

---

## Upcoming Sessions

### Session 6: Base Widgets & Testing
**Files to Create:**
- `lib/app/widgets/app_button.dart`
- `lib/app/widgets/app_card.dart`
- `lib/app/widgets/app_text_field.dart`
- `lib/app/widgets/app_avatar.dart`
- `lib/app/widgets/app_chip.dart`
- `lib/app/widgets/state_widgets.dart`

---

## Code Patterns

### Logging Pattern
```dart
AppLogger.debug('Debug message', tag: 'ServiceName');
AppLogger.info('Info message');
AppLogger.error('Error occurred', error: e, stackTrace: stackTrace);
```

### Validation Pattern
```dart
TextFormField(
  validator: Validators.email,
)

// Combine validators
TextFormField(
  validator: Validators.combine([
    Validators.required,
    Validators.minLength(3),
  ]),
)
```

### Date Formatting Pattern
```dart
AppDateUtils.formatDate(date); // "26 Nov 2025"
AppDateUtils.getRelativeTime(date); // "2 hours ago"
AppDateUtils.calculateAge(birthDate); // 25
```

### Extension Usage Pattern
```dart
// String
'hello'.capitalize; // "Hello"
'hello world'.capitalizeWords; // "Hello World"
'test@email.com'.isValidEmail; // true

// Context
context.screenWidth;
context.isSmallScreen;
context.theme;

// DateTime
DateTime.now().isToday; // true
date.startOfDay;
```
