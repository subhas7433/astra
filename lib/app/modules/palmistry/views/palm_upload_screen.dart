import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/enums/gender.dart';
import '../../../core/services/impl/subscription_service.dart';
import '../../../widgets/buttons/app_button.dart';
import '../../../widgets/containers/app_card.dart';
import '../../../widgets/containers/app_chip.dart';
import '../../../widgets/inputs/app_text_field.dart';
import '../../../widgets/state/state_widgets.dart';
import '../controllers/palm_reading_controller.dart';
import '../widgets/palm_image_selector.dart';
import '../widgets/palm_scanner_overlay.dart';
import '../../../routes/app_routes.dart';

class PalmUploadScreen extends GetView<PalmReadingController> {
  const PalmUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Palm Reading'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: 'History',
            onPressed: () => Get.toNamed(AppRoutes.palmReadingHistory),
          ),
          Center(
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.stars, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${SubscriptionService.to.chatCredits.value}',
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingStatus.value) {
          return const LoadingView(message: 'Loading...');
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Banner
                  _buildStatusBanner(),
                  const SizedBox(height: AppDimensions.lg),

                  // Guidelines
                  Text(
                    'Upload Clear Palm Images',
                    style: AppTypography.h2,
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    'For accurate readings, ensure good lighting and capture your full palm clearly.',
                    style: AppTypography.body2,
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  // Reading For Section
                  _buildReadingForSection(context),
                  const SizedBox(height: AppDimensions.lg),

                  // Left Palm Selector
                  PalmImageSelector(
                    label: 'Left Hand',
                    imageData: controller.leftPalmImage.value,
                    onTap: () => controller.pickImage(isLeftPalm: true),
                    onRemove: () => controller.removeImage(isLeftPalm: true),
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  // Right Palm Selector
                  PalmImageSelector(
                    label: 'Right Hand',
                    imageData: controller.rightPalmImage.value,
                    onTap: () => controller.pickImage(isLeftPalm: false),
                    onRemove: () => controller.removeImage(isLeftPalm: false),
                  ),
                  const SizedBox(height: AppDimensions.xl),

                  // Tips Card
                  AppCard(
                    backgroundColor: AppColors.cardBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.tips_and_updates,
                              color: AppColors.primary,
                              size: AppDimensions.iconMd,
                            ),
                            const SizedBox(width: AppDimensions.xs),
                            Text(
                              'Tips for Best Results',
                              style: AppTypography.body1.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        _buildTipItem('Hold your palm flat and open'),
                        _buildTipItem('Use natural daylight if possible'),
                        _buildTipItem('Avoid shadows or glare'),
                        _buildTipItem('Capture your full palm and fingers'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xxl),

                  // Create Reading Button
                  AppButton.primary(
                    label: 'Create Reading',
                    onPressed:
                        controller.canCreateReading && !controller.isProcessing
                            ? controller.createReading
                            : null,
                    isLoading: controller.isProcessing,
                    isDisabled: !controller.canCreateReading,
                    leadingIcon: Icons.auto_awesome,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                ],
              ),
            ),

            // Scanner Overlay
            if (controller.isProcessing)
              PalmScannerOverlay(
                leftPalmImage: controller.leftPalmImage.value,
                rightPalmImage: controller.rightPalmImage.value,
                isUploading: controller.isUploading.value,
                isCreating: controller.isCreating.value,
                progressText: controller.uploadProgress.value,
              ),
          ],
        );
      }),
    );
  }

  Widget _buildReadingForSection(BuildContext context) {
    return Obx(() {
      final isExpanded = controller.isSubjectExpanded.value;
      final name = controller.subjectNameController.text;
      final previewName = name.isNotEmpty ? name : 'Yourself';

      return AppCard(
        backgroundColor: AppColors.cardBackground,
        child: Column(
          children: [
            // Header (always visible)
            GestureDetector(
              onTap: () => controller.isSubjectExpanded.value = !isExpanded,
              child: Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                    size: AppDimensions.iconMd,
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Text(
                    'Reading For',
                    style: AppTypography.body1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Expanded(
                    child: Text(
                      previewName,
                      style: AppTypography.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            // Expanded fields
            if (isExpanded) ...[
              const SizedBox(height: AppDimensions.md),

              // Name
              AppTextField(
                label: 'Name',
                hint: 'Person being read',
                controller: controller.subjectNameController,
                prefixIcon: Icons.person_outline,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppDimensions.sm),

              // Gender selector
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gender',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Row(
                    children: Gender.values.map((gender) {
                      final isSelected =
                          controller.subjectGender.value == gender;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right:
                                gender != Gender.other ? AppDimensions.xs : 0,
                          ),
                          child: GestureDetector(
                            onTap: () =>
                                controller.subjectGender.value = gender,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimensions.sm,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.1)
                                    : AppColors.surface,
                                borderRadius:
                                    BorderRadius.circular(AppDimensions.radiusSm),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.divider,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                gender.displayName,
                                style: AppTypography.body2.copyWith(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),

              // Date of Birth
              GestureDetector(
                onTap: () => controller.pickSubjectDateOfBirth(context),
                child: AbsorbPointer(
                  child: AppTextField(
                    label: 'Date of Birth',
                    hint: 'Select date of birth',
                    controller: TextEditingController(
                      text: controller.subjectDateOfBirth.value != null
                          ? '${controller.subjectDateOfBirth.value!.day.toString().padLeft(2, '0')}/${controller.subjectDateOfBirth.value!.month.toString().padLeft(2, '0')}/${controller.subjectDateOfBirth.value!.year}'
                          : '',
                    ),
                    prefixIcon: Icons.cake_outlined,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.sm),

              // Birth Time (optional)
              GestureDetector(
                onTap: () => controller.pickSubjectBirthTime(context),
                child: AbsorbPointer(
                  child: AppTextField(
                    label: 'Birth Time (Optional)',
                    hint: 'Select birth time',
                    controller: TextEditingController(
                      text: controller.subjectBirthTimeDisplay,
                    ),
                    prefixIcon: Icons.access_time,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.sm),

              // Birth Place (optional)
              AppTextField(
                label: 'Birth Place (Optional)',
                hint: 'City of birth',
                controller: controller.subjectBirthPlaceController,
                prefixIcon: Icons.location_on_outlined,
                textInputAction: TextInputAction.done,
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildStatusBanner() {
    final status = controller.palmStatus.value;
    if (status == null) return const SizedBox.shrink();

    final bool isFree = status.hasFreeReadingAvailable;
    final String message = isFree
        ? 'Free Lifetime Reading Available'
        : '10 credits will be deducted';

    return AppCard(
      backgroundColor:
          isFree ? AppColors.success.withValues(alpha: 0.1) : AppColors.cardBackground,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                isFree ? Icons.celebration : Icons.stars,
                color: isFree ? AppColors.success : AppColors.primary,
                size: AppDimensions.iconLg,
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFree ? 'First Reading Free' : 'Premium Reading',
                      style: AppTypography.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isFree ? AppColors.success : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              AppChip(
                label: isFree ? 'FREE' : '10 Credits',
                isSelected: true,
                onTap: () {},
                backgroundColor: isFree ? AppColors.success : AppColors.primary,
              ),
            ],
          ),
          if (!isFree)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GestureDetector(
                onTap: () => SubscriptionService.to.showPaywall(),
                child: Text(
                  'Upgrade to Pro for more readings',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('  ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(tip, style: AppTypography.body2),
          ),
        ],
      ),
    );
  }
}
