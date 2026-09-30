import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/movie_repository.dart';
import 'browse_event.dart';
import 'browse_state.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final MovieRepository movieRepository;

  BrowseBloc({required this.movieRepository}) : super(BrowseInitial()) {
    on<BrowseInitRequested>(_onInit);
    on<SelectGenreRequested>(_onSelectGenre);
    on<SimulateBrowseLoadingRequested>((event, emit) => emit(BrowseLoading()));
    on<SimulateBrowseErrorRequested>((event, emit) => emit(const BrowseError('Failed to load genres catalog.')));
  }

  Future<void> _onInit(BrowseInitRequested event, Emitter<BrowseState> emit) async {
    emit(BrowseLoading());
    try {
      final genres = await movieRepository.getGenres();
      final movies = await movieRepository.getMoviesByGenre('all');
      emit(BrowseLoaded(genres: genres, selectedGenreId: 'all', movies: movies));
    } catch (e) {
      emit(BrowseError(e.toString()));
    }
  }

  Future<void> _onSelectGenre(SelectGenreRequested event, Emitter<BrowseState> emit) async {
    if (state is BrowseLoaded) {
      final current = state as BrowseLoaded;
      emit(BrowseLoading());
      try {
        final movies = await movieRepository.getMoviesByGenre(event.genreId);
        emit(BrowseLoaded(
          genres: current.genres,
          selectedGenreId: event.genreId,
          movies: movies,
        ));
      } catch (e) {
        emit(BrowseError(e.toString()));
      }
    }
  }
}
