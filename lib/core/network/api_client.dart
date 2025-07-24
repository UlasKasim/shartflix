import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shartflix/data/models/models.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl, ParseErrorLogger errorLogger}) =
      _ApiClient;

  // Auth Endpoints
  @POST('/user/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST('/user/register')
  Future<RegisterResponse> register(@Body() RegisterRequest request);

  @GET('/user/profile')
  Future<UserProfileResponse> getUserProfile();

  @POST('/user/upload_photo')
  @MultiPart()
  Future<UploadPhotoResponse> uploadPhoto(@Part(name: 'file') File file);

  // Movie Endpoints
  @GET('/movie/list')
  Future<MovieListResponse> getMovies(@Query('page') int page);

  @GET('/movie/favorites')
  Future<FavoriteMoviesResponse> getFavoriteMovies();

  @POST('/movie/favorite/{favoriteId}')
  Future<ToggleFavoriteResponse> toggleFavoriteMovie(
    @Path('favoriteId') String movieId,
  );
}
