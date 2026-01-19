import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/astrologer_model.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/enums/sender_type.dart';
import '../../../core/services/interfaces/i_ai_service.dart';
import '../../../core/services/impl/ad_service.dart';
import '../../../core/services/impl/subscription_service.dart';
import '../../../data/repositories/astrologer_repository.dart';
import '../../../data/repositories/chat_repository.dart';
import '../widgets/ad_modal.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/guest_service.dart';
import '../../../core/services/interfaces/i_auth_service.dart';

class ChatController extends GetxController {
  final AstrologerRepository _astrologerRepository = Get.find<AstrologerRepository>();
  final ChatRepository _chatRepository = Get.find<ChatRepository>();
  final AdService _adService = Get.find<AdService>();
  final IAIService _aiService = Get.find<IAIService>();
  final IAuthService _authService = Get.find<IAuthService>();

  final astrologer = Rxn<AstrologerModel>();
  final isLoading = true.obs;
  final messages = <MessageModel>[].obs;
  final messageInput = ''.obs;
  final isTyping = false.obs;
  final ScrollController scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();

  String? _sessionId;

  RxInt get freeMessageCount => _adService.freeMessageCount;

  void onInputChanged(String val) {
    messageInput.value = val;
  }

  @override
  void onInit() {
    super.onInit();
    final id = Get.parameters['astrologerId'];
    if (id != null) {
      loadAstrologer(id);
    } else {
      isLoading.value = false;
    }
  }

  Future<void> loadAstrologer(String id) async {
    isLoading.value = true;
    
    // Fetch Astrologer
    // Assuming we can get by ID or find in list
    final result = await _astrologerRepository.getAstrologers(limit: 100);
    result.fold(
      onSuccess: (list) {
        astrologer.value = list.firstWhereOrNull((a) => a.id == id);
      },
      onFailure: (error) => Get.snackbar('Error', error.message),
    );

    if (astrologer.value == null) {
      // Fallback mock if not found (for safety during dev)
      // In real app, handle error or redirect
    }

    // Initialize Session
    final sessionResult = await _chatRepository.createSession(id);
    sessionResult.fold(
      onSuccess: (sessionId) {
        _sessionId = sessionId;
        _loadMessages(sessionId);
      },
      onFailure: (error) => Get.snackbar('Error', 'Failed to start chat session'),
    );
    
    isLoading.value = false;
  }

  Future<void> _loadMessages(String sessionId) async {
    final result = await _chatRepository.getMessages(sessionId);
    result.fold(
      onSuccess: (list) {
        messages.assignAll(list);
        if (messages.isEmpty) {
          // Add welcome message if empty
          // Fetch greeting from AI Service
          _fetchGreeting();
        }
        scrollToBottom();
      },
      onFailure: (error) => Get.snackbar('Error', 'Failed to load messages'),
    );
  }

  Future<void> _fetchGreeting() async {
    final userId = _authService.currentUserId ?? 'guest';
    final result = await _aiService.getGreeting(
      userId: userId, 
      astrologerId: astrologer.value?.id ?? 'unknown'
    );
    
    result.fold(
      onSuccess: (greeting) {
        final greetingMessage = MessageModel(
          id: 'welcome',
          sessionId: _sessionId!,
          senderType: SenderType.astrologer,
          content: greeting,
          createdAt: DateTime.now(),
        );
        messages.add(greetingMessage);
        // Optimize: Save greeting to DB? Or just show it? 
        // Typically greeting starts the session in DB.
        _chatRepository.saveMessage(_sessionId!, greetingMessage);
      },
      onFailure: (error) {
        // Fallback greeting if AI fails
        messages.add(MessageModel(
            id: 'welcome',
            sessionId: _sessionId!,
            senderType: SenderType.astrologer,
            content: 'Namaste! How can I help you today?',
            createdAt: DateTime.now(),
        ));
      },
    );
  }

  void sendMessage() {
    if (messageInput.value.trim().isEmpty || _sessionId == null) return;

    // Check Guest Limit
    if (!GuestService.to.canGuestChat()) {
      GuestService.to.incrementGuestChat(); // Triggers prompt
      return;
    }

    // Check Free Limit (if not premium)
    final isPremium = Get.find<SubscriptionService>().isPremium;
    if (!isPremium && freeMessageCount.value <= 0) {
      _showAdModal();
      return;
    }
    
    final text = messageInput.value.trim();
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sessionId: _sessionId!,
      senderType: SenderType.user,
      content: text,
      createdAt: DateTime.now(),
    );

    messages.add(message);
    _chatRepository.saveMessage(_sessionId!, message);
    
    // Decrement Count via Service
    _adService.decrementCredit();
    
    // Increment Guest Count
    GuestService.to.incrementGuestChat();

    messageInput.value = '';
    textController.clear();
    scrollToBottom();

    // Simulate AI Response
    _simulateAIResponse(text);
  }

  void _showAdModal() {
    Get.dialog(
      AdModal(
        onWatchAd: _watchAd,
        onRemoveAds: _removeAds,
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _watchAd() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );

    final success = await _adService.showRewardedAd();
    Get.back();

    if (success) {
      _adService.resetCredits();
      Get.snackbar(
        'Success',
        'You earned 3 more free messages!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _removeAds() {
    Get.back(); // Close modal first if open
    Get.toNamed('/settings/paywall'); // Use const from AppRoutes if imported, or raw string
  }

  void _simulateAIResponse(String userMessage) async {
    isTyping.value = true;
    scrollToBottom();
    
    // Get User ID (or null if guest/not logged in)
    final userId = _authService.currentUserId;
    
    // If no user ID (e.g. guest), use a placeholder or handle gracefully
    // Current AI function requires userId. 
    // If guest, maybe we should skip saving "personalized" context but backend needs a userId.
    final effectiveUserId = userId ?? 'guest';

    if (_sessionId == null) return;

    final result = await _aiService.generateResponse(
      userId: effectiveUserId,
      astrologerId: astrologer.value?.id ?? 'unknown',
      message: userMessage,
      sessionId: _sessionId!,
    );
    
    isTyping.value = false;
    
    result.fold(
      onSuccess: (responseText) {
        final responseMessage = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sessionId: _sessionId!,
          senderType: SenderType.astrologer,
          content: responseText,
          createdAt: DateTime.now(),
        );

        messages.add(responseMessage);
        _chatRepository.saveMessage(_sessionId!, responseMessage); // Already saved by backend function? 
        // Note: The backend function usually saves the AI message. 
        // If we save it again here, we might duplicate if we sync.
        // But for local UI update we need it. 
        // ChatRepository local save might be redundant if we refetch.
        // For now, keeping it for consistency with optimistic UI.
        
        scrollToBottom();
      },
      onFailure: (error) {
         Get.snackbar('Error', 'Failed to get response: ${error.message}');
      },
    );
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void onMenuAction(String action) {
    // Implement menu actions if needed
  }

  @override
  void onClose() {
    scrollController.dispose();
    textController.dispose();
    super.onClose();
  }
}
