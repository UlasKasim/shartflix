import 'package:dartz/dartz.dart';

import 'package:shartflix/core/error/error.dart';
import 'package:shartflix/domain/entities/entities.dart';

abstract class MovieRepository {
  Future<Either<Failure, MovieListEntity>> getMovies({
    required int page,
  });

  Future<Either<Failure, List<MovieEntity>>> getFavoriteMovies();

  Future<Either<Failure, bool>> toggleFavoriteMovie(String movieId);
}
