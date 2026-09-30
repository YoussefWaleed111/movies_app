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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(text: 'alex.johnson@cinemabloc.com');
  final TextEditingController _passwordController = TextEditingController(text: 'password123');

  void _onLogin() {
    context.read<AuthBloc>().add(AuthLoginRequested(
          email: _emailController.text,
          password: _passwordController.text,
        ));
    context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.mainShell));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Stylized Non-Image Abstract Wireframe Header Element
                  const Center(
                    child: NonImagePlaceholder(
                      type: PlaceholderType.logo,
                      label: 'AUTH APPARATUS',
                      width: 90,
                      height: 90,
                      borderRadius: 20,
                      accentColor: AppColors.primaryGold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Header Texts
                  Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: AppTypography.displayLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sign in to your BLoC movie universe',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 36),

                  // Email Input Field
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

                  // Password Input Field
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: AppTypography.bodyLarge,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryGold),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.forgetPassword));
                      },
                      child: Text(
                        'Forgot Password?',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.primaryGold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Yellow Login Button
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is Authenticated) {
                        context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.mainShell));
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: AppColors.primaryGold),
                        );
                      }
                      return ElevatedButton(
                        onPressed: _onLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGold,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Login', style: AppTypography.button),
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // Social Login Section with Non-Image Placeholder Icon
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.placeholderBorder)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text('OR SIGN IN WITH', style: AppTypography.labelSmall),
                      ),
                      const Expanded(child: Divider(color: AppColors.placeholderBorder)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Social Login Placeholder Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIconPlaceholder('G (Google)'),
                      const SizedBox(width: 16),
                      _buildSocialIconPlaceholder('Apple'),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // Register Link Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: AppTypography.bodyMedium),
                      GestureDetector(
                        onTap: () {
                          context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.register));
                        },
                        child: Text(
                          'Register Now',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.primaryGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIconPlaceholder(String label) {
    return Container(
      width: 120,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.placeholderBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.g_mobiledata_rounded, color: AppColors.textPrimary, size: 24),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
