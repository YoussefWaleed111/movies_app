import 'package:equatable/equatable.dart';

abstract class MovieListEvent extends Equatable {
  const MovieListEvent();
  @override
  List<Object?> get props => [];
}

class LoadMoviesRequested extends MovieListEvent {}

class SimulateMovieLoadingRequested extends MovieListEvent {}

class SimulateMovieErrorRequested extends MovieListEvent {}

class SimulateMovieEmptyRequested extends MovieListEvent {}
