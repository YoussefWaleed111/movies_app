import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/common/non_image_placeholder.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _onRegister() {
    context.read<AuthBloc>().add(AuthRegisterRequested(
          name: _nameController.text.isEmpty ? 'New User' : _nameController.text,
          email: _emailController.text.isEmpty ? 'user@domain.com' : _emailController.text,
          password: _passwordController.text,
          phone: _phoneController.text,
        ));
    context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.mainShell));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.login));
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Clean Avatar Placeholder (Grey Circle with User Icon)
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const NonImagePlaceholder(
                        type: PlaceholderType.avatar,
                        label: 'Avatar',
                        width: 96,
                        height: 96,
                        isCircle: true,
                        accentColor: AppColors.primaryGold,
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_outlined, size: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Form Fields
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
                  controller: _emailController,
                  style: AppTypography.bodyLarge,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryGold),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: AppTypography.bodyLarge,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.primaryGold),
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
                const SizedBox(height: 32),

                // Large Yellow 'Create Account' Button
                ElevatedButton(
                  onPressed: _onRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGold,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Create Account', style: AppTypography.button),
                ),
                const SizedBox(height: 20),

                // Back to Login Link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.login));
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        style: AppTypography.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.primaryGold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
