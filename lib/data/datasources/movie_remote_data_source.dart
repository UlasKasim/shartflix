import 'package:dio/dio.dart';

import 'package:shartflix/core/error/error.dart';
import 'package:shartflix/core/network/network.dart';
import 'package:shartflix/data/models/models.dart';

abstract class MovieRemoteDataSource {
  Future<MovieListResponse> getMovies(int page);
  Future<FavoriteMoviesResponse> getFavoriteMovies();
  Future<ToggleFavoriteResponse> toggleFavoriteMovie(String movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiClient _apiClient;

  MovieRemoteDataSourceImpl(this._apiClient);

  @override
  Future<MovieListResponse> getMovies(int page) async {
    try {
      final response = await _apiClient.getMovies(page);
      return response;
    } on DioException catch (e) {
      final exception = _handleDioException(e);
      if (exception is AuthException) {
        throw exception;
      } else {
        throw exception as ServerException;
      }
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<FavoriteMoviesResponse> getFavoriteMovies() async {
    try {
      final response = await _apiClient.getFavoriteMovies();
      return response;
    } on DioException catch (e) {
      final exception = _handleDioException(e);
      if (exception is AuthException) {
        throw exception;
      } else {
        throw exception as ServerException;
      }
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<ToggleFavoriteResponse> toggleFavoriteMovie(String movieId) async {
    try {
      final response = await _apiClient.toggleFavoriteMovie(movieId);
      return response;
    } on DioException catch (e) {
      final exception = _handleDioException(e);
      if (exception is AuthException) {
        throw exception;
      } else {
        throw exception as ServerException;
      }
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerException(
          message: 'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.connectionError:
        return const ServerException(
          message: 'No internet connection. Please check your network.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = _getErrorMessageFromResponse(e.response);

        switch (statusCode) {
          case 401:
            return const AuthException(
              message: 'Session expired. Please login again.',
              statusCode: 401,
            );
          case 404:
            return ServerException(
              message: 'Movie not found',
              statusCode: statusCode,
            );
          case 500:
            return ServerException(
              message: 'Server error. Please try again later.',
              statusCode: statusCode,
            );
          default:
            return ServerException(
              message: message,
              statusCode: statusCode,
            );
        }
      default:
        return ServerException(
          message: e.message ?? 'An unexpected error occurred',
        );
    }
  }

  String _getErrorMessageFromResponse(Response? response) {
    if (response?.data != null) {
      try {
        final data = response!.data;
        if (data is Map<String, dynamic>) {
          return data['message'] ?? data['error'] ?? 'An error occurred';
        }
      } catch (e) {
        // Ignore parsing errors
      }
    }
    return 'An error occurred';
  }
}
