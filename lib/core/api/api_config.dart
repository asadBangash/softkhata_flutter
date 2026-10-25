import 'package:flutter/foundation.dart';

/// Central API configuration for Laravel backend.
class ApiConfig {
  /// Live Hostinger (Laravel lives under /public/ until doc root is fixed in hPanel).
  /// Local override: `--dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1/`
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://softkhata.skylinedelivery.ae/public/api/v1/',
  );

  static const String productionBaseUrl =
      'https://softkhata.skylinedelivery.ae/public/api/v1/';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Android emulator → host machine Laravel
  static String get emulatorBaseUrl => 'http://10.0.2.2:8000/api/v1/';

  static String resolveBaseUrl() {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android && baseUrl.contains('127.0.0.1')) {
      return emulatorBaseUrl;
    }
    return baseUrl;
  }
}
