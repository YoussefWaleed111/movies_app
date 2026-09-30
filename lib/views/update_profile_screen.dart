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

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    final name = authState is Authenticated ? authState.user.name : 'Alex Johnson';
    final phone = authState is Authenticated ? authState.user.phone : '+1 (555) 234-5678';
    _nameController = TextEditingController(text: name);
    _phoneController = TextEditingController(text: phone);
  }

  void _onSaveProfile() {
    final authState = context.read<AuthBloc>().state;
    final avatarIndex = authState is Authenticated ? authState.user.avatarIndex : 0;

    context.read<AuthBloc>().add(AuthUpdateProfileRequested(
          name: _nameController.text,
          phone: _phoneController.text,
          avatarIndex: avatarIndex,
        ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully via BLoC!'),
        backgroundColor: AppColors.successGreen,
      ),
    );

    context.read<NavigationBloc>().add(
          const NavigateToRoute(AppViewRoute.mainShell, bottomNavIndex: 3),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Update Profile Data'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            context.read<NavigationBloc>().add(
                  const NavigateToRoute(AppViewRoute.mainShell, bottomNavIndex: 3),
                );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar Placeholder with Camera/Edit Overlay Icon
              Center(
                child: GestureDetector(
                  onTap: () {
                    context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.chooseAvatar));
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const NonImagePlaceholder(
                        type: PlaceholderType.avatar,
                        label: 'EDIT AVATAR',
                        width: 104,
                        height: 104,
                        isCircle: true,
                        accentColor: AppColors.primaryGold,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded, size: 18, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap image to choose generic avatar placeholder',
                textAlign: TextAlign.center,
                style: AppTypography.labelSmall,
              ),
              const SizedBox(height: 32),

              // Text Input Fields (Name, Phone)
              TextField(
                controller: _nameController,
                style: AppTypography.bodyLarge,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.primaryGold),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _phoneController,
                style: AppTypography.bodyLarge,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primaryGold),
                ),
              ),
              const SizedBox(height: 24),

              // Option for 'Reset Password' Field / Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.placeholderBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Password & Auth', style: AppTypography.titleMedium),
                        const SizedBox(height: 2),
                        Text('Want to change your credentials?', style: AppTypography.bodyMedium),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.forgetPassword));
                      },
                      child: Text(
                        'Reset Password',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.primaryGold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Final Prominent Colored Buttons
              ElevatedButton(
                onPressed: _onSaveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Update Profile Data', style: AppTypography.button),
              ),
              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () {
                  context.read<NavigationBloc>().add(
                        const NavigateToRoute(AppViewRoute.mainShell, bottomNavIndex: 3),
                      );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: AppColors.placeholderBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Cancel', style: AppTypography.bodyLarge.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
