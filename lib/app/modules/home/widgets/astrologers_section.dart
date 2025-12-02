import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/astrologer_model.dart';
import 'astrologer_card.dart';

class AstrologersSection extends StatelessWidget {
  final List<AstrologerModel> astrologers;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final VoidCallback onViewAll;
  final Function(String) onAstrologerTap;

  const AstrologersSection({
    super.key,
    required this.astrologers,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onViewAll,
    required this.onAstrologerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Astrologers',
                style: AppTypography.h3,
              ),
              TextButton(
                onPressed: onViewAll,
                child: Text(
                  'View All',
                  style: AppTypography.button.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        
        // Categories
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
          child: Row(
            children: ['All', 'Career', 'Life', 'Love', 'Health'].map((category) {
              final isSelected = selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: AppDimensions.paddingSm),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) onCategorySelected(category);
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : Colors.grey[600],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppDimensions.md),

        // List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
          itemCount: astrologers.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.md),
          itemBuilder: (context, index) {
            final astrologer = astrologers[index];
            return AstrologerCard(
              astrologer: astrologer,
              onTap: () => onAstrologerTap(astrologer.id),
            );
          },
        ),
      ],
    );
  }
}
