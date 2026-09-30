import 'package:equatable/equatable.dart';

enum AppViewRoute {
  splash,
  onboarding,
  login,
  register,
  forgetPassword,
  mainShell,
  movieDetail,
  updateProfile,
  chooseAvatar,
}

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();
  @override
  List<Object?> get props => [];
}

class NavigateToRoute extends NavigationEvent {
  final AppViewRoute route;
  final String? movieId;
  final int bottomNavIndex;

  const NavigateToRoute(
    this.route, {
    this.movieId,
    this.bottomNavIndex = 0,
  });

  @override
  List<Object?> get props => [route, movieId, bottomNavIndex];
}
