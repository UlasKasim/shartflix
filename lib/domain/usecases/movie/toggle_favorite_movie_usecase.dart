import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:shartflix/core/error/error.dart';
import 'package:shartflix/domain/repositories/repositories.dart';
import 'package:shartflix/domain/usecases/usecases.dart';

class ToggleFavoriteMovieUseCase
    implements UseCase<bool, ToggleFavoriteParams> {
  final MovieRepository repository;

  ToggleFavoriteMovieUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ToggleFavoriteParams params) async {
    // Validate movie ID
    if (params.movieId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Movie ID cannot be empty'));
    }

    return await repository.toggleFavoriteMovie(params.movieId.trim());
  }
}

class ToggleFavoriteParams extends Equatable {
  final String movieId;

  const ToggleFavoriteParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
