import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/movie_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MovieRepository movieRepository;

  SearchBloc({required this.movieRepository}) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SimulateSearchLoadingRequested>((event, emit) => emit(SearchLoading()));
    on<SimulateSearchEmptyRequested>((event, emit) => emit(const SearchEmpty('Unknown Movie Title')));
    on<SimulateSearchErrorRequested>((event, emit) => emit(const SearchError('Search service currently unreachable.')));
  }

  Future<void> _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final results = await movieRepository.searchMovies(query);
      if (results.isEmpty) {
        emit(SearchEmpty(query));
      } else {
        emit(SearchLoaded(query: query, results: results));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
