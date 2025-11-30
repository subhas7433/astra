# Week 3: Chat System - Implementation Sessions
## Astro GPT Flutter App
**Total Duration:** 24 hours (6 sessions x 4 hours)

---

## Executive Summary

### Week 3 Goal
Complete AI Chat system with astrologer personas, message UI, and ad-gated free chats

### What We're Building
- Chat module with full conversation UI
- Message bubbles (user and AI variants)
- Chat input with send functionality
- Typing indicator animation
- ChatController with mock AI responses
- Chat sessions and history
- Ad integration for free chat credits
- Menu popup (Clear, Report, Block)

### What We're NOT Building
- Real AI backend integration (using mocks)
- Voice input (Phase 2)
- Image sharing in chat
- Video calls

### Prerequisites (from Week 1-2)
- [x] AstrologerModel and repository
- [x] AstrologerDetailScreen (entry point)
- [x] Base widgets (AppButton, AppCard)
- [x] Theme system configured
- [x] Navigation infrastructure

---

## Session 1: Chat Module Structure (4 hours)

### Objectives
1. Create Chat module folder structure
2. Implement ChatController with state management
3. Build ChatScreen scaffold
4. Create ChatAppBar with astrologer info
5. Set up ChatBinding and routing

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `chat/` module | Complete folder structure |
| `ChatController` | Messages state, send/receive logic |
| `ChatBinding` | Dependency injection |
| `ChatScreen` | Main chat scaffold |
| `ChatAppBar` | Astrologer avatar, name, status, menu |

### Module Structure
```
lib/app/modules/chat/
├── bindings/
│   └── chat_binding.dart
├── controllers/
│   └── chat_controller.dart
├── models/
│   └── chat_state.dart
├── views/
│   └── chat_screen.dart
└── widgets/
    ├── chat_app_bar.dart
    ├── message_bubble.dart
    ├── message_input.dart
    ├── typing_indicator.dart
    ├── chat_menu_popup.dart
    └── ad_modal.dart
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Create module folders | 15 min | Folder structure |
| ChatController | 75 min | Full state management |
| ChatBinding | 15 min | DI setup |
| ChatScreen scaffold | 45 min | Basic structure |
| ChatAppBar | 50 min | Avatar, name, menu icon |

### ChatController Structure
```dart
class ChatController extends BaseController {
  // Dependencies
  final AstrologerModel astrologer;
  final ChatRepository _chatRepo;
  final AIService _aiService;

  // State
  final messages = <MessageModel>[].obs;
  final isTyping = false.obs;
  final freeChatsRemaining = 3.obs;
  final inputText = ''.obs;

  // Methods
  Future<void> sendMessage(String text);
  Future<void> _getAIResponse(String userMessage);
  void onWatchAdComplete();
  void clearChat();
  void reportChat();
}
```

### Acceptance Criteria
- [ ] Chat screen opens from AstrologerDetailScreen
- [ ] AppBar shows astrologer info correctly
- [ ] Controller initializes with astrologer data
- [ ] Route parameter passes astrologer ID
- [ ] Back navigation works correctly

---

## Session 2: Message Components (4 hours)

### Objectives
1. Create MessageBubble widget (user and AI variants)
2. Build TypingIndicator animation
3. Implement message list with auto-scroll
4. Add timestamp display
5. Handle different message states (sent, delivered, error)

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `MessageBubble` | User and AI message variants |
| `TypingIndicator` | Animated dots indicator |
| `MessageList` | Scrollable message container |
| `MessageTimestamp` | Time display component |
| `MessageStatus` | Sent/delivered/error icons |

### Message Bubble Specs (from design)
```
User Message:
- Align: Right
- Background: Primary color (#F26B4E)
- Text: White
- Border radius: 16dp (top-left, top-right, bottom-left)
- Max width: 75% of screen

AI Message:
- Align: Left
- Background: White
- Text: Dark (#1A1A2E)
- Border radius: 16dp (top-left, top-right, bottom-right)
- Avatar: Small circular on left
- Max width: 75% of screen
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| MessageBubble (user) | 40 min | Right-aligned bubble |
| MessageBubble (AI) | 40 min | Left-aligned with avatar |
| TypingIndicator | 45 min | Animated dots |
| MessageList | 50 min | ListView with auto-scroll |
| Timestamp display | 25 min | Time formatting |
| Message status | 40 min | State indicators |

### Typing Indicator Animation
```dart
// Three dots with staggered animation
class TypingIndicator extends StatefulWidget {
  // Dots animate up/down in sequence
  // Duration: 300ms per dot
  // Delay: 150ms between dots
  // Loop continuously while visible
}
```

### Acceptance Criteria
- [ ] User messages align right with correct styling
- [ ] AI messages align left with avatar
- [ ] Typing indicator animates smoothly
- [ ] List auto-scrolls to new messages
- [ ] Timestamps show correctly formatted time

---

## Session 3: Chat Input & Send Flow (4 hours)

### Objectives
1. Build ChatInput widget with text field
2. Implement send button with states
3. Create message send flow
4. Add input validation
5. Handle keyboard interactions

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `ChatInput` | Text field + send button |
| Send flow | User input → Controller → Mock AI |
| Input validation | Empty check, max length |
| Keyboard handling | Auto-focus, dismiss on send |
| Input states | Enabled, disabled, sending |

### Chat Input Specs (from design)
```
┌─────────────────────────────────┐
│ [Type your message...    ] [➤] │
└─────────────────────────────────┘

- Background: White card
- Border radius: 24dp
- Send button: Circular, primary color
- Send icon: Arrow or send icon
- Disabled when empty
- Max length: 500 characters
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| ChatInput widget | 60 min | Complete input component |
| Send button states | 30 min | Enabled/disabled/loading |
| Send message flow | 50 min | Full send pipeline |
| Input validation | 25 min | Empty, length checks |
| Keyboard handling | 35 min | Focus, dismiss logic |
| Input field styling | 40 min | Match design specs |

### Send Flow Sequence
```
1. User types message
2. Send button enables (non-empty)
3. User taps send
4. Message added to list (pending state)
5. Input clears, keyboard stays
6. Show typing indicator
7. AI response received (mock: 1-3s delay)
8. Typing indicator hides
9. AI message added to list
10. Auto-scroll to bottom
```

### Acceptance Criteria
- [ ] Input field captures text correctly
- [ ] Send button disabled when empty
- [ ] Message sends on button tap
- [ ] Input clears after send
- [ ] Keyboard remains open after send
- [ ] Error state shows if send fails

---

## Session 4: AI Mock Service & Responses (4 hours)

### Objectives
1. Create AIService with mock responses
2. Implement astrologer persona responses
3. Add response delay simulation
4. Create response templates
5. Handle error scenarios

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `AIService` | Mock AI response generator |
| `ResponseTemplates` | Persona-based response sets |
| Delay simulation | 1-3 second random delays |
| Context awareness | Basic keyword matching |
| Error handling | Timeout, failure scenarios |

### AI Service Structure
```dart
class AIService {
  // Generate mock response based on persona and input
  Future<String> generateResponse({
    required AstrologerModel astrologer,
    required String userMessage,
    required List<MessageModel> context,
  });

  // Response delay simulation
  Future<void> _simulateThinking();

  // Template selection based on keywords
  String _selectTemplate(String input, String persona);
}
```

### Response Templates (by category)
```dart
// Love/Relationship responses
final loveResponses = [
  "The stars indicate positive energy in your love life...",
  "Venus is favorably positioned for romance...",
  "I see a meaningful connection approaching...",
];

// Career responses
final careerResponses = [
  "Jupiter's influence suggests career growth...",
  "Your professional path shows promising signs...",
  "The planetary alignment favors new opportunities...",
];

// General responses
final generalResponses = [
  "Based on your birth chart...",
  "The cosmic energies suggest...",
  "Let me consult the stars for guidance...",
];
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| AIService class | 45 min | Service structure |
| Response templates | 60 min | 20+ template responses |
| Keyword matching | 40 min | Category detection |
| Delay simulation | 20 min | Random 1-3s delay |
| Persona integration | 35 min | Style per astrologer |
| Error scenarios | 40 min | Timeout, failures |

### Acceptance Criteria
- [ ] AI responses feel natural (not instant)
- [ ] Responses vary (not repetitive)
- [ ] Responses match astrologer persona
- [ ] Keyword detection works (love, career, etc.)
- [ ] Error handling shows user-friendly message

---

## Session 5: Ad Integration & Free Chat Flow (4 hours)

### Objectives
1. Implement free chat credit system
2. Create AdModal for watching ads
3. Integrate rewarded ad placeholder
4. Build credit display UI
5. Handle ad completion callback

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| Credit system | 3 free chats, watch ad for more |
| `AdModal` | "Unlock Free Chat" popup |
| Rewarded ad integration | Placeholder for AdMob |
| Credit display | Show remaining in UI |
| `AdController` | Manage ad state and rewards |

### Ad Modal Specs (from design)
```
┌─────────────────────────────────┐
│            [X close]            │
│                                 │
│    🎬 Unlock Free Chat          │
│                                 │
│    Watch a short video to       │
│    continue chatting for free   │
│                                 │
│    [ Watch Video Ad ]           │
│                                 │
│    ── or ──                     │
│                                 │
│    [ Go Premium - No Ads ]      │
│                                 │
└─────────────────────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| Credit system logic | 45 min | Track free chats |
| AdModal widget | 50 min | Popup UI |
| AdController | 45 min | Ad state management |
| Rewarded ad placeholder | 40 min | Mock ad flow |
| Credit display UI | 30 min | Remaining chats indicator |
| Premium upsell flow | 30 min | Navigation to premium |

### Credit System Flow
```
1. User starts with 3 free messages per session
2. Each sent message decrements counter
3. At 0 credits, show AdModal before send
4. User watches ad → +3 credits
5. Or user goes premium → unlimited
6. Credits reset on new session (or persist - TBD)
```

### Acceptance Criteria
- [ ] Free chat counter works correctly
- [ ] AdModal shows when credits exhausted
- [ ] "Watch Ad" triggers ad flow
- [ ] Credits added after ad completion
- [ ] Premium option navigates to paywall
- [ ] Close button dismisses modal

---

## Session 6: Chat Menu & History (4 hours)

### Objectives
1. Implement chat menu popup
2. Add clear chat functionality
3. Build chat session persistence
4. Create chat history list (optional)
5. Final integration and testing

### Key Deliverables

| Deliverable | Description |
|-------------|-------------|
| `ChatMenuPopup` | Clear, Report, Block options |
| Clear chat | Confirmation + clear messages |
| Session persistence | Save/load chat sessions |
| `ChatHistoryScreen` | List of past conversations |
| Widget tests | Tests for chat components |

### Menu Popup Options
```
┌─────────────────┐
│ 🗑️ Clear Chat   │
│ ⚠️ Report       │
│ 🚫 Block        │
└─────────────────┘
```

### Tasks Breakdown
| Task | Duration | Output |
|------|----------|--------|
| ChatMenuPopup | 40 min | Popup menu widget |
| Clear chat flow | 35 min | Confirm + clear |
| Report/Block stubs | 25 min | Placeholder actions |
| Session persistence | 50 min | Local storage |
| Chat history screen | 45 min | Past sessions list |
| Widget tests | 45 min | Component tests |

### Chat Persistence
```dart
// Save chat session to local storage
class ChatStorage {
  Future<void> saveSession(ChatSession session);
  Future<ChatSession?> loadSession(String astrologerId);
  Future<List<ChatSession>> getAllSessions();
  Future<void> clearSession(String astrologerId);
}
```

### Acceptance Criteria
- [ ] Menu popup opens on icon tap
- [ ] Clear chat shows confirmation dialog
- [ ] Chat persists between app restarts
- [ ] Chat history shows past sessions
- [ ] Report/Block show placeholder toast
- [ ] All widget tests pass

---

## Week 3 Success Metrics

| Metric | Target |
|--------|--------|
| Message send latency | <100ms to show in list |
| AI response time | 1-3s (simulated) |
| Scroll performance | 60fps with 100+ messages |
| Widget test coverage | >75% for chat components |
| Ad modal conversion | Tracked (analytics ready) |

## Reusable Components Created

| Component | Reuse Potential |
|-----------|-----------------|
| `MessageBubble` | Any chat-like UI |
| `TypingIndicator` | Loading states |
| `ChatInput` | Any text input with send |
| `AdModal` | Any ad-gated feature |
| `PopupMenu` | Other context menus |

## State Management Pattern

```dart
// Chat state for clean management
class ChatState {
  final List<MessageModel> messages;
  final bool isTyping;
  final int freeCredits;
  final bool isAdModalVisible;
  final String? error;

  ChatState copyWith({...});
}
```

---

## Notes

### Message Model
```dart
class MessageModel {
  final String id;
  final String content;
  final MessageSender sender; // user, ai
  final DateTime timestamp;
  final MessageStatus status; // pending, sent, delivered, error

  // For AI messages
  final String? astrologerId;
}
```

### Future AI Integration Points
```dart
// When real AI backend is ready:
// 1. Replace AIService.generateResponse() implementation
// 2. Add streaming support for typewriter effect
// 3. Add context window management
// 4. Add rate limiting handling
```

### Performance Considerations
- Use `ListView.builder` for message list
- Limit visible messages (paginate old ones)
- Cache astrologer avatars
- Debounce typing indicator updates
