import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/auth_entity.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthEntity>> register({
    required String email,
    required String name,
    required String password,
  });

  Future<Either<Failure, UserEntity>> getUserProfile();

  Future<Either<Failure, String>> uploadPhoto(String filePath);

  Future<Either<Failure, void>> logout();
}
