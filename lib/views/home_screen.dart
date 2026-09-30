import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/common/non_image_placeholder.dart';
import '../widgets/common/shimmer_loading.dart';
import '../widgets/common/responsive_layout.dart';
import '../blocs/movie_list/movie_list_bloc.dart';
import '../blocs/movie_list/movie_list_event.dart';
import '../blocs/movie_list/movie_list_state.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';
import '../models/movie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<MovieListBloc, MovieListState>(
          builder: (context, state) {
            if (state is MovieListLoading) {
              return _buildShimmerLoadingView(context);
            }
            if (state is MovieListError) {
              return _buildErrorView(context, state.message);
            }
            if (state is MovieListEmpty) {
              return _buildEmptyView(context);
            }
            if (state is MovieListLoaded) {
              return _buildLoadedView(context, state);
            }
            // Initial state trigger
            context.read<MovieListBloc>().add(LoadMoviesRequested());
            return _buildShimmerLoadingView(context);
          },
        ),
      ),
    );
  }

  // --- 1. LOADED STATE VIEW ---
  Widget _buildLoadedView(BuildContext context, MovieListLoaded state) {
    final isTablet = ResponsiveLayout.isTablet(context);

    return RefreshIndicator(
      color: AppColors.primaryGold,
      backgroundColor: AppColors.cardBackground,
      onRefresh: () async {
        context.read<MovieListBloc>().add(LoadMoviesRequested());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top App Bar Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WELCOME BACK',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.primaryGold),
                      ),
                      const SizedBox(height: 2),
                      Text('Stream Now', style: AppTypography.displayMedium),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.search_rounded, color: AppColors.primaryGold, size: 28),
                    onPressed: () {
                      context.read<NavigationBloc>().add(
                            const NavigateToRoute(AppViewRoute.mainShell, bottomNavIndex: 1),
                          );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Section Header: "Watch Now" Hero Carousel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('WATCH NOW', style: AppTypography.titleLarge),
            ),
            const SizedBox(height: 14),

            // Primary "Watch Now" Hero Carousel (Flanked non-image poster placeholders)
            SizedBox(
              height: isTablet ? 360 : 280,
              child: PageView.builder(
                controller: PageController(viewportFraction: isTablet ? 0.65 : 0.75),
                itemCount: 3,
                itemBuilder: (context, index) {
                  final isCenter = index == 0;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    transform: Matrix4.identity()..scale(isCenter ? 1.0 : 0.92),
                    child: GestureDetector(
                      onTap: () {
                        context.read<NavigationBloc>().add(
                              const NavigateToRoute(AppViewRoute.movieDetail, movieId: 'm1'),
                            );
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          NonImagePlaceholder(
                            type: PlaceholderType.heroPoster,
                            label: index == 0 ? 'WATCH NOW: DOCTOR STRANGE' : 'HERO BANNER #${index + 1}',
                            borderRadius: 16,
                            accentColor: index == 0 ? AppColors.accentRed : AppColors.primaryGold,
                          ),
                          // Dark Gradient Overlay & Quick Title Stack
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                                gradient: AppColors.heroPosterOverlay,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryGold,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'FEATURED • 4.8 ★',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    index == 0
                                        ? 'Doctor Strange in Multiverse'
                                        : 'Blockbuster Title #${index + 1}',
                                    style: AppTypography.titleLarge,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            // Section 2: "Popular" Movies (3x / Horizontal Non-Image Poster Cards)
            _buildSectionHeader(context, 'Popular Movies'),
            const SizedBox(height: 14),
            _buildMovieHorizontalList(context, state.popularMovies),
            const SizedBox(height: 28),

            // Section 3: "Recommended" Movies (3x / Grid Carousel)
            _buildSectionHeader(context, 'Recommended For You'),
            const SizedBox(height: 14),
            _buildMovieHorizontalList(context, state.recommendedMovies),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.titleLarge),
          GestureDetector(
            onTap: () {
              context.read<NavigationBloc>().add(
                    const NavigateToRoute(AppViewRoute.mainShell, bottomNavIndex: 2),
                  );
            },
            child: Text(
              'See All →',
              style: AppTypography.labelSmall.copyWith(color: AppColors.primaryGold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieHorizontalList(BuildContext context, List<Movie> movies) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            width: 130,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () {
                context.read<NavigationBloc>().add(
                      NavigateToRoute(AppViewRoute.movieDetail, movieId: movie.id),
                    );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: NonImagePlaceholder(
                      type: PlaceholderType.poster,
                      label: 'Poster: ${movie.title.split(" ").first}',
                      borderRadius: 12,
                      accentColor: AppColors.primaryGold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.title,
                    style: AppTypography.titleMedium.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.primaryGold, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.rating} | ${movie.releaseYear}',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- 2. SHIMMER LOADING STATE VIEW ---
  Widget _buildShimmerLoadingView(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                ShimmerBlock(width: 140, height: 28),
                ShimmerBlock(width: 36, height: 36, borderRadius: 18),
              ],
            ),
            const SizedBox(height: 24),
            const ShimmerBlock(width: double.infinity, height: 260, borderRadius: 16),
            const SizedBox(height: 28),
            const ShimmerBlock(width: 160, height: 24),
            const SizedBox(height: 16),
            Row(
              children: List.generate(
                3,
                (i) => Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: const ShimmerBlock(width: 120, height: 180, borderRadius: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. ERROR STATE VIEW ---
  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const NonImagePlaceholder(
              type: PlaceholderType.generic,
              label: 'BLOC ERROR STATE',
              width: 90,
              height: 90,
              accentColor: AppColors.errorRed,
            ),
            const SizedBox(height: 20),
            Text('Movie Feed Loading Failed', style: AppTypography.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<MovieListBloc>().add(LoadMoviesRequested());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry Fetching Data'),
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. EMPTY STATE VIEW ---
  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const NonImagePlaceholder(
            type: PlaceholderType.poster,
            label: 'EMPTY FEED',
            width: 100,
            height: 130,
          ),
          const SizedBox(height: 16),
          Text('No Movies Currently Available', style: AppTypography.titleLarge),
          const SizedBox(height: 8),
          Text('Check back later or try changing your filters.', style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
