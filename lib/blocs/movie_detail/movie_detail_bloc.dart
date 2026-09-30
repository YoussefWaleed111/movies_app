import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/movie_repository.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final MovieRepository movieRepository;

  MovieDetailBloc({required this.movieRepository}) : super(MovieDetailInitial()) {
    on<LoadMovieDetailRequested>(_onLoadDetail);
    on<ToggleWatchlistRequested>(_onToggleWatchlist);
    on<SimulateMovieDetailLoadingRequested>((event, emit) => emit(MovieDetailLoading()));
    on<SimulateMovieDetailErrorRequested>((event, emit) => emit(const MovieDetailError('Failed to load movie details. Please check connection.')));
  }

  Future<void> _onLoadDetail(LoadMovieDetailRequested event, Emitter<MovieDetailState> emit) async {
    emit(MovieDetailLoading());
    try {
      final movie = await movieRepository.getMovieDetails(event.movieId);
      emit(MovieDetailLoaded(movie: movie, isInWatchlist: movie.isWatchlist));
    } catch (e) {
      emit(MovieDetailError(e.toString()));
    }
  }

  void _onToggleWatchlist(ToggleWatchlistRequested event, Emitter<MovieDetailState> emit) {
    if (state is MovieDetailLoaded) {
      final current = state as MovieDetailLoaded;
      final updatedMovie = current.movie.copyWith(isWatchlist: !current.isInWatchlist);
      emit(MovieDetailLoaded(
        movie: updatedMovie,
        isInWatchlist: !current.isInWatchlist,
      ));
    }
  }
}
