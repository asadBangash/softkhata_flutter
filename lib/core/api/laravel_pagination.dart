import 'package:dio/dio.dart';

/// Fetches all pages from a Laravel [ApiResponse::paginated] endpoint.
Future<List<Map<String, dynamic>>> fetchAllPaginated(
  Dio dio,
  String path, {
  Map<String, dynamic>? queryParameters,
  int perPage = 100,
}) async {
  final items = <Map<String, dynamic>>[];
  var page = 1;
  while (true) {
    final response = await dio.get<Map<String, dynamic>>(
      path,
      queryParameters: {
        ...?queryParameters,
        'page': page,
        'per_page': perPage,
      },
    );
    final body = response.data!;
    final batch = (body['data'] as List<dynamic>).cast<Map<String, dynamic>>();
    items.addAll(batch);
    final meta = body['meta'] as Map<String, dynamic>?;
    if (meta == null) break;
    final lastPage = meta['last_page'] as int? ?? 1;
    if (page >= lastPage) break;
    page++;
  }
  return items;
}
