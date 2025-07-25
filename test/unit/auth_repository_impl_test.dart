import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:shartflix/core/core.dart';
import 'package:shartflix/data/data.dart';
import 'package:shartflix/domain/domain.dart';

@GenerateMocks([AuthRemoteDataSource, AuthService])
import 'auth_repository_impl_test.mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthService mockAuthService;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockAuthService = MockAuthService();
    repository = AuthRepositoryImpl(mockRemoteDataSource, mockAuthService);
  });

  const testLoginResponse = LoginResponse(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    photoUrl: null,
    token: 'test_token',
  );

  const testUserData = {
    'id': '1',
    'name': 'Test User',
    'email': 'test@example.com',
    'photoUrl': null,
  };

  group('AuthRepositoryImpl', () {
    group('login', () {
      test('should return AuthEntity when login is successful', () async {
        // arrange
        // Mock'ları düzgün setup et
        when(mockRemoteDataSource.login(any))
            .thenAnswer((_) async => testLoginResponse);

        // Named parameters için specific matchers kullan
        when(mockAuthService.saveAuthData(
          accessToken: anyNamed('accessToken'),
          userData: anyNamed('userData'),
        )).thenAnswer((_) async {});

        // act
        final result = await repository.login(
          email: 'test@example.com',
          password: 'password123',
        );

        // assert
        expect(result, isA<Right<Failure, AuthEntity>>());

        // AuthEntity'yi extract et ve verify et
        final authEntity = result.fold(
          (failure) => null,
          (authEntity) => authEntity,
        );

        expect(authEntity, isNotNull);
        expect(authEntity!.token, 'test_token');
        expect(authEntity.user.id, '1');
        expect(authEntity.user.name, 'Test User');
        expect(authEntity.user.email, 'test@example.com');

        // Verify interactions
        verify(mockRemoteDataSource.login(any)).called(1);
        verify(mockAuthService.saveAuthData(
          accessToken: 'test_token',
          userData: testUserData,
        )).called(1);
      });

      test('should return AuthFailure when server throws AuthException',
          () async {
        // arrange
        // AuthException'ı throw edecek şekilde mock'la
        when(mockRemoteDataSource.login(any)).thenThrow(const AuthException(
          message: 'Invalid credentials',
          statusCode: 401,
        ));

        // act
        final result = await repository.login(
          email: 'test@example.com',
          password: 'wrongpassword',
        );

        // assert
        expect(result, isA<Left<Failure, AuthEntity>>());

        final failure = result.fold(
          (failure) => failure,
          (authEntity) => null,
        );

        expect(failure, isA<AuthFailure>());
        expect(failure!.message, 'Invalid credentials');
        expect(failure.statusCode, 401);

        // Verify interactions
        verify(mockRemoteDataSource.login(any)).called(1);
        verifyNever(mockAuthService.saveAuthData(
          accessToken: anyNamed('accessToken'),
          userData: anyNamed('userData'),
        ));
      });

      test('should return ServerFailure when server throws ServerException',
          () async {
        // arrange
        // ServerException'ı throw edecek şekilde mock'la
        when(mockRemoteDataSource.login(any)).thenThrow(const ServerException(
          message: 'Server error',
          statusCode: 500,
        ));

        // act
        final result = await repository.login(
          email: 'test@example.com',
          password: 'password123',
        );

        // assert
        expect(result, isA<Left<Failure, AuthEntity>>());

        final failure = result.fold(
          (failure) => failure,
          (authEntity) => null,
        );

        expect(failure, isA<ServerFailure>());
        expect(failure!.message, 'Server error');
        expect(failure.statusCode, 500);

        // Verify interactions
        verify(mockRemoteDataSource.login(any)).called(1);
        verifyNever(mockAuthService.saveAuthData(
          accessToken: anyNamed('accessToken'),
          userData: anyNamed('userData'),
        ));
      });

      test('should return ValidationFailure when ValidationException is thrown',
          () async {
        // arrange
        when(mockRemoteDataSource.login(any))
            .thenThrow(const ValidationException(
          message: 'Invalid input data',
        ));

        // act
        final result = await repository.login(
          email: 'invalid-email',
          password: '123',
        );

        // assert
        expect(result, isA<Left<Failure, AuthEntity>>());

        final failure = result.fold(
          (failure) => failure,
          (authEntity) => null,
        );

        expect(failure, isA<ValidationFailure>());
        expect(failure!.message, 'Invalid input data');
      });

      test('should return ServerFailure when unexpected exception is thrown',
          () async {
        // arrange
        when(mockRemoteDataSource.login(any))
            .thenThrow(Exception('Unexpected error'));

        // act
        final result = await repository.login(
          email: 'test@example.com',
          password: 'password123',
        );

        // assert
        expect(result, isA<Left<Failure, AuthEntity>>());

        final failure = result.fold(
          (failure) => failure,
          (authEntity) => null,
        );

        expect(failure, isA<ServerFailure>());
        expect(
            failure!.message, 'Unexpected error: Exception: Unexpected error');
      });
    });

    group('register', () {
      const testRegisterResponse = RegisterResponse(
        id: '2',
        name: 'New User',
        email: 'newuser@example.com',
        photoUrl: null,
        token: 'new_token',
      );

      test('should return AuthEntity when register is successful', () async {
        // arrange
        when(mockRemoteDataSource.register(any))
            .thenAnswer((_) async => testRegisterResponse);

        when(mockAuthService.saveAuthData(
          accessToken: anyNamed('accessToken'),
          userData: anyNamed('userData'),
        )).thenAnswer((_) async {});

        // act
        final result = await repository.register(
          email: 'newuser@example.com',
          name: 'New User',
          password: 'password123',
        );

        // assert
        expect(result, isA<Right<Failure, AuthEntity>>());

        final authEntity = result.fold(
          (failure) => null,
          (authEntity) => authEntity,
        );

        expect(authEntity, isNotNull);
        expect(authEntity!.token, 'new_token');
        expect(authEntity.user.name, 'New User');
        expect(authEntity.user.email, 'newuser@example.com');

        verify(mockRemoteDataSource.register(any)).called(1);
        verify(mockAuthService.saveAuthData(
          accessToken: 'new_token',
          userData: anyNamed('userData'),
        )).called(1);
      });
    });

    group('logout', () {
      test('should return success when logout is successful', () async {
        // arrange
        when(mockAuthService.clearAuthData()).thenAnswer((_) async {});

        // act
        final result = await repository.logout();

        // assert
        expect(result, isA<Right<Failure, void>>());
        verify(mockAuthService.clearAuthData()).called(1);
      });

      test('should return ServerFailure when logout fails', () async {
        // arrange
        when(mockAuthService.clearAuthData())
            .thenThrow(Exception('Logout failed'));

        // act
        final result = await repository.logout();

        // assert
        expect(result, isA<Left<Failure, void>>());

        final failure = result.fold(
          (failure) => failure,
          (_) => null,
        );

        expect(failure, isA<ServerFailure>());
        expect(failure!.message, 'Logout failed: Exception: Logout failed');
      });
    });
  });
}
