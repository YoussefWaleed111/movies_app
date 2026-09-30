import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../blocs/navigation/navigation_bloc.dart';
import '../../blocs/navigation/navigation_event.dart';
import '../../blocs/movie_list/movie_list_bloc.dart';
import '../../blocs/movie_list/movie_list_event.dart';
import '../../blocs/movie_detail/movie_detail_bloc.dart';
import '../../blocs/movie_detail/movie_detail_event.dart';
import '../../blocs/search/search_bloc.dart';
import '../../blocs/search/search_event.dart';
import '../../blocs/browse/browse_bloc.dart';
import '../../blocs/browse/browse_event.dart';

class BlocStateOverlay extends StatefulWidget {
  final Widget child;

  const BlocStateOverlay({super.key, required this.child});

  @override
  State<BlocStateOverlay> createState() => _BlocStateOverlayState();
}

enum DeviceSimMode { fluid, phonePortrait, phoneLandscape, tabletPortrait }

class _BlocStateOverlayState extends State<BlocStateOverlay> {
  bool _isPanelOpen = false;
  DeviceSimMode _simMode = DeviceSimMode.fluid;

  Size? _getSimulatedDimensions(DeviceSimMode mode) {
    switch (mode) {
      case DeviceSimMode.phonePortrait:
        return const Size(390, 844);
      case DeviceSimMode.phoneLandscape:
        return const Size(844, 390);
      case DeviceSimMode.tabletPortrait:
        return const Size(768, 1024);
      case DeviceSimMode.fluid:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final navState = context.watch<NavigationBloc>().state;
    final currentRoute = navState.currentRoute;
    final simSize = _getSimulatedDimensions(_simMode);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top Control Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.backgroundSecondary,
              border: Border(bottom: BorderSide(color: AppColors.placeholderBorder)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Icon(Icons.architecture_rounded, color: AppColors.primaryGold, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'BLoC State Inspector & Simulator',
                    style: AppTypography.titleMedium.copyWith(fontSize: 13, color: AppColors.primaryGold),
                  ),
                  const SizedBox(width: 16),
                  
                  // Device Viewport Selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.placeholderBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<DeviceSimMode>(
                        value: _simMode,
                        isDense: true,
                        dropdownColor: AppColors.cardBackground,
                        style: AppTypography.labelSmall.copyWith(color: Colors.white),
                        items: const [
                          DropdownMenuItem(
                            value: DeviceSimMode.fluid,
                            child: Text('Device: Fluid / Screen'),
                          ),
                          DropdownMenuItem(
                            value: DeviceSimMode.phonePortrait,
                            child: Text('Device: Phone Portrait (390x844)'),
                          ),
                          DropdownMenuItem(
                            value: DeviceSimMode.phoneLandscape,
                            child: Text('Device: Phone Landscape (844x390)'),
                          ),
                          DropdownMenuItem(
                            value: DeviceSimMode.tabletPortrait,
                            child: Text('Device: Tablet Portrait (768x1024)'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _simMode = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // BLoC State Controller Buttons for active route
                  _buildStateTriggerButtons(context, currentRoute),

                  const SizedBox(width: 12),
                  // Toggle Drawer Button
                  InkWell(
                    onTap: () => setState(() => _isPanelOpen = !_isPanelOpen),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _isPanelOpen ? AppColors.primaryGold : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            size: 16,
                            color: _isPanelOpen ? Colors.black : Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Nav Workflows',
                            style: AppTypography.labelSmall.copyWith(
                              color: _isPanelOpen ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Drawer Panel for Navigation Jumps
          if (_isPanelOpen) _buildNavigationJumpPanel(context),

          // Main Viewport Container
          Expanded(
            child: Container(
              color: const Color(0xFF0A0A0E),
              alignment: Alignment.center,
              child: simSize == null
                  ? widget.child
                  : Container(
                      width: simSize.width,
                      height: simSize.height,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primaryGold.withOpacity(0.5), width: 2),
                        boxShadow: const [
                          BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 4),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: widget.child,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateTriggerButtons(BuildContext context, AppViewRoute route) {
    return Wrap(
      spacing: 6,
      children: [
        _buildSmallBadge('State Triggers:'),
        _buildActionBtn('Shimmer Loading', () {
          if (route == AppViewRoute.mainShell) {
            context.read<MovieListBloc>().add(SimulateMovieLoadingRequested());
          } else if (route == AppViewRoute.movieDetail) {
            context.read<MovieDetailBloc>().add(SimulateMovieDetailLoadingRequested());
          } else if (route == AppViewRoute.mainShell) {
            context.read<SearchBloc>().add(SimulateSearchLoadingRequested());
          }
        }),
        _buildActionBtn('Data Loaded', () {
          context.read<MovieListBloc>().add(LoadMoviesRequested());
          context.read<MovieDetailBloc>().add(const LoadMovieDetailRequested('m1'));
          context.read<BrowseBloc>().add(BrowseInitRequested());
        }),
        _buildActionBtn('Empty State', () {
          context.read<MovieListBloc>().add(SimulateMovieEmptyRequested());
          context.read<SearchBloc>().add(SimulateSearchEmptyRequested());
        }),
        _buildActionBtn('Error State', () {
          context.read<MovieListBloc>().add(SimulateMovieErrorRequested());
          context.read<MovieDetailBloc>().add(SimulateMovieDetailErrorRequested());
          context.read<SearchBloc>().add(SimulateSearchErrorRequested());
          context.read<BrowseBloc>().add(SimulateBrowseErrorRequested());
        }),
      ],
    );
  }

  Widget _buildSmallBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Text(text, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
    );
  }

  Widget _buildActionBtn(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundLight,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.placeholderBorder),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: AppColors.primaryGold, fontSize: 11),
        ),
      ),
    );
  }

  Widget _buildNavigationJumpPanel(BuildContext context) {
    return Container(
      color: AppColors.backgroundSecondary,
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildNavChip(context, 'A1. Splash Screen', AppViewRoute.splash),
          _buildNavChip(context, 'A2. Onboarding Flow', AppViewRoute.onboarding),
          _buildNavChip(context, 'B1. Login Screen', AppViewRoute.login),
          _buildNavChip(context, 'B2. Register Screen', AppViewRoute.register),
          _buildNavChip(context, 'B3. Forget Password', AppViewRoute.forgetPassword),
          _buildNavChip(context, 'C1. Home Screen (Watch Now)', AppViewRoute.mainShell, navIndex: 0),
          _buildNavChip(context, 'C2. Doctor Strange Details', AppViewRoute.movieDetail, movieId: 'm1'),
          _buildNavChip(context, 'D1. Search Screen', AppViewRoute.mainShell, navIndex: 1),
          _buildNavChip(context, 'D2. Browse / Genres Grid', AppViewRoute.mainShell, navIndex: 2),
          _buildNavChip(context, 'D3. User Profile', AppViewRoute.mainShell, navIndex: 3),
          _buildNavChip(context, 'D4. Update Profile Form', AppViewRoute.updateProfile),
          _buildNavChip(context, 'D5. Choose Avatar Grid', AppViewRoute.chooseAvatar),
        ],
      ),
    );
  }

  Widget _buildNavChip(BuildContext context, String label, AppViewRoute route, {String? movieId, int navIndex = 0}) {
    return ActionChip(
      backgroundColor: AppColors.cardBackground,
      label: Text(label, style: AppTypography.labelSmall.copyWith(color: Colors.white)),
      onPressed: () {
        context.read<NavigationBloc>().add(NavigateToRoute(route, movieId: movieId, bottomNavIndex: navIndex));
      },
    );
  }
}
