# Astro GPT - Development Patterns & Learnings

## Quick Decision Rules

### Dependencies
- Always check `flutter_localizations` pinned versions before specifying `intl`
- Use `^0.20.2` for intl to match Flutter SDK requirements
- Check `flutter pub outdated` for version conflicts before adding new packages

### External Drives (macOS)
- Run `find . -name "._*" -type f -delete` before commits to remove macOS metadata
- These `._*` files break Dart test runner and analyzer

### Testing
- Always update tests when refactoring app class names
- Use `dotenv.testLoad(fileInput: '...')` in tests to mock environment

---

## Repeated Mistakes to Avoid

### 1. Hardcoded Values
**Wrong:**
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xFFF26B4E),
    borderRadius: BorderRadius.circular(12),
  ),
)
```

**Correct:**
```dart
Container(
  padding: EdgeInsets.all(AppDimensions.cardPadding),
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
  ),
)
```

### 2. Inconsistent Logging
**Wrong:**
```dart
print('Error: $e');
debugPrint('Something happened');
```

**Correct:**
```dart
AppLogger.error('Something failed', error: e, stackTrace: stackTrace);
AppLogger.info('Something happened', tag: 'ServiceName');
```

### 3. Duplicate Validation Logic
**Wrong:**
```dart
// In multiple places
if (email == null || email.isEmpty) return 'Required';
if (!RegExp(r'...').hasMatch(email)) return 'Invalid';
```

**Correct:**
```dart
TextFormField(validator: Validators.email)
```

### 4. Flutter Path Issues
**Wrong:**
```bash
flutter run  # May not be in PATH
```

**Correct:**
```bash
/Users/subhas/Work/flutter/bin/flutter run
```

---

## Successful Patterns

### 1. Feature-Based Folder Structure
```
lib/app/modules/{feature}/
  {feature}_screen.dart
  {feature}_controller.dart
  {feature}_binding.dart
  widgets/
```
- Each feature is self-contained
- Easy to find related files
- Simple to add/remove features

### 2. Centralized Constants
```
lib/app/core/constants/
  app_colors.dart      # All colors
  app_dimensions.dart  # All spacing, radius, sizes
  app_typography.dart  # All text styles
  app_assets.dart      # All asset paths
```
- Single source of truth
- No magic numbers in code
- Easy theme updates

### 3. Base Classes for DRY
```dart
abstract class BaseController extends GetxController {
  final _isLoading = false.obs;
  final _error = Rxn<String>();
  // Common methods...
}

abstract class BaseRepository<T> {
  Future<T> getById(String id);
  Future<List<T>> getAll();
  // Common CRUD...
}

abstract class BaseService {
  Future<T> handleError<T>(Future<T> Function() operation);
}
```

### 4. Extension Methods
```dart
extension StringExtensions on String {
  String get capitalize => ...;
  bool get isValidEmail => ...;
}

extension ContextExtensions on BuildContext {
  double get screenWidth => ...;
  bool get isSmallScreen => ...;
}
```
- Reduce boilerplate
- Improve readability
- Consistent behavior

### 5. Environment-Aware Logging
```dart
class AppLogger {
  static bool get _isDebug => dotenv.env['DEBUG'] == 'true';

  static void debug(String message, {String? tag}) {
    if (_isDebug) _log('DEBUG', message, tag: tag);
  }
}
```
- No debug logs in production
- Structured output with timestamps
- Tag support for filtering

---

## Flutter/Dart Best Practices Used

### 1. Null Safety
- Use `?` for nullable types
- Use `!` only when 100% certain
- Prefer `??` for default values
- Use `?.` for null-safe method calls

### 2. Const Constructors
- Use `const` for widgets when possible
- Improves rebuild performance
- Example: `const SizedBox(height: 16)`

### 3. Named Parameters
- Use named parameters for readability
- Add `required` for mandatory params
- Provide defaults where sensible

### 4. Private by Convention
- Prefix with `_` for private members
- Use `.obs` suffix for GetX observables
- Use `_` prefix for internal methods

---

## GetX Conventions

### Controllers
- Suffix: `*Controller`
- Location: `lib/app/controllers/` or `lib/app/modules/{feature}/`
- Use `final _var = value.obs` for reactive state

### Bindings
- Suffix: `*Binding`
- Location: `lib/app/bindings/`
- Use `Get.lazyPut()` for lazy initialization

### Routes
- Define in `app_routes.dart` as constants
- Configure in `app_pages.dart` with GetPage
- Use named routes: `Get.toNamed(AppRoutes.home)`

---

## Testing Patterns

### Widget Test Setup
```dart
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    dotenv.testLoad(fileInput: '''
APP_ENV=test
DEBUG=true
''');
  });

  testWidgets('description', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Expected'), findsOneWidget);
  });
}
```

### Service Test Pattern (TDD)
```dart
void main() {
  late MockAppwriteClient mockClient;
  late AuthService authService;

  setUp(() {
    mockClient = MockAppwriteClient();
    authService = AuthService(mockClient);
  });

  test('login returns user on success', () async {
    // Arrange
    when(mockClient.createSession(...)).thenAnswer(...);

    // Act
    final result = await authService.login(email, password);

    // Assert
    expect(result, isA<UserModel>());
  });
}
```

---

## Performance Considerations

### 1. Use const
- `const EdgeInsets.all(16)` instead of `EdgeInsets.all(16)`
- Prevents unnecessary rebuilds

### 2. Lazy Loading
- Use `Get.lazyPut()` for services
- Load heavy assets on demand

### 3. Image Caching
- Use `cached_network_image` for network images
- Provide placeholder during load

### 4. List Optimization
- Use `ListView.builder` for long lists
- Consider `ListView.separated` for dividers

---

## Last Updated
November 26, 2025 - Session 1 Complete
