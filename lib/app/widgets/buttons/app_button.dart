import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';

enum AppButtonVariant { primary, secondary, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final AppButtonVariant variant;
  final bool fullWidth;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.leadingIcon,
    this.trailingIcon,
    this.variant = AppButtonVariant.primary,
    this.fullWidth = true,
    this.height,
    this.backgroundColor,
    this.textColor,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = true,
    this.height,
    this.backgroundColor,
    this.textColor,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = true,
    this.height,
    this.backgroundColor,
    this.textColor,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = true,
    this.height,
    this.backgroundColor,
    this.textColor,
  }) : variant = AppButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = !isDisabled && !isLoading && onPressed != null;
    
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height ?? AppDimensions.buttonHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          child: Ink(
            decoration: _getDecoration(isEnabled),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
              alignment: Alignment.center,
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(bool isEnabled) {
    if (backgroundColor != null && variant == AppButtonVariant.primary) {
      return BoxDecoration(
        color: isEnabled ? backgroundColor : AppColors.divider,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      );
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return BoxDecoration(
          color: isEnabled ? AppColors.primary : AppColors.divider,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        );
      case AppButtonVariant.secondary:
        return BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: isEnabled ? (textColor ?? AppColors.primary) : AppColors.divider,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        );
      case AppButtonVariant.text:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        );
    }
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == AppButtonVariant.primary
                ? (textColor ?? AppColors.textOnPrimary)
                : (textColor ?? AppColors.primary),
          ),
        ),
      );
    }

    final Color finalTextColor = _getTextColor();
    final TextStyle textStyle = AppTypography.button.copyWith(color: finalTextColor);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, color: finalTextColor, size: AppDimensions.iconMd),
          const SizedBox(width: AppDimensions.xs),
        ],
        Text(
          label,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppDimensions.xs),
          Icon(trailingIcon, color: finalTextColor, size: AppDimensions.iconMd),
        ],
      ],
    );
  }

  Color _getTextColor() {
    if (isDisabled || onPressed == null) {
      return AppColors.textHint;
    }
    
    if (textColor != null) {
      return textColor!;
    }
    
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.textOnPrimary;
      case AppButtonVariant.secondary:
      case AppButtonVariant.text:
        return AppColors.primary;
    }
  }
}
