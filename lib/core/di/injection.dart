import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../core/device/repositories/gps_device.dart';
import '../../core/device/repositories/gps_device_impl.dart';
import '../../core/device/repositories/camera_device.dart';
import '../../core/device/repositories/camera_device_impl.dart';

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

import '../../features/kehadiran/data/datasources/kehadiran_remote_datasource.dart';
import '../../features/kehadiran/data/repositories/kehadiran_repository_impl.dart';
import '../../features/kehadiran/domain/repositories/kehadiran_repository.dart';
import '../../features/kehadiran/domain/usecase/kehadiran/checkin_usecase.dart';
import '../../features/kehadiran/domain/usecase/kehadiran/checkout_usecase.dart';
import '../../features/kehadiran/domain/usecase/kehadiran/get_today_attendance_usecase.dart';

import '../../features/dashboard/presentation/pages/dashboard_controller.dart';
import '../../features/dashboard/presentation/pages/dashboard_presenter.dart';

import '../../features/banner/data/datasources/banner_remote_data_source.dart';
import '../../features/banner/data/repositories/banner_repository_impl.dart';
import '../../features/banner/domain/repositories/banner_repository.dart';
import '../../features/banner/domain/usecases/get_banners_usecase.dart';

import '../../features/pengajuan_cuti/data/datasources/cuti_remote_datasource.dart';
import '../../features/pengajuan_cuti/data/repositories/cuti_repository_impl.dart';
import '../../features/pengajuan_cuti/domain/repositories/cuti_repository.dart';
import '../../features/pengajuan_cuti/domain/usecase/approve_cuti_usecase.dart';
import '../../features/pengajuan_cuti/domain/usecase/create_cuti_usecase.dart';
import '../../features/pengajuan_cuti/domain/usecase/get_list_cuti_bawahan_usecase.dart';
import '../../features/pengajuan_cuti/domain/usecase/get_list_cuti_usecase.dart';
import '../../features/pengajuan_cuti/domain/usecase/reject_cuti_usecase.dart';
import '../../features/pengajuan_cuti/presentation/controller/cuti_controller.dart';
import '../../features/pengajuan_cuti/presentation/controller/cuti_presenter.dart';

import '../../features/pengajuan_izin/data/datasources/izin_remote_datasource.dart';
import '../../features/pengajuan_izin/data/repositories/izin_repository_impl.dart';
import '../../features/pengajuan_izin/domain/repositories/izin_repository.dart';
import '../../features/pengajuan_izin/domain/usecase/approve_izin_usecase.dart';
import '../../features/pengajuan_izin/domain/usecase/create_izin_usecase.dart';
import '../../features/pengajuan_izin/domain/usecase/get_list_izin_bawahan_usecase.dart';
import '../../features/pengajuan_izin/domain/usecase/get_list_izin_usecase.dart';
import '../../features/pengajuan_izin/domain/usecase/reject_izin_usecase.dart';
import '../../features/pengajuan_izin/presentation/controller/izin_controller.dart';
import '../../features/pengajuan_izin/presentation/controller/izin_presenter.dart';



final sl = GetIt.instance;

Future<void> init() async {
  // 0. External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  
  // Device
  sl.registerLazySingleton<GpsDevice>(() => GpsDeviceImpl());
  sl.registerLazySingleton<CameraDevice>(() => CameraDeviceImpl());

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

  // Kehadiran
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<KehadiranRepository>(
    () =>
        KehadiranRepositoryImpl(remoteDataSource: sl<AttendanceRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => CheckInUseCase(sl<KehadiranRepository>()));
  sl.registerLazySingleton(() => CheckOutUseCase(sl<KehadiranRepository>()));
  sl.registerLazySingleton(
    () => GetTodayAttendanceUseCase(sl<KehadiranRepository>()),
  );

  // Dashboard
  sl.registerFactory(
    () => DashboardPresenter(
      sl<CheckInUseCase>(),
      sl<CheckOutUseCase>(),
      sl<GetTodayAttendanceUseCase>(),
      sl<GetBannersUseCase>(),
    ),
  );

  // Banner
  sl.registerLazySingleton<BannerRemoteDataSource>(
      () => BannerRemoteDataSourceImpl(apiClient: sl<ApiClient>()));
  sl.registerLazySingleton<BannerRepository>(
      () => BannerRepositoryImpl(remoteDataSource: sl<BannerRemoteDataSource>()));
  sl.registerLazySingleton(() => GetBannersUseCase(sl<BannerRepository>()));

  sl.registerFactory(() => DashboardController(
    sl<DashboardPresenter>(),
    sl<GpsDevice>(),
    sl<CameraDevice>(),
  ));

  // Pengajuan Cuti
  sl.registerLazySingleton<CutiRemoteDataSource>(() => CutiRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton<CutiRepository>(() => CutiRepositoryImpl(sl<CutiRemoteDataSource>()));
  
  sl.registerLazySingleton(() => CreateCutiUseCase(sl<CutiRepository>()));
  sl.registerLazySingleton(() => GetListCutiUseCase(sl<CutiRepository>()));
  sl.registerLazySingleton(() => GetListCutiBawahanUseCase(sl<CutiRepository>()));
  sl.registerLazySingleton(() => ApproveCutiUseCase(sl<CutiRepository>()));
  sl.registerLazySingleton(() => RejectCutiUseCase(sl<CutiRepository>()));

  sl.registerFactory(
    () => CutiPresenter(
      sl<CreateCutiUseCase>(),
      sl<GetListCutiUseCase>(),
      sl<GetListCutiBawahanUseCase>(),
      sl<ApproveCutiUseCase>(),
      sl<RejectCutiUseCase>(),
    ),
  );
  sl.registerFactory(() => CutiController(sl<CutiPresenter>()));

  // Pengajuan Izin
  sl.registerLazySingleton<IzinRemoteDataSource>(() => IzinRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton<IzinRepository>(() => IzinRepositoryImpl(sl<IzinRemoteDataSource>()));
  
  sl.registerLazySingleton(() => CreateIzinUseCase(sl<IzinRepository>()));
  sl.registerLazySingleton(() => GetListIzinUseCase(sl<IzinRepository>()));
  sl.registerLazySingleton(() => GetListIzinBawahanUseCase(sl<IzinRepository>()));
  sl.registerLazySingleton(() => ApproveIzinUseCase(sl<IzinRepository>()));
  sl.registerLazySingleton(() => RejectIzinUseCase(sl<IzinRepository>()));

  sl.registerFactory(
    () => IzinPresenter(
      sl<CreateIzinUseCase>(),
      sl<GetListIzinUseCase>(),
      sl<GetListIzinBawahanUseCase>(),
      sl<ApproveIzinUseCase>(),
      sl<RejectIzinUseCase>(),
    ),
  );
  sl.registerFactory(() => IzinController(sl<IzinPresenter>()));
}