import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shartflix/core/core.dart';
import 'package:shartflix/data/data.dart';
import 'package:shartflix/domain/domain.dart';
import 'package:shartflix/presentation/blocs/blocs.dart';

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
  sl.registerFactory(() => NavigationCubit());
}
