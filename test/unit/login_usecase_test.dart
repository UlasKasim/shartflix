import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:shartflix/core/error/failures.dart';
import 'package:shartflix/domain/entities/auth_entity.dart';
import 'package:shartflix/domain/entities/user_entity.dart';
import 'package:shartflix/domain/repositories/auth_repository.dart';
import 'package:shartflix/domain/usecases/auth/login_usecase.dart';

@GenerateMocks([AuthRepository])
import 'login_usecase_test.mocks.dart';

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = LoginUseCase(mockAuthRepository);
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testUser = UserEntity(
    id: '1',
    name: 'Test User',
    email: testEmail,
    photoUrl: null,
  );
  const testAuthEntity = AuthEntity(
    token: 'test_token',
    user: testUser,
  );

  group('LoginUseCase', () {
    test('should return AuthEntity when login is successful', () async {
      // arrange
      when(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => const Right(testAuthEntity));

      // act
      final result = await useCase(const LoginParams(
        email: testEmail,
        password: testPassword,
      ));

      // assert
      expect(result, const Right(testAuthEntity));
      verify(mockAuthRepository.login(
        email: testEmail,
        password: testPassword,
      ));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when email is invalid', () async {
      // act
      final result = await useCase(const LoginParams(
        email: 'invalid-email',
        password: testPassword,
      ));

      // assert
      expect(
          result,
          const Left(ValidationFailure(
            message: 'Please enter a valid email address',
          )));
      verifyZeroInteractions(mockAuthRepository);
    });

    test('should return ValidationFailure when password is too short',
        () async {
      // act
      final result = await useCase(const LoginParams(
        email: testEmail,
        password: '123',
      ));

      // assert
      expect(
          result,
          const Left(ValidationFailure(
            message: 'Password must be at least 6 characters',
          )));
      verifyZeroInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when login fails', () async {
      // arrange
      when(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => const Left(AuthFailure(
            message: 'Invalid credentials',
          )));

      // act
      final result = await useCase(const LoginParams(
        email: testEmail,
        password: testPassword,
      ));

      // assert
      expect(result, const Left(AuthFailure(message: 'Invalid credentials')));
    });
  });
}
