import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/services/auth_service.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth/login_request.dart';
import '../models/auth/register_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthService _authService;

  AuthRepositoryImpl(this._remoteDataSource, this._authService);

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _remoteDataSource.login(request);

      // Save auth data
      await _authService.saveAuthData(
        accessToken: response.token ?? '',
        userData: {
          'id': response.id ?? '',
          'name': response.name ?? '',
          'email': response.email ?? '',
          'photoUrl': response.photoUrl,
        },
      );

      final authEntity = AuthEntity(
        token: response.token ?? '',
        user: UserEntity(
          id: response.id ?? '',
          name: response.name ?? '',
          email: response.email ?? '',
          photoUrl: response.photoUrl,
        ),
      );

      return Right(authEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on AuthException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        name: name,
        password: password,
      );
      final response = await _remoteDataSource.register(request);

      // Save auth data
      await _authService.saveAuthData(
        accessToken: response.token ?? '', // Fallback
        userData: {
          'id': response.id ?? '',
          'name': response.name ?? '',
          'email': response.email ?? '',
          'photoUrl': response.photoUrl,
        },
      );

      final authEntity = AuthEntity(
        token: response.token ?? '', // Fallback
        user: UserEntity(
          id: response.id ?? '', // Fallback
          name: response.name ?? '', // Fallback
          email: response.email ?? '', // Fallback
          photoUrl: response.photoUrl,
        ),
      );

      return Right(authEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on AuthException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final response = await _remoteDataSource.getUserProfile();

      final userEntity = UserEntity(
        id: response.id,
        name: response.name,
        email: response.email,
        photoUrl: response.photoUrl,
      );

      // Update stored user data
      await _authService.updateUserData(response.toJson());

      return Right(userEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on AuthException catch (e) {
      if (e.statusCode == 401) {
        await _authService.clearAuthData();
        return const Left(UnauthorizedFailure());
      }
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(String filePath) async {
    try {
      final photoUrl = await _remoteDataSource.uploadPhoto(filePath);

      // Update user data with new photo URL
      final userData = _authService.getUserData();
      if (userData != null) {
        userData['photoUrl'] = photoUrl;
        await _authService.updateUserData(userData);
      }

      return Right(photoUrl);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on AuthException catch (e) {
      if (e.statusCode == 401) {
        await _authService.clearAuthData();
        return const Left(UnauthorizedFailure());
      }
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'Photo upload failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _authService.clearAuthData();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Logout failed: $e'));
    }
  }
}
