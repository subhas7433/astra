import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';

class HoroscopeProgressBar extends StatelessWidget {
  final double percentage; // 0.0 to 1.0
  final Color color;

  const HoroscopeProgressBar({
    super.key,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: percentage),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Container(
                    width: constraints.maxWidth * value,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
