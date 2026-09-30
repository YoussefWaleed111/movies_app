import 'package:equatable/equatable.dart';
import '../../models/genre.dart';
import '../../models/movie.dart';

abstract class BrowseState extends Equatable {
  const BrowseState();
  @override
  List<Object?> get props => [];
}

class BrowseInitial extends BrowseState {}

class BrowseLoading extends BrowseState {}

class BrowseLoaded extends BrowseState {
  final List<Genre> genres;
  final String selectedGenreId;
  final List<Movie> movies;

  const BrowseLoaded({
    required this.genres,
    required this.selectedGenreId,
    required this.movies,
  });

  @override
  List<Object?> get props => [genres, selectedGenreId, movies];
}

class BrowseError extends BrowseState {
  final String message;
  const BrowseError(this.message);
  @override
  List<Object?> get props => [message];
}
