import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/common/non_image_placeholder.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Find Your Next Favorite',
      'description': 'Explore thousands of blockbusters, indie gems, and trending movies tailored to your cinematic taste.',
      'placeholderLabel': 'ONBOARDING HERO POSTER 1',
    },
    {
      'title': 'State-Driven MVVM Architecture',
      'description': 'Experience zero-lag browsing powered by BLoC state management and reactive data streams.',
      'placeholderLabel': 'ONBOARDING HERO POSTER 2',
    },
    {
      'title': 'Curate Your Watchlist',
      'description': 'Save your favorite movies, track watch history, and sync across all your mobile devices effortlessly.',
      'placeholderLabel': 'ONBOARDING HERO POSTER 3',
    },
  ];

  void _onNextPressed() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  void _navigateToAuth() {
    context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.login));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Top Bar with Step Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'STEP ${_currentPage + 1} OF ${_onboardingData.length}',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.primaryGold),
                  ),
                  TextButton(
                    onPressed: _navigateToAuth,
                    child: const Text('Skip', style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // PageView Carousel Content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    final item = _onboardingData[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Central Large Icon-Based Non-Image Placeholder
                        NonImagePlaceholder(
                          type: PlaceholderType.heroPoster,
                          label: item['placeholderLabel'],
                          width: double.infinity,
                          height: size.height * 0.4,
                          borderRadius: 20,
                          accentColor: AppColors.primaryGold,
                        ),
                        const SizedBox(height: 32),

                        // Title Text
                        Text(
                          item['title']!,
                          textAlign: TextAlign.center,
                          style: AppTypography.displayMedium,
                        ),
                        const SizedBox(height: 12),

                        // Description Text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            item['description']!,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(height: 1.5),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Page Indicator Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingData.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? AppColors.primaryGold : AppColors.placeholderBorder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Vertical Stack Buttons: Yellow 'Next' / 'Get Started' and White 'Skip'
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _onNextPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGold,
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _currentPage == _onboardingData.length - 1 ? 'Get Started' : 'Next',
                      style: AppTypography.button,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _navigateToAuth,
                    child: Text(
                      'Skip to Login',
                      style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
