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

  // Pagination
  static const int moviesPerPage = 5;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  // Firebase
  static const String firebaseCollectionUsers = 'users';
  static const String firebaseCollectionMovies = 'movies';
}
