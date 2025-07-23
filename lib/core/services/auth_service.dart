import 'dart:async';

import '../constants/app_constants.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storageService;

  AuthService(this._storageService);

  final StreamController<bool> _authStateController =
      StreamController<bool>.broadcast();
  Stream<bool> get authStateStream => _authStateController.stream;

  // Check if user is authenticated
  Future<bool> get isAuthenticated async {
    final token = await _storageService.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // Save authentication data
  Future<void> saveAuthData({
    required String accessToken,
    String? refreshToken,
    Map<String, dynamic>? userData,
  }) async {
    await _storageService.setAccessToken(accessToken);

    if (refreshToken != null) {
      await _storageService.setRefreshToken(refreshToken);
    }

    if (userData != null) {
      await _storageService.setUserData(AppConstants.userDataKey, userData);
    }

    _authStateController.add(true);
  }

  // Clear authentication data
  Future<void> clearAuthData() async {
    await _storageService.setAccessToken('');
    await _storageService.setRefreshToken('');
    await _storageService.clearUserData();

    _authStateController.add(false);
  }

  // Get access token
  Future<String?> getAccessToken() async {
    return await _storageService.getAccessToken();
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storageService.getRefreshToken();
  }

  // Get user data
  Map<String, dynamic>? getUserData() {
    return _storageService.getUserData(AppConstants.userDataKey);
  }

  // Update user data
  Future<void> updateUserData(Map<String, dynamic> userData) async {
    await _storageService.setUserData(AppConstants.userDataKey, userData);
  }

  // Check if token is expired (basic implementation)
  Future<bool> isTokenExpired() async {
    // This is a basic implementation
    // In production, you should decode JWT and check exp claim
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return true;

    // For now, we'll assume token is valid
    // You can implement JWT decoding here
    return false;
  }

  // Refresh token (if your API supports it)
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      // Make API call to refresh token
      // This depends on your API implementation
      // For now, we'll return false
      return false;
    } catch (e) {
      return false;
    }
  }

  // Initialize auth state on app start
  Future<void> initializeAuthState() async {
    final isAuth = await isAuthenticated;
    _authStateController.add(isAuth);
  }

  void dispose() {
    _authStateController.close();
  }
}
