import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie_entity.dart';
import '../../../domain/usecases/movie/get_movies_usecase.dart';
import '../../../domain/usecases/movie/get_favorite_movies_usecase.dart';
import '../../../domain/usecases/movie/toggle_favorite_movie_usecase.dart';
import '../../../domain/usecases/usecase.dart';

// Movie Events
abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class MovieLoadRequested extends MovieEvent {}

class MovieLoadMoreRequested extends MovieEvent {}

class MovieRefreshRequested extends MovieEvent {}

class MovieToggleFavoriteRequested extends MovieEvent {
  final String movieId;

  const MovieToggleFavoriteRequested({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class MovieFavoritesLoadRequested extends MovieEvent {}

// Movie States
abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<MovieEntity> movies;
  final bool hasReachedMax;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;
  final String? error;

  const MovieLoaded({
    required this.movies,
    required this.hasReachedMax,
    required this.currentPage,
    required this.totalPages,
    this.isLoadingMore = false,
    this.error,
  });

  MovieLoaded copyWith({
    List<MovieEntity>? movies,
    bool? hasReachedMax,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
    String? error,
  }) {
    return MovieLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        movies,
        hasReachedMax,
        currentPage,
        totalPages,
        isLoadingMore,
        error,
      ];
}

class MovieError extends MovieState {
  final String message;

  const MovieError({required this.message});

  @override
  List<Object> get props => [message];
}

// Favorites states
class MovieFavoritesLoading extends MovieState {}

class MovieFavoritesLoaded extends MovieState {
  final List<MovieEntity> favorites;

  const MovieFavoritesLoaded({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

class MovieFavoritesError extends MovieState {
  final String message;

  const MovieFavoritesError({required this.message});

  @override
  List<Object> get props => [message];
}

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMoviesUseCase _getMoviesUseCase;
  final GetFavoriteMoviesUseCase _getFavoriteMoviesUseCase;
  final ToggleFavoriteMovieUseCase _toggleFavoriteMovieUseCase;

  MovieBloc(
    this._getMoviesUseCase,
    this._getFavoriteMoviesUseCase,
    this._toggleFavoriteMovieUseCase,
  ) : super(MovieInitial()) {
    on<MovieLoadRequested>(_onMovieLoadRequested);
    on<MovieLoadMoreRequested>(_onMovieLoadMoreRequested);
    on<MovieRefreshRequested>(_onMovieRefreshRequested);
    on<MovieToggleFavoriteRequested>(_onMovieToggleFavoriteRequested);
    on<MovieFavoritesLoadRequested>(_onMovieFavoritesLoadRequested);
  }

  Future<void> _onMovieLoadRequested(
      MovieLoadRequested event, Emitter<MovieState> emit) async {
    if (state is MovieLoading) return;

    emit(MovieLoading());

    final result = await _getMoviesUseCase(
      const GetMoviesParams(page: 1, enableCache: true),
    );

    result.fold(
      (failure) => emit(MovieError(message: failure.message)),
      (movieList) => emit(MovieLoaded(
        movies: movieList.movies,
        hasReachedMax: movieList.currentPage >= movieList.totalPages,
        currentPage: movieList.currentPage,
        totalPages: movieList.totalPages,
      )),
    );
  }

  Future<void> _onMovieLoadMoreRequested(
      MovieLoadMoreRequested event, Emitter<MovieState> emit) async {
    final currentState = state;
    if (currentState is! MovieLoaded || currentState.hasReachedMax) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await _getMoviesUseCase(
      GetMoviesParams(page: nextPage, enableCache: true),
    );

    result.fold(
      (failure) => emit(currentState.copyWith(
        isLoadingMore: false,
        error: failure.message,
      )),
      (movieList) {
        final allMovies = List<MovieEntity>.from(currentState.movies)
          ..addAll(movieList.movies);

        emit(MovieLoaded(
          movies: allMovies,
          hasReachedMax: movieList.currentPage >= movieList.totalPages,
          currentPage: movieList.currentPage,
          totalPages: movieList.totalPages,
        ));
      },
    );
  }

  Future<void> _onMovieRefreshRequested(
      MovieRefreshRequested event, Emitter<MovieState> emit) async {
    emit(MovieLoading());

    final result = await _getMoviesUseCase(
      const GetMoviesParams(page: 1, enableCache: false),
    );

    result.fold(
      (failure) => emit(MovieError(message: failure.message)),
      (movieList) => emit(MovieLoaded(
        movies: movieList.movies,
        hasReachedMax: movieList.currentPage >= movieList.totalPages,
        currentPage: movieList.currentPage,
        totalPages: movieList.totalPages,
      )),
    );
  }

  Future<void> _onMovieToggleFavoriteRequested(
      MovieToggleFavoriteRequested event, Emitter<MovieState> emit) async {
    final currentState = state;
    if (currentState is! MovieLoaded) return;

    // Optimistic update
    final updatedMovies = currentState.movies.map((movie) {
      if (movie.id == event.movieId) {
        return movie.copyWith(isFavorite: !movie.isFavorite);
      }
      return movie;
    }).toList();

    emit(currentState.copyWith(movies: updatedMovies));

    final result = await _toggleFavoriteMovieUseCase(
      ToggleFavoriteParams(movieId: event.movieId),
    );

    result.fold(
      (failure) {
        // Revert optimistic update on error
        emit(currentState);
        emit(currentState.copyWith(error: failure.message));
      },
      (success) {
        // Keep the optimistic update as it was successful
      },
    );
  }

  Future<void> _onMovieFavoritesLoadRequested(
      MovieFavoritesLoadRequested event, Emitter<MovieState> emit) async {
    emit(MovieFavoritesLoading());

    final result = await _getFavoriteMoviesUseCase(const NoParams());

    result.fold(
      (failure) => emit(MovieFavoritesError(message: failure.message)),
      (favoriteMovies) => emit(MovieFavoritesLoaded(favorites: favoriteMovies)),
    );
  }
}
