import 'package:get_it/get_it.dart';
import 'package:todo/core/network/api_client.dart';
import 'package:todo/core/storage/shared_pref_service.dart';
import 'package:todo/features/auth/data/auth_repository_impl.dart';
import 'package:todo/features/auth/domain/auth_repository.dart';
import 'package:todo/features/auth/presentation/auth_viewmodel.dart';
import 'package:todo/features/download/data/download_repository_impl.dart';
import 'package:todo/features/download/domain/download_repository.dart';
import 'package:todo/features/download/presentation/download_viewmodel.dart';
import 'package:todo/features/user/data/user_repository_impl.dart';
import 'package:todo/features/user/domain/user_repository.dart';
import 'package:todo/features/user/presentation/user_view_model.dart';

final locator = GetIt.instance;

Future<void> configureDependencies() async {
  locator.registerLazySingleton<ApiClient>(() => ApiClient());
  locator.registerSingletonAsync<SharedPrefService>(
    () async => SharedPrefService.createInstance(),
  );
  await locator.isReady<SharedPrefService>();

  // Repository
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(locator<ApiClient>(), locator<SharedPrefService>()),
  );
  locator.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(locator<ApiClient>()));
  locator.registerLazySingleton<DownloadRepository>(
    () => DownloadRepositoryImpl(locator<ApiClient>(), locator<SharedPrefService>()),
  );

  // View Model
  locator.registerFactory<AuthViewModel>(() => AuthViewModel(locator<AuthRepository>()));
  locator.registerFactory<UserViewModel>(() => UserViewModel(locator<UserRepository>()));
  locator.registerFactory<DownloadViewModel>(() => DownloadViewModel(locator<DownloadRepository>()));
}
