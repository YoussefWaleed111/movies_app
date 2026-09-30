import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/common/non_image_placeholder.dart';
import '../widgets/common/shimmer_loading.dart';
import '../blocs/movie_detail/movie_detail_bloc.dart';
import '../blocs/movie_detail/movie_detail_event.dart';
import '../blocs/movie_detail/movie_detail_state.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MovieDetailBloc>().add(LoadMovieDetailRequested(widget.movieId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return _buildShimmerView(context);
          }
          if (state is MovieDetailError) {
            return _buildErrorView(context, state.message);
          }
          if (state is MovieDetailLoaded) {
            return _buildDetailContent(context, state.movie, state.isInWatchlist);
          }
          return _buildShimmerView(context);
        },
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, Movie movie, bool isInWatchlist) {
    final size = MediaQuery.of(context).size;
    final isDoctorStrange = movie.themeVibe == 'doctor_strange';

    return CustomScrollView(
      slivers: [
        // Hero Header Area with Specific Movie Vibe Gradient (Dark Blue/Red Gradient for Doctor Strange)
        SliverAppBar(
          expandedHeight: size.height * 0.42,
          pinned: true,
          backgroundColor: AppColors.background,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              onPressed: () {
                context.read<NavigationBloc>().add(
                      const NavigateToRoute(AppViewRoute.mainShell, bottomNavIndex: 0),
                    );
              },
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  isInWatchlist ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isInWatchlist ? AppColors.accentRed : Colors.white,
                ),
                onPressed: () {
                  context.read<MovieDetailBloc>().add(ToggleWatchlistRequested());
                },
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Specific Screen Gradient Background (Doctor Strange theme)
                Container(
                  decoration: BoxDecoration(
                    gradient: isDoctorStrange
                        ? AppColors.doctorStrangeGradient
                        : const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF2A1A40), AppColors.background],
                          ),
                  ),
                ),

                // Hero Scaled Non-Image Poster Placeholder
                Center(
                  child: Container(
                    width: size.width * 0.55,
                    height: size.height * 0.32,
                    margin: const EdgeInsets.only(top: 40),
                    child: NonImagePlaceholder(
                      type: PlaceholderType.heroPoster,
                      label: 'HERO POSTER: ${movie.title.split(" ").first.toUpperCase()}',
                      borderRadius: 16,
                      accentColor: isDoctorStrange ? AppColors.accentRed : AppColors.primaryGold,
                    ),
                  ),
                ),

                // Bottom Gradient Overlay for Smooth Fade
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.background],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Main Details Body
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(movie.title, style: AppTypography.displayLarge.copyWith(fontSize: 24)),
                const SizedBox(height: 10),

                // Ratings & Badges Meta Info
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: Colors.black),
                          const SizedBox(width: 4),
                          Text(
                            movie.rating,
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${movie.releaseYear}  •  ${movie.duration}',
                      style: AppTypography.bodyMedium,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.placeholderBorder),
                      ),
                      child: Text(
                        '4K ULTRA HD',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.primaryGold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Genre Text Chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: movie.genres.map((g) {
                    return Chip(
                      label: Text(g, style: AppTypography.labelSmall.copyWith(color: Colors.white)),
                      backgroundColor: AppColors.cardBackground,
                      side: const BorderSide(color: AppColors.placeholderBorder),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Button Stack: Yellow 'Watch' and Red 'In Watchlist / Update Profile' Button
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow_rounded, size: 28, color: Colors.black),
                      label: const Text('WATCH NOW', style: AppTypography.button),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGold,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<MovieDetailBloc>().add(ToggleWatchlistRequested());
                      },
                      icon: Icon(
                        isInWatchlist ? Icons.check_circle_outline_rounded : Icons.bookmark_add_outlined,
                        size: 22,
                        color: Colors.white,
                      ),
                      label: Text(
                        isInWatchlist ? 'IN WATCHLIST (REMOVE)' : 'ADD TO WATCHLIST',
                        style: AppTypography.button.copyWith(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInWatchlist ? AppColors.accentRed : AppColors.cardBackgroundLight,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Synopsis Text
                Text('SYNOPSIS', style: AppTypography.titleMedium),
                const SizedBox(height: 8),
                Text(
                  movie.synopsis,
                  style: AppTypography.bodyMedium.copyWith(height: 1.6),
                ),
                const SizedBox(height: 28),

                // Screenshots Section (Icon-based Non-Image Placeholders)
                Text('SCREENSHOTS', style: AppTypography.titleMedium),
                const SizedBox(height: 12),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movie.screenshotsCount,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 170,
                        margin: const EdgeInsets.only(right: 12),
                        child: NonImagePlaceholder(
                          type: PlaceholderType.screen,
                          label: 'Screen #${index + 1}',
                          borderRadius: 10,
                          accentColor: AppColors.primaryGold,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Cast Section (Icon-based Non-Image Placeholders)
                Text('TOP CAST', style: AppTypography.titleMedium),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movie.castList.length,
                    itemBuilder: (context, index) {
                      final actor = movie.castList[index];
                      return Container(
                        width: 76,
                        margin: const EdgeInsets.only(right: 14),
                        child: Column(
                          children: [
                            NonImagePlaceholder(
                              type: PlaceholderType.cast,
                              label: 'Cast',
                              width: 60,
                              height: 60,
                              isCircle: true,
                              accentColor: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              actor,
                              textAlign: TextAlign.center,
                              style: AppTypography.labelSmall.copyWith(fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerView(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 40),
            ShimmerBlock(width: double.infinity, height: 260, borderRadius: 16),
            SizedBox(height: 20),
            ShimmerBlock(width: 220, height: 28),
            SizedBox(height: 12),
            ShimmerBlock(width: 140, height: 20),
            SizedBox(height: 20),
            ShimmerBlock(width: double.infinity, height: 50, borderRadius: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const NonImagePlaceholder(
            type: PlaceholderType.generic,
            label: 'DETAIL ERROR',
            width: 80,
            height: 80,
            accentColor: AppColors.errorRed,
          ),
          const SizedBox(height: 16),
          Text(message, style: AppTypography.bodyLarge),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<MovieDetailBloc>().add(LoadMovieDetailRequested(widget.movieId));
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
