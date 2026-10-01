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

class ChooseAvatarScreen extends StatefulWidget {
  const ChooseAvatarScreen({super.key});

  @override
  State<ChooseAvatarScreen> createState() => _ChooseAvatarScreenState();
}

class _ChooseAvatarScreenState extends State<ChooseAvatarScreen> {
  int _selectedAvatarIndex = 0;

  final List<IconData> _avatarIcons = const [
    Icons.account_circle_rounded,
    Icons.face_rounded,
    Icons.person_pin_rounded,
    Icons.theater_comedy_rounded,
    Icons.emoji_emotions_rounded,
    Icons.smart_toy_rounded,
    Icons.star_border_purple500_rounded,
    Icons.videocam_rounded,
    Icons.movie_rounded,
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      _selectedAvatarIndex = state.user.avatarIndex;
    }
  }

  void _onSaveAvatar() {
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      context.read<AuthBloc>().add(AuthUpdateProfileRequested(
            name: state.user.name,
            phone: state.user.phone,
            avatarIndex: _selectedAvatarIndex,
          ));
    }
    context.read<NavigationBloc>().add(
          const NavigateToRoute(AppViewRoute.updateProfile),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Choose Generic Avatar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            context.read<NavigationBloc>().add(
                  const NavigateToRoute(AppViewRoute.updateProfile),
                );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'GENERIC AVATAR PLACEHOLDERS',
                style: AppTypography.labelSmall.copyWith(color: AppColors.primaryGold),
              ),
              const SizedBox(height: 6),
              Text(
                'Select a non-image avatar tile for your profile wireframe.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),

              // GridView (Multiple small circles filled with different generic avatar placeholders)
              Expanded(
                child: GridView.builder(
                  itemCount: _avatarIcons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedAvatarIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedAvatarIndex = index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.primaryGold : AppColors.placeholderBorder,
                            width: isSelected ? 3 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryGold.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ]
                              : null,
                        ),
                        child: NonImagePlaceholder(
                          type: PlaceholderType.avatar,
                          customIcon: _avatarIcons[index],
                          label: 'Icon #${index + 1}',
                          isCircle: true,
                          backgroundColor: isSelected ? AppColors.cardBackgroundLight : AppColors.placeholderDark,
                          accentColor: isSelected ? AppColors.primaryGold : AppColors.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onSaveAvatar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Confirm Avatar Selection', style: AppTypography.button),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
