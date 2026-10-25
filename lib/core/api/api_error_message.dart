import 'package:dio/dio.dart';

/// User-facing text from Laravel JSON errors (422 validation, 401, etc.).
String messageFromDio(DioException error) {
  final data = error.response?.data;
  if (data is Map<String, dynamic>) {
    final errors = data['errors'];
    if (errors is Map<String, dynamic>) {
      final parts = <String>[];
      for (final entry in errors.entries) {
        final list = entry.value;
        if (list is List && list.isNotEmpty) {
          parts.add(list.first.toString());
        }
      }
      if (parts.isNotEmpty) {
        return parts.join('\n');
      }
    }
    final message = data['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }
  }
  if (error.message != null && error.message!.isNotEmpty) {
    return error.message!;
  }
  return 'Request failed. Please try again.';
}
