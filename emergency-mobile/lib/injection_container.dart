import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

import 'core/networking/api_provider.dart';
import 'core/networking/auth_plugin.dart';
import 'core/networking/network_info.dart';
import 'core/networking/plugin_type.dart';
import 'core/util/keyword_validator.dart';
import 'features/country/data/datasources/country_local_data_source.dart';
import 'features/country/data/datasources/country_remote_data_source.dart';
import 'features/country/data/repositories/country_repository_impl.dart';
import 'features/country/data/repositories/local/country_local_repository.dart';
import 'features/country/data/repositories/remote/country_remote_repository.dart';
import 'features/country/domain/repositories/country_repository.dart';
import 'features/country/domain/usecases/get_all_countries_usecase.dart';
import 'features/country/domain/usecases/get_country_usecase.dart';
import 'features/country/domain/usecases/get_indexing_usecase.dart';
import 'features/country/domain/usecases/search_countries_usecase.dart';
import 'features/country/presentation/bloc/country_bloc.dart';
import 'features/member/data/repositories/user_repository_impl.dart';
import 'features/member/domain/repositories/user_repository.dart';
import 'features/member/domain/usecases/login_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Country
  // Bloc
  sl.registerFactory(
    () => CountryBloc(
      allCountriesUseCase: sl(),
      searchCountriesUseCase: sl(),
      indexingUseCase: sl(),
      validator: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllCountriesUseCase(sl()));
  sl.registerLazySingleton(() => GetCountryUseCase(sl()));
  sl.registerLazySingleton(() => SearchCountriesUseCase(sl()));
  sl.registerLazySingleton(() => GetIndexingUseCase());

  // Repository
  sl.registerLazySingleton<CountryRepository>(
    () => CountryRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<CountryLocalDataSource>(
      () => CountryLocalRepository());
  sl.registerLazySingleton<CountryRemoteDataSource>(
      () => CountryRemoteRepository(EGApiProvider(sl(), [sl()])));

  //! Features - Member
  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(EGApiProvider(sl())));

  //! Core
  sl.registerLazySingleton<PluginType>(() => AuthPlugin(sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => KeywordValidator());

  //! External
  sl.registerLazySingleton(() => Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
