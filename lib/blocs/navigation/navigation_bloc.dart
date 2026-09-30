import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc()
      : super(const NavigationState(currentRoute: AppViewRoute.splash)) {
    on<NavigateToRoute>((event, emit) {
      emit(NavigationState(
        currentRoute: event.route,
        activeMovieId: event.movieId,
        bottomNavIndex: event.bottomNavIndex,
      ));
    });
  }
}
