import 'package:dio/dio.dart';
import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/association/association_link_attachment.dart';
import 'package:kalivra/model/association/association_link_request_draft.dart';
import 'package:kalivra/model/association/association_member_profile.dart';
import 'package:kalivra/model/association/association_request_summary.dart';
import 'package:kalivra/model/services/api/customer_api_service.dart';

class AssociationLinkApiService {
  AssociationLinkApiService();

  final DioClient _client = DioClient();

  Future<AssociationLinkRequestDraft?> fetchDraftsRequest() async {
    try {
      final res = await _client.get(
        'association-link-requests/latest',
      );
      final body = res.data;
      if (body is! Map) return null;
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        return AssociationLinkRequestDraft.fromJson(data);
      }
      if (data is Map) {
        return AssociationLinkRequestDraft.fromJson(
          Map<String, dynamic>.from(data),
        );
      }
      return null;
    } on DioException {
      return null;
    }
  }

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

  Future<void> submitRequest({
    required AssociationLinkRequestDraft draft,
    required List<AssociationLinkAttachment> attachments,
  }) async {
    final fields = <String, dynamic>{
      ...draft.toJson(),
    };

    for (var i = 0; i < attachments.length; i++) {
      final attachment = attachments[i];
      fields['attachments[$i][description]'] = attachment.description.trim();
      fields['attachments[$i][file]'] = await MultipartFile.fromFile(
        attachment.file.path,
        filename: CustomerApiService.basename(attachment.file.path),
      );
    }

    await _client.post(
      'association-link-requests',
      data: FormData.fromMap(fields),
    );
  }

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

    final link = await AssociationLinkApiService().fetchDraftsRequest();
    if (link == null) return null;
    return AssociationMemberProfile.fromLinkRequest(link);
  }
}
