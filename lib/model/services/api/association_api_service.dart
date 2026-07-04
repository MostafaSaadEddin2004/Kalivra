import 'package:dio/dio.dart';
import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/association/association_link_attachment.dart';
import 'package:kalivra/model/association/association_member_profile_model.dart';
import 'package:kalivra/model/association/association_request_summary.dart';
import 'package:kalivra/model/association/association_request_type.dart';
import 'package:kalivra/model/services/api/customer_api_service.dart';

class AssociationApiService {
  AssociationApiService();

  final DioClient _client = DioClient();

  Future<List<AssociationRequestSummary>> fetchRequests() async {
    try {
      final res = await _client.get('customer/requests');
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

  Future<List<AssociationRequestType>> fetchRequestTypes() async {
    try {
      final res = await _client.get('customer/requests/types');
      final body = res.data;
      if (body is! Map) return [];
      final data = body['data'];
      if (data is! List) return [];
      return data
          .whereType<Map>()
          .map(
            (e) =>
                AssociationRequestType.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> submitLinkRequest({
    String customerNote = '',
    String type = 'association_membership',
    required String requestedMembershipType,
    required String fatherName,
    required String motherName,
    required String nationalId,
    String? permanentCapitalId,
    String? permanentCityId,
    String? permanentTownId,
    String permanentVillage = '',
    required String officialStreet,
    required String officialBuilding,
    required List<String> additionalAddresses,
    String? claimedMembershipNumber,
    String? claimedPriorityNumber,
    String? claimedBuildingNumber,
    String? claimedUnitNumber,
    List<AssociationLinkAttachment> attachments = const [],
  }) async {
    final data = {
      'type': type,
      'customer_note': customerNote,
      'father_name': fatherName,
      'mother_name': motherName,
      'national_id': nationalId,
      'permanent_capital_id': permanentCapitalId,
      'permanent_city_id': permanentCityId,
      'permanent_town_id': permanentTownId,
      'village': permanentVillage,
      'official_street': officialStreet,
      'official_building': officialBuilding,
      'additional_addresses': additionalAddresses,
      'requested_membership_type': requestedMembershipType,
      'claimed_membership_number': claimedMembershipNumber,
      'claimed_priority_number': claimedPriorityNumber,
      'claimed_building_number': claimedBuildingNumber,
      'claimed_unit_number': claimedUnitNumber,
      'documents': attachments,
    };

    final requestDocuments = attachments;
    for (var i = 0; i < requestDocuments.length; i++) {
      final attachment = requestDocuments[i];
      data['documents[$i][description]'] = attachment.description.trim();
      data['documents[$i][file]'] = await MultipartFile.fromFile(
        attachment.file.path,
        filename: CustomerApiService.basename(attachment.file.path),
      );
    }
    await _client.post('customer/requests', data: FormData.fromMap(data));
  }

  Future<void> submitNormalRequest({
    required String type,
    required String customerNot,
    List<AssociationLinkAttachment> attachments = const [],
  }) async {
    final data = {
      'type': type,
      'customer_note': customerNot,
      'documents': attachments,
    };
    final requestDocuments = attachments;
    for (var i = 0; i < requestDocuments.length; i++) {
      final attachment = requestDocuments[i];
      data['documents[$i][description]'] = attachment.description.trim();
      data['documents[$i][file]'] = await MultipartFile.fromFile(
        attachment.file.path,
        filename: CustomerApiService.basename(attachment.file.path),
      );
    }
    await _client.post('customer/requests', data: FormData.fromMap(data));
  }

  Future<AssociationMemberProfileModel> fetchProfile() async {
    try {
      final res = await _client.get('customer/association/member');
      final body = res.data;
      final data = body['data'];
      return AssociationMemberProfileModel.fromJson(data);
    } catch (e) {
      throw e.toString();
    }
  }
}
