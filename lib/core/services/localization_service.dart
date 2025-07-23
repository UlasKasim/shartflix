import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  Map<String, String> _localizedStrings = {};
  late Locale _currentLocale;

  Locale get currentLocale => _currentLocale;

  Future<void> load(Locale locale) async {
    _currentLocale = locale;

    try {
      String jsonString = await rootBundle.loadString(
        'assets/translations/${locale.languageCode}.json',
      );
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    } catch (e) {
      // Fallback to English if loading fails
      if (locale.languageCode != 'en') {
        await load(const Locale('en'));
      }
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

// Extension for easy access
extension LocalizationExtension on String {
  String get tr => LocalizationService().translate(this);
}
