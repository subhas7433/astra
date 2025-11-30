import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_decorations.dart';

enum AppCardVariant { standard, elevated, gradient, outlined }

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? borderRadius;
  final VoidCallback? onTap;
  final AppCardVariant variant;
  final Color? backgroundColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.onTap,
    this.variant = AppCardVariant.standard,
    this.backgroundColor,
  });

  const AppCard.elevated({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.onTap,
    this.backgroundColor,
  }) : variant = AppCardVariant.elevated;

  const AppCard.gradient({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.onTap,
  })  : variant = AppCardVariant.gradient,
        backgroundColor = null;

  const AppCard.outlined({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.onTap,
    this.backgroundColor,
  }) : variant = AppCardVariant.outlined;

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? AppDimensions.radiusMd;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          padding: padding ?? const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: _getDecoration(radius),
          child: child,
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(double radius) {
    switch (variant) {
      case AppCardVariant.standard:
        return AppDecorations.card.copyWith(
          color: backgroundColor ?? AppColors.surface,
          borderRadius: BorderRadius.circular(radius),
        );
      case AppCardVariant.elevated:
        return AppDecorations.cardElevated.copyWith(
          color: backgroundColor ?? AppColors.surface,
          borderRadius: BorderRadius.circular(radius),
        );
      case AppCardVariant.gradient:
        return AppDecorations.astrologerCard.copyWith(
          borderRadius: BorderRadius.circular(radius),
        );
      case AppCardVariant.outlined:
        return BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: AppColors.divider),
        );
    }
  }
}
