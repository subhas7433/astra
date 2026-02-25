import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';

class PalmScannerOverlay extends StatefulWidget {
  final Uint8List? leftPalmImage;
  final Uint8List? rightPalmImage;
  final bool isUploading;
  final bool isCreating;
  final String progressText;

  const PalmScannerOverlay({
    super.key,
    this.leftPalmImage,
    this.rightPalmImage,
    required this.isUploading,
    required this.isCreating,
    required this.progressText,
  });

  @override
  State<PalmScannerOverlay> createState() => _PalmScannerOverlayState();
}

class _PalmScannerOverlayState extends State<PalmScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;

  static const double _scanAreaHeight = 280;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  String get _currentStageKey {
    if (widget.isUploading && widget.progressText.contains('left')) {
      return 'left';
    }
    if (widget.isUploading && widget.progressText.contains('right')) {
      return 'right';
    }
    return 'both';
  }

  int get _currentStageIndex {
    if (widget.isUploading && widget.progressText.contains('left')) return 0;
    if (widget.isUploading && widget.progressText.contains('right')) return 1;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.85),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Reading Your Palm Lines',
              style: AppTypography.h2.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppDimensions.lg),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimensions.xl),
              child: _buildScanArea(),
            ),
            const SizedBox(height: AppDimensions.lg),
            _buildProgressSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildScanArea() {
    return Container(
      height: _scanAreaHeight,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Image layer
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildImageLayer(),
            ),

            // Vignette overlay
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.4),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // Scan line
            AnimatedBuilder(
              animation: _scanController,
              builder: (context, child) {
                final scanY = _scanController.value * _scanAreaHeight;
                return Stack(
                  children: [
                    // Glow band
                    Positioned(
                      left: 0,
                      right: 0,
                      top: scanY - 30,
                      child: IgnorePointer(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.primaryLight
                                    .withValues(alpha: 0.25),
                                AppColors.primary
                                    .withValues(alpha: 0.6),
                                AppColors.primaryLight
                                    .withValues(alpha: 0.25),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Thin center line
                    Positioned(
                      left: 0,
                      right: 0,
                      top: scanY - 1,
                      child: IgnorePointer(
                        child: Container(
                          height: 2,
                          color: AppColors.primary.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Corner brackets
            AnimatedBuilder(
              animation: _scanController,
              builder: (context, child) {
                final opacity =
                    0.4 + 0.6 * sin(_scanController.value * 2 * pi);
                return Stack(
                  children: [
                    _buildCornerBracket(
                        isTop: true, isLeft: true, opacity: opacity),
                    _buildCornerBracket(
                        isTop: true, isLeft: false, opacity: opacity),
                    _buildCornerBracket(
                        isTop: false, isLeft: true, opacity: opacity),
                    _buildCornerBracket(
                        isTop: false, isLeft: false, opacity: opacity),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageLayer() {
    final stageKey = _currentStageKey;

    if (stageKey == 'both' &&
        widget.leftPalmImage != null &&
        widget.rightPalmImage != null) {
      return Row(
        key: const ValueKey('both'),
        children: [
          Expanded(
            child: Image.memory(
              widget.leftPalmImage!,
              fit: BoxFit.cover,
              height: _scanAreaHeight,
            ),
          ),
          Container(width: 2, color: Colors.black),
          Expanded(
            child: Image.memory(
              widget.rightPalmImage!,
              fit: BoxFit.cover,
              height: _scanAreaHeight,
            ),
          ),
        ],
      );
    }

    final image =
        stageKey == 'right' ? widget.rightPalmImage : widget.leftPalmImage;
    if (image == null) return const SizedBox.shrink();

    return SizedBox(
      key: ValueKey(stageKey),
      width: double.infinity,
      height: _scanAreaHeight,
      child: Image.memory(
        image,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCornerBracket({
    required bool isTop,
    required bool isLeft,
    required double opacity,
  }) {
    const double size = 24;
    const double thickness = 2.5;

    return Positioned(
      top: isTop ? 0 : null,
      bottom: !isTop ? 0 : null,
      left: isLeft ? 0 : null,
      right: !isLeft ? 0 : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? BorderSide(
                    color: AppColors.primary.withValues(alpha: opacity),
                    width: thickness)
                : BorderSide.none,
            bottom: !isTop
                ? BorderSide(
                    color: AppColors.primary.withValues(alpha: opacity),
                    width: thickness)
                : BorderSide.none,
            left: isLeft
                ? BorderSide(
                    color: AppColors.primary.withValues(alpha: opacity),
                    width: thickness)
                : BorderSide.none,
            right: !isLeft
                ? BorderSide(
                    color: AppColors.primary.withValues(alpha: opacity),
                    width: thickness)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      children: [
        Text(
          widget.progressText,
          style: AppTypography.body1.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isActive = index == _currentStageIndex;
            final isCompleted = index < _currentStageIndex;

            Color dotColor;
            if (isActive) {
              dotColor = AppColors.primary;
            } else if (isCompleted) {
              dotColor = AppColors.primaryLight;
            } else {
              dotColor = Colors.white24;
            }

            Widget dot = Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            );

            if (isActive) {
              dot = AnimatedBuilder(
                animation: _scanController,
                builder: (context, child) {
                  final scale =
                      0.8 + 0.4 * sin(_scanController.value * 2 * pi);
                  return Transform.scale(scale: scale, child: child);
                },
                child: dot,
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: dot,
            );
          }),
        ),
      ],
    );
  }
}
