import 'package:dio/dio.dart';
import 'package:presensi_application_1/core/utils/logger.dart';

class LogInterceptorCustom extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    AppLogger('➡️ REQUEST');
    AppLogger('URL: ${options.uri}');
    AppLogger('METHOD: ${options.method}');
    AppLogger('HEADERS: ${options.headers}');
    AppLogger('DATA: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger('✅ RESPONSE');
    AppLogger('URL: ${response.requestOptions.uri}');
    AppLogger('STATUS: ${response.statusCode}');
    AppLogger('DATA: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    AppLogger('❌ ERROR');
    AppLogger('URL: ${err.requestOptions.uri}');
    AppLogger('MESSAGE: ${err.message}');
    AppLogger('DATA: ${err.response?.data}');
    handler.next(err);
  }
}
