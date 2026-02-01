import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../home/widgets/most_asked_section.dart';
import '../controllers/astrologer_profile_controller.dart';
import 'review_card.dart';
import 'specialty_chip.dart';

class ProfileInfoSheet extends GetView<AstrologerProfileController> {
  const ProfileInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFF3E0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.paddingLg,
          AppDimensions.paddingLg,
          AppDimensions.paddingLg,
          100,
        ),
        child: Obx(() {
          final astrologer = controller.astrologer.value;
          final specialties = astrologer?.expertiseTags ?? [];
          final languages = astrologer?.languages ?? [];
          final reviews = controller.reviews;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              Center(
                child: Text(
                  astrologer?.name ?? 'Loading...',
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
                astrologer?.bio ?? 'Loading profile information...',
                style: AppTypography.body1.copyWith(
                  color: Colors.brown[900],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppDimensions.lg),

              // Specialties
              if (specialties.isNotEmpty) ...[
                Wrap(
                  spacing: AppDimensions.sm,
                  runSpacing: AppDimensions.sm,
                  children: specialties.map((s) => SpecialtyChip(label: s)).toList(),
                ),
                const SizedBox(height: AppDimensions.lg),
              ],

              // Info Row (Language, Chats, Rating)
              Wrap(
                spacing: AppDimensions.md,
                runSpacing: AppDimensions.sm,
                children: [
                  if (languages.isNotEmpty)
                    _buildInfoBox(languages.join(', ')),
                  if (astrologer?.chatCount != null && astrologer!.chatCount > 0)
                    _buildInfoBox('${_formatCount(astrologer.chatCount)} Chats'),
                  if (astrologer?.rating != null && astrologer!.rating > 0)
                    _buildInfoBox('${astrologer.rating.toStringAsFixed(1)} ⭐'),
                ],
              ),
              const SizedBox(height: AppDimensions.xl),

              // Most Asked Questions
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

              if (reviews.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingLg),
                    child: Text(
                      'No reviews yet',
                      style: AppTypography.body2.copyWith(color: Colors.grey),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: reviews.length,
                    separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.md),
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return ReviewCard(
                        name: review.userName,
                        rating: review.rating.toDouble(),
                        comment: review.text,
                      );
                    },
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
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
