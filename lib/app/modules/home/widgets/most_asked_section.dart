import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../widgets/containers/app_card.dart';
import 'section_header.dart';

class MostAskedSection extends StatelessWidget {
  final List<String> questions;
  final Function(String) onQuestionTap;

  const MostAskedSection({
    super.key,
    required this.questions,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Most Ask Question'),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
            itemCount: questions.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.md),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 200,
                child: AppCard(
                  variant: AppCardVariant.standard,
                  padding: EdgeInsets.zero,
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingMd),
                    decoration: BoxDecoration(
                      gradient: AppColors.questionCardGradient,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      questions[index],
                      style: AppTypography.body1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  onTap: () => onQuestionTap(questions[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
