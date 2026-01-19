# Flutter Integration Guide - Astro GPT

**Version:** 1.0
**Last Updated:** December 3, 2025
**Audience:** Flutter Frontend Developers

---

## Table of Contents

1. [Quick Start](#1-quick-start)
2. [Project Setup](#2-project-setup)
3. [Appwrite SDK Configuration](#3-appwrite-sdk-configuration)
4. [Chat Integration](#4-chat-integration)
5. [Horoscope Integration](#5-horoscope-integration)
6. [Subscription Integration](#6-subscription-integration)
7. [Realtime Updates](#7-realtime-updates)
8. [Error Handling](#8-error-handling)
9. [Complete Examples](#9-complete-examples)

---

## 1. Quick Start

### Installation

Add dependencies to `pubspec.yaml`:

```yaml
dependencies:
  appwrite: ^12.0.0
  get: ^4.6.6
  get_storage: ^2.1.1
```

### Initialize Appwrite

```dart
// lib/main.dart
import 'package:appwrite/appwrite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Appwrite
  final client = Client()
    .setEndpoint('https://fra.cloud.appwrite.io/v1')
    .setProject('692c18270006e1438830');

  Get.put(AppwriteService(client));

  runApp(const AstroGptApp());
}
```

---

## 2. Project Setup

### Directory Structure

```
lib/
  app/
    core/
      config/
        appwrite_config.dart    # Configuration constants
      services/
        appwrite_service.dart   # Appwrite SDK wrapper
        chat_service.dart       # Chat API service
        horoscope_service.dart  # Horoscope service
      models/
        chat_response.dart
        horoscope_model.dart
        subscription_model.dart
        user_model.dart
        astrologer_model.dart
```

### Configuration File

```dart
// lib/app/core/config/appwrite_config.dart

class AppwriteConfig {
  // Appwrite Cloud (Frankfurt)
  static const String endpoint = 'https://fra.cloud.appwrite.io/v1';
  static const String projectId = '692c18270006e1438830';
  static const String databaseId = 'astro_gpt_db';

  // Function IDs
  static const String aiChatFunction = 'ai-chat-response';
  static const String horoscopeFunction = 'generate-daily-horoscope';
  static const String contentFunction = 'rotate-daily-content';
  static const String webhookFunction = 'subscription-webhook';
}

class CollectionIds {
  static const String users = 'users';
  static const String astrologers = 'astrologers';
  static const String messages = 'messages';
  static const String chatSessions = 'chat_sessions';
  static const String horoscopes = 'horoscopes';
  static const String dailyContent = 'daily_content';
  static const String todayContent = 'today_content';
  static const String subscriptions = 'subscriptions';
  static const String reviews = 'reviews';
  static const String favorites = 'favorites';
}
```

---

## 3. Appwrite SDK Configuration

### Appwrite Service (GetX)

```dart
// lib/app/core/services/appwrite_service.dart

import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

class AppwriteService extends GetxService {
  late final Client client;
  late final Account account;
  late final Databases databases;
  late final Functions functions;
  late final Realtime realtime;
  late final Storage storage;

  AppwriteService(this.client) {
    account = Account(client);
    databases = Databases(client);
    functions = Functions(client);
    realtime = Realtime(client);
    storage = Storage(client);
  }

  // Authentication helpers
  Future<bool> isLoggedIn() async {
    try {
      await account.get();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getCurrentUserId() async {
    try {
      final user = await account.get();
      return user.$id;
    } catch (e) {
      return null;
    }
  }
}
```

### Dependency Injection

```dart
// lib/app/core/bindings/initial_binding.dart

import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Appwrite Client
    final client = Client()
      .setEndpoint(AppwriteConfig.endpoint)
      .setProject(AppwriteConfig.projectId);

    // Core Services
    Get.put(AppwriteService(client), permanent: true);
    Get.put(ChatService(Get.find()), permanent: true);
    Get.put(HoroscopeService(Get.find()), permanent: true);
    Get.put(SubscriptionService(Get.find()), permanent: true);
  }
}
```

---

## 4. Chat Integration

### Chat Service

```dart
// lib/app/core/services/chat_service.dart

import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

class ChatService extends GetxService {
  final AppwriteService _appwrite;

  ChatService(this._appwrite);

  /// Send a message to the AI astrologer
  Future<ChatResponse> sendMessage({
    required String userId,
    required String astrologerId,
    required String message,
    String? sessionId,
  }) async {
    try {
      final execution = await _appwrite.functions.createExecution(
        functionId: AppwriteConfig.aiChatFunction,
        body: jsonEncode({
          'path': '/',
          'method': 'POST',
          'body': jsonEncode({
            'userId': userId,
            'astrologerId': astrologerId,
            'message': message,
            if (sessionId != null) 'sessionId': sessionId,
          }),
        }),
      );

      final responseData = jsonDecode(execution.responseBody);

      if (responseData['success'] != true) {
        throw ChatException(
          code: responseData['code'] ?? 'UNKNOWN_ERROR',
          message: responseData['error'] ?? 'Unknown error',
          remainingCredits: responseData['remainingCredits'],
          resetTime: responseData['resetTime'] != null
              ? DateTime.parse(responseData['resetTime'])
              : null,
        );
      }

      return ChatResponse.fromJson(responseData);
    } on AppwriteException catch (e) {
      throw ChatException(
        code: 'APPWRITE_ERROR',
        message: e.message ?? 'Appwrite error',
      );
    }
  }

  /// Get greeting from astrologer
  Future<GreetingResponse> getGreeting({
    required String userId,
    required String astrologerId,
  }) async {
    final execution = await _appwrite.functions.createExecution(
      functionId: AppwriteConfig.aiChatFunction,
      body: jsonEncode({
        'path': '/greeting',
        'method': 'POST',
        'body': jsonEncode({
          'userId': userId,
          'astrologerId': astrologerId,
        }),
      }),
    );

    final responseData = jsonDecode(execution.responseBody);
    return GreetingResponse.fromJson(responseData);
  }

  /// Get chat history for a session
  Future<List<MessageModel>> getChatHistory(String sessionId) async {
    final response = await _appwrite.databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: CollectionIds.messages,
      queries: [
        Query.equal('sessionId', sessionId),
        Query.orderAsc('createdAt'),
        Query.limit(100),
      ],
    );

    return response.documents
        .map((doc) => MessageModel.fromJson(doc.data))
        .toList();
  }

  /// Get or create chat session
  Future<String> getOrCreateSession(String userId, String astrologerId) async {
    final existing = await _appwrite.databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: CollectionIds.chatSessions,
      queries: [
        Query.equal('userId', userId),
        Query.equal('astrologerId', astrologerId),
      ],
    );

    if (existing.documents.isNotEmpty) {
      return existing.documents.first.$id;
    }

    final session = await _appwrite.databases.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: CollectionIds.chatSessions,
      documentId: ID.unique(),
      data: {
        'userId': userId,
        'astrologerId': astrologerId,
        'isActive': true,
        'messageCount': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );

    return session.$id;
  }
}
```

### Chat Controller (GetX)

```dart
// lib/app/modules/chat/chat_controller.dart

import 'package:get/get.dart';

class ChatController extends GetxController {
  final ChatService _chatService = Get.find();
  final AuthController _authController = Get.find();

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isTyping = false.obs;
  final RxInt remainingCredits = 5.obs;
  final Rx<DateTime?> resetTime = Rx<DateTime?>(null);

  late String sessionId;
  late AstrologerModel astrologer;

  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    astrologer = Get.arguments as AstrologerModel;
    _initChat();
  }

  Future<void> _initChat() async {
    isLoading.value = true;

    try {
      final userId = _authController.currentUser.value!.id;

      // Get or create session
      sessionId = await _chatService.getOrCreateSession(userId, astrologer.id);

      // Load existing messages
      messages.value = await _chatService.getChatHistory(sessionId);

      // If no messages, get greeting
      if (messages.isEmpty) {
        await _getGreeting();
      }

      // Subscribe to realtime updates
      _subscribeToMessages();
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize chat');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _getGreeting() async {
    final userId = _authController.currentUser.value!.id;
    final greeting = await _chatService.getGreeting(
      userId: userId,
      astrologerId: astrologer.id,
    );

    // Add greeting as first message
    final greetingMessage = MessageModel(
      id: ID.unique(),
      sessionId: sessionId,
      senderType: SenderType.astrologer,
      content: greeting.greeting,
      createdAt: DateTime.now(),
    );

    messages.add(greetingMessage);
  }

  Future<void> sendMessage() async {
    final content = inputController.text.trim();
    if (content.isEmpty) return;

    inputController.clear();

    // Add user message immediately (optimistic UI)
    final userMessage = MessageModel(
      id: ID.unique(),
      sessionId: sessionId,
      senderType: SenderType.user,
      content: content,
      createdAt: DateTime.now(),
    );
    messages.add(userMessage);
    _scrollToBottom();

    // Show typing indicator
    isTyping.value = true;

    try {
      final userId = _authController.currentUser.value!.id;
      final response = await _chatService.sendMessage(
        userId: userId,
        astrologerId: astrologer.id,
        message: content,
        sessionId: sessionId,
      );

      // Add AI response
      final aiMessage = MessageModel(
        id: response.messageId,
        sessionId: sessionId,
        senderType: SenderType.astrologer,
        content: response.response,
        createdAt: DateTime.now(),
      );
      messages.add(aiMessage);

      // Update credits
      remainingCredits.value = response.remainingCredits;
      resetTime.value = response.resetTime;

      _scrollToBottom();
    } on ChatException catch (e) {
      if (e.code == 'RATE_LIMIT_EXCEEDED') {
        remainingCredits.value = e.remainingCredits ?? 0;
        resetTime.value = e.resetTime;
        _showRateLimitDialog();
      } else {
        Get.snackbar('Error', e.message);
      }
    } finally {
      isTyping.value = false;
    }
  }

  void _showRateLimitDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Daily Limit Reached'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You have used all your free messages for today.'),
            const SizedBox(height: 16),
            Text('Credits reset at: ${_formatResetTime()}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed(AppRoutes.SUBSCRIPTION);
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  String _formatResetTime() {
    if (resetTime.value == null) return 'Midnight';
    return DateFormat('HH:mm').format(resetTime.value!.toLocal());
  }

  void _subscribeToMessages() {
    final subscription = _chatService.subscribeToMessages(
      sessionId,
      (message) {
        if (!messages.any((m) => m.id == message.id)) {
          messages.add(message);
          _scrollToBottom();
        }
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
```

### Chat Screen Widget

```dart
// lib/app/modules/chat/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.astrologer.name),
        actions: [
          // Show remaining credits
          Obx(() => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
              label: Text('${controller.remainingCredits.value} left'),
            ),
          )),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return MessageBubble(message: message);
                },
              );
            }),
          ),

          // Typing indicator
          Obx(() {
            if (!controller.isTyping.value) return const SizedBox.shrink();
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: TypingIndicator(),
            );
          }),

          // Input field
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.inputController,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => controller.sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: controller.sendMessage,
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.senderType == SenderType.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
```

---

## 5. Horoscope Integration

### Horoscope Service

```dart
// lib/app/core/services/horoscope_service.dart

import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

class HoroscopeService extends GetxService {
  final AppwriteService _appwrite;

  HoroscopeService(this._appwrite);

  /// Get today's horoscopes for a zodiac sign
  Future<List<HoroscopeModel>> getTodayHoroscopes(String zodiacSign) async {
    final today = DateTime.now().toIso8601String().split('T')[0];

    final response = await _appwrite.databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: CollectionIds.horoscopes,
      queries: [
        Query.equal('zodiacSign', zodiacSign.toLowerCase()),
        Query.equal('periodType', 'daily'),
        Query.equal('validDate', today),
      ],
    );

    return response.documents
        .map((doc) => HoroscopeModel.fromJson(doc.data))
        .toList();
  }

  /// Get horoscope by category
  Future<HoroscopeModel?> getHoroscopeByCategory(
    String zodiacSign,
    String category,
  ) async {
    final today = DateTime.now().toIso8601String().split('T')[0];

    final response = await _appwrite.databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: CollectionIds.horoscopes,
      queries: [
        Query.equal('zodiacSign', zodiacSign.toLowerCase()),
        Query.equal('category', category.toLowerCase()),
        Query.equal('validDate', today),
        Query.limit(1),
      ],
    );

    if (response.documents.isEmpty) return null;
    return HoroscopeModel.fromJson(response.documents.first.data);
  }

  /// Get all zodiac signs with today's horoscope status
  Future<Map<String, bool>> getHoroscopeAvailability() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final signs = ZodiacSign.values.map((s) => s.name).toList();

    final response = await _appwrite.databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: CollectionIds.horoscopes,
      queries: [
        Query.equal('validDate', today),
        Query.equal('periodType', 'daily'),
      ],
    );

    final available = <String>{};
    for (final doc in response.documents) {
      available.add(doc.data['zodiacSign']);
    }

    return {for (final sign in signs) sign: available.contains(sign)};
  }
}
```

### Horoscope Controller

```dart
// lib/app/modules/horoscope/horoscope_controller.dart

class HoroscopeController extends GetxController {
  final HoroscopeService _horoscopeService = Get.find();
  final AuthController _authController = Get.find();

  final RxList<HoroscopeModel> horoscopes = <HoroscopeModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<String?> selectedCategory = Rx<String?>(null);

  String get userZodiac => _authController.currentUser.value?.zodiacSign ?? 'aries';

  @override
  void onInit() {
    super.onInit();
    loadHoroscopes();
  }

  Future<void> loadHoroscopes() async {
    isLoading.value = true;

    try {
      horoscopes.value = await _horoscopeService.getTodayHoroscopes(userZodiac);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load horoscopes');
    } finally {
      isLoading.value = false;
    }
  }

  HoroscopeModel? getByCategory(String category) {
    return horoscopes.firstWhereOrNull((h) => h.category == category);
  }

  String getLocalizedContent(HoroscopeModel horoscope) {
    final locale = Get.locale?.languageCode ?? 'en';
    return horoscope.getContent(locale);
  }
}
```

---

## 6. Subscription Integration

### Subscription Service

```dart
// lib/app/core/services/subscription_service.dart

class SubscriptionService extends GetxService {
  final AppwriteService _appwrite;

  SubscriptionService(this._appwrite);

  /// Get user's current subscription
  Future<SubscriptionModel?> getUserSubscription(String userId) async {
    try {
      final response = await _appwrite.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: CollectionIds.subscriptions,
        queries: [
          Query.equal('userId', userId),
          Query.equal('status', 'active'),
          Query.limit(1),
        ],
      );

      if (response.documents.isEmpty) return null;
      return SubscriptionModel.fromJson(response.documents.first.data);
    } catch (e) {
      return null;
    }
  }

  /// Check if user has premium access
  Future<bool> hasPremiumAccess(String userId) async {
    final subscription = await getUserSubscription(userId);
    return subscription?.isPremium ?? false;
  }

  /// Create free tier subscription for new user
  Future<SubscriptionModel> createFreeSubscription(String userId) async {
    final doc = await _appwrite.databases.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: CollectionIds.subscriptions,
      documentId: ID.unique(),
      data: {
        'userId': userId,
        'tier': 'free',
        'status': 'active',
        'platform': Platform.isAndroid ? 'android' : 'ios',
        'startDate': DateTime.now().toIso8601String(),
        'chatCredits': 5,
        'adsRemoved': false,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );

    return SubscriptionModel.fromJson(doc.data);
  }
}
```

---

## 7. Realtime Updates

### Subscribe to Messages

```dart
// In chat_service.dart

RealtimeSubscription? _messageSubscription;

void subscribeToMessages(
  String sessionId,
  Function(MessageModel) onMessage,
) {
  _messageSubscription = _appwrite.realtime.subscribe([
    'databases.${AppwriteConfig.databaseId}.collections.${CollectionIds.messages}.documents'
  ]);

  _messageSubscription!.stream.listen((event) {
    // Check if event is for our session
    if (event.payload['sessionId'] == sessionId) {
      // Handle different event types
      if (event.events.contains('databases.*.collections.*.documents.*.create')) {
        final message = MessageModel.fromJson(event.payload);
        onMessage(message);
      }
    }
  });
}

void unsubscribeFromMessages() {
  _messageSubscription?.close();
  _messageSubscription = null;
}
```

### Subscribe to Horoscope Updates

```dart
// In horoscope_service.dart

void subscribeToHoroscopes(
  String zodiacSign,
  Function(HoroscopeModel) onUpdate,
) {
  _appwrite.realtime.subscribe([
    'databases.${AppwriteConfig.databaseId}.collections.${CollectionIds.horoscopes}.documents'
  ]).stream.listen((event) {
    if (event.payload['zodiacSign'] == zodiacSign) {
      final horoscope = HoroscopeModel.fromJson(event.payload);
      onUpdate(horoscope);
    }
  });
}
```

---

## 8. Error Handling

### Custom Exceptions

```dart
// lib/app/core/exceptions/chat_exception.dart

class ChatException implements Exception {
  final String code;
  final String message;
  final int? remainingCredits;
  final DateTime? resetTime;

  ChatException({
    required this.code,
    required this.message,
    this.remainingCredits,
    this.resetTime,
  });

  bool get isRateLimited => code == 'RATE_LIMIT_EXCEEDED';
  bool get isUserNotFound => code == 'USER_NOT_FOUND';
  bool get isAstrologerNotFound => code == 'ASTROLOGER_NOT_FOUND';

  @override
  String toString() => 'ChatException: [$code] $message';
}

class HoroscopeException implements Exception {
  final String message;
  HoroscopeException(this.message);
}
```

### Error Handler Utility

```dart
// lib/app/core/utils/error_handler.dart

class ErrorHandler {
  static void handle(dynamic error) {
    if (error is ChatException) {
      _handleChatError(error);
    } else if (error is AppwriteException) {
      _handleAppwriteError(error);
    } else {
      Get.snackbar('Error', error.toString());
    }
  }

  static void _handleChatError(ChatException error) {
    switch (error.code) {
      case 'RATE_LIMIT_EXCEEDED':
        Get.dialog(RateLimitDialog(
          resetTime: error.resetTime,
        ));
        break;
      case 'USER_NOT_FOUND':
        Get.snackbar('Error', 'Please login again');
        Get.offAllNamed(AppRoutes.LOGIN);
        break;
      default:
        Get.snackbar('Error', error.message);
    }
  }

  static void _handleAppwriteError(AppwriteException error) {
    switch (error.code) {
      case 401:
        Get.snackbar('Session Expired', 'Please login again');
        Get.offAllNamed(AppRoutes.LOGIN);
        break;
      case 404:
        Get.snackbar('Not Found', error.message ?? 'Resource not found');
        break;
      case 429:
        Get.snackbar('Too Many Requests', 'Please try again later');
        break;
      default:
        Get.snackbar('Error', error.message ?? 'Something went wrong');
    }
  }
}
```

---

## 9. Complete Examples

### Full Chat Flow Example

```dart
// Complete working chat implementation

class ChatRepository {
  final ChatService _chatService;
  final SubscriptionService _subscriptionService;

  ChatRepository(this._chatService, this._subscriptionService);

  /// Initialize chat with all necessary checks
  Future<ChatInitResult> initializeChat({
    required String userId,
    required String astrologerId,
  }) async {
    // Check subscription status
    final subscription = await _subscriptionService.getUserSubscription(userId);

    // Get or create session
    final sessionId = await _chatService.getOrCreateSession(userId, astrologerId);

    // Load message history
    final messages = await _chatService.getChatHistory(sessionId);

    // Get greeting if new chat
    String? greeting;
    if (messages.isEmpty) {
      final greetingResponse = await _chatService.getGreeting(
        userId: userId,
        astrologerId: astrologerId,
      );
      greeting = greetingResponse.greeting;
    }

    return ChatInitResult(
      sessionId: sessionId,
      messages: messages,
      greeting: greeting,
      subscription: subscription,
      isPremium: subscription?.isPremium ?? false,
    );
  }

  /// Send message with rate limit handling
  Future<SendMessageResult> sendMessageSafe({
    required String userId,
    required String astrologerId,
    required String message,
    required String sessionId,
  }) async {
    try {
      final response = await _chatService.sendMessage(
        userId: userId,
        astrologerId: astrologerId,
        message: message,
        sessionId: sessionId,
      );

      return SendMessageResult.success(
        response: response.response,
        messageId: response.messageId,
        remainingCredits: response.remainingCredits,
      );
    } on ChatException catch (e) {
      if (e.isRateLimited) {
        return SendMessageResult.rateLimited(
          resetTime: e.resetTime!,
        );
      }
      return SendMessageResult.error(e.message);
    }
  }
}

// Usage in controller
class ChatControllerV2 extends GetxController {
  final ChatRepository _repo = Get.find();

  Future<void> init(AstrologerModel astrologer) async {
    final userId = Get.find<AuthController>().userId;

    final result = await _repo.initializeChat(
      userId: userId,
      astrologerId: astrologer.id,
    );

    sessionId = result.sessionId;
    messages.value = result.messages;

    if (result.greeting != null) {
      messages.add(MessageModel(
        id: ID.unique(),
        sessionId: sessionId,
        senderType: SenderType.astrologer,
        content: result.greeting!,
        createdAt: DateTime.now(),
      ));
    }

    isPremium.value = result.isPremium;
  }
}
```

### Horoscope Screen Example

```dart
class HoroscopeScreen extends GetView<HoroscopeController> {
  const HoroscopeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Horoscope - ${controller.userZodiac.capitalize}'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.horoscopes.isEmpty) {
          return const Center(
            child: Text('No horoscope available for today'),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Category tabs
            _buildCategoryTabs(),
            const SizedBox(height: 16),

            // Horoscope cards
            ...controller.horoscopes.map((h) => HoroscopeCard(horoscope: h)),
          ],
        );
      }),
    );
  }

  Widget _buildCategoryTabs() {
    return Row(
      children: [
        _categoryChip('Love', Icons.favorite),
        _categoryChip('Career', Icons.work),
        _categoryChip('Health', Icons.health_and_safety),
      ],
    );
  }

  Widget _categoryChip(String label, IconData icon) {
    return Obx(() => FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: controller.selectedCategory.value == label.toLowerCase(),
      onSelected: (selected) {
        controller.selectedCategory.value = selected ? label.toLowerCase() : null;
      },
    ));
  }
}

class HoroscopeCard extends StatelessWidget {
  final HoroscopeModel horoscope;

  const HoroscopeCard({super.key, required this.horoscope});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HoroscopeController>();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category header
            Row(
              children: [
                _getCategoryIcon(horoscope.category),
                const SizedBox(width: 8),
                Text(
                  horoscope.category.capitalize!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                _buildEnergyIndicator(horoscope.energyLevel),
              ],
            ),
            const Divider(),

            // Content
            Text(
              controller.getLocalizedContent(horoscope),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'love':
        return const Icon(Icons.favorite, color: Colors.red);
      case 'career':
        return const Icon(Icons.work, color: Colors.blue);
      case 'health':
        return const Icon(Icons.health_and_safety, color: Colors.green);
      default:
        return const Icon(Icons.star);
    }
  }

  Widget _buildEnergyIndicator(int level) {
    return Row(
      children: [
        const Icon(Icons.bolt, size: 16, color: Colors.amber),
        Text('$level%'),
      ],
    );
  }
}
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-03 | Initial release |

---

**Maintained By:** Astro GPT Development Team
