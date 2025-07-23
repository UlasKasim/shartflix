import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/auth_entity.dart';
import '../entities/movie_entity.dart';

abstract class MovieRepository {
  Future<Either<Failure, MovieListEntity>> getMovies({
    required int page,
  });

  Future<Either<Failure, List<MovieEntity>>> getFavoriteMovies();

  Future<Either<Failure, bool>> toggleFavoriteMovie(String movieId);

  // Cache methods for offline support
  // Future<List<MovieEntity>?> getCachedMovies(int page);
  // Future<void> cacheMovies(List<MovieEntity> movies, int page);
}
