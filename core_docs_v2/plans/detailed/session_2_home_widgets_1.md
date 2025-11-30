# Session 2: Home Widgets Part 1 - Detailed Plan

## Objective
Implement the key interactive widgets for the Home Screen: `TodayMantraCard`, `MostAskedSection`, and `FeatureIconsGrid`. These components will populate the placeholders created in Session 1.

## 1. File Structure
We will create the following files in `lib/app/modules/home/widgets/`:

```
lib/app/modules/home/widgets/
├── today_mantra_card.dart
├── most_asked_section.dart
├── feature_icons_grid.dart
└── section_header.dart (Reusable header for sections)
```

## 2. Implementation Steps

### Step 1: SectionHeader Widget
**File:** `lib/app/modules/home/widgets/section_header.dart`
- A reusable widget for section titles.
- **Props:** `title` (String), `onViewAll` (VoidCallback?, optional).
- **Design:**
    - Row with Text (h3, bold) and optional TextButton ("View All").

### Step 2: TodayMantraCard
**File:** `lib/app/modules/home/widgets/today_mantra_card.dart`
- **Design:**
    - Container with `AppColors.primary` (or a dark blue variant `Color(0xFF1A1A2E)` as per screenshot `uploaded_image_0` which shows "Today Mantra" in a dark pill).
    - **Wait**, looking at `uploaded_image_0`, "Today Mantra" is a dark blue/black pill shape with an icon and a dropdown arrow. It looks like an accordion or a header.
    - **Correction:** The user's plan says "Today's Mantra Card: Gradient background (coral to orange)".
    - Let's look at `uploaded_image_0` again.
        - There is a dark blue header "Today Mantra" with an Om icon and a down arrow.
        - **BUT** the user plan explicitly says: "Today's Mantra Card: Gradient background (coral to orange)... Copy and Share icon buttons".
        - This might refer to the *expanded* state or a specific card *below* the header.
        - **Decision:** I will implement the **Dark Blue Header** as seen in the screenshot, and if expanded, it shows the **Gradient Card**. Or maybe the "Today Mantra" *is* the card.
        - **Let's follow the User Plan** which describes a "Gradient background (coral to orange)".
        - **Wait**, `uploaded_image_0` shows "Most Ask Question" below the dark blue "Today Mantra" bar.
        - **Hypothesis:** The "Today Mantra" bar is an accordion. When expanded, it shows the mantra.
        - **Plan:** Implement `TodayMantraCard` as a **Gradient Card** (as per text plan) but wrapped or triggered by the **Dark Blue Header** (as per screenshot).
        - **Actually**, let's build the **Dark Blue Header** first as `TodayMantraHeader`.
        - **Refined Plan:**
            - `TodayMantraCard`: The dark blue container with "Today Mantra", Icon, and Arrow.
            - It will be an `ExpansionTile` or similar.
            - When expanded, it shows the Mantra text.

### Step 3: MostAskedSection
**File:** `lib/app/modules/home/widgets/most_asked_section.dart`
- **Design:**
    - Title: "Most Ask Question" (h3).
    - Content: Horizontal `ListView`.
    - Items: `AppCard` with Gradient background (Orange/Red).
    - Text: White, medium size.
    - **Data:** List of strings ["Kaunse planets career me...", "Mera career start hoga..."].

### Step 4: FeatureIconsGrid
**File:** `lib/app/modules/home/widgets/feature_icons_grid.dart`
- **Design:**
    - Row of circular icons.
    - Items: Horoscope, Today God, Numerology, History.
    - **Widget:** `Column` (Icon Container + Text).
    - **Icon Container:** Circle, Border/Background.
    - **Images:** Use assets or Icons for now.

## 3. Integration
- Update `HomeScreen` to replace placeholders with these new widgets.

## 4. Verification
- Run the app.
- Verify "Today Mantra" looks like the dark blue bar.
- Verify "Most Ask Question" scrolls horizontally.
- Verify Feature Icons are aligned.
