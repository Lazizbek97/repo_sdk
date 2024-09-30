import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

abstract class DioRestClientBase {
  DioRestClientBase({required String baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  final Dio _dio;

  @protected
  Dio get dio => _dio;

  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters, Options? options});
  Future<T> post<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options});
  Future<T> put<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options});
  Future<T> delete<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options});
  Future<T> patch<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options});
}