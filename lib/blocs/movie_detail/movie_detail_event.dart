import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadMovieDetailRequested extends MovieDetailEvent {
  final String movieId;
  const LoadMovieDetailRequested(this.movieId);
  @override
  List<Object?> get props => [movieId];
}

class ToggleWatchlistRequested extends MovieDetailEvent {}

class SimulateMovieDetailLoadingRequested extends MovieDetailEvent {}

class SimulateMovieDetailErrorRequested extends MovieDetailEvent {}
