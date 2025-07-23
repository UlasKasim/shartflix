import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shartflix/core/injection/injection_container.dart';
import 'package:shartflix/core/services/navigation_service.dart';

import '../blocs/auth/auth_bloc.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/home/main_page.dart';
import '../pages/home/home_page.dart';
import '../pages/profile/profile_page.dart';

class RouteNames {
  static const String login = 'login';
  static const String register = 'register';
  static const String home = 'home';
  static const String profile = 'profile';
  static const String favorites = 'favorites';
}

class AppRouter {
  static const String login = '/${RouteNames.login}';
  static const String register = '/${RouteNames.register}';
  static const String home = '/${RouteNames.home}';
  static const String profile = '/${RouteNames.profile}';
  static const String favorites = '/${RouteNames.favorites}';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    navigatorKey: sl<NavigationService>().navigatorKey,
    redirect: _guard,
    routes: [
      // Auth Routes with custom transitions
      GoRoute(
        path: login,
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const LoginPage(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Login -> Register: slide left to right
            // Register -> Login: slide right to left
            const begin = Offset(-1.0, 0.0); // Geldiği yer (sol)
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: register,
        name: 'register',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const RegisterPage(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Register animasyonu (sağdan gelen)
            const begin = Offset(1.0, 0.0); // Geldiği yer (sağ)
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      ),

      // Main App Routes (with bottom navigation)
      ShellRoute(
        builder: (context, state, child) => MainPage(child: child),
        routes: [
          GoRoute(
            path: home,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );

  static String? _guard(BuildContext context, GoRouterState state) {
    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;

    final isOnAuthPages = [login, register].contains(state.uri.toString());

    // If user is authenticated
    if (authState is AuthAuthenticated) {
      // Redirect to home if on auth pages
      if (isOnAuthPages) return home;
      return null; // Allow access to protected pages
    }

    // If user is not authenticated
    if (authState is AuthUnauthenticated) {
      // Redirect to login if not on auth pages
      if (!isOnAuthPages) return login;
      return null; // Allow access to auth pages
    }

    // If auth state is loading or unknown, stay on current page
    return null;
  }
}
