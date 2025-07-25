import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:shartflix/core/error/failures.dart';
import 'package:shartflix/domain/entities/auth_entity.dart';
import 'package:shartflix/domain/entities/movie_entity.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';
import 'package:shartflix/domain/usecases/movie/get_movies_usecase.dart';

@GenerateMocks([MovieRepository])
import 'get_movies_usecase_test.mocks.dart';

void main() {
  late GetMoviesUseCase useCase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    useCase = GetMoviesUseCase(mockMovieRepository);
  });

  const testMovieList = MovieListEntity(
    movies: [
      MovieEntity(
        id: '1',
        title: 'Test Movie',
        description: 'Test Description',
        posterUrl: 'https://test.com/poster.jpg',
        isFavorite: false,
        year: '2023',
        genre: 'Action',
      ),
    ],
    totalPages: 10,
    currentPage: 1,
  );

  group('GetMoviesUseCase', () {
    test('should return MovieListEntity when call is successful', () async {
      // arrange
      when(mockMovieRepository.getMovies(page: anyNamed('page')))
          .thenAnswer((_) async => const Right(testMovieList));

      // act
      final result = await useCase(const GetMoviesParams(page: 1));

      // assert
      expect(result, const Right(testMovieList));
      verify(mockMovieRepository.getMovies(page: 1));
    });

    test('should return ValidationFailure when page number is invalid',
        () async {
      // act
      final result = await useCase(const GetMoviesParams(page: 0));

      // assert
      expect(
          result,
          const Left(ValidationFailure(
            message: 'Page number must be greater than 0',
          )));
      verifyZeroInteractions(mockMovieRepository);
    });

    test('should return ServerFailure when repository call fails', () async {
      // arrange
      when(mockMovieRepository.getMovies(page: anyNamed('page')))
          .thenAnswer((_) async => const Left(ServerFailure(
                message: 'Server error',
              )));

      // act
      final result = await useCase(const GetMoviesParams(page: 1));

      // assert
      expect(result, const Left(ServerFailure(message: 'Server error')));
    });
  });
}
