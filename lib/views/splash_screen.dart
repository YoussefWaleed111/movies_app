import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../widgets/auth/route_logo.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Auto navigate to Onboarding flow after 2.5 seconds
    _timer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        _navigateToOnboarding();
      }
    });
  }

  void _navigateToOnboarding() {
    _timer?.cancel();
    context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.onboarding));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.figmaBackground,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateToOnboarding,
        child: SafeArea(
          child: Stack(
            children: [
              // Centered Yellow Route Logo Icon
              Center(
                child: RouteLogo(
                  width: 120,
                  height: 96,
                  color: AppColors.figmaYellow,
                ),
              ),

              // Bottom Brand Wordmark & Supervision Credit
              Positioned(
                bottom: 36,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    RouteScriptWordmark(
                      width: 110,
                      height: 36,
                      color: AppColors.figmaYellow,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Supervised by Mohamed Nabil',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
