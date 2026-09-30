import 'package:equatable/equatable.dart';

abstract class BrowseEvent extends Equatable {
  const BrowseEvent();
  @override
  List<Object?> get props => [];
}

class BrowseInitRequested extends BrowseEvent {}

class SelectGenreRequested extends BrowseEvent {
  final String genreId;
  const SelectGenreRequested(this.genreId);
  @override
  List<Object?> get props => [genreId];
}

class SimulateBrowseLoadingRequested extends BrowseEvent {}

class SimulateBrowseErrorRequested extends BrowseEvent {}
