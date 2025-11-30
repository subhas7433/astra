# Session 3: Home Widgets Part 2 - Detailed Plan

## Objective
Implement the remaining Home Screen widgets: `PanditBanner`, `CategoryChips`, and `AstrologersSection`. These components complete the main Home Screen layout.

## 1. File Structure
We will create the following files in `lib/app/modules/home/widgets/`:

```
lib/app/modules/home/widgets/
├── pandit_banner.dart
├── category_chips.dart
├── astrologers_section.dart
└── astrologer_mini_card.dart
```

## 2. Implementation Steps

### Step 1: PanditBanner
**File:** `lib/app/modules/home/widgets/pandit_banner.dart`
- **Design:**
    - Container with Orange/Yellow background (Gradient?).
    - Row:
        - **Left:** Image of Pandit Ji (Asset or Network).
        - **Right:** Column with Text:
            - "PANDIT JI" (Blue, Bold, Large).
            - "Pandit Ji Astro App - Bharosa bhi, samadhan bhi!" (Black, Small).
    - **Note:** Since we don't have the exact asset, we will use a placeholder image or an Icon for the Pandit.
    - **Colors:** Background `Color(0xFFFF9800)` (Orange) to `Color(0xFFFFB74D)` (Light Orange). Text Blue `Color(0xFF1565C0)`.

### Step 2: CategoryChips
**File:** `lib/app/modules/home/widgets/category_chips.dart`
- **Design:**
    - Horizontal `ListView` of chips.
    - **Items:** "All", "Career", "Life", "Love".
    - **Selected Style:**
        - Background: Light Pink/Red `Color(0xFFFBE9E7)`.
        - Border: Primary `AppColors.primary`.
        - Text: Primary `AppColors.primary`.
    - **Unselected Style:**
        - Background: Tan `AppColors.tan` (or `Color(0xFFD7CCC8)`).
        - Border: None.
        - Text: Black/Brown.
- **Logic:**
    - `selectedCategory` string.
    - `onCategorySelected` callback.

### Step 3: AstrologerMiniCard
**File:** `lib/app/modules/home/widgets/astrologer_mini_card.dart`
- **Design:**
    - Container with `AppColors.primary` (Red/Orange) background.
    - Rounded Corners.
    - **Content:**
        - Row (or Column? Screenshot `uploaded_image_0` shows vertical list of cards? No, "Astrologers" section at bottom shows horizontal list?
        - **Wait**, `uploaded_image_0` shows "Astrologers" header at the bottom, but the list is cut off.
        - `uploaded_image_3` shows "Astrologers" vertical list (Session 4).
        - `uploaded_image_0` shows "Astrologers" header. I will assume it's a **Horizontal List** for the Home Screen (Top Astrologers) and a Vertical List for the "View All" screen.
        - **Card Design (Horizontal):**
            - Similar to `uploaded_image_3` but maybe smaller?
            - Let's stick to the design in `uploaded_image_3` (Red Card):
                - Left: Circular Avatar.
                - Right: Column (Name, Specialty, Rating).
                - Background: Red/Orange `AppColors.primary`.
                - Text: White.

### Step 4: AstrologersSection
**File:** `lib/app/modules/home/widgets/astrologers_section.dart`
- **Design:**
    - `SectionHeader` ("Astrologers", "View All").
    - `CategoryChips` (below header).
    - Vertical List of `AstrologerMiniCard`?
    - **Correction:** `uploaded_image_0` shows "Astrologers" header. `uploaded_image_3` shows the full list.
    - **Home Screen Strategy:**
        - Show `SectionHeader`.
        - Show `CategoryChips`.
        - Show a **Vertical List** (shrinkWrap: true) of top 3-5 astrologers? Or Horizontal?
        - Usually Home screens have Horizontal lists for "Top Astrologers".
        - **However**, the user plan says: "Astrologers Section: Section title... Horizontal scroll of AstrologerMiniCards".
        - **BUT** `uploaded_image_3` looks like the Home Screen scrolled down? Or a separate screen?
        - It has "Astro GPT" header. It has "All, Career..." chips. It has a vertical list.
        - **Hypothesis:** `uploaded_image_3` IS the Home Screen scrolled down.
        - So the "Astrologers" section on Home is actually a **Vertical List** that takes up the rest of the space, or a long list.
        - **Decision:** I will implement it as a **Vertical List** (using `ListView.builder` with `physics: NeverScrollableScrollPhysics` inside the main ScrollView) so it shows all/some astrologers directly on Home.
        - This matches `uploaded_image_3` which shows multiple cards vertically.

## 3. Integration
- Update `HomeScreen` to include `PanditBanner` and `AstrologersSection`.
- Update `HomeController` with mock Astrologer data.

## 4. Verification
- Verify Pandit Banner layout.
- Verify Category Chips selection logic.
- Verify Astrologer Cards rendering (Red background, White text).
