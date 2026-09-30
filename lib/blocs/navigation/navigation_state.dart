import 'package:equatable/equatable.dart';
import 'navigation_event.dart';

class NavigationState extends Equatable {
  final AppViewRoute currentRoute;
  final String? activeMovieId;
  final int bottomNavIndex;

  const NavigationState({
    required this.currentRoute,
    this.activeMovieId,
    this.bottomNavIndex = 0,
  });

  NavigationState copyWith({
    AppViewRoute? currentRoute,
    String? activeMovieId,
    int? bottomNavIndex,
  }) {
    return NavigationState(
      currentRoute: currentRoute ?? this.currentRoute,
      activeMovieId: activeMovieId ?? this.activeMovieId,
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
    );
  }

  @override
  List<Object?> get props => [currentRoute, activeMovieId, bottomNavIndex];
}
