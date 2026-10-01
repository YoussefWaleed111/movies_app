import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../models/onboarding_page_model.dart';
import 'custom_primary_button.dart';
import 'custom_outlined_button.dart';

class OnboardingCardOverlay extends StatelessWidget {
  final OnboardingPageModel model;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onBackPressed;

  const OnboardingCardOverlay({
    super.key,
    required this.model,
    required this.onPrimaryPressed,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!model.isCardOverlay) {
      // Screen 1 Layout: Seamless text and button over gradient (no box card container)
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                model.title,
                textAlign: TextAlign.center,
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                model.subtitle,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 14,
                  color: AppColors.figmaHint,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              CustomPrimaryButton(
                text: model.actionButtonText,
                onPressed: onPrimaryPressed,
              ),
            ],
          ),
        ),
      );
    }

    // Screens 2 to 6: Dark rounded bottom card overlay sitting over poster background
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.figmaBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Color(0xFF282A28), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 30,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title Text
              Text(
                model.title,
                textAlign: TextAlign.center,
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle Text
              Text(
                model.subtitle,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 14,
                  color: AppColors.figmaHint,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons: Yellow Primary ("Next" / "Finish") + Optional Yellow Outlined "Back"
              Column(
                children: [
                  CustomPrimaryButton(
                    text: model.actionButtonText,
                    onPressed: onPrimaryPressed,
                  ),
                  if (model.hasBackButton) ...[
                    const SizedBox(height: 14),
                    CustomOutlinedButton(
                      text: 'Back',
                      onPressed: onBackPressed,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
