import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String? avatarUrl;
  final String time;
  final bool enableMarkdown;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.time,
    this.avatarUrl,
    this.enableMarkdown = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      return _buildUserBubble();
    }
    return enableMarkdown ? _buildAiMarkdownBubble() : _buildAiBubble();
  }

  /// User message: right-aligned, primary colored, compact.
  Widget _buildUserBubble() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 60,
        right: AppDimensions.paddingMd,
        top: AppDimensions.paddingSm,
        bottom: AppDimensions.paddingSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
                vertical: AppDimensions.paddingSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusLg),
                  topRight: Radius.circular(AppDimensions.radiusLg),
                  bottomLeft: Radius.circular(AppDimensions.radiusLg),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: AppTypography.body1.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// AI message: plain text, left-aligned (legacy style for non-markdown chats).
  Widget _buildAiBubble() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (avatarUrl != null || !enableMarkdown) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              backgroundColor: Colors.grey[300],
              child: avatarUrl == null
                  ? const Icon(Icons.person, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: AppDimensions.sm),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMd),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(AppDimensions.radiusLg),
                  bottomLeft: Radius.circular(AppDimensions.radiusLg),
                  bottomRight: Radius.circular(AppDimensions.radiusLg),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: AppTypography.body1.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  /// AI message with markdown: full-width, dark card, rendered markdown.
  Widget _buildAiMarkdownBubble() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimensions.paddingMd,
        right: AppDimensions.paddingMd,
        top: AppDimensions.paddingSm,
        bottom: AppDimensions.paddingSm,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.scaffoldDark,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarkdownBody(
              data: message,
              shrinkWrap: true,
              selectable: true,
              styleSheet: _markdownStyleSheet(),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                time,
                style: AppTypography.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  MarkdownStyleSheet _markdownStyleSheet() {
    const white = Colors.white;
    final muted = Colors.white.withValues(alpha: 0.7);

    return MarkdownStyleSheet(
      p: const TextStyle(fontSize: 15, color: white, height: 1.6),
      h1: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: white,
        height: 1.4,
      ),
      h2: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: white,
        height: 1.4,
      ),
      h3: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: white,
        height: 1.4,
      ),
      strong: const TextStyle(fontWeight: FontWeight.bold, color: white),
      em: const TextStyle(fontStyle: FontStyle.italic, color: white),
      listBullet: const TextStyle(fontSize: 15, color: white, height: 1.6),
      listIndent: 20.0,
      blockquote: TextStyle(
        fontSize: 15,
        color: muted,
        fontStyle: FontStyle.italic,
        height: 1.6,
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.6),
            width: 3,
          ),
        ),
      ),
      blockquotePadding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
      code: TextStyle(
        fontSize: 13,
        color: AppColors.primaryLight,
        backgroundColor: Colors.white.withValues(alpha: 0.1),
      ),
      codeblockDecoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      codeblockPadding: const EdgeInsets.all(12),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      pPadding: const EdgeInsets.only(bottom: 8),
      h1Padding: const EdgeInsets.only(top: 12, bottom: 8),
      h2Padding: const EdgeInsets.only(top: 12, bottom: 6),
      h3Padding: const EdgeInsets.only(top: 8, bottom: 4),
      listBulletPadding: const EdgeInsets.only(right: 8),
    );
  }
}
