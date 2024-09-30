import 'package:dio/dio.dart';
import 'package:repository_package/repository_package.dart';
import 'package:repository_package/src/auth/token.dart';
import 'package:repository_package/src/core/interceptor/revoke_token_exception.dart';

class AuthorizationClient implements AuthorizationClientBase<Token> {
  AuthorizationClient(this._dio);

  final Dio _dio;

  @override
  Future<bool> isRefreshTokenValid(Token token) async {
    // Implement your logic to check if the refresh token is valid
    // This could involve checking the expiration time or making a request to your server
    return true; // Placeholder implementation
  }

  @override
  Future<bool> isAccessTokenValid(Token token) async {
    // Implement your logic to check if the access token is valid
    // This could involve checking the expiration time or making a request to your server
    return true; // Placeholder implementation
  }

  @override
  Future<Token> refresh(Token token) async {
    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': token.refreshToken},
      );
      
      if (response.statusCode == 200) {
        return Token(
          response.data['access_token'],
          response.data['refresh_token'],
        );
      } else {
        throw RevokeTokenException('Failed to refresh token');
      }
    } catch (e) {
      throw RevokeTokenException('Failed to refresh token: $e');
    }
  }
}