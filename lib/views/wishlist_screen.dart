import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/common/non_image_placeholder.dart';
import '../widgets/common/responsive_layout.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveLayout.getGridColumnCount(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Wishlist'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SAVED MOVIES (12)', style: AppTypography.titleLarge),
              const SizedBox(height: 14),
              Expanded(
                child: GridView.builder(
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.read<NavigationBloc>().add(
                              const NavigateToRoute(AppViewRoute.movieDetail, movieId: 'm1'),
                            );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: NonImagePlaceholder(
                              type: PlaceholderType.poster,
                              label: index == 0 ? 'DOCTOR STRANGE' : 'SAVED POSTER #${index + 1}',
                              borderRadius: 12,
                              accentColor: AppColors.accentRed,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            index == 0 ? 'Doctor Strange Multiverse' : 'Saved Movie Title #${index + 1}',
                            style: AppTypography.titleMedium.copyWith(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Saved in Wishlist',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.primaryGold),
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
}
