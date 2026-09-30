import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
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
    // Auto navigate to Onboarding flow after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        _navigateToOnboarding();
      }
    });
  }

  void _navigateToOnboarding() {
    context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.onboarding));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundPureBlack,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background ambient radial yellow aura
          Positioned(
            top: size.height * 0.32,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryYellow.withValues(alpha: 0.06),
              ),
            ),
          ),

          // Main Center Content: Centered Yellow 'Route' Play Icon Logo
          Center(
            child: GestureDetector(
              onTap: _navigateToOnboarding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Stylized Yellow Route Play Icon Logo
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppColors.primaryYellow, width: 2.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryYellow.withValues(alpha: 0.25),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: const [
                        Icon(
                          Icons.play_arrow_rounded,
                          size: 64,
                          color: AppColors.primaryYellow,
                        ),
                        Positioned(
                          bottom: 8,
                          child: Text(
                            'ROUTE',
                            style: TextStyle(
                              color: AppColors.primaryYellow,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Brand App Title
                  Text(
                    'ROUTE MOVIES',
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 28,
                      letterSpacing: 3.5,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    'CINEMATIC DISCOVERY STREAM',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primaryYellow,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Optional Skip / Tap Indicator
                  OutlinedButton(
                    onPressed: _navigateToOnboarding,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.placeholderBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: Text(
                      'Tap to Enter Flow →',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Watermark Text: "Supervised by Mohamed Nabil"
          Positioned(
            bottom: 40,
            child: Column(
              children: [
                Text(
                  'Supervised by Mohamed Nabil',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Flutter Expert MVVM & BLoC Architecture',
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
