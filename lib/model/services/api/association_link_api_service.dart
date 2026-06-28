import 'package:dio/dio.dart';
import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/association/association_link_attachment.dart';
import 'package:kalivra/model/association/association_member_profile.dart';
import 'package:kalivra/model/association/association_request_summary.dart';
import 'package:kalivra/model/services/api/customer_api_service.dart';

class AssociationLinkApiService {
  AssociationLinkApiService();

  final DioClient _client = DioClient();

  Future<List<AssociationRequestSummary>> fetchRequests() async {
    try {
      final res = await _client.get('customer/association/requests');
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
    } catch (_) {
      return [];
    }
  }

  Future<void> submitRequest({
    required String fatherName,
    required String motherName,
    required String officialGovernorate,
    required String officialCity,
    required String officialTown,
    required String officialMunicipalityVillage,
    required String officialStreet,
    required String officialBuilding,
    required String permanentAddress,
    required String phone,
    required List<AssociationLinkAttachment> attachments,
  }) async {
    final fields = <String, dynamic>{
      'father_name': fatherName.trim(),
      'mother_name': motherName.trim(),
      'official_governorate': officialGovernorate.trim(),
      'official_city': officialCity.trim(),
      'official_town': officialTown.trim(),
      'official_municipality_village': officialMunicipalityVillage.trim(),
      'official_street': officialStreet.trim(),
      'official_building': officialBuilding.trim(),
      'permanent_address': permanentAddress.trim(),
      'phone': phone.trim(),
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
      'customer/association/link-request',
      data: FormData.fromMap(fields),
    );
  }

  Future<AssociationMemberProfile> fetchProfile() async {
    try {
      final res = await _client.get('customer/association/member');
      final body = res.data;
      final data = body['data'];
      return AssociationMemberProfile.fromJson(data);
    } catch (e) {
      throw e.toString();
    }
  }
}
