import 'package:equatable/equatable.dart';
import '../../models/movie.dart';

abstract class MovieListState extends Equatable {
  const MovieListState();
  @override
  List<Object?> get props => [];
}

class MovieListInitial extends MovieListState {}

class MovieListLoading extends MovieListState {}

class MovieListLoaded extends MovieListState {
  final Movie watchNowHero;
  final List<Movie> popularMovies;
  final List<Movie> recommendedMovies;

  const MovieListLoaded({
    required this.watchNowHero,
    required this.popularMovies,
    required this.recommendedMovies,
  });

  @override
  List<Object?> get props => [watchNowHero, popularMovies, recommendedMovies];
}

class MovieListEmpty extends MovieListState {}

class MovieListError extends MovieListState {
  final String message;
  const MovieListError(this.message);
  @override
  List<Object?> get props => [message];
}
