import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../controllers/settings_controller.dart';
import '../../../widgets/buttons/app_button.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final SettingsController _controller = Get.find<SettingsController>();
  double _rating = 5.0;
  String _selectedCategory = 'Suggestion';

  final List<String> _categories = ['Suggestion', 'Bug Report', 'Question', 'Other'];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Feedback', style: AppTypography.h2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We value your feedback!',
              style: AppTypography.h2,
            ),
            const SizedBox(height: AppDimensions.paddingSm),
            Text(
              'Help us make Astra AI better for everyone.',
              style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
            ),
            
            const SizedBox(height: AppDimensions.paddingXl),
            
            Text('Category', style: AppTypography.h3),
            const SizedBox(height: AppDimensions.paddingSm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppDimensions.paddingSm),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingLg),
            
            Text('Rate your experience', style: AppTypography.h3),
            const SizedBox(height: AppDimensions.paddingSm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: AppDimensions.paddingLg),
            
            Text('Your Message', style: AppTypography.h3),
            const SizedBox(height: AppDimensions.paddingSm),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tell us what you think...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(AppDimensions.paddingMd),
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingXl),
            
            AppButton.primary(
              label: 'Submit Feedback',
              onPressed: () {
                _controller.submitFeedback(
                  _feedbackController.text,
                  _rating,
                );
              },
            ),
            ],
          ),
        ),
      ),
    );
  }
}
