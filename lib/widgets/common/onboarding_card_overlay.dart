import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../models/onboarding_page_model.dart';
import 'custom_primary_button.dart';
import 'custom_outlined_button.dart';

class OnboardingCardOverlay extends StatelessWidget {
  final OnboardingPageModel model;
  final int totalPages;
  final int currentPageIndex;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onBackPressed;

  const OnboardingCardOverlay({
    super.key,
    required this.model,
    required this.totalPages,
    required this.currentPageIndex,
    required this.onPrimaryPressed,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
      decoration: const BoxDecoration(
        color: AppColors.overlayCardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.placeholderBorder, width: 1.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title Text
          Text(
            model.title,
            textAlign: TextAlign.center,
            style: AppTypography.displayLarge.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),

          // Subtitle Text
          Text(
            model.subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // Page Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalPages,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentPageIndex == index ? 26 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentPageIndex == index ? AppColors.primaryYellow : AppColors.placeholderBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons: Yellow Primary Button + Optional Dark Outlined Back Button Below
          Column(
            children: [
              CustomPrimaryButton(
                text: model.actionButtonText,
                onPressed: onPrimaryPressed,
              ),
              if (model.hasBackButton) ...[
                const SizedBox(height: 12),
                CustomOutlinedButton(
                  text: 'Back',
                  onPressed: onBackPressed,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
