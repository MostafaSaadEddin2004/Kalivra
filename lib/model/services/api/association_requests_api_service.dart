import 'package:dio/dio.dart';
import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/association/association_request_summary.dart';

class AssociationRequestsApiService {
  AssociationRequestsApiService();

  final DioClient _client = DioClient();

  Future<List<AssociationRequestSummary>> fetchRequests() async {
    try {
      final res = await _client.get('association-link-requests');
      final body = res.data;
      if (body is! Map) return [];
      final data = body['data'];
      if (data is! List) return [];
      return data
          .whereType<Map>()
          .map(
            (e) => AssociationRequestSummary.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
    } on DioException {
      return [];
    }
  }
}
