import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:shartflix/core/error/error.dart';
import 'package:shartflix/domain/entities/entities.dart';
import 'package:shartflix/domain/repositories/repositories.dart';
import 'package:shartflix/domain/usecases/usecases.dart';

class LoginUseCase implements UseCase<AuthEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(LoginParams params) async {
    // Input validation
    if (!_isValidEmail(params.email)) {
      return const Left(
          ValidationFailure(message: 'Please enter a valid email address'));
    }

    if (params.password.length < 6) {
      return const Left(
          ValidationFailure(message: 'Password must be at least 6 characters'));
    }

    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
