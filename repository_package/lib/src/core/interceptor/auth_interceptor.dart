import 'package:dio/dio.dart';
import 'package:repository_package/repository_package.dart';
import 'package:repository_package/src/auth/token.dart';

import 'revoke_token_exception.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokenStorage,
    required this.authorizationClient,
  });

  final TokenStorage tokenStorage;
  final AuthorizationClientBase authorizationClient;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final Token? token = await tokenStorage.load();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final token = await tokenStorage.load();
      if (token != null && await authorizationClient.isRefreshTokenValid(token)) {
        try {
          final newToken = await authorizationClient.refresh(token);
          await tokenStorage.save(newToken);

          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer ${newToken.accessToken}';

          final response = await Dio().fetch(opts);
          return handler.resolve(response);
        } on RevokeTokenException {
          await tokenStorage.clear();
        }
      }
    }
    return super.onError(err, handler);
  }
}
