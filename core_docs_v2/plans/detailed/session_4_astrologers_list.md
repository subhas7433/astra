# Session 4: Astrologers List Integration - Detailed Plan

## Objective
Enhance the "Astrologers" section on the Home Screen to function as a fully featured list. This includes refining the card UI to match the "Large Red Card" design, implementing category filtering, and adding pagination support.

**Note:** As per user instruction and screenshots, the Astrologers List is part of the Home Screen, not a separate screen.

## 1. UI Refinements

### Step 1: Refine AstrologerCard
**File:** `lib/app/modules/home/widgets/astrologer_mini_card.dart` (Rename to `astrologer_card.dart`?)
- **Current:** `AstrologerMiniCard` (Red background, Row layout).
- **Refinement (based on `uploaded_image_1`):**
    - The card is quite large and prominent.
    - **Layout:**
        - Background: `AppColors.primary` (Red/Orange).
        - **Left:** Large Circular Avatar (Bordered).
        - **Right:** Column:
            - Name (White, Large, Bold).
            - Specialty (White, Medium).
            - Rating Row (Star Icon, Rating, Review Count).
    - **Action:** The current `AstrologerMiniCard` is actually very close to this. We will verify the sizing and spacing to ensure it looks "Premium" and matches the screenshot.
    - **Update:** Rename to `AstrologerCard` to reflect it's the main card.

### Step 2: Search Bar (Conditional)
- The plan mentions a Search Bar, but `uploaded_image_1` does not show one.
- **Decision:** We will **NOT** add a visible Search Bar in the main layout to stay true to the screenshot. We can add a "Search" icon in the `HomeAppBar` later if needed.

## 2. Logic Implementation

### Step 3: Filtering Logic
**File:** `lib/app/modules/home/controllers/home_controller.dart`
- **State:**
    - `allAstrologers`: List of all loaded astrologers.
    - `filteredAstrologers`: List to display based on category.
- **Method `filterAstrologers(String category)`:**
    - If "All", show all.
    - Else, filter by `specialty` or a `category` field in the model.

### Step 4: Pagination / Infinite Scroll
**File:** `lib/app/modules/home/controllers/home_controller.dart`
- **State:**
    - `isMoreLoading`: Bool for pagination loader.
    - `page`: Int.
- **Method `loadMoreAstrologers()`:**
    - Called when user scrolls near bottom (or via "Load More" button if infinite scroll is tricky in nested view).
    - **Approach:** Since it's a nested list inside a SingleChildScrollView, true infinite scroll detection can be tricky.
    - **Simpler Approach:** "Load More" button at the bottom of the list, OR use a `NotificationListener` on the main scroll view.
    - **Decision:** Use `NotificationListener<ScrollNotification>` in `HomeScreen` to detect bottom and trigger `loadMore`.

## 3. Integration

### Step 5: Update HomeScreen
**File:** `lib/app/modules/home/views/home_screen.dart`
- Wrap body in `NotificationListener`.
- Pass `filteredAstrologers` to `AstrologersSection`.
- Show `CircularProgressIndicator` at bottom if `isMoreLoading` is true.

## 4. Verification
- Verify "All" shows all mock astrologers.
- Verify selecting "Career" filters the list (need mock data with categories).
- Verify scrolling to bottom triggers "Load More" (console log).
