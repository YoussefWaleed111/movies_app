import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../widgets/common/non_image_placeholder.dart';
import '../widgets/common/onboarding_card_overlay.dart';
import '../models/onboarding_page_model.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  // Exact 6 Onboarding Pages matching Figma Specifications
  final List<OnboardingPageModel> _onboardingPages = const [
    OnboardingPageModel(
      pageIndex: 0,
      title: 'Find Your Next Favorite Movie Here',
      subtitle: 'Get access to a huge library of movies to suit all tastes. You will surely like it.',
      actionButtonText: 'Explore Now',
      hasBackButton: false,
      posterLabel: 'POSTER COLLAGE GRID',
      movieTag: 'GLOBAL MOVIE LIBRARY',
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1E1E28), Color(0xFF121216)],
      ),
    ),
    OnboardingPageModel(
      pageIndex: 1,
      title: 'Discover Movies',
      subtitle: 'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.',
      actionButtonText: 'Next',
      hasBackButton: true,
      posterLabel: 'MARVEL / AVENGERS POSTER',
      movieTag: 'ACTION & BLOCKBUSTERS',
      backgroundGradient: AppColors.avengersGradient,
    ),
    OnboardingPageModel(
      pageIndex: 2,
      title: 'Explore All Genres',
      subtitle: 'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.',
      actionButtonText: 'Next',
      hasBackButton: true,
      posterLabel: 'FIERY SCI-FI / OPPENHEIMER',
      movieTag: 'ALL GENRES & QUALITIES',
      backgroundGradient: AppColors.oppenheimerGradient,
    ),
    OnboardingPageModel(
      pageIndex: 3,
      title: 'Create Watchlists',
      subtitle: 'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.',
      actionButtonText: 'Next',
      hasBackButton: true,
      posterLabel: 'BAD BOYS / PURPLE LIGHTING',
      movieTag: 'PERSONAL WATCHLISTS',
      backgroundGradient: AppColors.badBoysGradient,
    ),
    OnboardingPageModel(
      pageIndex: 4,
      title: 'Rate, Review, and Learn',
      subtitle: 'Share your thoughts on the movies you\'ve watched. Dive deep into film details and help others discover great movies with your reviews.',
      actionButtonText: 'Next',
      hasBackButton: true,
      posterLabel: 'DOCTOR STRANGE / WANDA',
      movieTag: 'RATINGS & COMMUNITY',
      backgroundGradient: AppColors.doctorStrangeGradient,
    ),
    OnboardingPageModel(
      pageIndex: 5,
      title: 'Start Watching Now',
      subtitle: 'Start watching movie details and summaries, and get ready for a seamless experience.',
      actionButtonText: 'Finish',
      hasBackButton: true,
      posterLabel: '1917 DRAMATIC WAR POSTER',
      movieTag: 'SEAMLESS EXPERIENCE',
      backgroundGradient: AppColors.war1917Gradient,
    ),
  ];

  void _onPrimaryPressed() {
    if (_currentPageIndex < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  void _onBackPressed() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToAuth() {
    context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.login));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundPureBlack,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-Bleed Background Poster Container PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPageIndex = index);
            },
            itemCount: _onboardingPages.length,
            itemBuilder: (context, index) {
              final model = _onboardingPages[index];
              return _buildFullBleedBackgroundPoster(context, size, model);
            },
          ),

          // Bottom Sheet Card Overlay sitting over full-screen background poster
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: OnboardingCardOverlay(
              model: _onboardingPages[_currentPageIndex],
              totalPages: _onboardingPages.length,
              currentPageIndex: _currentPageIndex,
              onPrimaryPressed: _onPrimaryPressed,
              onBackPressed: _onBackPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullBleedBackgroundPoster(BuildContext context, Size size, OnboardingPageModel model) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: model.backgroundGradient,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Graphic / Wireframe Poster Placeholder
          Positioned(
            top: size.height * 0.08,
            left: 20,
            right: 20,
            height: size.height * 0.48,
            child: NonImagePlaceholder(
              type: PlaceholderType.heroPoster,
              label: '${model.posterLabel}\n[${model.movieTag}]',
              borderRadius: 20,
              accentColor: AppColors.primaryYellow,
              backgroundColor: AppColors.cardBackground.withValues(alpha: 0.8),
            ),
          ),

          // Dark Gradient Overlay for Smooth Fade into Bottom Card Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.5,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xCC000000),
                    Color(0xFF000000),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
