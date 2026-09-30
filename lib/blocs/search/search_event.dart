import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class SimulateSearchLoadingRequested extends SearchEvent {}

class SimulateSearchEmptyRequested extends SearchEvent {}

class SimulateSearchErrorRequested extends SearchEvent {}
