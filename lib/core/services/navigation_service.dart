import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shartflix/core/theme/app_theme.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext? get context => navigatorKey.currentContext;

  Future<T?> pushBottomSheetOverlay<T>(Widget child) {
    return showModalBottomSheet<T>(
      context: context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.transparent,
          ),
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping on content
            child: DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              builder: (context, scrollController) => child,
            ),
          ),
        ),
      ),
    );
  }

  // Basic Navigation
  Future<T?> push<T>(String routeName, {Object? arguments}) {
    return context!.push<T>(routeName, extra: arguments);
  }

  void pushReplacement(String routeName, {Object? arguments}) {
    context!.pushReplacement(routeName, extra: arguments);
  }

  Future<T?> pushAndClearStack<T>(String routeName, {Object? arguments}) async {
    context!.go(routeName, extra: arguments);
    return null;
  }

  void pop<T>([T? result]) {
    if (context!.canPop()) {
      context!.pop(result);
    }
  }

  void popUntil(String routeName) {
    context!.go(routeName);
  }

  // Go Router specific methods
  void go(String location, {Object? extra}) {
    context!.go(location, extra: extra);
  }

  Future<T?> pushNamed<T>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    return context!.pushNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  void goNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    context!.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  // Custom navigation methods for Sinflix
  void goToLogin() {
    go('/login');
  }

  void goToRegister() {
    go('/register');
  }

  void goToHome() {
    go('/home');
  }

  void goToProfile() {
    go('/profile');
  }

  void goToMovieDetail(String movieId) {
    go('/movie/$movieId');
  }

  // Bottom sheet helpers
  Future<T?> showCustomBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context!,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? Colors.transparent,
      builder: (context) => child,
    );
  }

  // Dialog helpers
  Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<T>(
      context: context!,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => child,
    );
  }

  // Snackbar helpers
  void showSnackBar(
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: duration,
      backgroundColor: AppTheme.transparent20White,
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onActionPressed ?? () {},
              textColor: AppTheme.textPrimary)
          : null,
    );

    ScaffoldMessenger.of(context!).clearSnackBars();
    ScaffoldMessenger.of(context!).showSnackBar(snackBar);
  }

  // Loading dialog
  void showLoadingDialog({String? message}) {
    showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message),
            ],
          ],
        ),
      ),
    );
  }

  void hideLoadingDialog() {
    if (context!.canPop()) {
      context!.pop();
    }
  }

  // Get current route
  String? get currentRoute {
    return GoRouterState.of(context!).uri.toString();
  }
}

enum SnackBarType { success, error, warning, info }
