import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/auth/get_user_profile_usecase.dart';
import '../../domain/usecases/auth/upload_photo_usecase.dart';
import '../network/api_client.dart';
import '../network/dio_client.dart';
import '../network/custom_parse_error_logger.dart';
import '../services/auth_service.dart';
import '../services/logger_service.dart';
import '../services/navigation_service.dart';
import '../services/storage_service.dart';
import '../constants/app_constants.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/movie_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/movie/get_movies_usecase.dart';
import '../../domain/usecases/movie/get_favorite_movies_usecase.dart';
import '../../domain/usecases/movie/toggle_favorite_movie_usecase.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/movie/movie_bloc.dart';
import '../../presentation/blocs/profile/profile_bloc.dart';

final GetIt sl = GetIt.instance;

@InjectableInit()
Future<void> init() async {
  // External
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Core
  sl.registerLazySingleton<LoggerService>(() => LoggerService());
  sl.registerLazySingleton<NavigationService>(() => NavigationService());
  sl.registerLazySingleton<StorageService>(
    () => StorageService(sl()),
  );
  sl.registerLazySingleton<AuthService>(() => AuthService(sl()));

  // Network
  sl.registerLazySingleton<Dio>(() => DioClient.createDio());
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      sl<Dio>(),
      baseUrl: AppConstants.baseUrl,
      errorLogger: CustomParseErrorLogger(sl<LoggerService>()),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => UploadPhotoUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetMoviesUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoriteMoviesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteMovieUseCase(sl()));

  // Blocs
  sl.registerFactory(() => AuthBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => MovieBloc(sl(), sl(), sl()));
  sl.registerFactory(() => ProfileBloc(sl()));
}
