import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/movie_entity.dart';
import '../../repositories/movie_repository.dart';
import '../usecase.dart';

class GetFavoriteMoviesUseCase implements UseCase<List<MovieEntity>, NoParams> {
  final MovieRepository repository;

  GetFavoriteMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(NoParams params) async {
    return await repository.getFavoriteMovies();
  }
}
