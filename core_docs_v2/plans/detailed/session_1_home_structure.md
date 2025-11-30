# Session 1: Home Screen Structure - Detailed Plan

## Objective
Establish the foundational structure for the Home Screen, including the module architecture, state management (Controller), dependency injection (Binding), and the main UI scaffold with a custom AppBar.

## 1. File Structure Setup
Create the following directory structure in `lib/app/modules/home/`:

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
    ├── today_mantra_card.dart      (Placeholder for Session 2)
    ├── most_asked_section.dart     (Placeholder for Session 2)
    ├── feature_icons_grid.dart     (Placeholder for Session 2)
    ├── pandit_banner.dart          (Placeholder for Session 3)
    ├── category_chips.dart         (Placeholder for Session 3)
    └── astrologers_section.dart    (Placeholder for Session 3)
```

## 2. Implementation Steps

### Step 1: HomeBinding
**File:** `lib/app/modules/home/bindings/home_binding.dart`
- Create a class `HomeBinding` extending `Bindings`.
- Override `dependencies()` to lazy put `HomeController`.

### Step 2: HomeController
**File:** `lib/app/modules/home/controllers/home_controller.dart`
- Create `HomeController` extending `GetxController`.
- **Properties:**
    - `isLoading`: RxBool for loading state.
    - `currentLocation`: RxString (Default: "New Delhi, India").
    - `notificationCount`: RxInt (Default: 2).
- **Methods:**
    - `onInit()`: Call `fetchHomeData()`.
    - `fetchHomeData()`: Simulate network delay (2s) and set `isLoading` to false.
    - `refreshHome()`: Re-trigger `fetchHomeData()`.
    - `onNotificationTap()`: Log/Print action.
    - `onLocationTap()`: Log/Print action.

### Step 3: HomeAppBar Widget
**File:** `lib/app/modules/home/widgets/home_app_bar.dart`
- Create a `StatelessWidget` named `HomeAppBar`.
- **Design:**
    - Background: `AppColors.primary` (Red/Orange).
    - Height: Standard toolbar height + extra spacing if needed.
    - **Left:** "Astro GPT" title (White, Bold, Large).
    - **Right:** Settings Icon (White, Hexagon shape as per screenshot).
    - **Note:** The screenshot shows a simplified header "Astro GPT" with a settings icon. The "Location" and "Notification" might be part of a different variant or sub-header, but based on the main "Astro GPT" screenshot (uploaded_image_0), it has a large "Astro GPT" title and a Hexagon Settings icon.
    - **Refinement:** Let's stick to the screenshot `uploaded_image_0`.
        - Title: "Astro GPT" (Center or Left? Looks Centered in one, Left in another. Let's go with Center for "Astro GPT" and Right for Settings).
        - **Correction:** Looking at `uploaded_image_0`, it's a large red header. "Astro GPT" is centered. A Hexagon icon is on the right.
        - **Wait**, `uploaded_image_4` (Chat) shows "Nikki Diwan" in the header.
        - Let's implement the **Home** header specifically.
        - **Layout:**
            - Container with `AppColors.primary`.
            - SafeArea.
            - Row:
                - Expanded -> Center -> Text "Astro GPT" (White, h1).
                - Icon(Icons.hexagon_outlined) (or custom asset) on right.

### Step 4: HomeScreen View
**File:** `lib/app/modules/home/views/home_screen.dart`
- Create `HomeScreen` extending `GetView<HomeController>`.
- **Scaffold:**
    - `backgroundColor`: `AppColors.background` (Cream/Peach).
    - `body`: `RefreshIndicator` wrapping a `SingleChildScrollView`.
    - **Content:**
        - Column:
            - `HomeAppBar()`
            - `SizedBox(height: 20)`
            - *Placeholders for future widgets (Mantra, Questions, etc.)*
            - Text("Home Content Placeholder")

### Step 5: Route Setup
**File:** `lib/app/routes/app_pages.dart` (and `app_routes.dart`)
- Add `Routes.HOME` constant.
- Add `GetPage` for `Routes.HOME` binding `HomeBinding` and `HomeScreen`.
- Set `INITIAL` route to `Routes.HOME` (temporarily for development).

## 3. Verification
- Run the app.
- Verify the "Astro GPT" header appears with the correct primary color.
- Verify the background color matches the design.
- Verify Pull-to-Refresh works (shows indicator).
