# Main Application Screens - Desktop/Responsive Web Specifications

## Global Application Layout Structure

### Desktop Navigation Architecture
```
Screen Layout:
- Sidebar Navigation: 280px width (collapsible to 80px)
- Main Content Area: Remaining width (calc(100% - 280px))
- Top Bar: 64px height
- Content Viewport: calc(100vh - 64px)
```

### Persistent Navigation Components

#### Sidebar Navigation (Left)
- **Width**: 280px expanded, 80px collapsed
- **Height**: 100vh
- **Background**: White with 1px right border #E0E0E0
- **Position**: Fixed left
- **Z-index**: 1000
- **Transition**: Width 300ms ease
- **Box Shadow**: 2px 0 8px rgba(0,0,0,0.04)

##### Sidebar Header
- **Height**: 64px (matches top bar)
- **Padding**: 20px
- **Logo**: 40px x 40px when expanded, centered when collapsed
- **App Name**: "Sentinel" - 20px semibold (hidden when collapsed)
- **Border Bottom**: 1px solid #E0E0E0

##### Navigation Items
- **Item Height**: 48px
- **Padding**: 12px 20px
- **Font Size**: 15px medium
- **Icon Size**: 24px x 24px
- **Icon Margin Right**: 16px (when expanded)
- **Border Radius**: 8px with 8px margin horizontal
- **Active State**: 
  - Background: Primary color with 0.1 opacity
  - Text Color: Primary color
  - Left Border: 3px solid primary color
- **Hover State**: Background #F5F5F5
- **Transition**: All 200ms ease

##### Navigation Structure
```
Primary Navigation:
- Dashboard (Grid icon)
- Chats (Message icon)
- Connections (Users icon)
- Contacts (Book icon)
- Notifications (Bell icon with badge)

Bottom Section:
- Settings (Gear icon)
- Help Center (Question mark icon)
- Profile (User avatar)
- Sign Out (Logout icon)
```

##### Collapse Toggle
- **Position**: Bottom of sidebar, above profile
- **Icon**: Chevron left/right
- **Size**: 40px x 40px click target
- **Behavior**: Persist preference in localStorage

#### Top Bar
- **Height**: 64px
- **Background**: White
- **Border Bottom**: 1px solid #E0E0E0
- **Padding**: 0 32px
- **Position**: Fixed top
- **Z-index**: 999

##### Top Bar Content
- **Left Section** (40%):
  - Hamburger Menu: 40px x 40px (shows on tablet/mobile only)
  - Page Title: 20px semibold
  - Breadcrumbs: 14px with separator "/"

- **Center Section** (20%):
  - Global Search Bar (optional based on page)

- **Right Section** (40%):
  - Quick Actions: Flexbox, right aligned
  - Notification Bell: 40px x 40px, badge overlay
  - Help Icon: 40px x 40px
  - User Avatar: 36px x 36px with dropdown
  - Theme Toggle: Light/Dark mode

## Screen 1: Dashboard - Desktop

### Content Layout
- **Container**: Max-width 1600px, centered
- **Padding**: 32px
- **Background**: #F8F9FA (light grey)

### Dashboard Header Section
- **Height**: Auto
- **Margin Bottom**: 32px

#### Welcome Message
- **Container**: White card, full width
- **Padding**: 32px
- **Border Radius**: 12px
- **Box Shadow**: 0 2px 8px rgba(0,0,0,0.06)

- **Content Layout**: Flexbox, space-between
  - Left Side:
    - Avatar: 64px x 64px circular
    - Greeting Text: "Welcome back, [Name]" - 28px semibold
    - Subtext: Current date and time - 16px, 0.7 opacity
  - Right Side:
    - Quick Stats: 3 metric cards in row
    - Each Metric: Number (24px bold) + Label (14px)
    - Examples: "12 New Messages" | "5 Tasks Today" | "3 Meetings"

#### Quick Prompt Bar
- **Margin Top**: 24px
- **Container**: White background
- **Border**: 1px solid #E0E0E0
- **Border Radius**: 8px
- **Height**: 56px
- **Layout**: Flexbox

- **Input Field**:
  - Placeholder: "Ask me anything..." - 16px
  - Padding: 16px 16px 16px 56px
  - No Border
  - Flex: 1

- **AI Icon**: 
  - Position: Absolute left 16px
  - Size: 28px x 28px
  - Style: Gradient or animated

- **Action Buttons**:
  - Microphone: 40px x 40px
  - Camera/Image: 40px x 40px
  - Send: 40px x 40px (primary color when text present)

### Widget Grid System
- **Layout**: CSS Grid
- **Grid Template**: 
  ```css
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 24px;
  ```
- **Responsive Columns**:
  - Ultra-wide (>1920px): 4 columns
  - Desktop (1440-1920px): 3 columns
  - Small Desktop (1024-1439px): 2 columns
  - Tablet (<1024px): 1 column

### Widget Card Template
- **Container**: White background
- **Border Radius**: 12px
- **Box Shadow**: 0 2px 8px rgba(0,0,0,0.06)
- **Hover State**: Transform translateY(-2px), shadow increase
- **Transition**: All 200ms ease

#### Widget Header
- **Height**: 56px
- **Padding**: 16px 20px
- **Border Bottom**: 1px solid #F0F0F0
- **Layout**: Flexbox, space-between

- **Title Section**:
  - Icon: 20px x 20px
  - Title: 16px semibold
  - Badge/Count: Optional, 12px

- **Actions Section**:
  - Expand/Collapse: 32px x 32px
  - Settings: 32px x 32px
  - Refresh: 32px x 32px
  - More Options: 32px x 32px (three dots)

#### Widget Body
- **Padding**: 20px
- **Min Height**: 200px
- **Max Height**: 400px (scrollable)
- **Overflow**: Auto with custom scrollbar

### Individual Widget Specifications

#### Events Widget (Calendar)
- **Default Size**: Span 2 columns on desktop
- **Content**:
  - Timeline View: Next 24 hours
  - Event Card: 
    - Height: 72px
    - Left Border: 4px colored by calendar type
    - Time: 14px medium
    - Title: 16px semibold
    - Location/Meet Link: 14px with icon
    - Attendees: Avatar stack (max 3 shown)
- **Empty State**: "No upcoming events" with illustration
- **Action Button**: "View Full Calendar" bottom link

#### Travel Widget
- **Content**:
  - Flight Card:
    - Airline Logo: 40px x 40px
    - Flight Number: 16px bold
    - Route: "SFO → JFK" 18px
    - Time: Departure and arrival
    - Status Badge: On time/Delayed
    - Gate Information: If available
  - Hotel Card:
    - Hotel Name: 16px semibold
    - Check-in/out dates
    - Confirmation Number
    - Address with map link

#### To-Do List Widget
- **Header**: Count of completed/total
- **List Items**:
  - Checkbox: 20px x 20px
  - Task Text: 15px, strikethrough when complete
  - Due Time: 13px, red if overdue
  - Priority Indicator: Colored dot
  - Drag Handle: For reordering (on hover)
- **Add Task**: 
  - Inline input at bottom
  - Plus button or Enter to add

#### Calendar Month Widget
- **Grid**: 7x6 calendar grid
- **Day Cell**: 
  - Height: 40px
  - Number: Top-left
  - Event Dots: Max 3, different colors
  - Today: Primary color background
  - Selected: Border 2px primary
- **Navigation**: Previous/Next month arrows

#### Work/Life Appointments
- **Toggle**: Work/Personal/All filter
- **List View**: Similar to Events widget
- **Color Coding**: 
  - Work: Blue palette
  - Personal: Green palette
  - Shared: Purple palette

#### Birthdays Widget
- **Layout**: List with avatars
- **Content**:
  - Avatar: 40px circular
  - Name: 15px semibold
  - Date: "Today", "Tomorrow", or date
  - Age: Optional, 13px grey
  - Action: "Send wishes" button

#### Shopping List Widget
- **Categories**: Collapsible sections
- **Items**:
  - Checkbox: 20px
  - Item Name: 15px
  - Quantity: 14px grey
  - Delete: X icon on hover
- **Add Item**: Bottom input with category dropdown

#### Wellness Widget
- **Stats Grid**: 2x2
  - Water Intake: Progress circle
  - Steps: Bar chart
  - Sleep: Hours with quality indicator
  - Meditation: Streak counter
- **Reminders**: List with time and action

#### Alarms Widget
- **Alarm Card**:
  - Time: 24px bold
  - Label: 14px
  - Repeat: Days of week
  - Toggle: Switch 48px x 28px
  - Edit/Delete: Icon buttons

#### Custom Widget
- **Add Custom**: Plus icon card
- **Builder Modal**: 
  - Widget Type selector
  - Data Source picker
  - Display Options
  - Preview Panel

### Widget Management Mode
- **Edit Mode Toggle**: Button in dashboard header
- **Edit State**:
  - Drag Handles: Visible on widgets
  - Resize Handles: Corner grips
  - Delete Button: X in corner
  - Grid Guidelines: Visible during drag
- **Add Widget Panel**: 
  - Slide-out from right
  - Widget Gallery with previews
  - Search/Filter options

### Chat History Button
- **Position**: Fixed bottom-right (FAB style)
- **Size**: 64px x 64px
- **Icon**: Message icon 28px
- **Badge**: Unread count
- **Shadow**: Elevated appearance
- **Hover**: Scale 1.1
- **Click**: Opens chat sidebar overlay

## Screen 2: Chats Hub - Desktop

### Layout Structure
- **Three-Panel Layout**:
  - Conversations List: 360px fixed width
  - Chat View: Flexible center (min 500px)
  - Info Panel: 320px (toggleable)

### Conversations List Panel (Left)

#### Header
- **Height**: 64px
- **Padding**: 16px
- **Search Bar**: 
  - Height: 40px
  - Icon: Search 20px
  - Placeholder: "Search conversations"
  - Clear Button: When text present

#### Tabs Navigation
- **Container**: Below search
- **Tab Items**: "All Chats" | "Groups" | "Contacts"
- **Tab Style**: 
  - Height: 48px
  - Bottom Border: 2px primary when active
  - Count Badge: 12px text in parentheses

#### Conversation List
- **Container**: Scrollable
- **Height**: calc(100vh - 176px)
- **Custom Scrollbar**: 4px width

#### Conversation Item
- **Container**: 
  - Height: 72px
  - Padding: 12px 16px
  - Hover: Background #F8F9FA
  - Active: Background #E3F2FD
  - Border Bottom: 1px solid #F0F0F0

- **Layout**: Grid
  ```css
  grid-template-columns: 48px 1fr auto;
  grid-template-rows: 1fr 1fr;
  gap: 12px 8px;
  ```

- **Avatar**: 
  - Size: 48px circular
  - Online Indicator: 12px green dot
  - Group Icon Overlay: For group chats

- **Name**: 
  - Font: 15px semibold
  - Truncate: Ellipsis overflow

- **Last Message**:
  - Font: 14px regular
  - Color: 0.7 opacity
  - Truncate: Single line
  - Typing Indicator: Animated dots

- **Metadata**:
  - Timestamp: 12px, top-right
  - Unread Badge: 20px circle, primary color
  - Delivered/Read Icons: 16px

#### New Chat FAB
- **Position**: Bottom-right of panel
- **Size**: 56px circular
- **Icon**: Plus or compose
- **Menu Options**: 
  - New Chat
  - New Group
  - Chat with Sentinel

### Chat View Panel (Center)

#### Chat Header
- **Height**: 72px
- **Background**: White
- **Border Bottom**: 1px solid #E0E0E0
- **Padding**: 16px 24px

- **Layout**: Flexbox
  - Left: Avatar (40px) + Name/Status
  - Center: Optional context pills
  - Right: Action buttons

- **Name Section**:
  - Name: 18px semibold
  - Status: 13px green "Online" or "Last seen"

- **Action Buttons**:
  - Voice Call: 40px x 40px
  - Video Call: 40px x 40px
  - Search: 40px x 40px
  - Info: 40px x 40px (toggles right panel)

#### Messages Container
- **Height**: calc(100vh - 200px)
- **Padding**: 24px
- **Background**: #FAFAFA
- **Overflow**: Auto, scroll to bottom default

#### Message Bubble Design

**Sent Messages (Right)**:
- **Max Width**: 60% of container
- **Background**: Primary color
- **Text Color**: White
- **Border Radius**: 18px 18px 4px 18px
- **Padding**: 12px 16px
- **Margin**: 4px 0

**Received Messages (Left)**:
- **Max Width**: 60% of container
- **Background**: White
- **Border**: 1px solid #E0E0E0
- **Border Radius**: 18px 18px 18px 4px
- **Padding**: 12px 16px

**Message Content Types**:

- **Text Message**:
  - Font: 15px regular
  - Line Height: 1.4
  - Word Break: Break-word

- **AI Response** (Markdown):
  - Styled Markdown rendering
  - Code Blocks: Monospace with background
  - Tables: Bordered and striped
  - Lists: Proper indentation
  - Links: Underlined, primary color

- **Image Message**:
  - Max Width: 300px
  - Border Radius: 8px
  - Click: Lightbox preview
  - Download Button: Overlay

- **Voice Message**:
  - Width: 250px
  - Waveform Visualization
  - Play/Pause Button: 32px
  - Duration: 12px text
  - Playback Speed: 1x/1.5x/2x

- **File Attachment**:
  - Width: 280px
  - Icon: File type icon 32px
  - Name: 14px truncated
  - Size: 12px grey
  - Download Button

**Message Metadata**:
- **Timestamp**: 11px, grey, bottom-right
- **Read Receipts**: 
  - Single check: Sent
  - Double check: Delivered
  - Double check blue: Read
- **Edited Indicator**: "edited" 11px italic

#### Message Groups
- **Date Divider**:
  - Centered text: "Today", "Yesterday", or date
  - Font: 12px medium
  - Line-through dividers
  - Margin: 24px vertical

- **Sender Groups**: Messages within 1 minute grouped
  - First shows avatar/name
  - Subsequent only show bubble

#### Typing Indicator
- **Style**: Three dots animation
- **Position**: Below last message
- **Height**: 40px reserved space

#### Input Area
- **Container**: White background
- **Height**: Auto, min 64px, max 160px
- **Border Top**: 1px solid #E0E0E0
- **Padding**: 16px

- **Layout**: Flexbox
  - Attachment Button: 40px
  - Input Field: Flex 1
  - Voice Button: 40px
  - Send Button: 40px

- **Input Field**:
  - Multiline Textarea
  - Auto-resize
  - Placeholder: "Type your message..."
  - Font: 15px
  - Padding: 12px

- **Attachment Menu** (on click):
  - Position: Above button
  - Options: Photo, File, Location, Contact
  - Icons: 24px with labels

- **Voice Recording** (on hold):
  - Replace input with recording UI
  - Timer: Counting up
  - Waveform: Real-time visualization
  - Cancel/Send options

### Info Panel (Right)

#### Panel Header
- **Height**: 64px
- **Title**: "Chat Info" or "Group Info"
- **Close Button**: X icon top-right

#### Content Sections

**Profile Section**:
- **Avatar**: 96px centered
- **Name**: 20px semibold centered
- **Status**: 14px centered
- **Bio/Description**: 14px regular

**Quick Actions**:
- **Grid**: 3 columns
- **Button Size**: 64px x 64px
- **Options**: 
  - Mute
  - Search
  - Pin Chat
  - Block
  - Delete
  - Archive

**Shared Media**:
- **Tabs**: Photos | Files | Links
- **Grid View**: 3 columns for photos
- **List View**: For files and links
- **See All**: Link to media browser

**Group Members** (Groups only):
- **Member Item**:
  - Avatar: 40px
  - Name: 15px
  - Role Badge: Admin/Member
  - Last Seen: 12px grey
  - Actions: Make admin, Remove

**Settings Section**:
- **Notifications**: Toggle with options
- **Encryption**: Status indicator
- **Auto-delete**: Timer settings
- **Background**: Color/image picker

## Screen 3: Connections - Desktop

### Page Header
- **Title**: "My Connections" - 28px semibold
- **Subtitle**: "Manage your Sentinel network" - 16px grey
- **Action Button**: "Share My Sentinel" primary button

### Search and Filter Bar
- **Container**: White card, full width
- **Height**: 72px
- **Padding**: 16px
- **Layout**: Flexbox

- **Search Input**:
  - Width: 400px
  - Placeholder: "Search by name, company, or role"
  - Search Icon: Left

- **Filter Chips**:
  - All | Work | Family | Friends | Custom
  - Active Chip: Primary background
  - Count: In parentheses

- **Sort Dropdown**:
  - Options: Recent | Alphabetical | Most Contacted
  - Default: Recent

### Connections Grid
- **Layout**: CSS Grid
- **Columns**: 
  - Ultra-wide: 4 columns
  - Desktop: 3 columns
  - Small Desktop: 2 columns
- **Gap**: 24px

### Connection Card
- **Container**: White background
- **Border**: 1px solid #E0E0E0
- **Border Radius**: 12px
- **Padding**: 24px
- **Height**: 280px
- **Hover**: Shadow elevation, transform

#### Card Content
- **Header**:
  - Avatar: 64px circular
  - Online Status: Green dot overlay
  - Name: 18px semibold
  - Company/Role: 14px grey

- **Stats Row**:
  - Last Interaction: With icon
  - Messages: Count
  - Shared Access: Icons for permissions

- **Last Message Preview**:
  - Container: Grey background
  - Padding: 12px
  - Border Radius: 8px
  - Text: 14px, 2 lines max
  - Timestamp: 12px

- **Actions**:
  - Message: Primary button
  - View Profile: Secondary button
  - More Options: Three dots menu

### Add Connection Modal
- **Width**: 600px
- **Sections**:
  - Search existing users
  - Invite via email
  - Share link/QR code
  - Import from contacts

### Permissions Management
- **Quick Toggle**: In card
- **Detailed View**: Modal with all options
- **Permission Categories**:
  - Calendar: Work/Personal/All/None
  - Location: Exact/Area/City/None
  - Email: All/Specific/None
  - Life Events: On/Off

## Screen 4: Contacts - Desktop

### Layout Structure
- **Two Column Layout**:
  - Contact List: 400px fixed
  - Contact Detail: Remaining width

### Contact List Panel

#### Header Controls
- **Search Bar**: Full width
- **View Toggle**: List/Grid view
- **Add Button**: "New Contact"

#### Alphabet Index
- **Position**: Fixed right of panel
- **Letters**: A-Z vertical list
- **Size**: 14px
- **Active Letter**: Highlighted
- **Click**: Jump to section

#### Contact List Items
- **Height**: 64px
- **Layout**: Avatar + Name + Details
- **Grouping**: By first letter with headers
- **Selection**: Checkbox for bulk actions
- **Actions**: Hover reveals quick actions

### Contact Detail Panel

#### Empty State
- **Illustration**: 200px centered
- **Text**: "Select a contact to view details"

#### Contact Information
- **Header Section**:
  - Avatar: 120px with edit overlay
  - Name: 24px editable field
  - Title/Company: 16px
  - Connection Status: Badge

- **Information Tabs**:
  - Overview | Communication | Calendar | Permissions

- **Contact Fields**:
  - Phone Numbers: Multiple with labels
  - Email Addresses: Multiple with labels
  - Addresses: Formatted address blocks
  - Social Links: Icons with handles
  - Notes: Rich text field

#### Action Bar
- **Position**: Sticky top
- **Actions**: 
  - Message
  - Call
  - Email
  - Share Sentinel
  - Edit
  - Delete

### Add Contact Methods

#### Manual Entry Form
- **Layout**: Two columns for fields
- **Sections**: 
  - Basic Info
  - Contact Methods
  - Address
  - Additional Info

#### QR Code Scanner
- **Camera View**: 480px x 480px
- **Guide Overlay**: Square target
- **Manual Code**: Input below camera

#### Import Interface
- **Source Selection**: 
  - Device Contacts
  - Google Contacts
  - CSV Upload
- **Preview Table**: Before import
- **Duplicate Detection**: Merge options

## Screen 5: Notifications Center - Desktop

### Page Layout
- **Header**: With filter tabs
- **Notification List**: Center column, max-width 800px
- **Right Sidebar**: Quick actions and stats

### Notification Types/Tabs
- **All**: Complete list
- **Recent**: Last 24 hours
- **Upcoming**: Future dated
- **Archive**: Past items

### Notification Card
- **Container**: White background
- **Border Left**: 4px colored by category
- **Padding**: 20px
- **Margin Bottom**: 12px

#### Card Structure
- **Icon Column**: 48px
  - Category Icon: 32px
  - Color coded by type

- **Content Column**: Flexible
  - Title: 16px semibold
  - Description: 14px regular
  - Source: 12px grey (Gmail, Calendar, etc.)
  - Timestamp: 12px

- **Action Column**: Right aligned
  - Primary Action: Button or link
  - Secondary Actions: Icon buttons
  - Priority Star: Toggle

#### Category Colors
- **Travel**: Blue (#2196F3)
- **Family**: Green (#4CAF50)
- **Work**: Purple (#9C27B0)
- **Social**: Orange (#FF9800)
- **Health**: Red (#F44336)

### Notification Actions
- **Swipe Actions** (with animation):
  - Left: Mark as read/unread
  - Right: Archive/Delete

- **Bulk Actions Bar**:
  - Appears with selection
  - Mark Read | Archive | Delete | Categorize

### Smart Grouping
- **Group Header**: 
  - Category Name: 16px semibold
  - Count: Badge
  - Expand/Collapse: Chevron

- **AI Insights Badge**:
  - "Sentinel organized this"
  - Suggestion for action

### Settings Gear Menu
- **Position**: Top right
- **Options**:
  - Notification preferences
  - Category settings
  - DND schedule
  - Sync settings

## Screen 6: Settings Hub - Desktop

### Layout Structure
- **Sidebar Navigation**: 280px fixed
- **Settings Content**: Remaining width, max 960px

### Settings Sidebar
- **Section Headers**: 12px uppercase, grey
- **Menu Items**: 
  - Height: 44px
  - Padding: 12px 20px
  - Active: Background highlight
  - Icons: 20px left side

#### Settings Categories
```
PERSONAL
- Profile
- Account
- Security

SENTINEL
- Dashboard
- Your Sentinel
- AI Preferences

INTEGRATIONS
- Email Settings
- Calendar
- WhatsApp

PREFERENCES
- Notifications
- Appearance
- Privacy

SYSTEM
- About
- Help & Support
- Legal
```

### Settings Content Panels

#### Profile Settings
- **Avatar Section**:
  - Image: 120px circular
  - Change Button: Overlay
  - Remove Option

- **Form Fields**:
  - Two-column layout for names
  - Full width for email/phone
  - Field Height: 48px
  - Labels: Above fields

#### Dashboard Settings
- **Widget Manager**:
  - Drag-drop list with handles
  - Toggle switches for each widget
  - Preview thumbnails
  - Reset to default button

#### Email Settings
- **Account List**:
  - Card for each account
  - Status indicator
  - Sync stats
  - Remove/Edit buttons

- **Add Account Flow**:
  - Provider selection
  - OAuth or IMAP setup
  - Test connection step

#### Notification Settings
- **Category Grid**:
  - 2x3 grid of categories
  - Icon + Toggle + Settings gear
  - Custom rules option

- **Channel Preferences**:
  - Push: Toggle with test button
  - Email: Digest options
  - WhatsApp: Number verification

- **DND Schedule**:
  - Time picker for start/end
  - Day selector
  - Override options

#### Security Settings
- **Password Section**:
  - Current password field
  - New password with strength
  - Last changed timestamp

- **Two-Factor Auth**:
  - Status card
  - Setup wizard
  - Backup codes display
  - Device list

- **Sessions**:
  - Active sessions table
  - Device, location, time
  - Revoke button

#### Appearance Settings
- **Theme Selector**:
  - Light/Dark/Auto cards with preview
  - Accent color picker
  - Font size slider

## Responsive Behavior Specifications

### Breakpoint Transitions

#### 1440px → 1024px (Small Desktop)
- Sidebar: Collapsible only
- Chat: Hide info panel by default
- Dashboard: 2 column widget grid
- Settings: Reduce content max-width to 720px

#### 1024px → 768px (Tablet)
- Navigation: Bottom tabs instead of sidebar
- Chat: Single panel with navigation
- Dashboard: Single column widgets
- Modals: Full screen instead of centered

#### 768px → Mobile
- All panels: Full screen
- Navigation: Bottom tab bar
- Typography: Increase touch targets
- Forms: Single column
- Tables: Card view transformation

### Performance Optimizations

#### Lazy Loading
- Images: Intersection Observer
- Widgets: Load on viewport entry
- Chat History: Infinite scroll
- Attachments: On-demand loading

#### Caching Strategy
- Static Assets: 1 year
- API Responses: 5 minutes
- User Data: Session storage
- Preferences: Local storage

#### Code Splitting
- Route-based splitting
- Component lazy loading
- Third-party libraries separate
- CSS modules per component

### Accessibility Requirements

#### Keyboard Navigation
- Tab order logical flow
- Skip links available
- Focus trap in modals
- Escape key handling

#### Screen Readers
- ARIA labels complete
- Live regions for updates
- Semantic HTML structure
- Alt text for all images

#### Visual Accessibility
- WCAG AA compliance
- High contrast mode support
- Focus indicators visible
- Text scalable to 200%