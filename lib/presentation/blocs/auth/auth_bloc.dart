import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shartflix/core/services/services.dart';
import 'package:shartflix/domain/entities/entities.dart';
import 'package:shartflix/domain/usecases/usecases.dart';

// Auth Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String name;
  final String password;

  const AuthRegisterRequested({
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  List<Object> get props => [email, name, password];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthUserProfileRequested extends AuthEvent {}

class AuthStateChanged extends AuthEvent {
  final bool isAuthenticated;

  const AuthStateChanged({required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];
}

// Auth States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthService _authService;

  late StreamSubscription _authStateSubscription;

  AuthBloc(
    this._loginUseCase,
    this._registerUseCase,
    this._getUserProfileUseCase,
    this._logoutUseCase,
    this._authService,
  ) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthUserProfileRequested>(_onUserProfileRequested);
    on<AuthStateChanged>(_onAuthStateChanged);

    // Listen to auth state changes
    _authStateSubscription =
        _authService.authStateStream.listen((isAuthenticated) {
      add(AuthStateChanged(isAuthenticated: isAuthenticated));
    });

    // Initialize auth state
    add(AuthStarted());
  }

  Future<void> _onAuthStarted(
      AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final isAuthenticated = await _authService.isAuthenticated;

      if (isAuthenticated) {
        // Try to get user profile
        final result = await _getUserProfileUseCase(const NoParams());
        result.fold(
          (failure) => emit(AuthUnauthenticated()),
          (user) => emit(AuthAuthenticated(user: user)),
        );
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (authEntity) => emit(AuthAuthenticated(user: authEntity.user)),
    );
  }

  Future<void> _onRegisterRequested(
      AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _registerUseCase(
      RegisterParams(
        email: event.email,
        name: event.name,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (authEntity) => emit(AuthAuthenticated(user: authEntity.user)),
    );
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _logoutUseCase(const NoParams());

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onUserProfileRequested(
      AuthUserProfileRequested event, Emitter<AuthState> emit) async {
    if (state is! AuthAuthenticated) return;

    emit(AuthLoading());

    final result = await _getUserProfileUseCase(const NoParams());

    result.fold(
      (failure) {
        if (failure.statusCode == 401) {
          emit(AuthUnauthenticated());
        } else {
          emit(AuthError(message: failure.message));
        }
      },
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onAuthStateChanged(
      AuthStateChanged event, Emitter<AuthState> emit) async {
    if (!event.isAuthenticated && state is! AuthUnauthenticated) {
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}
