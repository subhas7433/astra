# Functional Specifications
## Astro GPT - AI-Powered Astrology Companion

**Version:** 1.0
**Date:** November 25, 2025
**Platform:** Flutter Mobile (iOS & Android)
**Backend:** Appwrite Cloud

---

## 1. PROJECT OVERVIEW

### 1.1 Purpose
Build a mobile application that provides AI-powered astrology consultations, daily horoscopes, and spiritual guidance through personalized chat interactions with virtual astrologer personas.

### 1.2 Business Problem
- Users seek personalized astrology guidance but face barriers: cost, availability, and trust
- Traditional astrology apps provide generic content without personalization
- Users want instant, conversational access to astrological insights
- Market demand for Hindi/English bilingual astrology apps in India

### 1.3 Solution
A mobile app that:
1. Provides AI-powered chat with multiple astrologer personas
2. Delivers personalized daily horoscopes for all 12 zodiac signs
3. Features daily spiritual content (mantras, deity information)
4. Offers numerology predictions based on birth date
5. Supports Hindi and English languages
6. Monetizes through ads, subscriptions, and in-app purchases

### 1.4 Success Criteria
- User engagement: Average 3+ chat sessions per user per week
- Retention: 40%+ Day-7 retention rate
- Monetization: 5%+ premium conversion rate
- Rating: 4.5+ stars on app stores
- Response quality: 90%+ positive feedback on AI responses

---

## 2. APP FEATURES

### 2.1 AI Astrologer Chat (Core Feature)
Conversational AI chat with personalized astrologer personas providing career, love, life, and spiritual guidance.

### 2.2 Daily Horoscope
Daily, weekly, monthly, and yearly horoscope predictions for all 12 zodiac signs across Love, Career, and Health categories.

### 2.3 Today's Bhagwan (God of the Day)
Daily rotating deity content with images, descriptions, and significance.

### 2.4 Today's Mantra
Daily spiritual mantras for meditation and positivity.

### 2.5 Numerology
Birth date-based numerology predictions and life path analysis.

### 2.6 Chat History
Access to previous conversations with astrologers.

---

## 3. USER ROLES

### 3.1 Primary User: App User
**Profile:**
- Age: 18-55 years
- Interest in astrology, spirituality, and self-improvement
- Seeking guidance on career, relationships, health, or life decisions
- Comfortable with Hindi or English

**Needs:**
- Quick access to personalized astrological guidance
- Daily horoscope check routine
- Spiritual content for daily motivation
- Ability to ask specific questions and get personalized answers
- Save favorite astrologers for quick access

### 3.2 Secondary: Astrologer Personas (AI)
**Profile:**
- Virtual astrologer characters with unique specializations
- Each has distinct personality, expertise, and communication style
- Examples: Vastu expert, Career specialist, Vedic remedy expert

---

## 4. CORE FEATURES

### 4.1 User Authentication & Profile

**FR-001:** System shall support user registration via Email
**FR-002:** System shall support user registration via Google Sign-In
**FR-003:** System shall support user registration via Apple Sign-In (iOS)
**FR-004:** System shall support guest mode with limited features
**FR-005:** System shall collect user profile information:
- Full Name (required)
- Gender (required: Male/Female/Other)
- Date of Birth (required for horoscope/numerology)
- Profile Avatar (optional)
- Preferred Language (Hindi/English)

**FR-006:** System shall auto-detect zodiac sign from date of birth
**FR-007:** System shall allow users to edit profile information
**FR-008:** System shall persist user session using Appwrite Auth
**FR-009:** System shall support account deletion (GDPR compliance)
**FR-010:** System shall support password reset via email

### 4.2 Home Dashboard

**FR-011:** Home screen shall display app branding "Astro GPT" in header
**FR-012:** Home screen shall display settings icon in top-right corner
**FR-013:** Home screen shall display "Today Mantra" expandable section with:
- Om icon
- Dropdown arrow for expand/collapse
- Daily mantra text when expanded

**FR-014:** Home screen shall display "Most Ask Question" section with:
- Horizontal scrollable cards
- Pre-defined questions in Hindi/English
- Tapping a question opens chat with selected topic

**FR-015:** Home screen shall display feature icons grid:
- Horoscope (zodiac wheel icon)
- Today God (deity icon)
- Numerology (numbers icon)
- History (chat history icon)

**FR-016:** Home screen shall display promotional banner for "Pandit Ji" section
**FR-017:** Home screen shall display category filter chips:
- All (default selected)
- Career
- Life
- Love
- (Additional categories scrollable)

**FR-018:** Home screen shall display "Astrologers" section with list of available astrologers
**FR-019:** Tapping an astrologer card navigates to astrologer profile
**FR-020:** Pull-to-refresh shall reload home content

### 4.3 Astrologer Listing

**FR-021:** Astrologer list shall be filterable by category (All, Career, Life, Love)
**FR-022:** Each astrologer card shall display:
- Profile photo (circular)
- Astrologer name
- Specialization/expertise
- Star rating (1-5 with decimals)
- Review count (e.g., "800+ reviews")

**FR-023:** Astrologer cards shall have coral/orange background
**FR-024:** List shall be vertically scrollable with infinite scroll pagination
**FR-025:** Tapping card navigates to astrologer detail screen

### 4.4 Astrologer Profile

**FR-026:** Profile screen shall display large hero image with zodiac background
**FR-027:** Profile shall show astrologer name prominently
**FR-028:** Profile shall show bio/description text
**FR-029:** Profile shall display attribute tags/chips:
- Expertise areas (e.g., "Vastu Strategies")
- Personality traits (e.g., "Empathetic")
- Languages spoken (e.g., "English", "Hindi")
- Chat statistics (e.g., "9.3K Chats")

**FR-030:** Profile shall display "Most Ask Question" section with:
- Horizontally scrollable question cards
- Questions in Hindi and English
- Tapping question starts chat with that topic

**FR-031:** Profile shall display "Reviews" section with:
- User name
- Star rating (1-5)
- Review text
- Horizontal scroll for multiple reviews

**FR-032:** Profile shall have sticky bottom bar with:
- "Chat" button (primary action)
- Heart/Favorite button (toggle)

**FR-033:** Favorite button shall toggle astrologer in user's favorites list
**FR-034:** Chat button shall navigate to chat screen with selected astrologer

### 4.5 AI Chat System

**FR-035:** Chat screen shall display header with:
- Back navigation arrow
- Astrologer avatar (circular)
- Astrologer name
- Menu icon (three dots)

**FR-036:** Chat shall display messages in bubble format:
- Astrologer messages: Left-aligned, coral/orange background
- User messages: Right-aligned, different color
- Astrologer avatar shown next to their messages

**FR-037:** Chat shall display typing indicator (three animated dots) when AI is generating response
**FR-038:** Chat input area shall include:
- Text input field with placeholder "Ask Questions..."
- Microphone icon for voice input (Phase 2)
- Send button (arrow icon)

**FR-039:** System shall generate personalized greeting using user's name
**FR-040:** AI shall maintain context within conversation session
**FR-041:** AI responses shall reflect astrologer's persona and expertise
**FR-042:** Chat shall support text messages up to 1000 characters
**FR-043:** Chat messages shall persist in Appwrite database
**FR-044:** User shall be able to access chat history

**FR-045:** Chat menu (three dots) shall display options:
- Report Chat (flag icon)
- Favourite (heart icon)
- Remove Ads (star icon)

**FR-046:** Report Chat shall allow users to flag inappropriate content
**FR-047:** Favourite from chat shall add astrologer to favorites

### 4.6 Horoscope Feature

**FR-048:** Horoscope selection screen shall display title "Choose Your Rashi"
**FR-049:** Screen shall show subtitle "Discover your daily, weekly and yearly horoscope"
**FR-050:** Screen shall display 4x3 grid of 12 zodiac signs:
- Aries, Taurus, Gemini
- Cancer, Leo, Virgo
- Libra, Scorpio, Sagittarius
- Capricorn, Aquarius, Pisces

**FR-051:** Each zodiac card shall display:
- Zodiac symbol icon (colored circle)
- Zodiac name in English

**FR-052:** Tapping zodiac navigates to horoscope detail screen
**FR-053:** System shall remember user's zodiac preference

**FR-054:** Horoscope detail screen shall display header card with:
- "Your Horoscope" label
- Selected zodiac icon and name
- "Change" button to select different zodiac

**FR-055:** Detail screen shall have tab bar for time periods:
- Today (default selected)
- Weekly
- Monthly
- Yearly

**FR-056:** Each time period shall display category cards:
- Love & Relationships (heart icon)
- Career & Finance (briefcase + money icon)
- Health & Wellness (person icon)

**FR-057:** Each category card shall display:
- Category title with icon
- Progress/energy bar (visual indicator)
- Prediction text (2-3 sentences)
- Daily tip with lightbulb icon
- Like (heart) button
- Share button

**FR-058:** Like button shall save prediction to favorites
**FR-059:** Share button shall open system share sheet with prediction text
**FR-060:** Horoscope content shall update daily at midnight (user's timezone)

### 4.7 Today's Bhagwan (God of the Day)

**FR-061:** Screen shall display "Today Bhagwan" title in header
**FR-062:** Screen shall display large deity image (centered)
**FR-063:** Screen shall display deity name below image
**FR-064:** Screen shall display description text about the deity:
- Significance of the deity
- Day of worship
- Benefits of worship
- Content in Hindi (with English option)

**FR-065:** Screen shall have bottom action buttons:
- Copy button (copy text to clipboard)
- Share button (share via system share)

**FR-066:** Deity shall rotate daily based on Hindu calendar
**FR-067:** Content shall be fetched from Appwrite database

### 4.8 Today's Mantra

**FR-068:** Mantra section shall be expandable/collapsible on home screen
**FR-069:** Expanded view shall display:
- Om symbol icon
- Mantra text in Sanskrit/Hindi
- English translation
- Audio playback button (Phase 2)

**FR-070:** Copy button shall copy mantra to clipboard
**FR-071:** Share button shall share mantra text
**FR-072:** Mantra shall update daily

### 4.9 Numerology Feature

**FR-073:** Numerology screen shall accept date of birth input
**FR-074:** System shall calculate life path number from DOB
**FR-075:** System shall display numerology reading including:
- Life path number
- Personality traits
- Lucky numbers
- Lucky colors
- Compatibility information

**FR-076:** System shall provide detailed interpretation text
**FR-077:** Results shall be shareable

### 4.10 Settings Screen

**FR-078:** Settings shall display user profile card at top:
- Avatar (initial letter or photo)
- Full name
- Gender
- Date of birth

**FR-079:** Settings shall display app description text
**FR-080:** Settings shall display menu items:
- Remove Ads (navigate to premium purchase)
- Change Language (Hindi/English toggle)
- About Us (app information)
- Feedback (feedback form)
- Rate Us (open app store)
- Request Feature (feature request form)

**FR-081:** Each menu item shall have icon and label
**FR-082:** Tapping profile card shall open profile edit screen
**FR-083:** Language change shall update app UI immediately

### 4.11 Favorites & History

**FR-084:** Users shall be able to favorite astrologers
**FR-085:** Users shall be able to access favorite astrologers quickly
**FR-086:** System shall maintain chat history per astrologer
**FR-087:** History feature shall show list of past conversations
**FR-088:** Tapping history item shall reopen conversation

---

## 5. MONETIZATION FEATURES

### 5.1 Ad-Based Monetization

**FR-089:** System shall display rewarded ads to unlock free chat
**FR-090:** Ad modal shall appear after initial free messages are exhausted
**FR-091:** Ad modal shall display:
- Title: "Unlock Free Chat"
- Description: "Watch a short ad to continue free chat with the astrologer."
- "Watch Ad" button (green, primary)
- "Remove Ads" button (outlined, secondary)
- "No Thanks" text link

**FR-092:** Watching ad shall grant additional free messages
**FR-093:** Interstitial ads shall display between screen transitions
**FR-094:** Banner ads shall display on non-premium screens
**FR-095:** Ads shall be served via Google AdMob

### 5.2 Subscription Tiers

**FR-096:** System shall offer subscription tiers:

| Tier | Price | Features |
|------|-------|----------|
| Free | $0 | 5 chat messages/day, ads, basic horoscope |
| Premium | $4.99/mo | Unlimited chat, no ads, detailed horoscope, priority responses |
| VIP | $9.99/mo | Everything + exclusive astrologers, personalized reports |

**FR-097:** Premium users shall have ad-free experience
**FR-098:** Premium users shall have unlimited chat messages
**FR-099:** Subscription shall be managed via RevenueCat or in_app_purchase
**FR-100:** System shall verify subscription status on app launch
**FR-101:** System shall handle subscription expiry gracefully

### 5.3 In-App Purchases

**FR-102:** Users shall be able to purchase chat credit packs:
- 50 credits: $1.99
- 150 credits: $4.99
- 500 credits: $14.99

**FR-103:** Users shall be able to purchase one-time "Remove Ads" ($4.99)
**FR-104:** Users shall be able to purchase premium reports:
- Detailed Birth Chart: $2.99
- Compatibility Report: $3.99
- Annual Forecast: $4.99

**FR-105:** Purchase history shall be accessible in settings
**FR-106:** Purchases shall sync across devices via Appwrite

---

## 6. DETAILED SCREEN SPECIFICATIONS

### 6.1 Home Dashboard Screen

**Navigation:** App launch / Bottom nav "Home"

**Layout (Top to Bottom):**
1. App Bar (coral background)
   - "Astro GPT" title (centered)
   - Settings gear icon (right)

2. Today Mantra Section
   - Dark rounded container
   - Om icon (orange) + "Today Mantra" text + Dropdown arrow
   - Expandable content area

3. Most Ask Question Section
   - Section title: "Most Ask Question"
   - Horizontal scroll of question cards
   - Cards: Coral/orange gradient background, white text

4. Feature Icons Row
   - Horizontal scroll
   - Icons: Horoscope, Today God, Numerology, History
   - Circular icon + label below

5. Promotional Banner
   - "PANDIT JI" banner
   - Illustration + tagline

6. Category Filter Chips
   - Horizontal scroll
   - Chips: All, Career, Life, Love
   - Selected chip has border highlight

7. Astrologers Section
   - Section title: "Astrologers"
   - Vertical list of astrologer cards

**Actions:**
- Tap settings: Navigate to Settings
- Tap mantra: Expand/collapse mantra section
- Tap question card: Open chat with question
- Tap feature icon: Navigate to respective feature
- Tap category chip: Filter astrologers
- Tap astrologer card: Navigate to profile

### 6.2 Astrologer List Screen

**Navigation:** Home screen scroll / Category filter

**Layout:**
1. App Bar
   - "Astro GPT" title
   - Settings icon

2. Category Filter Chips
   - Same as home screen

3. Astrologers Section Title
   - "Astrologers"

4. Astrologer Cards (Vertical List)
   - Coral/orange background with rounded corners
   - Left: Circular profile photo
   - Right: Name, Specialty, Rating + Reviews

**Card Details:**
- Photo: 80x80 circular
- Name: 18sp bold white
- Specialty: 14sp white
- Rating: Star icon + "4.8" + "(800+ reviews)"

### 6.3 Astrologer Profile Screen

**Navigation:** Tap astrologer card

**Layout:**
1. Hero Section (Half screen)
   - Full-width astrologer image
   - Zodiac wheel overlay in background
   - Gradient overlay at bottom

2. Info Card (Overlapping hero)
   - Astrologer name (large)
   - Bio/description text
   - Attribute chips (wrap layout)

3. Most Ask Question Section
   - Section title
   - Horizontal scroll of question cards

4. Reviews Section
   - Section title: "Reviews"
   - Horizontal scroll of review cards
   - Each: Name, stars, text

5. Bottom Action Bar (Sticky)
   - Chat button (coral, full width minus heart)
   - Heart/favorite button (outline)

### 6.4 Chat Screen

**Navigation:** Tap "Chat" on profile

**Layout:**
1. App Bar (coral)
   - Back arrow (left)
   - Avatar + Name (center)
   - Menu dots (right)

2. Messages Area (Scrollable)
   - Peach/cream background
   - Message bubbles
   - Astrologer avatar next to messages

3. Input Area (Bottom, sticky)
   - Text input field
   - Microphone button
   - Send button

**Message Bubble Specs:**
- Astrologer: Left-aligned, coral background, white text
- User: Right-aligned, darker background
- Max width: 80% of screen
- Border radius: 16dp
- Padding: 12dp

**Typing Indicator:**
- Astrologer avatar + 3 dots animation

### 6.5 Rashi Selection Screen

**Navigation:** Tap "Horoscope" icon

**Layout:**
1. Header
   - Sparkle icons + "Choose Your Rashi" + Sparkle icons
   - Subtitle text

2. Zodiac Grid (4x3)
   - 12 cards arranged in grid
   - Each card: Coral background, zodiac icon, name

**Zodiac Icons (Colored circles):**
- Aries: Red/pink
- Taurus: White/cream
- Gemini: Yellow/gold
- Cancer: Yellow
- Leo: Yellow
- Virgo: Green
- Libra: Green
- Scorpio: Teal
- Sagittarius: Blue
- Capricorn: Purple
- Aquarius: Purple
- Pisces: Pink

### 6.6 Horoscope Detail Screen

**Navigation:** Tap zodiac card

**Layout:**
1. Header Card (Coral)
   - "Your Horoscope" label
   - Zodiac icon + name
   - "Change" button (right)

2. Period Tabs
   - Today | Weekly | Monthly | Yearly
   - Underline indicator for selected

3. Category Cards (Vertical scroll)
   - Love & Relationships
   - Career & Finance
   - Health & Wellness

**Category Card Details:**
- Title with icon
- Progress bar
- Prediction text
- Tip with lightbulb icon
- Like + Share buttons

### 6.7 Today Bhagwan Screen

**Navigation:** Tap "Today God" icon

**Layout:**
1. App Bar (Coral)
   - "Today Bhagwan" title

2. Deity Image
   - Large, centered
   - Rounded corners
   - Aspect ratio preserved

3. Deity Name
   - Large text, coral color
   - Centered

4. Description
   - Hindi text
   - Multiple paragraphs
   - Scrollable if long

5. Action Buttons (Bottom)
   - Copy button (coral, outlined)
   - Share button (coral, filled)

### 6.8 Settings Screen

**Navigation:** Tap settings icon

**Layout:**
1. App Bar (Coral)
   - Back arrow
   - "Setting" title

2. Profile Card
   - Avatar (circular, initial)
   - Name
   - Gender + DOB

3. App Description
   - About text with emojis

4. Menu Items (List)
   - Icon + Label for each
   - Divider between items

**Menu Items:**
- Remove Ads (red diamond)
- Change Language (A with Hindi script)
- About Us (info circle)
- Feedback (smiley)
- Rate Us (star)
- Request Feature (lightbulb)

---

## 7. DATA REQUIREMENTS

### 7.1 User Data
- User ID (UUID)
- Email
- Full Name
- Gender (enum)
- Date of Birth
- Zodiac Sign (auto-calculated)
- Preferred Language
- Profile Photo URL
- Created At
- Updated At

### 7.2 Astrologer Data
- Astrologer ID (UUID)
- Name
- Profile Photo URL
- Hero Image URL
- Bio/Description
- Specialization
- Expertise Tags (array)
- Languages (array)
- Rating (decimal)
- Review Count
- Chat Count
- Category (Career/Life/Love)
- Is Active
- AI Persona Prompt
- Created At

### 7.3 Chat Data
- Session ID (UUID)
- User ID (FK)
- Astrologer ID (FK)
- Created At
- Updated At
- Is Active

### 7.4 Message Data
- Message ID (UUID)
- Session ID (FK)
- Sender Type (user/astrologer)
- Content (text)
- Created At
- Is Read

### 7.5 Horoscope Data
- Horoscope ID (UUID)
- Zodiac Sign (enum)
- Period Type (daily/weekly/monthly/yearly)
- Category (love/career/health)
- Prediction Text
- Tip Text
- Energy Level (0-100)
- Valid Date
- Created At

### 7.6 Daily Content Data
- Content ID (UUID)
- Type (mantra/god)
- Title
- Description
- Image URL (for god)
- Audio URL (for mantra, Phase 2)
- Valid Date
- Created At

### 7.7 Review Data
- Review ID (UUID)
- Astrologer ID (FK)
- User ID (FK)
- Rating (1-5)
- Text
- Created At

### 7.8 Favorite Data
- User ID (FK)
- Astrologer ID (FK)
- Created At

### 7.9 Subscription Data
- User ID (FK)
- Tier (free/premium/vip)
- Status (active/expired/cancelled)
- Start Date
- End Date
- Platform (ios/android)
- Transaction ID

### 7.10 FAQ Data
- FAQ ID (UUID)
- Question Text (Hindi)
- Question Text (English)
- Category
- Astrologer ID (optional, for persona-specific)
- Display Order

---

## 8. AI INTEGRATION REQUIREMENTS

### 8.1 Chat AI Configuration

**FR-107:** Each astrologer shall have unique AI persona configuration
**FR-108:** AI persona shall include:
- Base personality description
- Expertise areas
- Communication style
- Language preferences
- Greeting templates

**FR-109:** AI shall use user context in responses:
- User name
- User zodiac sign
- User gender
- Previous conversation context

**FR-110:** AI responses shall be:
- Empathetic and supportive
- Astrologically themed
- Culturally appropriate for Indian audience
- Available in Hindi and English

### 8.2 Response Generation

**FR-111:** System shall use mock responses initially (backend TBD)
**FR-112:** Mock responses shall be contextually appropriate
**FR-113:** Response time shall be under 3 seconds
**FR-114:** Typing indicator shall show during generation
**FR-115:** Failed responses shall show error message with retry option

### 8.3 Content Moderation

**FR-116:** AI shall not provide medical advice
**FR-117:** AI shall not provide financial investment advice
**FR-118:** AI shall redirect harmful queries appropriately
**FR-119:** Users can report inappropriate responses

---

## 9. MULTI-LANGUAGE SUPPORT

### 9.1 Supported Languages

**FR-120:** App shall support Hindi as primary language
**FR-121:** App shall support English as secondary language
**FR-122:** Language shall be selectable in settings
**FR-123:** Language preference shall persist across sessions

### 9.2 Localized Content

**FR-124:** UI strings shall be localized for both languages
**FR-125:** Horoscope content shall be available in both languages
**FR-126:** Deity descriptions shall be available in both languages
**FR-127:** Mantras shall show original Sanskrit with translations
**FR-128:** FAQ questions shall be available in both languages

---

## 10. TECHNICAL REQUIREMENTS

### 10.1 Platform
**FR-129:** App shall be built with Flutter for iOS and Android
**FR-130:** Minimum iOS version: 13.0
**FR-131:** Minimum Android version: API 21 (Android 5.0)
**FR-132:** App shall be responsive across different screen sizes

### 10.2 Connectivity
**FR-133:** App shall handle offline gracefully
**FR-134:** Cached content shall be available offline
**FR-135:** Chat shall require internet connection
**FR-136:** App shall show appropriate offline indicators

### 10.3 Performance
**FR-137:** App launch time: Under 3 seconds
**FR-138:** Screen transition: Under 300ms
**FR-139:** Image loading: Progressive with placeholders
**FR-140:** List scrolling: 60fps smooth scrolling

### 10.4 Storage
**FR-141:** App shall cache images locally
**FR-142:** App shall cache recent horoscopes
**FR-143:** Chat history shall be stored in Appwrite
**FR-144:** Maximum local cache: 100MB

---

## 11. OUT OF SCOPE (Phase 2)

The following features are NOT included in Phase 1:

- Voice input for chat (speech-to-text)
- Audio playback for mantras
- Push notifications for daily horoscope
- Live video consultations
- Community features (forums, discussions)
- Kundali/Birth chart generation
- Match-making compatibility
- Palm reading (image-based)
- Face reading
- Tarot card readings
- Advanced astrology reports (Dasha, Transit)
- Social login (Facebook, Twitter)
- Chat image/file sharing
- Astrologer availability status
- Appointment booking
- Referral program
- Gamification (badges, streaks)

---

## 12. USER STORIES

**US-001:** As a user, I want to sign up with my email so that I can access personalized astrology content.

**US-002:** As a user, I want to chat with an AI astrologer so that I can get guidance on my career questions.

**US-003:** As a user, I want to check my daily horoscope so that I can plan my day accordingly.

**US-004:** As a user, I want to see today's deity so that I can offer my prayers.

**US-005:** As a user, I want to read today's mantra so that I can meditate with positive energy.

**US-006:** As a user, I want to filter astrologers by category so that I can find an expert for my specific concern.

**US-007:** As a user, I want to favorite an astrologer so that I can quickly access them later.

**US-008:** As a user, I want to read reviews before chatting so that I can choose the right astrologer.

**US-009:** As a user, I want to watch an ad to get free chat messages so that I can use the app without paying.

**US-010:** As a user, I want to subscribe to premium so that I can chat without ads and limits.

**US-011:** As a user, I want to change the app language so that I can use it in Hindi.

**US-012:** As a user, I want to share my horoscope so that my friends can see my prediction.

**US-013:** As a user, I want to see my chat history so that I can revisit previous consultations.

**US-014:** As a user, I want to report inappropriate content so that the app remains safe.

**US-015:** As a user, I want to check numerology based on my birth date so that I can know my lucky numbers.

---

## 13. ACCEPTANCE CRITERIA

### 13.1 Authentication
**AC-001:** User can register with valid email and password
**AC-002:** User receives verification email after registration
**AC-003:** User can login with registered credentials
**AC-004:** User can reset password via email
**AC-005:** User session persists across app restarts

### 13.2 Chat Quality
**AC-006:** AI responds within 3 seconds
**AC-007:** AI uses user's name in greeting
**AC-008:** AI maintains conversation context
**AC-009:** AI responses are relevant to user's question
**AC-010:** Chat history is preserved after app restart

### 13.3 Horoscope
**AC-011:** All 12 zodiac signs are displayed correctly
**AC-012:** Daily horoscope updates at midnight
**AC-013:** All three categories (Love, Career, Health) have content
**AC-014:** Like and Share buttons function correctly
**AC-015:** Change zodiac button works from detail screen

### 13.4 Monetization
**AC-016:** Rewarded ad plays successfully and grants credits
**AC-017:** Subscription purchase completes successfully
**AC-018:** Premium features unlock after purchase
**AC-019:** Ads are hidden for premium users
**AC-020:** Purchase is restored on reinstall

### 13.5 Performance
**AC-021:** App loads within 3 seconds on average device
**AC-022:** No crashes during normal usage
**AC-023:** Smooth scrolling in all lists
**AC-024:** Images load progressively without blocking UI

---

## 14. PRIORITY FEATURES (MoSCoW)

### MUST HAVE (Phase 1 MVP)
- User authentication (email, Google)
- User profile with DOB and zodiac
- Home dashboard with all sections
- Astrologer listing with filters
- Astrologer profile with details
- AI chat with mock responses
- Daily horoscope (12 signs, 3 categories)
- Today's Bhagwan feature
- Today's Mantra feature
- Settings screen
- Rewarded ads for free chat
- Basic subscription tier

### SHOULD HAVE (Phase 1 if time permits)
- Reviews system
- Favorite astrologers
- Chat history
- Numerology feature
- Premium subscription tier
- In-app purchase credits

### COULD HAVE (Phase 2)
- Voice input for chat
- Push notifications
- Mantra audio playback
- VIP subscription tier
- Apple Sign-In
- Detailed astrology reports

### WON'T HAVE (Out of Scope)
- Live video consultations
- Community features
- Kundali generation
- Match-making
- Palm/Face reading
- Tarot readings

---

## 15. RISKS AND MITIGATION

| Risk | Impact | Mitigation |
|------|--------|------------|
| AI response quality issues | High | Extensive testing, fallback responses, user feedback loop |
| Low user retention | High | Engaging daily content, push notifications (Phase 2) |
| Ad revenue below expectations | Medium | Multiple monetization options, A/B testing ad placements |
| App store rejection | Medium | Follow guidelines, avoid medical/financial advice claims |
| Cultural sensitivity issues | Medium | Content review by native speakers, user reporting |
| Scalability of chat | Low | Appwrite scales automatically, caching strategies |

---

## 16. SUCCESS METRICS

**Post-Launch (3 months):**
- Daily Active Users: 10,000+
- Average session duration: 5+ minutes
- Messages per user per day: 3+
- Premium conversion rate: 3%+
- App store rating: 4.0+
- Crash-free rate: 99%+

---

## APPENDIX A: ZODIAC SIGNS REFERENCE

| # | English | Hindi | Symbol | Dates |
|---|---------|-------|--------|-------|
| 1 | Aries | Mesh | Ram | Mar 21 - Apr 19 |
| 2 | Taurus | Vrishabh | Bull | Apr 20 - May 20 |
| 3 | Gemini | Mithun | Twins | May 21 - Jun 20 |
| 4 | Cancer | Kark | Crab | Jun 21 - Jul 22 |
| 5 | Leo | Singh | Lion | Jul 23 - Aug 22 |
| 6 | Virgo | Kanya | Virgin | Aug 23 - Sep 22 |
| 7 | Libra | Tula | Scales | Sep 23 - Oct 22 |
| 8 | Scorpio | Vrishchik | Scorpion | Oct 23 - Nov 21 |
| 9 | Sagittarius | Dhanu | Archer | Nov 22 - Dec 21 |
| 10 | Capricorn | Makar | Goat | Dec 22 - Jan 19 |
| 11 | Aquarius | Kumbh | Water-bearer | Jan 20 - Feb 18 |
| 12 | Pisces | Meen | Fish | Feb 19 - Mar 20 |

---

## APPENDIX B: SAMPLE ASTROLOGER DATA

```json
{
  "id": "ast_001",
  "name": "Nikki Diwan",
  "photo_url": "https://...",
  "hero_image_url": "https://...",
  "bio": "Nikki Diwan specializing in providing tailored guidance for career advancement and financial prosperity.",
  "specialization": "Vastu Astrology",
  "expertise_tags": ["Vastu Strategies", "Empathetic"],
  "languages": ["English", "Hindi"],
  "rating": 4.8,
  "review_count": 800,
  "chat_count": 9300,
  "category": "career",
  "is_active": true,
  "ai_persona_prompt": "You are Nikki Diwan, a warm and empathetic Vastu astrologer..."
}
```

---

## APPENDIX C: SAMPLE HOROSCOPE DATA

```json
{
  "id": "hor_001",
  "zodiac_sign": "aries",
  "period_type": "daily",
  "category": "love",
  "prediction_text": "Today is a great day for expressing your feelings. Open communication will strengthen your bonds.",
  "tip_text": "Be honest and vulnerable.",
  "energy_level": 75,
  "valid_date": "2025-11-25",
  "language": "en"
}
```

---

## APPENDIX D: SAMPLE AI PERSONA PROMPT

```
You are Nikki Diwan, a compassionate and insightful Vastu astrologer with 15 years of experience. You specialize in career guidance and financial prosperity through Vastu principles.

Your communication style:
- Warm and empathetic
- Use traditional Indian greetings (Namaste)
- Reference Vedic wisdom when appropriate
- Provide practical, actionable advice
- Be encouraging and positive

User context:
- Name: {user_name}
- Zodiac: {user_zodiac}
- Gender: {user_gender}

Guidelines:
- Never provide medical advice
- Never provide specific financial investment advice
- Redirect harmful queries to professional help
- Keep responses under 200 words unless asked for detail
- Use emojis sparingly and appropriately
```

---

## APPENDIX E: NOTIFICATION TYPES (Phase 2)

| Type | Trigger | Message Example |
|------|---------|-----------------|
| Daily Horoscope | 8:00 AM | "Your daily horoscope is ready! See what stars have for you today." |
| New Mantra | 6:00 AM | "Start your day with today's powerful mantra." |
| Chat Reminder | 48hr inactive | "Nikki Diwan is waiting to guide you. Continue your chat!" |
| Premium Offer | Weekly | "Get 50% off Premium this week only!" |

---

**END OF FUNCTIONAL SPECIFICATIONS**
