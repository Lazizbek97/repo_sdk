import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:repository_package/repository_package.dart';
import 'package:repository_package/src/auth/authorization_client_impl.dart';
import 'package:repository_package/src/auth/token.dart';
import 'package:repository_package/src/core/interceptor/error_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cronet_http/cronet_http.dart' show CronetClient;
import 'package:cupertino_http/cupertino_http.dart' show CupertinoClient;

import 'core/interceptor/log_interceptor.dart';
import 'dio_rest_client_base.dart';

class DioRestClient extends DioRestClientBase {
  DioRestClient({
    required String baseUrl,
    TokenStorage<Token>? tokenStorage,
    AuthorizationClientBase<Token>? authorizationClient,
    List<Interceptor> customInterceptors = const [],
  }) : super(baseUrl: baseUrl) {
    _tokenStorage = tokenStorage;
    _authorizationClient = authorizationClient;
    _customInterceptors = customInterceptors;
    _initialize();
  }

  TokenStorage<Token>? _tokenStorage;
  AuthorizationClientBase<Token>? _authorizationClient;
  late List<Interceptor> _customInterceptors;

  void _initialize() {
    _initializeTokenStorage();
    _initializeAuthorizationClient();
    _setupInterceptors();
    _setupPlatformSpecificAdapter();
  }

  @override
  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters, Options? options}) {
    return dio
        .get(path, queryParameters: queryParameters, options: options)
        .then((response) => response.data as T);
  }

  @override
  Future<T> post<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio
        .post(path, data: data, queryParameters: queryParameters, options: options)
        .then((response) => response.data as T);
  }

  @override
  Future<T> put<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio
        .put(path, data: data, queryParameters: queryParameters, options: options)
        .then((response) => response.data as T);
  }

  @override
  Future<T> delete<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio
        .delete(path, data: data, queryParameters: queryParameters, options: options)
        .then((response) => response.data as T);
  }

  @override
  Future<T> patch<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio
        .patch(path, data: data, queryParameters: queryParameters, options: options)
        .then((response) => response.data as T);
  }

  void _initializeTokenStorage() async {
    // Initialize token storage if not provided

    _tokenStorage ??= SharedPreferencesTokenStorage(await SharedPreferences.getInstance());
  }

  void _initializeAuthorizationClient() {
    // Initialize authorization client if not provided
    _authorizationClient ??= AuthorizationClient(dio);
  }

  void _setupInterceptors() {
    dio.interceptors.addAll([
      if (_tokenStorage != null && _authorizationClient != null)
        AuthInterceptor(
          tokenStorage: _tokenStorage!,
          authorizationClient: _authorizationClient!,
        ),
      LoggingInterceptor(),
      ErrorReportingInterceptor(),
      ..._customInterceptors,
    ]);
  }

  void _setupPlatformSpecificAdapter() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Add CronetClient for Android
      dio.httpClientAdapter = CronetClient.defaultCronetEngine() as HttpClientAdapter;
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      // Add CupertinoClient for iOS/macOS
      dio.httpClientAdapter = CupertinoClient.defaultSessionConfiguration() as HttpClientAdapter;
    }
  }
}
