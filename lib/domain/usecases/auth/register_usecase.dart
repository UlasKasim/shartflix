import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../../entities/auth_entity.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class RegisterUseCase implements UseCase<AuthEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(RegisterParams params) async {
    // Input validation
    if (!_isValidEmail(params.email)) {
      return const Left(
          ValidationFailure(message: 'Please enter a valid email address'));
    }

    if (params.name.trim().length < 2) {
      return const Left(
          ValidationFailure(message: 'Name must be at least 2 characters'));
    }

    if (params.password.length < 6) {
      return const Left(
          ValidationFailure(message: 'Password must be at least 6 characters'));
    }

    // if (!_isStrongPassword(params.password)) {
    //   return const Left(ValidationFailure(
    //     message: 'Password must contain at least one letter and one number',
    //   ));
    // }

    return await repository.register(
      email: params.email.trim().toLowerCase(),
      name: params.name.trim(),
      password: params.password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // bool _isStrongPassword(String password) {
  //   // At least one letter and one number
  //   return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password);
  // }
}

class RegisterParams extends Equatable {
  final String email;
  final String name;
  final String password;

  const RegisterParams({
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  List<Object> get props => [email, name, password];
}
