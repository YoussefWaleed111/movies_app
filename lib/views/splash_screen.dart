import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/common/non_image_placeholder.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Auto navigate to Onboarding after 2 seconds (or user can click button)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.onboarding));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient dark glow outline
          Positioned(
            top: size.height * 0.3,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGold.withOpacity(0.05),
              ),
            ),
          ),

          // Main Center Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Application Logo Non-Image Placeholder
                const NonImagePlaceholder(
                  type: PlaceholderType.logo,
                  label: 'CINEBLOC LOGO',
                  width: 140,
                  height: 140,
                  borderRadius: 24,
                  accentColor: AppColors.primaryGold,
                ),
                const SizedBox(height: 28),

                // Title and Subtitle
                Text(
                  'CINEBLOC',
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: 32,
                    letterSpacing: 4.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'PREMIUM MOVIE DISCOVERY',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primaryGold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 32),

                // Manual Continue Trigger (for instant previewing)
                OutlinedButton(
                  onPressed: () {
                    context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.onboarding));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.placeholderBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    'Enter App Flow →',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Center "Built with BLoC" Indicator
          Positioned(
            bottom: 36,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGold,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Built with BLoC & MVVM',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Flutter Clean Architecture Specification',
                  style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.textDisabled),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
