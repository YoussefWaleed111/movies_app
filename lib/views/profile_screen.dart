import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/common/non_image_placeholder.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.errorRed),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.login));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final userName = state is Authenticated ? state.user.name : 'Alex Johnson';
            final userEmail = state is Authenticated ? state.user.email : 'alex.johnson@cinemabloc.com';
            final wishlistCount = state is Authenticated ? state.user.wishlistCount : 12;
            final historyCount = state is Authenticated ? state.user.historyCount : 10;
            final avatarIdx = state is Authenticated ? state.user.avatarIndex : 0;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Central Avatar Placeholder (Non-Image, User Icon)
                  Center(
                    child: NonImagePlaceholder(
                      type: PlaceholderType.avatar,
                      label: 'AVATAR #${avatarIdx + 1}',
                      width: 100,
                      height: 100,
                      isCircle: true,
                      accentColor: AppColors.primaryGold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name & Email
                  Text(userName, style: AppTypography.displayMedium),
                  const SizedBox(height: 4),
                  Text(userEmail, style: AppTypography.bodyMedium),
                  const SizedBox(height: 24),

                  // Stats Row (12 Wishlist, 10 History)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.placeholderBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Wishlist', '$wishlistCount', Icons.bookmark_border_rounded),
                        Container(width: 1, height: 40, color: AppColors.placeholderBorder),
                        _buildStatItem('History', '$historyCount', Icons.history_rounded),
                        Container(width: 1, height: 40, color: AppColors.placeholderBorder),
                        _buildStatItem('Reviews', '4', Icons.rate_review_outlined),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Option for 'Edit Profile' and 'Update Data' as Distinct Colored Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.updateProfile));
                          },
                          icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.black),
                          label: const Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGold,
                            minimumSize: const Size.fromHeight(46),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.chooseAvatar));
                          },
                          icon: const Icon(Icons.grid_view_rounded, size: 18, color: Colors.white),
                          label: const Text('Choose Avatar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.cardBackgroundLight,
                            minimumSize: const Size.fromHeight(46),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Option Lists (Watchlist, History, Security)
                  _buildOptionTile(
                    context,
                    title: 'My Watchlist Collection',
                    subtitle: '12 movies saved for later viewing',
                    icon: Icons.bookmark_rounded,
                    onTap: () {
                      context.read<NavigationBloc>().add(
                            const NavigateToRoute(AppViewRoute.mainShell, bottomNavIndex: 2),
                          );
                    },
                  ),
                  _buildOptionTile(
                    context,
                    title: 'Watch History',
                    subtitle: '10 movies recently streamed',
                    icon: Icons.history_rounded,
                    onTap: () {},
                  ),
                  _buildOptionTile(
                    context,
                    title: 'Avatar Selector Grid',
                    subtitle: 'Browse generic avatar icon placeholders',
                    icon: Icons.account_circle_outlined,
                    onTap: () {
                      context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.chooseAvatar));
                    },
                  ),
                  _buildOptionTile(
                    context,
                    title: 'Security & Password',
                    subtitle: 'Reset password & auth credentials',
                    icon: Icons.lock_outline_rounded,
                    onTap: () {
                      context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.forgetPassword));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryGold, size: 22),
        const SizedBox(height: 6),
        Text(value, style: AppTypography.titleLarge),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.placeholderBorder),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: AppColors.primaryGold),
          title: Text(title, style: AppTypography.titleMedium),
          subtitle: Text(subtitle, style: AppTypography.bodyMedium),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
