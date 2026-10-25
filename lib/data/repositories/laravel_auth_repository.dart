import 'package:dio/dio.dart';
import 'package:soft_khata_flutter/core/api/api_client.dart';

class LaravelAuthRepository {
  LaravelAuthRepository(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _client.dio.post('login', data: {
      'email': email,
      'password': password,
    });
    final data = response.data as Map<String, dynamic>;
    if (data['success'] != true) {
      throw DioException(requestOptions: response.requestOptions, message: data['message']?.toString());
    }
    final payload = data['data'] as Map<String, dynamic>;
    final token = payload['token'] as String;
    await _client.tokenStorage.saveToken(token);
    final user = payload['user'] as Map<String, dynamic>;
    final businessId = user['current_business_id'] as int?;
    if (businessId != null) {
      await _client.tokenStorage.saveBusinessId(businessId);
    }
    return payload;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String businessName,
    String? phone,
    String? businessCategory,
  }) async {
    final response = await _client.dio.post('register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone': phone,
      'business_name': businessName,
      'business_category': businessCategory,
    });
    final data = response.data as Map<String, dynamic>;
    if (data['success'] != true) {
      throw DioException(requestOptions: response.requestOptions, message: data['message']?.toString());
    }
    final payload = data['data'] as Map<String, dynamic>;
    await _client.tokenStorage.saveToken(payload['token'] as String);
    final user = payload['user'] as Map<String, dynamic>?;
    final businessId = user?['current_business_id'] as int?;
    if (businessId != null) {
      await _client.tokenStorage.saveBusinessId(businessId);
    }
    return payload;
  }

  Future<void> logout() async {
    try {
      await _client.dio.post('logout');
    } finally {
      await _client.tokenStorage.clearToken();
    }
  }

  Future<Map<String, dynamic>> me() async {
    final response = await _client.dio.get('me');
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }
}
