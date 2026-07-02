import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/association/association_link_attachment.dart';
import 'package:kalivra/model/association/association_member_profile.dart';
import 'package:kalivra/model/association/association_request_summary.dart';
import 'package:kalivra/model/association/association_request_type.dart';
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

  Future<void> submitRequest({
    String customerNote = '',
    String type = 'association_membership',
    String? membershipId,
    String? requestedMembershipType,
    required String fatherName,
    required String motherName,
    String? nationalId,
    String? permanentCapitalId,
    String? permanentCityId,
    String? permanentTownId,
    String? permanentVillageId,
    String officialGovernorate = '',
    String officialCity = '',
    String officialTown = '',
    String officialMunicipalityVillage = '',
    required String officialStreet,
    required String officialBuilding,
    String permanentAddress = '',
    String phone = '',
    Object? additionalAddresses,
    String? claimedMembershipNumber,
    String? claimedPriorityNumber,
    String? claimedBuildingNumber,
    String? claimedUnitNumber,
    List<AssociationLinkAttachment> attachments = const [],
    List<AssociationLinkAttachment>? documents,
  }) async {
    final fields = <String, dynamic>{};

    _putIfNotBlank(fields, 'customer_note', customerNote);
    _putIfNotBlank(fields, 'type', type);
    _putIfNotBlank(fields, 'membership_id', membershipId);
    _putIfNotBlank(
      fields,
      'requested_membership_type',
      requestedMembershipType,
    );
    _putIfNotBlank(fields, 'father_name', fatherName);
    _putIfNotBlank(fields, 'mother_name', motherName);
    _putIfNotBlank(fields, 'national_id', nationalId);
    _putIfNotBlank(
      fields,
      'permanent_capital_id',
      permanentCapitalId ?? officialGovernorate,
    );
    _putIfNotBlank(
      fields,
      'permanent_city_id',
      permanentCityId ?? officialCity,
    );
    _putIfNotBlank(
      fields,
      'permanent_town_id',
      permanentTownId ?? officialTown,
    );
    _putIfNotBlank(
      fields,
      'permanent_village_id',
      permanentVillageId ?? officialMunicipalityVillage,
    );
    _putIfNotBlank(fields, 'official_street', officialStreet);
    _putIfNotBlank(fields, 'official_building', officialBuilding);
    _putIfNotBlank(fields, 'permanent_address', permanentAddress);
    _putIfNotBlank(fields, 'phone', phone);
    _putIfNotBlank(
      fields,
      'claimed_membership_number',
      claimedMembershipNumber,
    );
    _putIfNotBlank(fields, 'claimed_priority_number', claimedPriorityNumber);
    _putIfNotBlank(fields, 'claimed_building_number', claimedBuildingNumber);
    _putIfNotBlank(fields, 'claimed_unit_number', claimedUnitNumber);

    final encodedAddresses = _encodeAdditionalAddresses(additionalAddresses);
    _putIfNotBlank(fields, 'additional_addresses', encodedAddresses);

    final requestDocuments = documents ?? attachments;
    for (var i = 0; i < requestDocuments.length; i++) {
      final attachment = requestDocuments[i];
      fields['documents[$i][description]'] = attachment.description.trim();
      fields['documents[$i][file]'] = await MultipartFile.fromFile(
        attachment.file.path,
        filename: CustomerApiService.basename(attachment.file.path),
      );
    }

    await _client.post('customer/requests', data: FormData.fromMap(fields));
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

  void _putIfNotBlank(Map<String, dynamic> fields, String key, Object? value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return;
    fields[key] = text;
  }

  String? _encodeAdditionalAddresses(Object? additionalAddresses) {
    if (additionalAddresses == null) return null;
    if (additionalAddresses is String) return additionalAddresses;
    if (additionalAddresses is List || additionalAddresses is Map) {
      return jsonEncode(additionalAddresses);
    }
    return additionalAddresses.toString();
  }
}
