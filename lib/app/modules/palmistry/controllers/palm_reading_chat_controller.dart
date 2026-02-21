import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/palm_reading_message_model.dart';
import '../../../data/models/palm_reading_session_model.dart';
import '../../../data/models/enums/sender_type.dart';
import '../../../data/repositories/palmistry_repository.dart';

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

  void onInputChanged(String val) {
    messageInput.value = val;
  }

  @override
  void onInit() {
    super.onInit();
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

  @override
  void onClose() {
    scrollController.dispose();
    textController.dispose();
    super.onClose();
  }
}
