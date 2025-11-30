import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../controllers/home_controller.dart'; // Import to access MockAstrologer
import 'astrologer_card.dart';
import 'category_chips.dart';
import 'section_header.dart';

class AstrologersSection extends StatelessWidget {
  final List<MockAstrologer> astrologers;
  final Function(String) onAstrologerTap;
  final Function(String) onCategorySelected;
  final String selectedCategory;
  final VoidCallback onViewAll;

  const AstrologersSection({
    super.key,
    required this.astrologers,
    required this.onAstrologerTap,
    required this.onCategorySelected,
    required this.selectedCategory,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Astrologers',
          onViewAll: onViewAll,
        ),
        
        // Category Chips
        CategoryChips(
          categories: const ['All', 'Career', 'Life', 'Love', 'Health'],
          selectedCategory: selectedCategory,
          onCategorySelected: onCategorySelected,
        ),
        
        const SizedBox(height: AppDimensions.md),

        // Vertical List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd),
          itemCount: astrologers.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.md),
          itemBuilder: (context, index) {
            final astrologer = astrologers[index];
            return AstrologerCard(
              name: astrologer.name,
              specialty: astrologer.specialty,
              rating: astrologer.rating,
              reviewCount: astrologer.reviewCount,
              imageUrl: astrologer.imageUrl,
              onTap: () => onAstrologerTap(astrologer.id),
            );
          },
        ),
      ],
    );
  }
}
