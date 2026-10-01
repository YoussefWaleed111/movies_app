import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/repositories/movie_repository.dart';
import 'package:movies_app/repositories/auth_repository.dart';
import 'package:movies_app/blocs/navigation/navigation_bloc.dart';
import 'package:movies_app/blocs/navigation/navigation_event.dart';
import 'package:movies_app/views/splash_screen.dart';
import 'package:movies_app/views/onboarding_screen.dart';
import 'package:movies_app/widgets/auth/route_logo.dart';

void main() {
  group('Repository & BLoC Data Verification', () {
    final movieRepository = MovieRepository();
    final authRepository = AuthRepository();

    test('MovieRepository fetches popular and recommended movies', () async {
      final popular = await movieRepository.getPopularMovies();
      final recommended = await movieRepository.getRecommendedMovies();
      final doctorStrange = await movieRepository.getMovieDetails('m1');

      expect(popular.isNotEmpty, isTrue);
      expect(recommended.isNotEmpty, isTrue);
      expect(doctorStrange.title, contains('Doctor Strange'));
      expect(doctorStrange.themeVibe, equals('doctor_strange'));
    });

    test('AuthRepository temporary authentication and no auto-login verification', () async {
      // 1. Initial state: auto-login must be disabled (null)
      final initialUser = await authRepository.getCurrentUser();
      expect(initialUser, isNull);

      // 2. Login with wrong credentials fails
      expect(
        () async => await authRepository.login('wrong@example.com', 'badpass'),
        throwsA(isA<Exception>()),
      );

      // 3. Login with fixed temporary credentials succeeds
      final loggedInUser = await authRepository.login(
        AuthRepository.tempEmail,
        AuthRepository.tempPassword,
      );
      expect(loggedInUser.email, equals('test@example.com'));

      // 4. Session now has current user in memory
      final activeUser = await authRepository.getCurrentUser();
      expect(activeUser, isNotNull);
      expect(activeUser!.email, equals('test@example.com'));

      // 5. Update user profile
      final updated = await authRepository.updateUserProfile('Alex Smith', '+1 555-9999', 2);
      expect(updated.name, equals('Alex Smith'));
      expect(updated.avatarIndex, equals(2));

      // 6. Logout resets state to null
      await authRepository.logout();
      final loggedOutUser = await authRepository.getCurrentUser();
      expect(loggedOutUser, isNull);
    });
  });

  group('Figma Splash & Onboarding Flow Verification', () {
    testWidgets('SplashScreen renders RouteLogo, RouteScriptWordmark and supervisor credit', (tester) async {
      final navigationBloc = NavigationBloc();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<NavigationBloc>.value(
            value: navigationBloc,
            child: const SplashScreen(),
          ),
        ),
      );

      // Center logo and wordmarks
      expect(find.byType(RouteLogo), findsOneWidget);
      expect(find.byType(RouteScriptWordmark), findsOneWidget);
      expect(find.text('Supervised by Mohamed Nabil'), findsOneWidget);

      // Tap navigates to onboarding
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      expect(navigationBloc.state.currentRoute, equals(AppViewRoute.onboarding));
    });

    testWidgets('OnboardingScreen navigates across all 6 Figma screens properly', (tester) async {
      final navigationBloc = NavigationBloc();
      navigationBloc.add(const NavigateToRoute(AppViewRoute.onboarding));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<NavigationBloc>.value(
            value: navigationBloc,
            child: const OnboardingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Screen 1: Explore
      expect(find.text('Find Your Next Favorite Movie Here'), findsOneWidget);
      expect(find.text('Explore Now'), findsOneWidget);
      expect(find.text('Back'), findsNothing);

      // Advance to Screen 2: Discover
      await tester.tap(find.text('Explore Now'));
      await tester.pumpAndSettle();
      expect(find.text('Discover Movies'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Back'), findsNothing);

      // Advance to Screen 3: Genres
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Explore All Genres'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);

      // Go back to Screen 2
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Discover Movies'), findsOneWidget);

      // Go forward to Screen 3
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Explore All Genres'), findsOneWidget);

      // Advance to Screen 4: Watchlists
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Create Watchlists'), findsOneWidget);

      // Advance to Screen 5: Rate & Review
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Rate, Review, and Learn'), findsOneWidget);

      // Advance to Screen 6: Finish
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Start Watching Now'), findsOneWidget);
      expect(find.text('Finish'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);

      // Finish navigates to Login
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();
      expect(navigationBloc.state.currentRoute, equals(AppViewRoute.login));
    });
  });
}
