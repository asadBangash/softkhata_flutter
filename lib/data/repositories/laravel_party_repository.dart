import 'package:soft_khata_flutter/core/api/api_client.dart';

class LaravelPartyRepository {
  LaravelPartyRepository(this._client);

  final ApiClient _client;

  Future<List<Map<String, dynamic>>> fetchParties({String? type, String? search, int page = 1}) async {
    final response = await _client.dio.get('parties', queryParameters: {
      if (type != null) 'type': type,
      if (search != null && search.isNotEmpty) 'search': search,
      'page': page,
    });
    final body = response.data as Map<String, dynamic>;
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createParty(Map<String, dynamic> payload) async {
    final response = await _client.dio.post('parties', data: payload);
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> ledger(int partyId, {String? fromDate, String? toDate}) async {
    final response = await _client.dio.get('parties/$partyId/ledger', queryParameters: {
      if (fromDate != null) 'from_date': fromDate,
      if (toDate != null) 'to_date': toDate,
    });
    return (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
  }
}
