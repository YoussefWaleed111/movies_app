import '../models/movie.dart';
import '../models/genre.dart';

class MovieRepository {
  // Mock data tailored for the UI design requirement
  final Movie _doctorStrange = const Movie(
    id: 'm1',
    title: 'Doctor Strange in the Multiverse of Madness',
    rating: '4.8',
    releaseYear: '2022',
    duration: '2h 6m',
    genres: ['Action', 'Adventure', 'Fantasy', 'Sci-Fi'],
    synopsis:
        'Dr. Stephen Strange casts a forbidden spell that opens the doorway to the multiverse, including alternate versions of himself, whose threat to humanity is too great for the combined forces of Strange, Wong, and Wanda Maximoff.',
    themeVibe: 'doctor_strange',
    castList: ['Benedict C.', 'Elizabeth O.', 'Chiwetel E.', 'Benedict W.', 'Xochitl G.'],
    screenshotsCount: 5,
    isWatchlist: true,
  );

  final List<Movie> _popularMovies = const [
    Movie(
      id: 'm1',
      title: 'Doctor Strange',
      rating: '4.8',
      releaseYear: '2022',
      duration: '2h 6m',
      genres: ['Action', 'Fantasy'],
      synopsis: 'Multiverse exploration and mystical arts.',
      themeVibe: 'doctor_strange',
      castList: ['Benedict C.', 'Elizabeth O.'],
    ),
    Movie(
      id: 'm2',
      title: 'Cyberpunk Odyssey',
      rating: '4.6',
      releaseYear: '2024',
      duration: '1h 58m',
      genres: ['Sci-Fi', 'Action'],
      synopsis: 'A futuristic thriller in Neo-Tokyo.',
      castList: ['Actor A', 'Actor B'],
    ),
    Movie(
      id: 'm3',
      title: 'Shadow Realm',
      rating: '4.5',
      releaseYear: '2023',
      duration: '2h 15m',
      genres: ['Horror', 'Mystery'],
      synopsis: 'Uncovering dark realm secrets.',
      castList: ['Actor C', 'Actor D'],
    ),
    Movie(
      id: 'm4',
      title: 'Galactic Horizon',
      rating: '4.9',
      releaseYear: '2024',
      duration: '2h 40m',
      genres: ['Sci-Fi', 'Adventure'],
      synopsis: 'Journey to the edge of the galaxy.',
      castList: ['Actor E', 'Actor F'],
    ),
  ];

  final List<Movie> _recommendedMovies = const [
    Movie(
      id: 'm5',
      title: 'Starlight Eclipse',
      rating: '4.7',
      releaseYear: '2023',
      duration: '1h 50m',
      genres: ['Drama', 'Sci-Fi'],
      synopsis: 'A cosmic romance during a solar event.',
      castList: ['Actor G', 'Actor H'],
    ),
    Movie(
      id: 'm6',
      title: 'Neon Detective',
      rating: '4.4',
      releaseYear: '2024',
      duration: '2h 05m',
      genres: ['Crime', 'Thriller'],
      synopsis: 'Solving high-tech crimes in the undercity.',
      castList: ['Actor I', 'Actor J'],
    ),
    Movie(
      id: 'm7',
      title: 'Ancient Legends',
      rating: '4.6',
      releaseYear: '2022',
      duration: '2h 30m',
      genres: ['Fantasy', 'Action'],
      synopsis: 'Warriors fight for the golden throne.',
      castList: ['Actor K', 'Actor L'],
    ),
  ];

  final List<Genre> _genres = const [
    Genre(id: 'all', name: 'All'),
    Genre(id: 'action', name: 'Action'),
    Genre(id: 'scifi', name: 'Sci-Fi'),
    Genre(id: 'fantasy', name: 'Fantasy'),
    Genre(id: 'drama', name: 'Drama'),
    Genre(id: 'horror', name: 'Horror'),
    Genre(id: 'comedy', name: 'Comedy'),
    Genre(id: 'thriller', name: 'Thriller'),
  ];

  Future<List<Movie>> getPopularMovies() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _popularMovies;
  }

  Future<List<Movie>> getRecommendedMovies() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _recommendedMovies;
  }

  Future<Movie> getMovieDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (id == 'm1') return _doctorStrange;
    final all = [..._popularMovies, ..._recommendedMovies];
    return all.firstWhere((m) => m.id == id, orElse: () => _doctorStrange);
  }

  Future<List<Genre>> getGenres() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _genres;
  }

  Future<List<Movie>> getMoviesByGenre(String genreId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (genreId == 'all') return [..._popularMovies, ..._recommendedMovies];
    return [..._popularMovies, ..._recommendedMovies].where((m) {
      return m.genres.any((g) => g.toLowerCase() == genreId.toLowerCase());
    }).toList();
  }

  Future<List<Movie>> searchMovies(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (query.trim().isEmpty) return [];
    if (query.toLowerCase() == 'empty' || query.toLowerCase() == 'no results') {
      return [];
    }
    return [..._popularMovies, ..._recommendedMovies].where((m) {
      return m.title.toLowerCase().contains(query.toLowerCase()) ||
          m.genres.any((g) => g.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }
}
