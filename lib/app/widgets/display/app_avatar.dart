import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';

enum AppAvatarSize { sm, md, lg }

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final AppAvatarSize size;
  final bool showBorder;
  final Color? borderColor;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AppAvatarSize.md,
    this.showBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final double dimension = _getDimension();
    final double fontSize = _getFontSize();

    Widget avatarContent;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarContent = CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        width: dimension,
        height: dimension,
        placeholder: (context, url) => _buildPlaceholder(dimension),
        errorWidget: (context, url, error) => _buildInitials(dimension, fontSize),
      );
    } else {
      avatarContent = _buildInitials(dimension, fontSize);
    }

    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: borderColor ?? AppColors.primary,
                width: 2,
              )
            : null,
      ),
      child: ClipOval(child: avatarContent),
    );
  }

  Widget _buildPlaceholder(double dimension) {
    return Container(
      width: dimension,
      height: dimension,
      color: AppColors.divider,
    );
  }

  Widget _buildInitials(double dimension, double fontSize) {
    return Container(
      width: dimension,
      height: dimension,
      color: AppColors.primary.withOpacity(0.1),
      alignment: Alignment.center,
      child: Text(
        _getInitials(),
        style: AppTypography.h3.copyWith(
          color: AppColors.primary,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getInitials() {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  double _getDimension() {
    switch (size) {
      case AppAvatarSize.sm:
        return AppDimensions.avatarSm;
      case AppAvatarSize.md:
        return AppDimensions.avatarMd;
      case AppAvatarSize.lg:
        return AppDimensions.avatarLg;
    }
  }

  double _getFontSize() {
    switch (size) {
      case AppAvatarSize.sm:
        return 14;
      case AppAvatarSize.md:
        return 18;
      case AppAvatarSize.lg:
        return 32;
    }
  }
}
