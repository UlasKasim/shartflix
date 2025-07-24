import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:shartflix/core/error/error.dart';
import 'package:shartflix/domain/entities/entities.dart';
import 'package:shartflix/domain/repositories/repositories.dart';
import 'package:shartflix/domain/usecases/usecases.dart';

class GetMoviesUseCase implements UseCase<MovieListEntity, GetMoviesParams> {
  final MovieRepository repository;

  GetMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, MovieListEntity>> call(GetMoviesParams params) async {
    // Validate page number
    if (params.page < 1) {
      return const Left(
          ValidationFailure(message: 'Page number must be greater than 0'));
    }

    // Fetch from network
    final result = await repository.getMovies(page: params.page);

    return result;
  }
}

class GetMoviesParams extends Equatable {
  final int page;
  final bool enableCache;

  const GetMoviesParams({
    required this.page,
    this.enableCache = true,
  });

  @override
  List<Object> get props => [page, enableCache];
}
