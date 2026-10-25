import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'sanctum_token';
  static const _businessIdKey = 'current_business_id';

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<void> saveBusinessId(int id) => _storage.write(key: _businessIdKey, value: id.toString());

  Future<int?> readBusinessId() async {
    final v = await _storage.read(key: _businessIdKey);
    return v == null ? null : int.tryParse(v);
  }
}
