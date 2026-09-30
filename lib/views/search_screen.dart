import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/common/non_image_placeholder.dart';
import '../widgets/common/responsive_layout.dart';
import '../widgets/common/shimmer_loading.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_event.dart';
import '../blocs/search/search_state.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveLayout.getGridColumnCount(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Full-Width Search Bar with Search Icon
              TextField(
                controller: _searchController,
                style: AppTypography.bodyLarge,
                onChanged: (query) {
                  context.read<SearchBloc>().add(SearchQueryChanged(query));
                },
                decoration: InputDecoration(
                  hintText: 'Search movies, genres, or cast...',
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryGold),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary),
                          onPressed: () {
                            _searchController.clear();
                            context.read<SearchBloc>().add(const SearchQueryChanged(''));
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // BLoC Result State View
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return _buildShimmerGrid(columns);
                    }
                    if (state is SearchEmpty) {
                      return _buildEmptyResultsView(state.query);
                    }
                    if (state is SearchError) {
                      return _buildErrorView(state.message);
                    }
                    if (state is SearchLoaded) {
                      return GridView.builder(
                        itemCount: state.results.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemBuilder: (context, index) {
                          final movie = state.results[index];
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
                                    label: 'Search Result: ${movie.title.split(" ").first}',
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
                                  '${movie.rating} ★ • ${movie.releaseYear}',
                                  style: AppTypography.labelSmall,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    // Initial prompt state
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const NonImagePlaceholder(
                            type: PlaceholderType.generic,
                            label: 'SEARCH SYSTEM',
                            width: 100,
                            height: 100,
                            accentColor: AppColors.primaryGold,
                          ),
                          const SizedBox(height: 16),
                          Text('Type to Search Movies', style: AppTypography.titleLarge),
                          const SizedBox(height: 6),
                          Text(
                            'Try typing "Doctor", "Sci-Fi", or "Empty" to test states.',
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyResultsView(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large Icon Placeholder for Empty State
            const NonImagePlaceholder(
              type: PlaceholderType.generic,
              label: 'NO RESULTS FOUND',
              customIcon: Icons.search_off_rounded,
              width: 120,
              height: 120,
              borderRadius: 24,
              accentColor: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text('No Results Found', style: AppTypography.displayMedium),
            const SizedBox(height: 8),
            Text(
              'We could not find any titles matching "$query".\nPlease check your spelling or search another movie.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid(int columns) {
    return ShimmerLoading(
      child: GridView.builder(
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          childAspectRatio: 0.65,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, index) {
          return const ShimmerBlock(width: double.infinity, height: double.infinity, borderRadius: 12);
        },
      ),
    );
  }

  Widget _buildErrorView(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.errorRed),
          const SizedBox(height: 12),
          Text(msg, style: AppTypography.bodyLarge),
        ],
      ),
    );
  }
}
