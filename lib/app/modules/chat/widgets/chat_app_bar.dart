import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
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
