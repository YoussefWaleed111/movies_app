import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/repositories/movie_repository.dart';
import 'package:movies_app/repositories/auth_repository.dart';

void main() {
  group('Repository & BLoC Data Verification', () {
    final movieRepository = MovieRepository();
    final authRepository = AuthRepository();

    test('MovieRepository fetches popular and recommended movies', () async {
      final popular = await movieRepository.getPopularMovies();
      final recommended = await movieRepository.getRecommendedMovies();
      final doctorStrange = await movieRepository.getMovieDetails('m1');

      expect(popular.isNotEmpty, isTrue);
      expect(recommended.isNotEmpty, isTrue);
      expect(doctorStrange.title, contains('Doctor Strange'));
      expect(doctorStrange.themeVibe, equals('doctor_strange'));
    });

    test('AuthRepository manages user state correctly', () async {
      final user = await authRepository.getCurrentUser();
      expect(user, isNotNull);
      expect(user!.email, contains('alex.johnson'));

      final updated = await authRepository.updateUserProfile('Alex Smith', '+1 555-9999', 2);
      expect(updated.name, equals('Alex Smith'));
      expect(updated.avatarIndex, equals(2));
    });
  });
}
