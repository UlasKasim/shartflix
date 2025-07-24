import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shartflix/core/services/logger_service.dart';

class CustomParseErrorLogger extends ParseErrorLogger {
  final LoggerService _logger;

  CustomParseErrorLogger(this._logger);

  @override
  void logError(Object error, StackTrace stackTrace, RequestOptions options) {
    _logger.e(
      '🔴 Retrofit Parse Error: ${options.method} ${options.uri}',
      error,
      stackTrace,
    );
  }
}
