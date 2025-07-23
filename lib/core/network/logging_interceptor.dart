import 'package:dio/dio.dart';

import '../services/logger_service.dart';

class LoggingInterceptor extends Interceptor {
  final LoggerService _logger;

  LoggingInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.apiRequest(
      options.method,
      '${options.baseUrl}${options.path}',
      data: _sanitizeData(options.data),
    );

    // Log query parameters
    if (options.queryParameters.isNotEmpty) {
      _logger.d('🔍 Query Parameters: ${options.queryParameters}');
    }

    // Log headers (excluding sensitive ones)
    final sanitizedHeaders = Map<String, dynamic>.from(options.headers);
    sanitizedHeaders.remove('Authorization');
    if (sanitizedHeaders.isNotEmpty) {
      _logger.d('📋 Headers: $sanitizedHeaders');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.apiResponse(
      response.requestOptions.method,
      '${response.requestOptions.baseUrl}${response.requestOptions.path}',
      response.statusCode ?? 0,
      data: _sanitizeData(response.data),
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode ?? 0;
    final url = '${err.requestOptions.baseUrl}${err.requestOptions.path}';

    _logger.e(
      '❌ API Error: ${err.requestOptions.method} $url - Status: $statusCode',
      err.error,
      err.stackTrace,
    );

    // Log error response data if available
    if (err.response?.data != null) {
      _logger.e('📦 Error Response: ${_sanitizeData(err.response!.data)}');
    }

    // Log error details
    _logger.e('🔍 Error Type: ${err.type}');
    _logger.e('💬 Error Message: ${err.message}');

    handler.next(err);
  }

  // Sanitize sensitive data from logs
  dynamic _sanitizeData(dynamic data) {
    if (data is Map<String, dynamic>) {
      final sanitized = Map<String, dynamic>.from(data);

      // Remove sensitive fields
      const sensitiveFields = [
        'password',
        'token',
        'accessToken',
        'authorization',
        'secret',
        'key',
        'api_key',
        'apiKey',
      ];

      for (final field in sensitiveFields) {
        if (sanitized.containsKey(field)) {
          sanitized[field] = '***HIDDEN***';
        }
      }

      return sanitized;
    }

    return data;
  }
}
