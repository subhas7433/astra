import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChatAppBar(controller: controller),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.messages.length) {
                    return const TypingIndicator();
                  }
                  
                  final msg = controller.messages[index];
                  return MessageBubble(
                    message: msg['message'],
                    isUser: msg['isUser'],
                    time: msg['time'],
                    avatarUrl: msg['isUser'] ? null : controller.astrologer.value?.imageUrl,
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
