import 'package:equatable/equatable.dart';

import 'user_entity.dart';
import 'movie_entity.dart';

class AuthEntity extends Equatable {
  final String token;
  final UserEntity user;

  const AuthEntity({
    required this.token,
    required this.user,
  });

  @override
  List<Object?> get props => [token, user];

  @override
  bool get stringify => true;
}

class MovieListEntity extends Equatable {
  final List<MovieEntity> movies;
  final int totalPages;
  final int currentPage;

  const MovieListEntity({
    required this.movies,
    required this.totalPages,
    required this.currentPage,
  });

  bool get hasNextPage => currentPage < totalPages;

  @override
  List<Object?> get props => [movies, totalPages, currentPage];

  @override
  bool get stringify => true;
}
