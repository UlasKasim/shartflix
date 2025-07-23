import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _remoteDataSource;

  MovieRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, MovieListEntity>> getMovies({
    required int page,
  }) async {
    try {
      final response = await _remoteDataSource.getMovies(page);

      final movies = response.movies
          .map((movieModel) => MovieEntity(
                id: movieModel.id ?? "",
                title: movieModel.title ?? "",
                description: movieModel.description ?? "",
                posterUrl: movieModel.posterUrl ?? "",
                isFavorite: movieModel.isFavorite ?? false,
                year: movieModel.year ?? "",
                genre: movieModel.genre ?? "",
                rated: movieModel.rated,
                released: movieModel.released,
                runtime: movieModel.runtime,
                director: movieModel.director,
                writer: movieModel.writer,
                actors: movieModel.actors,
                language: movieModel.language,
                country: movieModel.country,
                awards: movieModel.awards,
                metascore: movieModel.metascore,
                imdbRating: movieModel.imdbRating,
                imdbVotes: movieModel.imdbVotes,
                imdbID: movieModel.imdbID,
                type: movieModel.type,
                images: movieModel.images,
                comingSoon: movieModel.comingSoon,
              ))
          .toList();

      final movieListEntity = MovieListEntity(
        movies: movies,
        totalPages: response.pagination.maxPage,
        currentPage: response.pagination.currentPage,
      );

      return Right(movieListEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on AuthException catch (e) {
      if (e.statusCode == 401) {
        return const Left(UnauthorizedFailure());
      }
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load movies: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getFavoriteMovies() async {
    try {
      final response = await _remoteDataSource.getFavoriteMovies();

      final movies = response.movies
          .map((movieModel) => MovieEntity(
                id: movieModel.id ?? "",
                title: movieModel.title ?? "",
                description: movieModel.description ?? "",
                posterUrl: movieModel.posterUrl ?? "",
                isFavorite: true,
                year: movieModel.year ?? "",
                genre: movieModel.genre ?? "",
                rated: movieModel.rated,
                released: movieModel.released,
                runtime: movieModel.runtime,
                director: movieModel.director,
                writer: movieModel.writer,
                actors: movieModel.actors,
                language: movieModel.language,
                country: movieModel.country,
                awards: movieModel.awards,
                metascore: movieModel.metascore,
                imdbRating: movieModel.imdbRating,
                imdbVotes: movieModel.imdbVotes,
                imdbID: movieModel.imdbID,
                type: movieModel.type,
                images: movieModel.images,
                comingSoon: movieModel.comingSoon,
              ))
          .toList();

      return Right(movies);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on AuthException catch (e) {
      if (e.statusCode == 401) {
        return const Left(UnauthorizedFailure());
      }
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load favorite movies: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavoriteMovie(String movieId) async {
    try {
      final response = await _remoteDataSource.toggleFavoriteMovie(movieId);
      return Right(response.success ?? false);
    } on ServerException catch (e) {
      if (e.statusCode == 404) {
        return const Left(MovieNotFoundFailure());
      }
      return Left(MovieFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on AuthException catch (e) {
      if (e.statusCode == 401) {
        return const Left(UnauthorizedFailure());
      }
      return Left(AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(MovieFailure(message: 'Failed to toggle favorite: $e'));
    }
  }
}
