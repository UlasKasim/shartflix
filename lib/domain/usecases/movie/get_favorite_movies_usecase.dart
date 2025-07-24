import 'package:dartz/dartz.dart';

import 'package:shartflix/core/error/error.dart';
import 'package:shartflix/domain/entities/entities.dart';
import 'package:shartflix/domain/repositories/repositories.dart';
import 'package:shartflix/domain/usecases/usecases.dart';

class GetFavoriteMoviesUseCase implements UseCase<List<MovieEntity>, NoParams> {
  final MovieRepository repository;

  GetFavoriteMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(NoParams params) async {
    return await repository.getFavoriteMovies();
  }
}
