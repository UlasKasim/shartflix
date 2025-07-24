import 'package:dio/dio.dart';
import 'package:shartflix/core/constants/constants.dart';
import 'package:shartflix/core/injection/injection_container.dart';
import 'package:shartflix/core/network/network.dart';
import 'package:shartflix/core/services/services.dart';

class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.connectionTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        responseType: ResponseType.json,
      ),
    );

    // Add interceptors
    dio.interceptors.add(LoggingInterceptor(sl<LoggerService>()));
    dio.interceptors.add(AuthInterceptor(sl<AuthService>()));

    return dio;
  }
}
