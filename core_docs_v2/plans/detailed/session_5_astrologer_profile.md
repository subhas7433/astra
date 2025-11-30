# Session 5: Astrologer Profile Screen - Detailed Plan

## Objective
Implement the **Astrologer Profile Screen** which displays detailed information about a selected astrologer. This screen features a large profile image, a scrollable info sheet, and a fixed bottom action bar.

## 1. File Structure
We will create a new module `astrologer_profile` to keep it distinct from `home`.

```
lib/app/modules/astrologer_profile/
├── bindings/
│   └── astrologer_profile_binding.dart
├── controllers/
│   └── astrologer_profile_controller.dart
├── views/
│   └── astrologer_profile_view.dart
└── widgets/
    ├── profile_info_sheet.dart
    ├── specialty_chip.dart
    └── review_card.dart
```

## 2. UI Breakdown (Based on `uploaded_image_0`)

### Step 1: Main Layout (`AstrologerProfileView`)
- **Stack Layout:**
    - **Layer 1 (Background):** Large Image of the Astrologer (Top half).
    - **Layer 2 (Foreground):** `ProfileInfoSheet` (Scrollable bottom sheet style container).
    - **Layer 3 (Bottom Bar):** Fixed container at the bottom with "Chat" button and "Heart" icon.

### Step 2: Profile Info Sheet (`ProfileInfoSheet`)
- **Container:** Rounded top corners, Beige/Peach background (`Color(0xFFFFF3E0)` or similar).
- **Content (Column):**
    - **Name:** "Nikki Diwan" (AppTypography.h2, Brown).
    - **Divider:** Thin line.
    - **Description:** Text block describing the astrologer.
    - **Specialty Tags:** Wrap/Row of `SpecialtyChip` (Orange background `Color(0xFFFFCCBC)`, Brown text).
    - **Info Row:** "English", "9.3K Chats" (Boxed containers).
    - **Most Asked Question:** Re-use `MostAskedSection` or similar logic (Header + Gradient Card).
    - **Reviews Section:** "Reviews" Header + Horizontal List of `ReviewCard`.

### Step 3: Review Card (`ReviewCard`)
- **Design:** White rounded card.
- **Content:** Name, Star Rating, Comment ("good").

### Step 4: Bottom Bar
- **Container:** White/Peach background.
- **Chat Button:** Large, Full width (minus padding), Red/Orange Gradient or Solid Color, "Chat" text + Icon.
- **Favorite Icon:** Heart icon (Outline/Filled).

## 3. Logic Implementation

### Step 5: Controller (`AstrologerProfileController`)
- **State:**
    - `astrologer`: Observable `Astrologer` model.
    - `isLoading`: Bool.
    - `isFavorite`: Bool.
- **Methods:**
    - `loadProfile(String id)`: Fetch details (Mock).
    - `toggleFavorite()`: Toggle heart state.
    - `startChat()`: Navigate to Chat screen.

## 4. Navigation
- **Route:** `/astrologer-profile`
- **Arguments:** Pass `astrologerId` or the full `Astrologer` object.
- **Update Home:** `AstrologerCard` onTap -> `Get.toNamed(Routes.ASTROLOGER_PROFILE, arguments: ...)`

## 5. Verification
- Verify Image rendering.
- Verify Scrollable sheet covers the image correctly when scrolled.
- Verify "Chat" button is fixed at the bottom.
