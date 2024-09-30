import 'package:dio/dio.dart';

class ErrorReportingInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // Implement error reporting logic to your 3rd party service
    // For example: Sentry.captureException(err);
    handler.next(err);
  }
}