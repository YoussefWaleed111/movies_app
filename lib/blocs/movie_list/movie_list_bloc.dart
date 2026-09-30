import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/movie_repository.dart';
import 'movie_list_event.dart';
import 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieRepository movieRepository;

  MovieListBloc({required this.movieRepository}) : super(MovieListInitial()) {
    on<LoadMoviesRequested>(_onLoadMovies);
    on<SimulateMovieLoadingRequested>((event, emit) => emit(MovieListLoading()));
    on<SimulateMovieErrorRequested>((event, emit) => emit(const MovieListError('Network timeout: Unable to fetch movie feed from BLoC server.')));
    on<SimulateMovieEmptyRequested>((event, emit) => emit(MovieListEmpty()));
  }

  Future<void> _onLoadMovies(LoadMoviesRequested event, Emitter<MovieListState> emit) async {
    emit(MovieListLoading());
    try {
      final popular = await movieRepository.getPopularMovies();
      final recommended = await movieRepository.getRecommendedMovies();
      final heroMovie = await movieRepository.getMovieDetails('m1');

      emit(MovieListLoaded(
        watchNowHero: heroMovie,
        popularMovies: popular,
        recommendedMovies: recommended,
      ));
    } catch (e) {
      emit(MovieListError(e.toString()));
    }
  }
}
