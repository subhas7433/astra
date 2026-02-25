import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/palm_reading_message_model.dart';
import '../../../data/models/palm_reading_session_model.dart';
import '../../../data/models/enums/sender_type.dart';
import '../../../data/repositories/palmistry_repository.dart';
import '../../../core/services/impl/subscription_service.dart';
import '../../../core/constants/app_colors.dart';

class PalmReadingChatController extends GetxController {
  final PalmistryRepository _palmistryRepository =
      Get.find<PalmistryRepository>();

  // Session state
  final session = Rxn<PalmReadingSessionModel>();
  final isLoading = true.obs;
  final messages = <PalmReadingMessageModel>[].obs;
  final messageInput = ''.obs;
  final isTyping = false.obs;
  final ScrollController scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();

  String? _readingId;

  RxInt get chatCredits => Get.find<SubscriptionService>().chatCredits;

  void onInputChanged(String val) {
    messageInput.value = val;
  }

  @override
  void onInit() {
    super.onInit();
    SubscriptionService.to.fetchCredits();
    _readingId = Get.parameters['readingId'];
    if (_readingId != null) {
      loadReading(_readingId!);
    } else {
      isLoading.value = false;
      Get.snackbar('Error', 'No reading ID provided');
    }
  }

  Future<void> loadReading(String readingId) async {
    isLoading.value = true;

    final result = await _palmistryRepository.getReading(readingId);
    result.fold(
      onSuccess: (detail) {
        session.value = detail.session;
        messages.assignAll(detail.messages);
        scrollToBottom();
      },
      onFailure: (error) {
        Get.snackbar('Error', error.message);
      },
    );

    isLoading.value = false;
  }

  void sendMessage() {
    if (messageInput.value.trim().isEmpty || _readingId == null) return;

    if (session.value == null) return;

    final isPro = Get.find<SubscriptionService>().isPro;
    if (chatCredits.value < 10) {
      if (isPro) {
        Get.snackbar(
          'Daily Limit Reached',
          'Your daily credits have been used. Resets tomorrow.',
        );
      } else {
        SubscriptionService.to.showPaywall();
        Get.snackbar(
          'Not Enough Credits',
          'You need 10 credits to ask a follow-up question. Upgrade to Pro!',
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
        );
      }
      return;
    }

    final text = messageInput.value.trim();

    // Add optimistic user message
    final optimisticMsg = PalmReadingMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sessionId: _readingId!,
      senderType: SenderType.user,
      content: text,
      createdAt: DateTime.now(),
    );
    messages.add(optimisticMsg);

    // Optimistic credit deduction (backend is source of truth)
    chatCredits.value -= 10;

    messageInput.value = '';
    textController.clear();
    scrollToBottom();

    _sendAndReceive(text);
  }

  Future<void> _sendAndReceive(String userMessage) async {
    isTyping.value = true;
    scrollToBottom();

    if (_readingId == null) return;

    final result = await _palmistryRepository.sendQuestion(
      _readingId!,
      userMessage,
    );

    isTyping.value = false;

    result.fold(
      onSuccess: (sendResult) {
        // Add AI response (keep optimistic user message)
        messages.add(sendResult.aiResponse);

        // Update session metadata
        session.value = session.value?.copyWith(
          messageCount: (session.value?.messageCount ?? 0) + 2,
          lastMessageAt: DateTime.now(),
        );

        scrollToBottom();
      },
      onFailure: (error) {
        // Restore credits on failure
        final isPro = Get.find<SubscriptionService>().isPro;
        if (!isPro) {
          chatCredits.value += 10;
        }

        if (error.message.toLowerCase().contains('insufficient credits') || 
            error.toString().contains('402')) {
          SubscriptionService.to.showPaywall();
          Get.snackbar(
            'Not Enough Credits',
            'You need 10 credits to ask a follow-up question. Upgrade to Pro!',
            backgroundColor: AppColors.primary,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar('Error', 'Failed to get response: ${error.message}');
        }
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

  @override
  void onClose() {
    scrollController.dispose();
    textController.dispose();
    super.onClose();
  }
}
