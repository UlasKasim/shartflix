import 'package:dartz/dartz.dart';
import 'package:shartflix/core/error/error.dart';
import 'package:shartflix/domain/entities/entities.dart';
import 'package:shartflix/domain/repositories/repositories.dart';
import 'package:shartflix/domain/usecases/usecases.dart';

class GetUserProfileUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}
