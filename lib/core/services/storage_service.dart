import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage;
  late Box _generalBox;
  late Box _userBox;
  late Box _cacheBox;

  StorageService(this._secureStorage);

  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters here if needed
    // Hive.registerAdapter(UserAdapter());

    _generalBox = await Hive.openBox('general');
    _userBox = await Hive.openBox('user');
    _cacheBox = await Hive.openBox('cache');
  }

  // Secure Storage (for sensitive data like tokens)
  Future<void> setSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureString(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecureString(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  // Token Management
  Future<void> setAccessToken(String token) async {
    await setSecureString(AppConstants.accessTokenKey, token);
  }

  Future<String?> getAccessToken() async {
    return await getSecureString(AppConstants.accessTokenKey);
  }

  Future<void> setRefreshToken(String token) async {
    await setSecureString(AppConstants.refreshTokenKey, token);
  }

  Future<String?> getRefreshToken() async {
    return await getSecureString(AppConstants.refreshTokenKey);
  }

  // General Storage (for app preferences)
  Future<void> setString(String key, String value) async {
    await _generalBox.put(key, value);
  }

  String? getString(String key) {
    return _generalBox.get(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _generalBox.put(key, value);
  }

  bool? getBool(String key) {
    return _generalBox.get(key);
  }

  Future<void> setInt(String key, int value) async {
    await _generalBox.put(key, value);
  }

  int? getInt(String key) {
    return _generalBox.get(key);
  }

  Future<void> setDouble(String key, double value) async {
    await _generalBox.put(key, value);
  }

  double? getDouble(String key) {
    return _generalBox.get(key);
  }

  // User Data Storage
  Future<void> setUserData(String key, Map<String, dynamic> userData) async {
    await _userBox.put(key, jsonEncode(userData));
  }

  Map<String, dynamic>? getUserData(String key) {
    final data = _userBox.get(key);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  // Cache Storage (for temporary data like movie lists)
  Future<void> setCacheData(String key, dynamic data,
      {Duration? expiry}) async {
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiry': expiry?.inMilliseconds,
    };
    await _cacheBox.put(key, jsonEncode(cacheData));
  }

  T? getCacheData<T>(String key) {
    final cachedString = _cacheBox.get(key);
    if (cachedString == null) return null;

    try {
      final cacheData = jsonDecode(cachedString);
      final timestamp = cacheData['timestamp'] as int;
      final expiry = cacheData['expiry'] as int?;

      // Check if expired
      if (expiry != null) {
        final expiryTime = timestamp + expiry;
        if (DateTime.now().millisecondsSinceEpoch > expiryTime) {
          _cacheBox.delete(key);
          return null;
        }
      }

      return cacheData['data'] as T;
    } catch (e) {
      _cacheBox.delete(key);
      return null;
    }
  }

  // Clear methods
  Future<void> clearUserData() async {
    await _userBox.clear();
  }

  Future<void> clearCache() async {
    await _cacheBox.clear();
  }

  Future<void> clearAll() async {
    await _generalBox.clear();
    await _userBox.clear();
    await _cacheBox.clear();
    await clearSecureStorage();
  }

  // Theme
  Future<void> setTheme(String theme) async {
    await setString(AppConstants.themeKey, theme);
  }

  String getTheme() {
    return getString(AppConstants.themeKey) ?? 'system';
  }

  // Check if first launch
  bool get isFirstLaunch {
    return getBool('is_first_launch') ?? true;
  }

  Future<void> setFirstLaunch(bool value) async {
    await setBool('is_first_launch', value);
  }
}
