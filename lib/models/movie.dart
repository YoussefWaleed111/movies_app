import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String id;
  final String title;
  final String rating;
  final String releaseYear;
  final String duration;
  final List<String> genres;
  final String synopsis;
  final String themeVibe; // e.g. 'doctor_strange', 'default'
  final List<String> castList;
  final int screenshotsCount;
  final bool isWatchlist;

  const Movie({
    required this.id,
    required this.title,
    required this.rating,
    required this.releaseYear,
    required this.duration,
    required this.genres,
    required this.synopsis,
    this.themeVibe = 'default',
    required this.castList,
    this.screenshotsCount = 4,
    this.isWatchlist = false,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? rating,
    String? releaseYear,
    String? duration,
    List<String>? genres,
    String? synopsis,
    String? themeVibe,
    List<String>? castList,
    int? screenshotsCount,
    bool? isWatchlist,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      rating: rating ?? this.rating,
      releaseYear: releaseYear ?? this.releaseYear,
      duration: duration ?? this.duration,
      genres: genres ?? this.genres,
      synopsis: synopsis ?? this.synopsis,
      themeVibe: themeVibe ?? this.themeVibe,
      castList: castList ?? this.castList,
      screenshotsCount: screenshotsCount ?? this.screenshotsCount,
      isWatchlist: isWatchlist ?? this.isWatchlist,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        rating,
        releaseYear,
        duration,
        genres,
        synopsis,
        themeVibe,
        castList,
        screenshotsCount,
        isWatchlist,
      ];
}
