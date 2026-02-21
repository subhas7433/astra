import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../chat/widgets/chat_input.dart';
import '../../chat/widgets/message_bubble.dart';
import '../../chat/widgets/typing_indicator.dart';
import '../controllers/palm_reading_chat_controller.dart';
import '../widgets/palm_reading_app_bar.dart';
import '../widgets/palm_reading_info_card.dart';

class PalmReadingChatScreen extends GetView<PalmReadingChatController> {
  const PalmReadingChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PalmReadingAppBar(controller: controller),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final session = controller.session.value;
              if (session == null) {
                return const Center(
                  child: Text('Reading not found'),
                );
              }

              // InfoCard + messages + optional typing indicator
              final messageCount = controller.messages.length;
              final hasTyping = controller.isTyping.value;
              // +1 for InfoCard at index 0
              final itemCount = 1 + messageCount + (hasTyping ? 1 : 0);

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  // Index 0: Info card
                  if (index == 0) {
                    return PalmReadingInfoCard(session: session);
                  }

                  // Last item when typing: typing indicator
                  if (hasTyping && index == itemCount - 1) {
                    return const TypingIndicator();
                  }

                  // Messages (offset by 1 for info card)
                  final msgIndex = index - 1;
                  final msg = controller.messages[msgIndex];
                  return MessageBubble(
                    message: msg.content,
                    isUser: msg.isUserMessage,
                    time: msg.formattedTime,
                    avatarUrl: null,
                    enableMarkdown: !msg.isUserMessage,
                  );
                },
              );
            }),
          ),

          // Input Area
          Obx(() => ChatInput(
              controller: controller.textController,
              onChanged: controller.onInputChanged,
              onSend: controller.sendMessage,
              isEnabled: controller.messageInput.value.trim().isNotEmpty,
            )),
        ],
      ),
    );
  }
}
