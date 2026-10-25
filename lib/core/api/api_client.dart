import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:soft_khata_flutter/core/api/api_config.dart';
import 'package:soft_khata_flutter/core/api/token_storage.dart';

class ApiClient {
  ApiClient({TokenStorage? tokenStorage})
      : _tokenStorage = tokenStorage ?? TokenStorage(),
        _dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.resolveBaseUrl(),
            connectTimeout: ApiConfig.connectTimeout,
            receiveTimeout: ApiConfig.receiveTimeout,
            headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.readToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          final businessId = await _tokenStorage.readBusinessId();
          if (businessId != null) {
            options.headers['X-Business-Id'] = businessId.toString();
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint('API ${error.requestOptions.method} ${error.requestOptions.path} → ${error.response?.statusCode}');
          }
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Dio get dio => _dio;

  TokenStorage get tokenStorage => _tokenStorage;
}
