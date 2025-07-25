// test/unit/auth_bloc_test.dart
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:shartflix/core/core.dart';
import 'package:shartflix/domain/domain.dart';
import 'package:shartflix/presentation/blocs/blocs.dart';

@GenerateMocks([
  LoginUseCase,
  RegisterUseCase,
  GetUserProfileUseCase,
  LogoutUseCase,
  AuthService,
])
import 'auth_bloc_test.mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockGetUserProfileUseCase mockGetUserProfileUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockAuthService mockAuthService;
  late StreamController<bool> authStateController;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockAuthService = MockAuthService();
    authStateController = StreamController<bool>.broadcast();

    // AuthService mock setup - default değerler
    when(mockAuthService.authStateStream)
        .thenAnswer((_) => authStateController.stream);
    when(mockAuthService.isAuthenticated).thenAnswer((_) async => false);
  });

  tearDown(() {
    authStateController.close();
  });

  const testUser = UserEntity(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    photoUrl: null,
  );
  const testAuthEntity = AuthEntity(
    token: 'test_token',
    user: testUser,
  );

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      // Stream kontrolü için empty stream kullan
      when(mockAuthService.authStateStream)
          .thenAnswer((_) => const Stream<bool>.empty());

      authBloc = AuthBloc(
        mockLoginUseCase,
        mockRegisterUseCase,
        mockGetUserProfileUseCase,
        mockLogoutUseCase,
        mockAuthService,
      );

      expect(authBloc.state, AuthInitial());
      authBloc.close();
    });

    group('Initialization', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthUnauthenticated] when app starts and user is not authenticated',
        setUp: () {
          when(mockAuthService.isAuthenticated).thenAnswer((_) async => false);
        },
        build: () => AuthBloc(
          mockLoginUseCase,
          mockRegisterUseCase,
          mockGetUserProfileUseCase,
          mockLogoutUseCase,
          mockAuthService,
        ),
        expect: () => [
          AuthLoading(),
          AuthUnauthenticated(),
        ],
        verify: (_) {
          verify(mockAuthService.isAuthenticated).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when app starts and user is authenticated',
        setUp: () {
          when(mockAuthService.isAuthenticated).thenAnswer((_) async => true);
          when(mockGetUserProfileUseCase(any))
              .thenAnswer((_) async => const Right(testUser));
        },
        build: () => AuthBloc(
          mockLoginUseCase,
          mockRegisterUseCase,
          mockGetUserProfileUseCase,
          mockLogoutUseCase,
          mockAuthService,
        ),
        expect: () => [
          AuthLoading(),
          const AuthAuthenticated(user: testUser),
        ],
        verify: (_) {
          verify(mockAuthService.isAuthenticated).called(1);
          verify(mockGetUserProfileUseCase(any)).called(1);
        },
      );
    });

    group('Login', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when login is successful',
        setUp: () {
          when(mockLoginUseCase(any))
              .thenAnswer((_) async => const Right(testAuthEntity));
        },
        build: () {
          // Build phase'de AuthStarted'ı engellemek için
          when(mockAuthService.authStateStream)
              .thenAnswer((_) => const Stream<bool>.empty());
          when(mockAuthService.isAuthenticated).thenAnswer((_) async => false);

          return AuthBloc(
            mockLoginUseCase,
            mockRegisterUseCase,
            mockGetUserProfileUseCase,
            mockLogoutUseCase,
            mockAuthService,
          );
        },
        // Build sonrası initialization tamamlanacak
        act: (bloc) async {
          // Test'in initialization'ını bekle
          await Future.delayed(const Duration(milliseconds: 10));

          bloc.add(const AuthLoginRequested(
            email: 'test@example.com',
            password: 'password123',
          ));
        },
        skip: 2, // AuthLoading ve AuthUnauthenticated'ı skip et
        expect: () => [
          AuthLoading(),
          const AuthAuthenticated(user: testUser),
        ],
        verify: (_) {
          verify(mockLoginUseCase(const LoginParams(
            email: 'test@example.com',
            password: 'password123',
          ))).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when login fails',
        setUp: () {
          when(mockLoginUseCase(any))
              .thenAnswer((_) async => const Left(AuthFailure(
                    message: 'Invalid credentials',
                  )));
        },
        build: () {
          when(mockAuthService.authStateStream)
              .thenAnswer((_) => const Stream<bool>.empty());
          when(mockAuthService.isAuthenticated).thenAnswer((_) async => false);

          return AuthBloc(
            mockLoginUseCase,
            mockRegisterUseCase,
            mockGetUserProfileUseCase,
            mockLogoutUseCase,
            mockAuthService,
          );
        },
        act: (bloc) async {
          await Future.delayed(const Duration(milliseconds: 10));

          bloc.add(const AuthLoginRequested(
            email: 'test@example.com',
            password: 'wrongpassword',
          ));
        },
        skip: 2, // Initialization states'leri skip et
        expect: () => [
          AuthLoading(),
          const AuthError(message: 'Invalid credentials'),
        ],
      );
    });

    group('Register', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when register is successful',
        setUp: () {
          when(mockRegisterUseCase(any))
              .thenAnswer((_) async => const Right(testAuthEntity));
        },
        build: () {
          when(mockAuthService.authStateStream)
              .thenAnswer((_) => const Stream<bool>.empty());
          when(mockAuthService.isAuthenticated).thenAnswer((_) async => false);

          return AuthBloc(
            mockLoginUseCase,
            mockRegisterUseCase,
            mockGetUserProfileUseCase,
            mockLogoutUseCase,
            mockAuthService,
          );
        },
        act: (bloc) async {
          await Future.delayed(const Duration(milliseconds: 10));

          bloc.add(const AuthRegisterRequested(
            email: 'test@example.com',
            name: 'Test User',
            password: 'password123',
          ));
        },
        skip: 2,
        expect: () => [
          AuthLoading(),
          const AuthAuthenticated(user: testUser),
        ],
      );
    });

    group('Logout', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthUnauthenticated] when logout is successful',
        setUp: () {
          when(mockLogoutUseCase(any))
              .thenAnswer((_) async => const Right(null));
        },
        build: () {
          when(mockAuthService.authStateStream)
              .thenAnswer((_) => const Stream<bool>.empty());
          when(mockAuthService.isAuthenticated).thenAnswer((_) async => true);
          when(mockGetUserProfileUseCase(any))
              .thenAnswer((_) async => const Right(testUser));

          return AuthBloc(
            mockLoginUseCase,
            mockRegisterUseCase,
            mockGetUserProfileUseCase,
            mockLogoutUseCase,
            mockAuthService,
          );
        },
        act: (bloc) async {
          await Future.delayed(const Duration(milliseconds: 10));

          bloc.add(AuthLogoutRequested());
        },
        skip: 2, // AuthLoading ve AuthAuthenticated'ı skip et
        expect: () => [
          AuthLoading(),
          AuthUnauthenticated(),
        ],
      );
    });

    group('Auth State Changes', () {
      blocTest<AuthBloc, AuthState>(
        'should emit AuthUnauthenticated when auth service stream emits false',
        build: () {
          // İlk durumda authenticated olsun
          when(mockAuthService.isAuthenticated).thenAnswer((_) async => true);
          when(mockGetUserProfileUseCase(any))
              .thenAnswer((_) async => const Right(testUser));

          return AuthBloc(
            mockLoginUseCase,
            mockRegisterUseCase,
            mockGetUserProfileUseCase,
            mockLogoutUseCase,
            mockAuthService,
          );
        },
        act: (bloc) async {
          // Initialization tamamlanmasını bekle
          await Future.delayed(const Duration(milliseconds: 10));

          // Auth service stream'e false gönder
          authStateController.add(false);
        },
        skip: 2, // Initialization states'leri skip et
        expect: () => [
          AuthUnauthenticated(),
        ],
      );
    });
  });
}
