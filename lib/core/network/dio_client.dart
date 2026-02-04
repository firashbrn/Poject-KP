import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../constants/api_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/throttle_interceptor.dart';




class DioClient {
   final Dio _dio;
  Dio get dio => _dio;
  final AuthLocalDataSource authLocalDataSource;
  static const Duration throttleDuration = Duration(milliseconds: 500);

DioClient(this._dio, this.authLocalDataSource){
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      responseType: ResponseType.json,
      headers:{
        'Content-Type': 'application/json',
      }
  );

  _dio.interceptors.addAll([
      // Auth Interceptor
      AuthInterceptor(localDataSource: authLocalDataSource),

      // Throttle interceptor (tambahkan pertama/setelah auth)
      ThrottleInterceptor(throttleDuration: throttleDuration),

      // ... existing interceptors

      // Log interceptor (debug)
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    ]);
  }
}
  