import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/common/non_image_placeholder.dart';
import '../widgets/common/responsive_layout.dart';
import '../widgets/common/shimmer_loading.dart';
import '../blocs/browse/browse_bloc.dart';
import '../blocs/browse/browse_event.dart';
import '../blocs/browse/browse_state.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BrowseBloc>().add(BrowseInitRequested());
  }

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveLayout.getGridColumnCount(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Browse Categories'),
      ),
      body: SafeArea(
        child: BlocBuilder<BrowseBloc, BrowseState>(
          builder: (context, state) {
            if (state is BrowseLoading) {
              return ShimmerLoading(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: 6,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemBuilder: (_, __) => const ShimmerBlock(width: double.infinity, height: double.infinity),
                  ),
                ),
              );
            }
            if (state is BrowseError) {
              return Center(
                child: Text(state.message, style: AppTypography.bodyLarge),
              );
            }
            if (state is BrowseLoaded) {
              return Column(
                children: [
                  // Tab-Based Genre Selection Chips
                  Container(
                    height: 54,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.genres.length,
                      itemBuilder: (context, index) {
                        final genre = state.genres[index];
                        final isSelected = genre.id == state.selectedGenreId;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(genre.name),
                            selected: isSelected,
                            selectedColor: AppColors.primaryGold,
                            backgroundColor: AppColors.cardBackground,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (_) {
                              context.read<BrowseBloc>().add(SelectGenreRequested(genre.id));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Responsive GridView of Non-Image Poster Placeholders
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        itemCount: state.movies.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemBuilder: (context, index) {
                          final movie = state.movies[index];
                          return GestureDetector(
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
                                    label: 'Browse Poster: ${movie.title.split(" ").first}',
                                    borderRadius: 12,
                                    accentColor: AppColors.primaryGold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  movie.title,
                                  style: AppTypography.titleMedium.copyWith(fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${movie.rating} ★ • ${movie.genres.first}',
                                  style: AppTypography.labelSmall,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
