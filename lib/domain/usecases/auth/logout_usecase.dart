import 'package:dartz/dartz.dart';

import 'package:shartflix/core/error/error.dart';
import 'package:shartflix/domain/repositories/repositories.dart';
import 'package:shartflix/domain/usecases/usecases.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
