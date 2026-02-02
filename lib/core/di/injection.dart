import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecase/fogot-password/requestOTP_usecase.dart';
import '../../features/auth/domain/usecase/fogot-password/resetPasswod_usecase.dart';
import '../../features/auth/domain/usecase/fogot-password/verifyOTP_usecase.dart';
import '../../features/auth/domain/usecase/login/login_usecase.dart';
import '../../features/auth/presentation/pages/forgot_password/forgotPassword_controller.dart';
import '../../features/auth/presentation/pages/forgot_password/forgotPassword_presenter.dart';
import '../../features/auth/presentation/pages/login/login_controller.dart';
import '../../features/auth/presentation/pages/login/login_presenter.dart';
import '../network/api_client.dart';
import '../network/dio_client.dart';



final sl = GetIt.instance;

Future<void> init() async {
  // 0. External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // 1. Network & API Client
  sl.registerLazySingleton(() => DioClient(sl<Dio>(), sl<AuthLocalDataSource>()));
  sl.registerLazySingleton(() => ApiClient(sl<DioClient>().dio));

  // 2. DataSources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl<FlutterSecureStorage>()),
  );
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(apiClient: sl<ApiClient>()),
  );

  // 3. Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDatasource: sl<AuthRemoteDatasource>(),
      localDatasource: sl<AuthLocalDataSource>(),
    ),
  );

sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));

sl.registerFactory<LoginPresenter>(() => LoginPresenter(sl<LoginUseCase>()));

sl.registerFactory<LoginController>(() => LoginController(sl<LoginPresenter>()));

sl.registerLazySingleton(() => RequestotpUsecase(sl()));
sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
sl.registerLazySingleton(() => ResetPasswordUsecase(sl()));

sl.registerFactory(() => ForgotpasswordPresenter(sl(), sl(), sl()));

sl.registerFactory(() => ForgotpasswordController(sl()));
}