# Frontend UI Specifications
## Astro GPT - Screen-by-Screen Design Guide

**Version:** 1.0
**Date:** November 25, 2025

---

## 1. DESIGN SYSTEM

### 1.1 Color Palette

```dart
// Primary Colors
primary:          #F26B4E  // Coral/Orange - Main brand color
primaryLight:     #FF8A70  // Light coral - Hover states
primaryDark:      #D84A30  // Dark coral - Pressed states

// Background Colors
background:       #FFF5F0  // Peach/Cream - App background
surface:          #FFFFFF  // White - Cards, inputs
cardBackground:   #FAE5DC  // Light peach - Horoscope cards

// Text Colors
textPrimary:      #2D2D2D  // Near black - Headings
textSecondary:    #757575  // Gray - Subtext
textOnPrimary:    #FFFFFF  // White - Text on primary

// Accent Colors
success:          #4CAF50  // Green - Watch Ad button
error:            #E53935  // Red - Remove Ads, warnings

// Gradient (Astrologer Cards)
gradientStart:    #F26B4E
gradientEnd:      #FF8A70
```

### 1.2 Typography

```dart
// Font Family: Default system font (San Francisco / Roboto)

// Headings
h1: 24sp, FontWeight.bold    // Screen titles
h2: 20sp, FontWeight.w600    // Section titles
h3: 18sp, FontWeight.w600    // Card titles

// Body
body1: 16sp, FontWeight.normal    // Primary text
body2: 14sp, FontWeight.normal    // Secondary text
caption: 12sp, FontWeight.normal  // Timestamps, labels

// Special
button: 16sp, FontWeight.w600     // Button text
chip: 14sp, FontWeight.w500       // Chip labels
```

### 1.3 Spacing System

```dart
// Base unit: 4dp

xxs:  4dp   // Minimal spacing
xs:   8dp   // Tight spacing
sm:   12dp  // Small spacing
md:   16dp  // Medium spacing (default)
lg:   20dp  // Large spacing
xl:   24dp  // Extra large
xxl:  32dp  // Section spacing
```

### 1.4 Border Radius

```dart
small:   8dp   // Chips, small buttons
medium:  12dp  // Cards, inputs
large:   16dp  // Message bubbles
full:    50%   // Circular avatars
```

### 1.5 Shadows

```dart
// Card Shadow
elevation1: BoxShadow(
  color: Color(0x0D000000),  // 5% black
  blurRadius: 8,
  offset: Offset(0, 2),
)

// Elevated Shadow
elevation2: BoxShadow(
  color: Color(0x1A000000),  // 10% black
  blurRadius: 16,
  offset: Offset(0, 4),
)
```

---

## 2. SCREEN 1: HOME DASHBOARD

### 2.1 App Bar

```
+--------------------------------------------------+
|  11:11                              86%          | <- Status Bar
+--------------------------------------------------+
|              Astro GPT              [Settings]   | <- App Bar
+--------------------------------------------------+

Specifications:
- Height: 56dp (excluding status bar)
- Background: #F26B4E (primary)
- Title: "Astro GPT", 20sp, white, centered
- Settings Icon: 24x24dp, white, right aligned
- Padding: 16dp horizontal
```

### 2.2 Today Mantra Section

```
+--------------------------------------------------+
| [Om] Today Mantra                          [v]   |
+--------------------------------------------------+

Specifications:
- Container: Full width, rounded corners (12dp)
- Background: #2D2D2D (dark)
- Height: 56dp
- Padding: 16dp horizontal, 12dp vertical
- Om Icon: 28x28dp, orange (#F26B4E)
- Text: "Today Mantra", 16sp, white
- Dropdown Arrow: 20x20dp, white, right aligned
- Margin: 16dp horizontal, 16dp top
```

### 2.3 Most Ask Question Section

```
+--------------------------------------------------+
| Most Ask Question                                |
+--------------------------------------------------+
| +------------------+ +------------------+        |
| | Kaunse planets   | | Mera career     |        |
| | career me madad  | | start hoga?     |        |
| | karenge?         | |                 |        |
| +------------------+ +------------------+        |
+--------------------------------------------------+

Specifications:
Section Title:
- Text: "Most Ask Question", 18sp, #2D2D2D, bold
- Margin: 16dp top, 16dp horizontal

Question Cards:
- Width: 200dp
- Height: 100dp
- Background: Linear gradient (#F26B4E to #FF8A70)
- Border Radius: 12dp
- Padding: 16dp
- Text: 14sp, white
- Horizontal Scroll: true
- Gap between cards: 12dp
- Margin: 12dp top
```

### 2.4 Feature Icons Row

```
+--------------------------------------------------+
| [Horoscope] [Today God] [Numerology] [History]   |
+--------------------------------------------------+

Specifications:
Container:
- Horizontal scroll
- Margin: 24dp top
- Padding: 16dp horizontal

Feature Icon Item:
- Width: 80dp
- Gap: 16dp
- Alignment: Center

Icon Container:
- Size: 64x64dp
- Background: Circular image/icon
- Border: None

Label:
- Text: 14sp, #2D2D2D
- Margin Top: 8dp
- Alignment: Center
```

### 2.5 Pandit Ji Banner

```
+--------------------------------------------------+
| +----------------------------------------------+ |
| | [Illustration]  PANDIT JI                    | |
| |                 Pandit Ji Astro App -        | |
| |                 Bharosa bhi, samadhan bhi!   | |
| +----------------------------------------------+ |
+--------------------------------------------------+

Specifications:
- Width: Full width - 32dp margin
- Height: 120dp
- Background: #F26B4E
- Border Radius: 16dp
- Margin: 16dp horizontal, 24dp top

Illustration:
- Size: 80x100dp
- Position: Left

Text Container:
- Padding Left: 100dp

Title:
- "PANDIT JI", 20sp, white, bold

Subtitle:
- 14sp, white, normal
```

### 2.6 Category Filter Chips

```
+--------------------------------------------------+
| [All] [Career] [Life] [Love] ...                 |
+--------------------------------------------------+

Specifications:
Container:
- Horizontal scroll
- Margin: 16dp top
- Padding: 16dp horizontal

Chip (Selected - "All"):
- Height: 40dp
- Padding: 12dp horizontal
- Background: transparent
- Border: 2dp solid #F26B4E
- Border Radius: 8dp
- Text: 16sp, #F26B4E

Chip (Unselected):
- Height: 40dp
- Padding: 12dp horizontal
- Background: #E8E8E8
- Border: None
- Border Radius: 8dp
- Text: 16sp, #757575

Gap: 8dp
```

### 2.7 Astrologers Section

```
+--------------------------------------------------+
| Astrologers                                      |
+--------------------------------------------------+
| +----------------------------------------------+ |
| | [Photo]  Nikki Diwan                         | |
| |          Vastu Astrology                     | |
| |          * 4.8 (800+ reviews)                | |
| +----------------------------------------------+ |
+--------------------------------------------------+

Specifications:
Section Title:
- Text: "Astrologers", 18sp, #2D2D2D, bold
- Margin: 16dp top, 16dp horizontal

Astrologer Card: (See Section 3)
```

---

## 3. SCREEN 2: ASTROLOGER LIST / CARD

### 3.1 Astrologer Card

```
+----------------------------------------------+
| +--------+                                   |
| | Photo  |  Name                             |
| | 80x80  |  Specialization                   |
| |        |  * Rating (Reviews)               |
| +--------+                                   |
+----------------------------------------------+

Specifications:
Container:
- Width: Full width - 32dp margin
- Height: 120dp
- Background: #F26B4E
- Border Radius: 16dp
- Margin: 8dp vertical, 16dp horizontal
- Padding: 16dp

Photo:
- Size: 80x80dp
- Shape: Circle
- Border: 2dp white (optional)
- Position: Left

Content:
- Margin Left: 16dp from photo

Name:
- Text: 18sp, white, bold
- Single line, ellipsis overflow

Specialization:
- Text: 14sp, white, 0.9 opacity
- Margin Top: 4dp

Rating Row:
- Margin Top: 8dp
- Star Icon: 16x16dp, yellow (#FFD700)
- Rating Text: 14sp, white, bold
- Reviews: 14sp, white, 0.8 opacity
- Format: "* 4.8 (800+ reviews)"
```

---

## 4. SCREEN 3: SETTINGS

### 4.1 Layout Structure

```
+--------------------------------------------------+
| [<-]           Setting                           |
+--------------------------------------------------+
| +----------------------------------------------+ |
| | [S]  Subhas Chandra Bose    Male  01/01/2000 | |
| +----------------------------------------------+ |
|                                                  |
| Astro Talk AI - Your AI-powered astrology...    |
|                                                  |
| +----------------------------------------------+ |
| | [Icon]  Remove Ads                           | |
| +----------------------------------------------+ |
| | [Icon]  Change Language                      | |
| +----------------------------------------------+ |
| | [Icon]  About Us                             | |
| +----------------------------------------------+ |
| | [Icon]  Feedback                             | |
| +----------------------------------------------+ |
| | [Icon]  Rate us                              | |
| +----------------------------------------------+ |
| | [Icon]  Request Feature                      | |
| +----------------------------------------------+ |
+--------------------------------------------------+
```

### 4.2 App Bar

```
Specifications:
- Height: 56dp
- Background: #F26B4E
- Back Arrow: 24x24dp, white, left 16dp
- Title: "Setting", 20sp, white, centered
```

### 4.3 Profile Card

```
Specifications:
Container:
- Width: Full width - 32dp margin
- Height: 72dp
- Background: #E8D5CC (tan/beige)
- Border Radius: 12dp
- Margin: 16dp
- Padding: 16dp

Avatar:
- Size: 48x48dp
- Shape: Circle
- Background: #4CAF50 (green)
- Text: First initial, 20sp, white, centered

Name:
- Text: 16sp, #2D2D2D, bold
- Margin Left: 12dp

Gender + DOB:
- Text: 14sp, #757575
- Position: Right aligned
- Format: "Male  01/01/2000"
```

### 4.4 App Description

```
Specifications:
- Text: 14sp, #757575
- Margin: 16dp horizontal, 16dp top
- Line Height: 1.4
```

### 4.5 Menu Item

```
+----------------------------------------------+
| [Icon]  Label Text                           |
+----------------------------------------------+

Specifications:
Container:
- Height: 56dp
- Padding: 16dp horizontal
- Border Bottom: 1dp solid #E0E0E0

Icon:
- Size: 32x32dp
- Background: Colored circle
- Icon Color: White
- Icon Size: 20x20dp

Label:
- Text: 18sp, #2D2D2D
- Margin Left: 16dp

Icon Colors by Item:
- Remove Ads: #E53935 (red)
- Change Language: #F26B4E (coral)
- About Us: #F26B4E (coral)
- Feedback: #64B5F6 (blue)
- Rate Us: #FFB74D (orange)
- Request Feature: #FFA726 (amber)
```

---

## 5. SCREEN 4: TODAY BHAGWAN

### 5.1 Layout

```
+--------------------------------------------------+
|            Today Bhagwan                         |
+--------------------------------------------------+
|                                                  |
|        +----------------------------+            |
|        |                            |            |
|        |      [Deity Image]         |            |
|        |                            |            |
|        +----------------------------+            |
|                                                  |
|               Maa Santoshi                       |
|                                                  |
|        Aaj hum Maa Santoshi ki puja             |
|        karenge, jo ki sukh aur santosh          |
|        ki devi maani jaati hain...              |
|                                                  |
+--------------------------------------------------+
|        [Copy]              [Share]               |
+--------------------------------------------------+
```

### 5.2 App Bar

```
Specifications:
- Height: 56dp
- Background: #F26B4E
- Title: "Today Bhagwan", 20sp, white, centered
```

### 5.3 Deity Image

```
Specifications:
- Width: Full width - 48dp margin
- Aspect Ratio: 3:4
- Border Radius: 16dp
- Margin: 24dp top, 24dp horizontal
- Shadow: elevation2
- Object Fit: Cover
```

### 5.4 Deity Name

```
Specifications:
- Text: 24sp, #F26B4E, bold
- Alignment: Center
- Margin: 16dp top
```

### 5.5 Description

```
Specifications:
- Text: 16sp, #2D2D2D
- Line Height: 1.6
- Alignment: Left
- Margin: 16dp horizontal, 16dp top
- Max Lines: Scrollable
```

### 5.6 Action Buttons

```
Specifications:
Container:
- Position: Bottom, sticky
- Padding: 16dp
- Background: #FFF5F0

Copy Button:
- Width: 45%
- Height: 48dp
- Background: #F26B4E
- Border Radius: 12dp
- Icon: Copy, 20x20dp, white
- Text: "Copy", 16sp, white
- Layout: Row, centered

Share Button:
- Width: 45%
- Height: 48dp
- Background: #FF8A70
- Border Radius: 12dp
- Icon: Share, 20x20dp, white
- Text: "Share", 16sp, white
- Layout: Row, centered

Gap: 10% of width
```

---

## 6. SCREEN 5: RASHI SELECTION (Choose Your Rashi)

### 6.1 Layout

```
+--------------------------------------------------+
|         Choose Your Rashi                        |
|  Discover your daily, weekly and yearly horoscope|
+--------------------------------------------------+
| +----------+ +----------+ +----------+           |
| |  Aries   | |  Taurus  | |  Gemini  |           |
| +----------+ +----------+ +----------+           |
| +----------+ +----------+ +----------+           |
| |  Cancer  | |   Leo    | |  Virgo   |           |
| +----------+ +----------+ +----------+           |
| +----------+ +----------+ +----------+           |
| |  Libra   | | Scorpio  | |Sagittarius|          |
| +----------+ +----------+ +----------+           |
| +----------+ +----------+ +----------+           |
| |Capricorn | | Aquarius | |  Pisces  |           |
| +----------+ +----------+ +----------+           |
+--------------------------------------------------+
```

### 6.2 Header

```
Specifications:
Title:
- Text: "Choose Your Rashi", 24sp, #2D2D2D, bold
- Alignment: Center
- Sparkle Icons: 24x24dp on each side
- Margin: 32dp top

Subtitle:
- Text: "Discover your daily, weekly and yearly horoscope"
- Size: 14sp, #757575
- Alignment: Center
- Margin: 8dp top
```

### 6.3 Zodiac Grid

```
Specifications:
Grid:
- Columns: 3
- Rows: 4
- Gap: 12dp
- Padding: 16dp horizontal
- Margin: 24dp top

Zodiac Card:
- Aspect Ratio: 1:1 (square)
- Background: #F26B4E
- Border Radius: 16dp

Icon Circle:
- Size: 48x48dp
- Background: Zodiac-specific color (see below)
- Position: Center top
- Margin Top: 16dp

Icon:
- Size: 28x28dp
- Color: White
- Position: Centered in circle

Name:
- Text: 14sp, white
- Alignment: Center
- Margin: 8dp top

Zodiac Icon Colors:
- Aries: #E91E63 (pink)
- Taurus: #FFFDE7 (cream)
- Gemini: #FFD700 (gold)
- Cancer: #FFEB3B (yellow)
- Leo: #FFC107 (amber)
- Virgo: #4CAF50 (green)
- Libra: #8BC34A (light green)
- Scorpio: #009688 (teal)
- Sagittarius: #2196F3 (blue)
- Capricorn: #9C27B0 (purple)
- Aquarius: #673AB7 (deep purple)
- Pisces: #E91E63 (pink)
```

---

## 7. SCREEN 6: HOROSCOPE DETAIL

### 7.1 Header Card

```
+----------------------------------------------+
| Your Horoscope                               |
| [Aries Icon] Aries              [Change]     |
+----------------------------------------------+

Specifications:
Container:
- Width: Full width - 32dp margin
- Height: 88dp
- Background: #F26B4E
- Border Radius: 16dp
- Margin: 16dp
- Padding: 16dp

Label:
- "Your Horoscope", 14sp, white, 0.8 opacity

Zodiac Row:
- Icon: 32x32dp, circular with symbol
- Name: 20sp, white, bold
- Margin Left: 8dp from icon

Change Button:
- Position: Right aligned
- Icon: Pencil, 16x16dp, white
- Text: "Change", 14sp, white
```

### 7.2 Period Tabs

```
+----------------------------------------------+
|   Today   |  Weekly  |  Monthly  |  Yearly  |
+----------------------------------------------+

Specifications:
Container:
- Height: 48dp
- Background: Transparent
- Padding: 16dp horizontal

Tab:
- Padding: 12dp horizontal
- Text: 16sp
- Selected: #F26B4E, underline 2dp
- Unselected: #757575, no underline
```

### 7.3 Category Card (Love, Career, Health)

```
+----------------------------------------------+
| LOVE & RELATIONSHIPS [Heart]                 |
| [=============================------]        |
|                                              |
| Today is a great day for expressing your     |
| feelings. Open communication will            |
| strengthen your bonds.                       |
|                                              |
| [Lightbulb] Be honest and vulnerable.        |
|                              [Heart] [Share] |
+----------------------------------------------+

Specifications:
Container:
- Width: Full width - 32dp margin
- Background: #FAE5DC (light peach)
- Border Radius: 16dp
- Margin: 8dp vertical, 16dp horizontal
- Padding: 16dp

Title Row:
- Text: "LOVE & RELATIONSHIPS", 14sp, #2D2D2D, bold
- Icon: 20x20dp, red heart
- Position: Right of text

Progress Bar:
- Height: 8dp
- Background: #E0E0E0
- Fill Color: #F26B4E
- Border Radius: 4dp
- Margin: 12dp top

Prediction Text:
- Text: 15sp, #2D2D2D
- Line Height: 1.5
- Margin: 12dp top

Tip Row:
- Icon: Lightbulb, 16x16dp, yellow
- Text: 14sp, #757575, italic
- Margin: 12dp top

Action Row:
- Position: Bottom right
- Margin: 12dp top
- Heart Icon: 24x24dp, #2D2D2D
- Share Icon: 24x24dp, #2D2D2D
- Gap: 16dp
```

---

## 8. SCREEN 7-8: ASTROLOGER PROFILE

### 8.1 Hero Section

```
Specifications:
Container:
- Height: 50% of screen
- Background: Zodiac wheel overlay on image

Image:
- Size: Full container
- Object Fit: Cover

Overlay:
- Gradient from bottom: transparent to #FFF5F0
- Height: 30%

Zodiac Background:
- Opacity: 0.2
- Size: 200% of container
- Position: Center
```

### 8.2 Info Card (Overlapping)

```
+----------------------------------------------+
|                                              |
|              Nikki Diwan                     |
|              _______________                 |
|                                              |
| Nikki Diwan specializing in providing        |
| tailored guidance for career advancement     |
| and financial prosperity.                    |
|                                              |
| [Vastu Strategies] [Empathetic]              |
| [English] [9.3K Chats]                       |
|                                              |
+----------------------------------------------+

Specifications:
Container:
- Background: #FFF5F0
- Border Radius: 24dp 24dp 0 0
- Padding: 24dp
- Position: Overlaps hero by 48dp

Name:
- Text: 24sp, #2D2D2D, bold
- Alignment: Center

Divider:
- Width: 60dp
- Height: 2dp
- Color: #F26B4E
- Alignment: Center
- Margin: 8dp top

Bio:
- Text: 14sp, #757575
- Line Height: 1.5
- Alignment: Center
- Margin: 16dp top

Tags Row:
- Wrap Layout
- Alignment: Center
- Margin: 16dp top
- Gap: 8dp

Tag Chip:
- Height: 32dp
- Padding: 12dp horizontal
- Background: #FFFFFF
- Border: 1dp solid #E0E0E0
- Border Radius: 16dp
- Text: 14sp, #2D2D2D
```

### 8.3 Most Ask Question Section

```
Specifications:
Section Title:
- "Most Ask Question", 18sp, #2D2D2D, bold
- Margin: 24dp top, 16dp horizontal

Cards:
- Same as Home screen FAQ cards
- Horizontal scroll
- Hindi text: "Mere career mein safalta ke liye kaun se upay sujhayein?"
```

### 8.4 Reviews Section

```
+----------------------------------------------+
| Reviews                                      |
+----------------------------------------------+
| +------------------+ +------------------+    |
| | Shubham Pincha   | | Saban            |    |
| | **** (4 stars)   | | ** (2 stars)     |    |
| | good             | | Good             |    |
| +------------------+ +------------------+    |
+----------------------------------------------+

Specifications:
Section Title:
- "Reviews", 18sp, #2D2D2D, bold
- Margin: 24dp top

Review Card:
- Width: 180dp
- Height: 100dp
- Background: #FFFFFF
- Border Radius: 12dp
- Padding: 12dp
- Shadow: elevation1

Name:
- Text: 16sp, #2D2D2D, bold

Stars:
- Size: 16x16dp each
- Filled: #FFD700 (gold)
- Empty: #E0E0E0
- Gap: 2dp
- Margin: 4dp top

Text:
- Text: 14sp, #757575
- Margin: 8dp top
- Max Lines: 2

Horizontal Scroll
Gap: 12dp
```

### 8.5 Bottom Action Bar

```
+----------------------------------------------+
|    [        Chat        ]    [Heart]         |
+----------------------------------------------+

Specifications:
Container:
- Position: Fixed bottom
- Height: 72dp
- Background: #FFF5F0
- Padding: 16dp
- Shadow: elevation2 (inverted)

Chat Button:
- Flex: 1
- Height: 48dp
- Background: #F26B4E
- Border Radius: 12dp
- Icon: Chat, 20x20dp, white
- Text: "Chat", 16sp, white

Heart Button:
- Width: 56dp
- Height: 48dp
- Background: #FFFFFF
- Border: 2dp solid #F26B4E
- Border Radius: 12dp
- Icon: Heart outline, 24x24dp, #F26B4E
- Margin Left: 12dp
```

---

## 9. SCREEN 9-12: CHAT SCREEN

### 9.1 Chat App Bar

```
+----------------------------------------------+
| [<-]  [Avatar] Nikki Diwan           [...]   |
+----------------------------------------------+

Specifications:
- Height: 64dp
- Background: #F26B4E
- Padding: 12dp horizontal

Back Arrow:
- Size: 24x24dp
- Color: White

Avatar:
- Size: 40x40dp
- Shape: Circle
- Border: 2dp white
- Margin Left: 12dp

Name:
- Text: 18sp, white, bold
- Margin Left: 12dp

Menu Icon:
- 3 vertical dots
- Size: 24x24dp
- Color: White
- Position: Right aligned
```

### 9.2 Messages Area

```
Specifications:
- Background: #FFF5F0
- Padding: 16dp
- Scroll: Reverse (newest at bottom)
```

### 9.3 Astrologer Message Bubble

```
+------------------------------------------+
| [Avatar]                                  |
|          +----------------------------+   |
|          | Namaste Subhas Chandra    |   |
|          | Bose! This is Nikki       |   |
|          | Diwan. What brings you    |   |
|          | here, brave warrior       |   |
|          | from the future?          |   |
|          +----------------------------+   |
+------------------------------------------+

Specifications:
Container:
- Max Width: 80%
- Alignment: Left

Avatar:
- Size: 36x36dp
- Shape: Circle
- Position: Left, bottom aligned

Bubble:
- Background: #F26B4E
- Border Radius: 16dp 16dp 16dp 4dp
- Padding: 12dp 16dp
- Margin Left: 8dp from avatar

Text:
- Text: 15sp, white
- Line Height: 1.4
```

### 9.4 User Message Bubble

```
Specifications:
Container:
- Max Width: 80%
- Alignment: Right

Bubble:
- Background: #FFFFFF
- Border: 1dp solid #E0E0E0
- Border Radius: 16dp 16dp 4dp 16dp
- Padding: 12dp 16dp

Text:
- Text: 15sp, #2D2D2D
- Line Height: 1.4
```

### 9.5 Typing Indicator

```
+------------------------------------------+
| [Avatar] [. . .]                          |
+------------------------------------------+

Specifications:
- Avatar: Same as message
- Dots: 3 circles, 8x8dp each
- Dot Color: #F26B4E
- Gap: 4dp
- Animation: Bounce sequence (0.2s delay each)
```

### 9.6 Input Area

```
+----------------------------------------------+
| +------------------------------------------+ |
| | Ask Questions...              [Mic] [>]  | |
| +------------------------------------------+ |
+----------------------------------------------+

Specifications:
Container:
- Height: 64dp
- Background: #2D2D2D
- Padding: 8dp 16dp

Input Field:
- Flex: 1
- Height: 48dp
- Background: #FAE5DC
- Border Radius: 24dp
- Padding: 0 16dp
- Placeholder: "Ask Questions...", 16sp, #757575

Microphone Button:
- Size: 40x40dp
- Position: Inside input, right
- Icon: 24x24dp, #F26B4E

Send Button:
- Size: 40x40dp
- Position: Inside input, right of mic
- Icon: Arrow right, 24x24dp, #F26B4E
```

### 9.7 Ad Modal ("Unlock Free Chat")

```
+----------------------------------------------+
|                                              |
|          Unlock Free Chat                    |
|                                              |
|    Watch a short ad to continue free         |
|    chat with the astrologer.                 |
|                                              |
|    +----------------------------------+      |
|    |      [>]   Watch Ad             |      |
|    +----------------------------------+      |
|                                              |
|    +----------------------------------+      |
|    |      [*]   Remove Ads           |      |
|    +----------------------------------+      |
|                                              |
|              No Thanks                       |
|                                              |
+----------------------------------------------+

Specifications:
Modal Container:
- Width: 80%
- Background: #FFF5F0
- Border Radius: 16dp
- Padding: 24dp
- Shadow: elevation2
- Center aligned

Title:
- "Unlock Free Chat", 20sp, #2D2D2D, bold
- Alignment: Center

Description:
- 14sp, #757575
- Alignment: Center
- Margin: 16dp top

Watch Ad Button:
- Width: 100%
- Height: 48dp
- Background: #4CAF50 (green)
- Border Radius: 12dp
- Icon: Play, 20x20dp, white
- Text: "Watch Ad", 16sp, white
- Margin: 24dp top

Remove Ads Button:
- Width: 100%
- Height: 48dp
- Background: Transparent
- Border: 2dp solid #E91E63 (pink)
- Border Radius: 12dp
- Icon: Star, 20x20dp, #E91E63
- Text: "Remove Ads", 16sp, #E91E63
- Margin: 12dp top

No Thanks:
- Text: 14sp, #757575
- Alignment: Center
- Margin: 16dp top
- Tap: Dismiss modal
```

### 9.8 Chat Menu Popup

```
+------------------+
| [Flag] Report Chat |
+------------------+
| [Heart] Favourite  |
+------------------+
| [Star] Remove Ads  |
+------------------+

Specifications:
Container:
- Width: 180dp
- Background: #FFF5F0
- Border Radius: 12dp
- Shadow: elevation2
- Position: Below menu icon, right aligned

Menu Item:
- Height: 48dp
- Padding: 12dp 16dp
- Border Bottom: 1dp solid #E0E0E0 (except last)

Icon:
- Size: 20x20dp
- Colors:
  - Report: #2D2D2D
  - Favourite: #E91E63 (pink)
  - Remove Ads: #E91E63 (pink)

Text:
- 14sp, #2D2D2D
- Margin Left: 12dp
```

---

## 10. COMMON COMPONENTS

### 10.1 Loading Indicator

```
Specifications:
- Type: CircularProgressIndicator
- Size: 40x40dp
- Color: #F26B4E
- Stroke Width: 3dp
```

### 10.2 Empty State

```
Specifications:
- Illustration: 150x150dp
- Title: 18sp, #2D2D2D, bold
- Subtitle: 14sp, #757575
- Action Button: Optional
```

### 10.3 Snackbar / Toast

```
Specifications:
- Background: #2D2D2D
- Text: 14sp, white
- Border Radius: 8dp
- Padding: 12dp 16dp
- Position: Bottom, 16dp margin
- Duration: 3 seconds
```

### 10.4 Pull to Refresh

```
Specifications:
- Indicator: Coral (#F26B4E)
- Background: Background color
- Displacement: 40dp
```

---

## 11. ANIMATIONS

### 11.1 Screen Transitions

```dart
// Default: Slide from right
transition: Transition.rightToLeft
duration: 300ms
curve: Curves.easeInOut
```

### 11.2 Button Press

```dart
// Scale down effect
onTapDown: scale(0.95)
onTapUp: scale(1.0)
duration: 100ms
```

### 11.3 Card Tap

```dart
// Elevation + Scale
onTap: {
  elevation: 2 -> 4
  scale: 1.0 -> 0.98
}
duration: 150ms
```

### 11.4 Typing Indicator

```dart
// Bouncing dots
dot1: translateY(-4dp) at 0ms
dot2: translateY(-4dp) at 200ms
dot3: translateY(-4dp) at 400ms
duration: 600ms
repeat: infinite
```

### 11.5 Message Appear

```dart
// Slide up + fade in
translateY: 20dp -> 0dp
opacity: 0 -> 1
duration: 200ms
curve: Curves.easeOut
```

---

## 12. RESPONSIVE BREAKPOINTS

```dart
// Phone Portrait (Default)
width < 600dp

// Phone Landscape / Small Tablet
600dp <= width < 840dp
- Increase horizontal padding to 24dp
- 2-column zodiac grid possible

// Tablet
840dp <= width
- Max content width: 600dp centered
- Side margins increase
- 4-column zodiac grid
```

---

## 13. ACCESSIBILITY

### 13.1 Touch Targets

```
- Minimum size: 48x48dp
- Recommended: 56x56dp for primary actions
```

### 13.2 Contrast Ratios

```
- Large text (18sp+): 3:1 minimum
- Small text: 4.5:1 minimum
- Primary on white: #F26B4E passes
- White on primary: Passes
```

### 13.3 Semantic Labels

```dart
// All interactive elements must have:
Semantics(
  label: 'Descriptive label',
  button: true, // or appropriate role
  child: Widget,
)
```

---

**END OF FRONTEND UI SPECIFICATIONS**
