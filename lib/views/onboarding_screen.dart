import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
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
      subtitle:
          'Get access to a huge library of movies to suit all tastes. You will surely like it.',
      actionButtonText: 'Explore Now',
      hasBackButton: false,
      isCardOverlay: false,
    ),
    OnboardingPageModel(
      pageIndex: 1,
      title: 'Discover Movies',
      subtitle:
          'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.',
      actionButtonText: 'Next',
      hasBackButton: false,
      isCardOverlay: true,
      posterAsset: 'assets/images/avengers.jpg',
    ),
    OnboardingPageModel(
      pageIndex: 2,
      title: 'Explore All Genres',
      subtitle:
          'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.',
      actionButtonText: 'Next',
      hasBackButton: true,
      isCardOverlay: true,
      posterAsset: 'assets/images/oppenheimer.jpg',
    ),
    OnboardingPageModel(
      pageIndex: 3,
      title: 'Create Watchlists',
      subtitle:
          'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.',
      actionButtonText: 'Next',
      hasBackButton: true,
      isCardOverlay: true,
      posterAsset: 'assets/images/bad_boys.jpg',
    ),
    OnboardingPageModel(
      pageIndex: 4,
      title: 'Rate, Review, and Learn',
      subtitle:
          'Share your thoughts on the movies you\'ve watched. Dive deep into film details and help others discover great movies with your reviews.',
      actionButtonText: 'Next',
      hasBackButton: true,
      isCardOverlay: true,
      posterAsset: 'assets/images/doctor_strange.jpg',
    ),
    OnboardingPageModel(
      pageIndex: 5,
      title: 'Start Watching Now',
      subtitle:
          'Start watching movie details and summaries, and get ready for a seamless experience.',
      actionButtonText: 'Finish',
      hasBackButton: true,
      isCardOverlay: true,
      posterAsset: 'assets/images/war_1917.jpg',
    ),
  ];

  void _onPrimaryPressed() {
    if (_currentPageIndex < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  void _onBackPressed() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 320),
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
    final currentModel = _onboardingPages[_currentPageIndex];

    return Scaffold(
      backgroundColor: AppColors.figmaBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full Screen PageView (Background Posters)
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPageIndex = index);
            },
            itemCount: _onboardingPages.length,
            itemBuilder: (context, index) {
              final model = _onboardingPages[index];
              if (index == 0) {
                return _buildCollageBackground(context);
              }
              return _buildSinglePosterBackground(context, model);
            },
          ),

          // Bottom Content / Card Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: OnboardingCardOverlay(
              model: currentModel,
              onPrimaryPressed: _onPrimaryPressed,
              onBackPressed: _onBackPressed,
            ),
          ),
        ],
      ),
    );
  }

  /// Screen 1 Background: 3D Tilted Movie Poster Collage Grid
  Widget _buildCollageBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Dark background base
        Container(color: AppColors.figmaBackground),

        // Tilted Poster Grid
        Positioned(
          top: -size.height * 0.10,
          left: -size.width * 0.35,
          right: -size.width * 0.35,
          bottom: 0,
          child: ClipRect(
            child: OverflowBox(
              alignment: Alignment.topCenter,
              minWidth: 0,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: double.infinity,
              child: Transform.rotate(
                angle: -0.16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Column 1
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        _buildCollagePoster('assets/images/cars.jpg'),
                        const SizedBox(height: 14),
                        _buildCollagePoster('assets/images/oppenheimer.jpg'),
                        const SizedBox(height: 14),
                        _buildCollagePoster('assets/images/war_1917.jpg'),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Column 2 (Offset)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 70),
                        _buildCollagePoster('assets/images/bad_boys.jpg'),
                        const SizedBox(height: 14),
                        _buildCollagePoster('assets/images/avengers.jpg'),
                        const SizedBox(height: 14),
                        _buildCollagePoster('assets/images/interstellar.jpg'),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Column 3
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        _buildCollagePoster('assets/images/deadpool.jpg'),
                        const SizedBox(height: 14),
                        _buildCollagePoster('assets/images/doctor_strange.jpg'),
                        const SizedBox(height: 14),
                        _buildCollagePoster('assets/images/cars.jpg'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Smooth Vertical Fade to Dark (#121312)
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.35, 0.65, 0.88, 1.0],
                colors: [
                  Color(0x33000000),
                  Color(0x22121312),
                  Color(0xBB121312),
                  Color(0xFF121312),
                  Color(0xFF121312),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCollagePoster(String assetPath) {
    return Container(
      width: 135,
      height: 195,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFF1E1E28),
            child: const Icon(Icons.movie_outlined, color: Colors.white30, size: 28),
          );
        },
      ),
    );
  }

  /// Screens 2-6 Background: Full-Bleed Movie Poster with Gradient Overlay
  Widget _buildSinglePosterBackground(BuildContext context, OnboardingPageModel model) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Poster Image
        if (model.posterAsset != null)
          Image.asset(
            model.posterAsset!,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: const Color(0xFF161616));
            },
          )
        else
          Container(color: const Color(0xFF161616)),

        // Top Subtle Gradient for Status Bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 120,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x88000000),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Dark Vignette / Bottom Fade behind the Card Overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 350,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x66121312),
                  Color(0xDD121312),
                  Color(0xFF121312),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
