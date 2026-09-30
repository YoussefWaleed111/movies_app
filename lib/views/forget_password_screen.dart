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

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _onSendReset() {
    context.read<AuthBloc>().add(AuthPasswordResetRequested(email: _emailController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            context.read<NavigationBloc>().add(const NavigateToRoute(AppViewRoute.login));
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Central Non-Image Stylized Graphic (Lock Placeholder)
              const Center(
                child: NonImagePlaceholder(
                  type: PlaceholderType.lock,
                  label: 'LOCK GRAPHIC',
                  width: 100,
                  height: 100,
                  borderRadius: 24,
                  accentColor: AppColors.primaryGold,
                ),
              ),
              const SizedBox(height: 28),

              Text(
                'Forgot Your Password?',
                textAlign: TextAlign.center,
                style: AppTypography.displayMedium,
              ),
              const SizedBox(height: 8),

              Text(
                'Enter your registered email below to receive a password reset link.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Email Input Field
              TextField(
                controller: _emailController,
                style: AppTypography.bodyLarge,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Registered Email',
                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryGold),
                ),
              ),
              const SizedBox(height: 24),

              // BLoC State Reaction
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthPasswordResetSent) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password reset link sent to your email!'),
                        backgroundColor: AppColors.successGreen,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: _onSendReset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGold,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Send Email', style: AppTypography.button),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
