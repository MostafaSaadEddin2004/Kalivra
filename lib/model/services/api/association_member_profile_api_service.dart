import 'package:dio/dio.dart';
import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/association/association_member_profile.dart';
import 'package:kalivra/model/services/api/association_link_api_service.dart';

class AssociationMemberProfileApiService {
  AssociationMemberProfileApiService();

  final DioClient _client = DioClient();

  Future<AssociationMemberProfile?> fetchProfile() async {
    try {
      final res = await _client.get('association-member-profile');
      final body = res.data;
      if (body is! Map) return null;
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        return AssociationMemberProfile.fromJson(data);
      }
      if (data is Map) {
        return AssociationMemberProfile.fromJson(
          Map<String, dynamic>.from(data),
        );
      }
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code != null && code != 404 && code != 403) {
        rethrow;
      }
    }

    final link = await AssociationLinkApiService().fetchLatestRequest();
    if (link == null) return null;
    return AssociationMemberProfile.fromLinkRequest(link);
  }
}
