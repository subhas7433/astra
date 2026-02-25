import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/impl/subscription_service.dart';
import '../controllers/chat_controller.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ChatController controller;

  const ChatAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      titleSpacing: 0,
      title: Obx(() {
        final astrologer = controller.astrologer.value;
        if (astrologer == null) return const SizedBox();

        return Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(astrologer.photoUrl),
              radius: 18,
            ),
            const SizedBox(width: AppDimensions.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  astrologer.name,
                  style: AppTypography.h3.copyWith(fontSize: 16),
                ),
                Text(
                  'Online',
                  style: AppTypography.caption.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
      actions: [
        Center(
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stars, color: AppColors.primary, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${SubscriptionService.to.chatCredits.value}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        PopupMenuButton<String>(
          onSelected: controller.onMenuAction,
          icon: const Icon(Icons.more_vert, color: Colors.black),
          itemBuilder: (BuildContext context) {
            return {'Clear Chat', 'Report', 'Block'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
