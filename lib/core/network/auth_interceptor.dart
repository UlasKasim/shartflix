import 'package:dio/dio.dart';

import '../services/auth_service.dart';

class AuthInterceptor extends Interceptor {
  final AuthService _authService;

  AuthInterceptor(this._authService);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth for login and register endpoints
    if (_shouldSkipAuth(options.path)) {
      return handler.next(options);
    }

    // Add authorization header
    final token = await _authService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401) {
      // Try to refresh token
      final refreshSuccess = await _authService.refreshToken();

      if (refreshSuccess) {
        // Retry the original request
        final token = await _authService.getAccessToken();
        if (token != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $token';

          try {
            final dio = Dio();
            final response = await dio.fetch(err.requestOptions);
            return handler.resolve(response);
          } catch (e) {
            // If retry fails, clear auth data
            await _authService.clearAuthData();
          }
        }
      } else {
        // Refresh failed, clear auth data and redirect to login
        await _authService.clearAuthData();
      }
    }

    handler.next(err);
  }

  bool _shouldSkipAuth(String path) {
    const authSkipPaths = [
      '/user/login',
      '/user/register',
    ];

    return authSkipPaths.any((skipPath) => path.contains(skipPath));
  }
}
