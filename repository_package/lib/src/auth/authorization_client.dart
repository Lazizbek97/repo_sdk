
abstract class AuthorizationClientBase<T> {
  Future<bool> isRefreshTokenValid(T token);
  Future<bool> isAccessTokenValid(T token);
  Future<T> refresh(T token);
}

