part of 'token_storage.dart';

class SharedPreferencesTokenStorage implements TokenStorage<Token> {
  SharedPreferencesTokenStorage(this._prefs);

  final SharedPreferences _prefs;
  final _controller = StreamController<Token?>.broadcast();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  @override 
  Future<Token?> load() async {
    final accessToken = _prefs.getString(_accessTokenKey);
    final refreshToken = _prefs.getString(_refreshTokenKey);
    if (accessToken != null && refreshToken != null) {
      return Token(accessToken, refreshToken);
    }
    return null;
  }

  @override
  Future<void> save(Token token) async {
    await _prefs.setString(_accessTokenKey, token.accessToken);
    await _prefs.setString(_refreshTokenKey, token.refreshToken);
    _controller.add(token);
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    _controller.add(null);
  }

  @override
  Stream<Token?> getStream() => _controller.stream;

  @override
  Future<void> close() async {
    await _controller.close();
  }
}