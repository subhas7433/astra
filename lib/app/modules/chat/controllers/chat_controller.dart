import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/astrologer_model.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/enums/sender_type.dart';
import '../../../core/services/impl/ad_service.dart';
import '../../../core/services/impl/subscription_service.dart';
import '../../../core/services/interfaces/i_auth_service.dart';
import '../../../data/repositories/astrologer_repository.dart';
import '../../../data/repositories/chat_repository.dart';
import '../widgets/ad_modal.dart';
import '../../../data/services/guest_service.dart';

class ChatController extends GetxController {
  final AstrologerRepository _astrologerRepository = Get.find<AstrologerRepository>();
  final ChatRepository _chatRepository = Get.find<ChatRepository>();
  final AdService _adService = Get.find<AdService>();


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

    // Fetch astrologer by ID
    final result = await _astrologerRepository.getAstrologerById(id);
    result.fold(
      onSuccess: (a) => astrologer.value = a,
      onFailure: (error) => Get.snackbar('Error', error.message),
    );

    if (astrologer.value == null) {
      isLoading.value = false;
      return;
    }

    // Initialize Session via REST
    final userId = Get.find<IAuthService>().currentUserId;
    final sessionResult = await _chatRepository.createSession(id, userId: userId);
    if (sessionResult.isSuccess) {
      _sessionId = sessionResult.valueOrNull!;
      await _loadMessages(_sessionId!);
    } else {
      Get.snackbar('Error', 'Failed to start chat session');
    }

    isLoading.value = false;
  }

  Future<void> _loadMessages(String sessionId) async {
    final result = await _chatRepository.getMessages(sessionId);
    if (result.isSuccess) {
      final list = result.valueOrNull!;
      messages.assignAll(list);
      if (messages.isEmpty) {
        await _fetchGreeting();
      }
      scrollToBottom();
    } else {
      Get.snackbar('Error', 'Failed to load messages');
    }
  }

  Future<void> _fetchGreeting() async {
    if (_sessionId == null || astrologer.value == null) return;

    final result = await _chatRepository.getGreeting(
      _sessionId!,
      astrologer.value!.id,
    );

    result.fold(
      onSuccess: (greetingResult) {
        messages.add(greetingResult.greeting);
      },
      onFailure: (error) {
        // Fallback greeting if API fails
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
      GuestService.to.incrementGuestChat();
      return;
    }

    // Check Free Limit (if not premium)
    final isPremium = Get.find<SubscriptionService>().isPremium;
    if (!isPremium && freeMessageCount.value <= 0) {
      _showAdModal();
      return;
    }

    final text = messageInput.value.trim();

    // Add optimistic user message
    final optimisticMsg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sessionId: _sessionId!,
      senderType: SenderType.user,
      content: text,
      createdAt: DateTime.now(),
    );
    messages.add(optimisticMsg);

    // Decrement credit
    _adService.decrementCredit();
    GuestService.to.incrementGuestChat();

    messageInput.value = '';
    textController.clear();
    scrollToBottom();

    // Send to backend and get AI response
    _sendAndReceive(text);
  }

  Future<void> _sendAndReceive(String userMessage) async {
    isTyping.value = true;
    scrollToBottom();

    if (_sessionId == null) return;

    final result = await _chatRepository.sendMessage(
      _sessionId!,
      astrologer.value!.id,
      userMessage,
    );

    isTyping.value = false;

    result.fold(
      onSuccess: (sendResult) {
        // Replace optimistic user message with server version
        // and add AI response
        messages.add(sendResult.aiResponse);
        scrollToBottom();
      },
      onFailure: (error) {
        Get.snackbar('Error', 'Failed to get response: ${error.message}');
      },
    );
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
    Get.back();
    Get.toNamed('/settings/paywall');
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
