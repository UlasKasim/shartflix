import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shartflix/core/error/error.dart';
import 'package:shartflix/core/network/network.dart';
import 'package:shartflix/data/models/models.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<UserProfileResponse> getUserProfile();
  Future<String> uploadPhoto(String filePath);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.login(request);
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
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.register(request);
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
  Future<UserProfileResponse> getUserProfile() async {
    try {
      final response = await _apiClient.getUserProfile();
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
  Future<String> uploadPhoto(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw const ValidationException(
            message: 'Selected file does not exist');
      }

      // Create UploadPhotoRequest using factory method
      var filename = file.path.split('/').last;
      final uploadRequest = await UploadPhotoRequest.fromFilePath(
        filePath,
        filename: filename,
      );

      // Call ApiClient with generated model
      final response = await _apiClient.uploadPhoto(uploadRequest);

      return response.photoUrl;
    } on DioException catch (e) {
      final exception = _handleDioException(e);
      if (exception is AuthException) {
        throw exception;
      } else {
        throw exception as ServerException;
      }
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw ServerException(message: 'Photo upload failed: $e');
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
          case 400:
            return ServerException(message: message, statusCode: statusCode);
          case 401:
            return const AuthException(
              message: 'Invalid credentials or session expired',
              statusCode: 401,
            );
          case 404:
            return ServerException(
              message: 'Resource not found',
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
