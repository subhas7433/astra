import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/astrologer_model.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/enums/sender_type.dart';
import '../../../data/interfaces/ai_service_interface.dart';
import '../../../data/services/ad_service.dart';
import '../../../data/services/subscription_service.dart';
import '../../../data/repositories/astrologer_repository.dart';
import '../../../data/repositories/chat_repository.dart';
import '../widgets/ad_modal.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/guest_service.dart';

class ChatController extends GetxController {
  final AstrologerRepository _astrologerRepository = Get.find<AstrologerRepository>();
  final ChatRepository _chatRepository = Get.find<ChatRepository>();
  final AdService _adService = Get.find<AdService>();
  final IAIService _aiService = Get.find<IAIService>();

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
          messages.add(MessageModel(
            id: 'welcome',
            sessionId: sessionId,
            senderType: SenderType.astrologer,
            content: 'Hello! How can I help you today?',
            createdAt: DateTime.now(),
          ));
        }
        scrollToBottom();
      },
      onFailure: (error) => Get.snackbar('Error', 'Failed to load messages'),
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
    final isPremium = Get.find<SubscriptionService>().isPremium.value;
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
    Get.snackbar(
      'Premium',
      'Premium features coming soon!',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _simulateAIResponse(String userMessage) async {
    isTyping.value = true;
    scrollToBottom();
    
    final responseText = await _aiService.generateResponse(
      userMessage, 
      astrologer.value?.name ?? 'Astrologer'
    );
    
    isTyping.value = false;
    
    final responseMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sessionId: _sessionId!,
      senderType: SenderType.astrologer,
      content: responseText,
      createdAt: DateTime.now(),
    );

    messages.add(responseMessage);
    _chatRepository.saveMessage(_sessionId!, responseMessage);
    scrollToBottom();
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
