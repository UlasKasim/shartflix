import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shartflix/core/constants/asset_constants.dart';

class AppTheme {
  // Colors - Netflix-inspired dark theme for Sinflix
  static const Color primaryRed = Color(0xFFE50914);
  static const Color darkRed = Color(0xFFB81D24);
  static const Color lightRed = Color(0xFFFF1744);

  // Updated Background Colors
  static const Color backgroundDark = Color(0xFF090909); // Güncellendi
  static const Color surfaceDark = Color(0xFF1F1F1F);
  static const Color cardDark = Color(0xFF2D2D2D);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textHint = Color(0xFF737373);

  // Transparent Colors for Login Design
  static const Color transparent10White = Color(0x1AFFFFFF); // 10% Beyaz
  static const Color transparent20White = Color(0x33FFFFFF); // 20% Beyaz
  static const Color transparent50White = Color(0x80FFFFFF); // 50% Beyaz

  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);

  // Gradients
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, darkRed],
  );

  static const Gradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2D2D2D),
      Color(0xFF1F1F1F),
    ],
  );

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AssetConstants.fontEuclidCircularA,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: primaryRed,
        primaryContainer: darkRed,
        secondary: lightRed,
        surface: surfaceDark,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        error: errorRed,
        onError: textPrimary,
      ),

      // Scaffold
      scaffoldBackgroundColor: backgroundDark, // #090909

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: AssetConstants.fontEuclidCircularA,
        ),
        iconTheme: IconThemeData(color: textPrimary),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      // Cards
      cardTheme: CardTheme(
        color: cardDark,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: primaryRed,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: textPrimary,
          elevation: 4,
          shadowColor: primaryRed.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: AssetConstants.fontEuclidCircularA,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: primaryRed, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: AssetConstants.fontEuclidCircularA,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryRed,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: AssetConstants.fontEuclidCircularA,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        hintStyle: const TextStyle(color: textHint),
        labelStyle: const TextStyle(color: textSecondary),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
      ),

      // Text Theme - Updated with exact design specs
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: AssetConstants.fontEuclidCircularA,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: AssetConstants.fontEuclidCircularA,
        ),
        displaySmall: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          fontFamily: AssetConstants.fontEuclidCircularA,
        ),
        // Login Design Specific Styles
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: AssetConstants.fontEuclidCircularA,
          height: 1.0,
        ),
        headlineMedium: TextStyle(
          // Button text için
          color: textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: AssetConstants.fontEuclidCircularA,
          height: 1.0,
        ),
        headlineSmall: TextStyle(
          // Description için
          color: textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          fontFamily: AssetConstants.fontEuclidCircularA,
          height: 1.0,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: AssetConstants.fontEuclidCircularA,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: AssetConstants.fontEuclidCircularA,
        ),
        titleSmall: TextStyle(
          // Hint text ve küçük text'ler için
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: AssetConstants.fontEuclidCircularA,
          height: 1.5,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontFamily: AssetConstants.fontEuclidCircularA,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          fontFamily: AssetConstants.fontEuclidCircularA,
        ),
        bodySmall: TextStyle(
          color: textHint,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: AssetConstants.fontEuclidCircularA,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: textHint.withValues(alpha: 0.2),
        thickness: 1,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryRed,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardDark,
        contentTextStyle: const TextStyle(
          color: textPrimary,
          fontFamily: AssetConstants.fontEuclidCircularA,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Light theme (optional - for future use)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AssetConstants.fontEuclidCircularA,
      colorScheme: const ColorScheme.light(
        primary: primaryRed,
        primaryContainer: lightRed,
        secondary: darkRed,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
      ),
    );
  }
}

// Custom Box Shadows
class AppShadows {
  static const BoxShadow cardShadow = BoxShadow(
    color: Colors.black26,
    blurRadius: 8,
    offset: Offset(0, 4),
  );

  static const BoxShadow bottomNavShadow = BoxShadow(
    color: Colors.black12,
    blurRadius: 16,
    offset: Offset(0, -4),
  );

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];
}

// Custom Border Radius
class AppBorderRadius {
  static const BorderRadius small = BorderRadius.all(Radius.circular(4));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(8));
  static const BorderRadius large = BorderRadius.all(Radius.circular(12));
  static const BorderRadius extraLarge = BorderRadius.all(Radius.circular(16));
  static const BorderRadius circular = BorderRadius.all(Radius.circular(50));

  // Login Design Specific
  static const BorderRadius loginTextField =
      BorderRadius.all(Radius.circular(18));
  static const BorderRadius loginButton = BorderRadius.all(Radius.circular(18));
}
