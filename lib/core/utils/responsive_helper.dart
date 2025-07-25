import 'package:flutter/material.dart';

class ResponsiveHelper {
  final BuildContext context;

  ResponsiveHelper(this.context);

  // Screen dimensions
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  // Device type detection
  bool get isTablet => screenWidth >= 768;
  bool get isSmallScreen => screenHeight < 700;
  bool get isLargeTablet => screenWidth >= 1024;
  bool get isMobile => screenWidth < 768;

  // Responsive content constraints
  double get maxContentWidth {
    if (isLargeTablet) return 500;
    if (isTablet) return 400;
    return double.infinity;
  }

  // Responsive padding values
  double get horizontalPadding {
    if (isTablet) return 40;
    return isSmallScreen ? 24.0 : 39.0;
  }

  double get verticalPadding {
    if (isTablet) return 32;
    return isSmallScreen ? 16 : 24;
  }

  // Responsive spacing values
  double get smallSpacing => isTablet ? 12 : 8;
  double get mediumSpacing => isTablet ? 20 : 16;
  double get largeSpacing => isTablet ? 32 : 24;
  double get extraLargeSpacing => isTablet ? 48 : 32;

  // Responsive font sizes
  double get titleFontSize {
    if (isTablet) return 24;
    return isSmallScreen ? 16 : 18;
  }

  double get subtitleFontSize {
    if (isTablet) return 16;
    return isSmallScreen ? 12 : 13;
  }

  double get bodyFontSize {
    if (isTablet) return 16;
    return isSmallScreen ? 14 : 15;
  }

  double get captionFontSize {
    if (isTablet) return 14;
    return isSmallScreen ? 11 : 12;
  }

  // Responsive button dimensions
  double get buttonHeight {
    if (isTablet) return 56;
    return isSmallScreen ? 48 : 52;
  }

  double get buttonBorderRadius {
    if (isTablet) return 20;
    return 18;
  }

  double get socialButtonSize {
    if (isTablet) return 64;
    return 60;
  }

  // Responsive icon sizes
  double get smallIconSize => isTablet ? 20 : 16;
  double get mediumIconSize => isTablet ? 24 : 20;
  double get largeIconSize => isTablet ? 32 : 24;

  // Responsive input field dimensions
  double get inputFieldHeight {
    if (isTablet) return 56;
    return 52;
  }

  double get inputFieldBorderRadius {
    if (isTablet) return 20;
    return 18;
  }

  EdgeInsets get inputFieldPadding {
    if (isTablet) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 18);
    }
    return const EdgeInsets.symmetric(horizontal: 18, vertical: 16);
  }

  // Responsive card dimensions
  double get cardBorderRadius => isTablet ? 16 : 12;
  double get cardElevation => isTablet ? 12 : 8;

  // Responsive grid configurations
  int get gridCrossAxisCount {
    if (isLargeTablet) return 3;
    if (isTablet) return 2;
    return 2;
  }

  double get gridChildAspectRatio {
    if (isTablet) return 0.6;
    return 0.55;
  }

  double get gridSpacing => isTablet ? 20 : 16;

  // Helper methods for common responsive patterns
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? largeTablet,
  }) {
    if (isLargeTablet && largeTablet != null) return largeTablet;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  double responsiveValue({
    required double mobile,
    double? tablet,
    double? largeTablet,
  }) {
    if (isLargeTablet && largeTablet != null) return largeTablet;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // Content wrapper for responsive layouts
  Widget contentWrapper({required Widget child}) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: child,
      ),
    );
  }

  // Responsive safe area
  EdgeInsets get responsiveSafeArea {
    final padding = MediaQuery.of(context).padding;
    return EdgeInsets.only(
      top: padding.top,
      bottom: isTablet ? padding.bottom + 16 : padding.bottom,
      left: isTablet ? 16 : 0,
      right: isTablet ? 16 : 0,
    );
  }
}

// Extension for easy access
extension ResponsiveExtension on BuildContext {
  ResponsiveHelper get responsive => ResponsiveHelper(this);
}
