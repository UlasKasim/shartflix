import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
  });
}

// Auth specific failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.statusCode,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized access',
  }) : super(statusCode: 401);
}

class TokenExpiredFailure extends Failure {
  const TokenExpiredFailure({
    super.message = 'Session expired. Please login again.',
  }) : super(statusCode: 401);
}

// Movie specific failures
class MovieFailure extends Failure {
  const MovieFailure({
    required super.message,
    super.statusCode,
  });
}

class MovieNotFoundFailure extends Failure {
  const MovieNotFoundFailure({
    super.message = 'Movie not found',
  }) : super(statusCode: 404);
}
