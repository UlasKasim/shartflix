import 'dart:developer' as dev;
import 'package:logger/logger.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;
  LoggerService._internal();

  late final Logger _logger;

  void init() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
    );
  }

  // Debug logs
  void d(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
    dev.log(
      message,
      name: 'SINFLIX_DEBUG',
      error: error,
      stackTrace: stackTrace,
    );
  }

  // Info logs
  void i(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
    dev.log(
      message,
      name: 'SINFLIX_INFO',
      error: error,
      stackTrace: stackTrace,
    );
  }

  // Warning logs
  void w(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
    dev.log(
      message,
      name: 'SINFLIX_WARNING',
      error: error,
      stackTrace: stackTrace,
    );
  }

  // Error logs
  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    dev.log(
      message,
      name: 'SINFLIX_ERROR',
      error: error,
      stackTrace: stackTrace,
    );
  }

  // Fatal logs
  void f(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
    dev.log(
      message,
      name: 'SINFLIX_FATAL',
      error: error,
      stackTrace: stackTrace,
    );
  }

  // API Request logs
  void apiRequest(String method, String url, {Map<String, dynamic>? data}) {
    final message = '🚀 API Request: $method $url';
    d(message);
    if (data != null) {
      d('📦 Request Data: $data');
    }
  }

  // API Response logs
  void apiResponse(String method, String url, int statusCode, {dynamic data}) {
    final emoji = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
    final message = '$emoji API Response: $method $url - Status: $statusCode';
    d(message);
    if (data != null) {
      d('📦 Response Data: $data');
    }
  }

  // Navigation logs
  void navigation(String from, String to) {
    d('🧭 Navigation: $from → $to');
  }

  // User action logs
  void userAction(String action, {Map<String, dynamic>? parameters}) {
    final message = '👤 User Action: $action';
    i(message);
    if (parameters != null) {
      i('📊 Parameters: $parameters');
    }
  }

  // Performance logs
  void performance(String operation, Duration duration) {
    final message =
        '⏱️ Performance: $operation took ${duration.inMilliseconds}ms';
    if (duration.inMilliseconds > 1000) {
      w(message); // Warn if operation takes more than 1 second
    } else {
      d(message);
    }
  }

  // Cache logs
  void cache(String action, String key, {bool hit = false}) {
    final emoji = hit ? '🎯' : '💾';
    d('$emoji Cache $action: $key');
  }

  // Authentication logs
  void auth(String action, {String? userId}) {
    final message =
        '🔐 Auth: $action${userId != null ? ' (User: $userId)' : ''}';
    i(message);
  }

  // Bloc/State logs
  void state(String bloc, String from, String to) {
    d('🔄 State Change: $bloc - $from → $to');
  }

  // Firebase logs
  void firebase(String action, {Map<String, dynamic>? data}) {
    final message = '🔥 Firebase: $action';
    i(message);
    if (data != null) {
      d('📊 Firebase Data: $data');
    }
  }
}
