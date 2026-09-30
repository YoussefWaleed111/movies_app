import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Theme & Repositories
import 'theme/app_theme.dart';
import 'repositories/movie_repository.dart';
import 'repositories/auth_repository.dart';

// BLoCs
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/navigation/navigation_bloc.dart';
import 'blocs/navigation/navigation_event.dart';
import 'blocs/navigation/navigation_state.dart';
import 'blocs/movie_list/movie_list_bloc.dart';
import 'blocs/movie_list/movie_list_event.dart';
import 'blocs/movie_detail/movie_detail_bloc.dart';
import 'blocs/search/search_bloc.dart';
import 'blocs/browse/browse_bloc.dart';
import 'blocs/browse/browse_event.dart';

// Views
import 'views/splash_screen.dart';
import 'views/onboarding_screen.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/forget_password_screen.dart';
import 'views/main_shell.dart';
import 'views/movie_detail_screen.dart';
import 'views/update_profile_screen.dart';
import 'views/choose_avatar_screen.dart';

// Common
import 'widgets/common/bloc_state_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final movieRepository = MovieRepository();
  final authRepository = AuthRepository();

  runApp(MovieApp(
    movieRepository: movieRepository,
    authRepository: authRepository,
  ));
}

class MovieApp extends StatelessWidget {
  final MovieRepository movieRepository;
  final AuthRepository authRepository;

  const MovieApp({
    super.key,
    required this.movieRepository,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: movieRepository),
        RepositoryProvider.value(value: authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: authRepository)..add(AuthCheckRequested()),
          ),
          BlocProvider<NavigationBloc>(
            create: (context) => NavigationBloc(),
          ),
          BlocProvider<MovieListBloc>(
            create: (context) => MovieListBloc(movieRepository: movieRepository)..add(LoadMoviesRequested()),
          ),
          BlocProvider<MovieDetailBloc>(
            create: (context) => MovieDetailBloc(movieRepository: movieRepository),
          ),
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(movieRepository: movieRepository),
          ),
          BlocProvider<BrowseBloc>(
            create: (context) => BrowseBloc(movieRepository: movieRepository)..add(BrowseInitRequested()),
          ),
        ],
        child: MaterialApp(
          title: 'CineBloc Movie UI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: const AppViewRouter(),
        ),
      ),
    );
  }
}

class AppViewRouter extends StatelessWidget {
  const AppViewRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, navState) {
        Widget activeScreen;

        switch (navState.currentRoute) {
          case AppViewRoute.splash:
            activeScreen = const SplashScreen();
            break;
          case AppViewRoute.onboarding:
            activeScreen = const OnboardingScreen();
            break;
          case AppViewRoute.login:
            activeScreen = const LoginScreen();
            break;
          case AppViewRoute.register:
            activeScreen = const RegisterScreen();
            break;
          case AppViewRoute.forgetPassword:
            activeScreen = const ForgetPasswordScreen();
            break;
          case AppViewRoute.movieDetail:
            activeScreen = MovieDetailScreen(movieId: navState.activeMovieId ?? 'm1');
            break;
          case AppViewRoute.updateProfile:
            activeScreen = const UpdateProfileScreen();
            break;
          case AppViewRoute.chooseAvatar:
            activeScreen = const ChooseAvatarScreen();
            break;
          case AppViewRoute.mainShell:
            activeScreen = MainShellScreen(initialIndex: navState.bottomNavIndex);
            break;
        }

        return BlocStateOverlay(child: activeScreen);
      },
    );
  }
}
