import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // Network
  static String get baseUrl => dotenv.env['BASE_URL'] ?? "";
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme';
}
