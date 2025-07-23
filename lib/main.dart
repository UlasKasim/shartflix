import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Added

// Bu import'u ekle - flutterfire configure tarafından oluşturulan dosya
import 'firebase_options.dart';

import 'core/injection/injection_container.dart';
import 'core/services/logger_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/auth_service.dart';
import 'sinflix_app.dart';

Future<void> main() async {
  // Native splash'i koru
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize logger
  LoggerService().init();
  LoggerService().i('🚀 Sinflix is starting...');

  // Error handling for Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    LoggerService().e('Flutter Error: ${details.exception}', details.exception,
        details.stack);
    if (!kDebugMode) {
      // In production, report to Crashlytics
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
  };

  // Error handling for async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    LoggerService().e('Platform Error: $error', error, stack);
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    return true;
  };

  try {
    // Firebase initialization with specific options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    LoggerService().i('🔥 Firebase initialized successfully');

    // Initialize Firebase Crashlytics
    try {
      if (!kDebugMode) {
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
        LoggerService().i('💥 Crashlytics initialized');
      }
    } catch (e) {
      LoggerService().w('⚠️ Crashlytics initialization failed: $e');
    }

    // Initialize dependency injection
    await init();
    LoggerService().i('💉 Dependency injection initialized');

    // Initialize storage
    final storageService = sl<StorageService>();
    await storageService.init();
    LoggerService().i('💾 Storage initialized');

    // Initialize auth state
    final authService = sl<AuthService>();
    await authService.initializeAuthState();
    LoggerService().i('🔐 Auth state initialized');

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1F1F1F),
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    LoggerService().i('✅ Sinflix initialized successfully');
  } catch (e, stackTrace) {
    LoggerService().f('❌ Failed to initialize Sinflix', e, stackTrace);
    // Still run the app even if some initialization fails
  }

  // Kısa bir bekleme sonrası splash'i kaldır
  await Future.delayed(const Duration(milliseconds: 500));
  FlutterNativeSplash.remove();

  runApp(const SinflixApp());
}
