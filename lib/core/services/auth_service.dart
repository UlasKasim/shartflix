import 'dart:async';

import 'package:shartflix/core/constants/constants.dart';
import 'package:shartflix/core/services/services.dart';

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
    Map<String, dynamic>? userData,
  }) async {
    await _storageService.setAccessToken(accessToken);

    if (userData != null) {
      await _storageService.setUserData(AppConstants.userDataKey, userData);
    }

    _authStateController.add(true);
  }

  // Clear authentication data
  Future<void> clearAuthData() async {
    await _storageService.setAccessToken('');
    await _storageService.clearUserData();

    _authStateController.add(false);
  }

  // Get access token
  Future<String?> getAccessToken() async {
    return await _storageService.getAccessToken();
  }

  // Get user data
  Map<String, dynamic>? getUserData() {
    return _storageService.getUserData(AppConstants.userDataKey);
  }

  // Update user data
  Future<void> updateUserData(Map<String, dynamic> userData) async {
    await _storageService.setUserData(AppConstants.userDataKey, userData);
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
