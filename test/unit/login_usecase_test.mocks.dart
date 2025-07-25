// Mocks generated by Mockito 5.4.5 from annotations
// in shartflix/test/unit/login_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:shartflix/core/error/error.dart' as _i5;
import 'package:shartflix/domain/entities/entities.dart' as _i6;
import 'package:shartflix/domain/repositories/auth_repository.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AuthRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthRepository extends _i1.Mock implements _i3.AuthRepository {
  MockAuthRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.AuthEntity>> login({
    required String? email,
    required String? password,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #login,
          [],
          {
            #email: email,
            #password: password,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.AuthEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.AuthEntity>(
          this,
          Invocation.method(
            #login,
            [],
            {
              #email: email,
              #password: password,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.AuthEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.AuthEntity>> register({
    required String? email,
    required String? name,
    required String? password,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #register,
          [],
          {
            #email: email,
            #name: name,
            #password: password,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.AuthEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.AuthEntity>(
          this,
          Invocation.method(
            #register,
            [],
            {
              #email: email,
              #name: name,
              #password: password,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.AuthEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>> getUserProfile() =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserProfile,
          [],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.UserEntity>(
          this,
          Invocation.method(
            #getUserProfile,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, String>> uploadPhoto(String? filePath) =>
      (super.noSuchMethod(
        Invocation.method(
          #uploadPhoto,
          [filePath],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, String>>.value(
            _FakeEither_0<_i5.Failure, String>(
          this,
          Invocation.method(
            #uploadPhoto,
            [filePath],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, String>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> logout() => (super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, void>>.value(
            _FakeEither_0<_i5.Failure, void>(
          this,
          Invocation.method(
            #logout,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, void>>);
}
