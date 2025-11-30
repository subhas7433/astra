# Session 6: Base Widgets & Testing - Implementation Plan

## Executive Summary

Session 6 focuses on creating a reusable widget library that extracts common patterns from existing screens and implements the component specifications from the TDD. This establishes the UI foundation for all future features.

---

## Context Analysis

### Current State
- **Theme System Complete**: AppColors, AppDimensions, AppTypography, AppDecorations fully implemented
- **Auth Screens Built**: Login/Register screens contain patterns ready for extraction
- **Design Tokens Available**: Spacing (4dp base), border radius (8/12/16dp), typography scale, shadows

### Patterns Identified for Extraction
From login_screen.dart and register_screen.dart:
1. **Loading Indicator** - Used 3 times (buttons + splash)
2. **Error Message Box** - Identical in both auth screens
3. **Primary Button** - Same style in login/register with loading state
4. **Text Input Field** - 3 instances (email, name)
5. **Password Field** - 3 instances with visibility toggle
6. **Auth Navigation Link** - "Don't have account?" / "Already have account?"

### TDD Widget Specifications
Priority widgets from technical specifications:
- Custom buttons (primary, secondary, icon)
- Input fields with consistent styling
- Loading/state indicators
- Error/success message containers
- Cards (standard, elevated)
- Chips (selected/unselected states)
- Avatar component

---

## Session 6 Implementation Plan

### Scope: Balanced (Recommended)

**Focus**: Extract existing patterns + Build essential base widgets
**Estimated Files**: 12-15 new files
**Estimated Duration**: 3-4 hours

---

## File Structure

```
lib/app/widgets/
├── buttons/
│   ├── app_button.dart          # Primary/secondary/text button variants
│   └── icon_button_circle.dart  # Circular icon buttons
├── inputs/
│   ├── app_text_field.dart      # Standard text input
│   └── password_field.dart      # Password with visibility toggle
├── indicators/
│   ├── loading_indicator.dart   # Spinner with variants
│   └── typing_indicator.dart    # Chat typing dots (optional)
├── feedback/
│   ├── error_box.dart           # Error message container
│   └── success_box.dart         # Success message container
├── containers/
│   ├── app_card.dart            # Card variants (standard, elevated, gradient)
│   └── app_chip.dart            # Chip with selected/unselected states
├── display/
│   ├── app_avatar.dart          # Avatar with fallback initials
│   └── zodiac_icon.dart         # Zodiac sign icons (optional)
└── state/
    └── state_widgets.dart       # Loading/empty/error screen states
```

---

## Implementation Breakdown

### Phase 1: Button Components (30 min)

#### 1.1 AppButton (`lib/app/widgets/buttons/app_button.dart`)

**Purpose**: Universal button component with variants

**Variants**:
- `AppButton.primary()` - Filled coral background, white text
- `AppButton.secondary()` - Outlined with coral border
- `AppButton.text()` - Text only, no background

**Features**:
- Loading state with spinner
- Disabled state
- Icon support (leading/trailing)
- Full width by default, shrink option
- 48dp height (matches AppDimensions.buttonHeight)

**Props**:
```dart
AppButton({
  required String label,
  required VoidCallback? onPressed,
  bool isLoading = false,
  bool isDisabled = false,
  IconData? leadingIcon,
  IconData? trailingIcon,
  AppButtonVariant variant = AppButtonVariant.primary,
  bool fullWidth = true,
  double? height,
})
```

#### 1.2 IconButtonCircle (`lib/app/widgets/buttons/icon_button_circle.dart`)

**Purpose**: Circular icon button for actions

**Features**:
- 48x48dp default (meets touch target)
- Customizable colors
- Splash effect

---

### Phase 2: Input Components (45 min)

#### 2.1 AppTextField (`lib/app/widgets/inputs/app_text_field.dart`)

**Purpose**: Standard text input with consistent styling

**Features**:
- Label and hint text
- Prefix/suffix icons
- Error state with message
- Keyboard type configuration
- Text input action
- 12dp border radius
- White fill, primary focus border

**Props**:
```dart
AppTextField({
  String? label,
  String? hint,
  TextEditingController? controller,
  IconData? prefixIcon,
  Widget? suffixIcon,
  String? errorText,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  bool enabled = true,
  ValueChanged<String>? onChanged,
  VoidCallback? onEditingComplete,
})
```

#### 2.2 PasswordField (`lib/app/widgets/inputs/password_field.dart`)

**Purpose**: Password input with visibility toggle

**Features**:
- Built-in visibility toggle
- Reactive visibility state (RxBool support)
- Inherits from AppTextField styling
- Lock icon prefix by default

**Props**:
```dart
PasswordField({
  String label = 'Password',
  String? hint,
  TextEditingController? controller,
  RxBool? visibilityState,
  VoidCallback? onToggleVisibility,
  String? errorText,
})
```

---

### Phase 3: Feedback Components (30 min)

#### 3.1 ErrorBox (`lib/app/widgets/feedback/error_box.dart`)

**Purpose**: Error message display container

**Design**:
- Light red background (10% opacity)
- Red error icon + text
- 8dp border radius
- Supports reactive RxString

**Props**:
```dart
ErrorBox({
  required String message,
  IconData icon = Icons.error_outline,
})

// Reactive version
ErrorBox.reactive({
  required RxString message,
})
```

#### 3.2 SuccessBox (`lib/app/widgets/feedback/success_box.dart`)

**Purpose**: Success message display container

**Design**:
- Light green background (10% opacity)
- Green check icon + text
- Same structure as ErrorBox

---

### Phase 4: Container Components (45 min)

#### 4.1 AppCard (`lib/app/widgets/containers/app_card.dart`)

**Purpose**: Card container with variants

**Variants**:
- `AppCard()` - Standard white card with shadow
- `AppCard.elevated()` - Stronger shadow
- `AppCard.gradient()` - Primary gradient background (coral to light coral)
- `AppCard.outlined()` - Border only, no shadow

**Features**:
- Configurable padding
- Configurable border radius
- onTap callback
- Child widget

**Props**:
```dart
AppCard({
  required Widget child,
  EdgeInsets? padding,
  double? borderRadius,
  VoidCallback? onTap,
  AppCardVariant variant = AppCardVariant.standard,
})
```

#### 4.2 AppChip (`lib/app/widgets/containers/app_chip.dart`)

**Purpose**: Chip for filtering/selection

**States**:
- Selected: Primary border, transparent background
- Unselected: Gray background, no border

**Features**:
- 40dp height
- 8dp border radius
- Icon support (optional)
- onTap callback

**Props**:
```dart
AppChip({
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
  IconData? icon,
})
```

---

### Phase 5: Display Components (30 min)

#### 5.1 AppAvatar (`lib/app/widgets/display/app_avatar.dart`)

**Purpose**: User/astrologer avatar with fallback

**Features**:
- Network image with caching
- Fallback to initials
- Configurable sizes (sm: 36dp, md: 48dp, lg: 80dp)
- Optional border
- Loading shimmer

**Props**:
```dart
AppAvatar({
  String? imageUrl,
  String? name,
  AppAvatarSize size = AppAvatarSize.md,
  bool showBorder = false,
  Color? borderColor,
})
```

---

### Phase 6: State Widgets (30 min)

#### 6.1 StateWidgets (`lib/app/widgets/state/state_widgets.dart`)

**Purpose**: Full-screen state displays

**Widgets**:
- `LoadingView` - Centered spinner with optional message
- `EmptyView` - Icon + message + optional action button
- `ErrorView` - Error icon + message + retry button

**Common Props**:
```dart
LoadingView({String? message})

EmptyView({
  required String message,
  IconData icon = Icons.inbox_outlined,
  String? actionLabel,
  VoidCallback? onAction,
})

ErrorView({
  required String message,
  VoidCallback? onRetry,
})
```

---

### Phase 7: Refactor Existing Screens (30 min)

Replace inline implementations with new widgets:

#### login_screen.dart
- Replace `_buildLoginButton()` with `AppButton.primary()`
- Replace `_buildErrorMessage()` with `ErrorBox.reactive()`
- Replace email TextField with `AppTextField()`
- Replace password TextField with `PasswordField()`

#### register_screen.dart
- Same replacements as login screen
- Replace `_buildRegisterButton()` with `AppButton.primary()`

---

### Phase 8: Testing (60 min)

#### Test Files to Create

```
test/widgets/
├── buttons/
│   └── app_button_test.dart      # ~15 tests
├── inputs/
│   ├── app_text_field_test.dart  # ~12 tests
│   └── password_field_test.dart  # ~10 tests
├── feedback/
│   └── error_box_test.dart       # ~8 tests
├── containers/
│   ├── app_card_test.dart        # ~10 tests
│   └── app_chip_test.dart        # ~8 tests
└── display/
    └── app_avatar_test.dart      # ~10 tests
```

**Test Categories**:
1. **Rendering**: Widget renders correctly
2. **Props**: Props are applied correctly
3. **Variants**: Each variant renders properly
4. **Interactions**: onTap/onPressed work
5. **States**: Loading, disabled, error states
6. **Accessibility**: Semantic labels present

---

## Implementation Order

| Priority | Component | Duration | Dependencies |
|----------|-----------|----------|--------------|
| 1 | AppButton | 20 min | None |
| 2 | AppTextField | 25 min | None |
| 3 | PasswordField | 15 min | AppTextField |
| 4 | ErrorBox/SuccessBox | 20 min | None |
| 5 | AppCard | 25 min | None |
| 6 | AppChip | 15 min | None |
| 7 | AppAvatar | 20 min | None |
| 8 | StateWidgets | 20 min | AppButton |
| 9 | Refactor Screens | 30 min | All widgets |
| 10 | Tests | 60 min | All widgets |

**Total Estimated Time**: 4-5 hours

---

## Verification Checklist

- [ ] `flutter analyze` passes with no issues
- [ ] All widgets use AppColors, AppDimensions, AppTypography
- [ ] All widgets follow Material 3 guidelines
- [ ] Login/Register screens refactored to use new widgets
- [ ] Widget tests pass (~70+ tests)
- [ ] Memory file updated with Session 6 completion

---

## Code Standards

### Widget Naming
- All widgets prefixed with `App` (AppButton, AppCard, etc.)
- Variants as named constructors (AppButton.primary(), AppCard.elevated())

### Documentation
- Each widget has dartdoc comment explaining purpose
- All props documented with `///` comments

### Design Token Usage
- Colors from `AppColors` only
- Spacing from `AppDimensions` only
- Typography from `AppTypography` or `Theme.of(context).textTheme`
- Decorations from `AppDecorations` when applicable

### Testing
- Use `flutter_test` package
- Widget tests with `pumpWidget`
- Golden tests optional (future session)

---

## Files to Create Summary

**New Files (12)**:
1. `lib/app/widgets/buttons/app_button.dart`
2. `lib/app/widgets/buttons/icon_button_circle.dart`
3. `lib/app/widgets/inputs/app_text_field.dart`
4. `lib/app/widgets/inputs/password_field.dart`
5. `lib/app/widgets/feedback/error_box.dart`
6. `lib/app/widgets/feedback/success_box.dart`
7. `lib/app/widgets/containers/app_card.dart`
8. `lib/app/widgets/containers/app_chip.dart`
9. `lib/app/widgets/display/app_avatar.dart`
10. `lib/app/widgets/state/state_widgets.dart`
11. `test/widgets/` (multiple test files)

**Modified Files (2)**:
1. `lib/app/modules/auth/login_screen.dart`
2. `lib/app/modules/auth/register_screen.dart`

---

## Architecture Recommendations

1. **Stateless Widgets**: Most base widgets should be stateless, receiving all state via props
2. **Composition over Inheritance**: Use composition to build complex widgets from simpler ones
3. **Minimal GetX Dependency**: Widgets should work with or without GetX (accept both regular and Rx types)
4. **Theme Awareness**: Use `Theme.of(context)` for dynamic theming support
5. **Accessibility First**: Include Semantics widgets for screen readers

---

## Success Criteria

1. All 10 base widgets implemented and tested
2. Login/Register screens refactored with 50%+ code reduction
3. Widget tests achieve 80%+ coverage
4. `flutter analyze` shows no issues
5. Documentation complete for all public APIs
