import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';

class SuccessBox extends StatelessWidget {
  final String? message;
  final RxString? rxMessage;
  final IconData icon;

  const SuccessBox({
    super.key,
    required this.message,
    this.icon = Icons.check_circle_outline,
  }) : rxMessage = null;

  const SuccessBox.reactive({
    super.key,
    required this.rxMessage,
    this.icon = Icons.check_circle_outline,
  }) : message = null;

  @override
  Widget build(BuildContext context) {
    if (rxMessage != null) {
      return Obx(() {
        if (rxMessage!.value.isEmpty) return const SizedBox.shrink();
        return _buildContainer(rxMessage!.value);
      });
    }

    if (message == null || message!.isEmpty) return const SizedBox.shrink();
    return _buildContainer(message!);
  }

  Widget _buildContainer(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.sm),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.success, size: AppDimensions.iconMd),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Text(
              msg,
              style: AppTypography.body2.copyWith(color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }
}
