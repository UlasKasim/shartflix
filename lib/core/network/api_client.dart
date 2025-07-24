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

  // Photo upload - With generated UploadPhotoRequest model
  @MultiPart()
  @POST('/user/upload_photo')
  Future<UploadPhotoResponse> uploadPhoto(@Body() UploadPhotoRequest request);

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
