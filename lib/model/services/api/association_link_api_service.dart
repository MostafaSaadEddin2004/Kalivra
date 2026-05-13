import 'package:dio/dio.dart';
import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/association/association_link_attachment.dart';
import 'package:kalivra/model/association/association_link_request_draft.dart';
import 'package:kalivra/model/services/api/customer_api_service.dart';

class AssociationLinkApiService {
  AssociationLinkApiService();

  final DioClient _client = DioClient();

  Future<AssociationLinkRequestDraft?> fetchLatestRequest() async {
    try {
      final res = await _client.get<Map<String, dynamic>>(
        'association-link-requests/latest',
      );
      final data = res['data'];
      if (data is Map<String, dynamic>) {
        return AssociationLinkRequestDraft.fromJson(data);
      }
      return null;
    } on DioException {
      return null;
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

    await _client.post<void>(
      'association-link-requests',
      data: FormData.fromMap(fields),
    );
  }
}
