import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../home/widgets/most_asked_section.dart'; // Reusing
import '../controllers/astrologer_profile_controller.dart';
import 'review_card.dart';
import 'specialty_chip.dart';

class ProfileInfoSheet extends StatelessWidget {
  final AstrologerProfileController controller;

  const ProfileInfoSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Mock Data for UI building
    final specialties = ['Vastu Strategies', 'Empathetic', 'Vedic'];
    final languages = ['English', 'Hindi'];
    
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFF3E0), // Beige/Peach background
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.paddingLg,
          AppDimensions.paddingLg,
          AppDimensions.paddingLg,
          100, // Bottom padding for fixed button
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            Center(
              child: Text(
                controller.astrologer.value?.name ?? 'Nikki Diwan',
                style: AppTypography.h2.copyWith(
                  color: Colors.brown[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            const Divider(color: Colors.brown, thickness: 0.5),
            const SizedBox(height: AppDimensions.md),

            // Description
            Text(
              '${controller.astrologer.value?.name ?? "Nikki Diwan"} specializing in providing tailored guidance for career advancement and financial prosperity.',
              style: AppTypography.body1.copyWith(
                color: Colors.brown[900],
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),

            // Specialties
            Wrap(
              spacing: AppDimensions.sm,
              runSpacing: AppDimensions.sm,
              children: specialties.map((s) => SpecialtyChip(label: s)).toList(),
            ),
            const SizedBox(height: AppDimensions.lg),

            // Info Row (Language, Chats)
            Row(
              children: [
                _buildInfoBox('English'),
                const SizedBox(width: AppDimensions.md),
                _buildInfoBox('9.3K Chats'),
              ],
            ),
            const SizedBox(height: AppDimensions.xl),

            // Most Asked Questions (Reused)
            MostAskedSection(
              questions: const [
                'Mere career mein safalta ke liye kaun se upay sujhayein?',
                'Mujhe yahan career start karna chahiye?',
              ],
              onQuestionTap: (q) {},
            ),
            const SizedBox(height: AppDimensions.xl),

            // Reviews
            Text(
              'Reviews',
              style: AppTypography.h3.copyWith(color: Colors.brown[800]),
            ),
            const SizedBox(height: AppDimensions.md),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.md),
                itemBuilder: (context, index) {
                  return const ReviewCard(
                    name: 'Shubham Pincha',
                    rating: 4.0,
                    comment: 'good',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingSm,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCCBC),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: AppTypography.body2.copyWith(
          color: Colors.brown,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
