import 'dart:async';

import 'package:repository_package/src/auth/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'token_storage_impl.dart';

abstract class TokenStorage<T> {
  Future<T?> load();
  Future<void> save(T token);
  Future<void> clear();
  Stream<T?> getStream();
  Future<void> close();
}
