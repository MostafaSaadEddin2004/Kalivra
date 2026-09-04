import 'package:dio/dio.dart';
import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/association/association_announcement_model.dart';
import 'package:kalivra/model/app_info/faq_item_model.dart';
import 'package:kalivra/model/association/association_attachment_type.dart';
import 'package:kalivra/model/association/association_link_attachment.dart';
import 'package:kalivra/model/association/association_member_profile_model.dart';
import 'package:kalivra/model/association/association_news_model.dart';
import 'package:kalivra/model/association/association_request_address.dart';
import 'package:kalivra/model/association/association_request_summary.dart';
import 'package:kalivra/model/association/association_request_type.dart';
import 'package:kalivra/model/services/api/customer_api_service.dart';

class AssociationApiService {
  AssociationApiService();

  final DioClient _client = DioClient();

  Future<List<AssociationRequestSummary>> fetchRequests() async {
    final res = await _client.get('customer/requests');
    final body = res.data['data'];
    final data = (body as List)
        .map((e) => AssociationRequestSummary.fromJson(e))
        .toList();
    return data;
  }

  Future<List<AssociationRequestType>> fetchRequestTypes() async {
    final res = await _client.get('customer/requests/types');
    final body = res.data['data'];
    final data = (body as List)
        .map((e) => AssociationRequestType.fromJson(e))
        .toList();
    return data;
  }

  Future<List<AssociationAttachmentType>> fetchAttachmentTypes() async {
    final res = await _client.get('customer/profile/documents/definitions');
    final body = res.data['data'];
    final data = (body as List)
        .map((e) => AssociationAttachmentType.fromJson(e))
        .toList();
    return data;
  }

  Future<void> submitLinkRequest({
    String customerNote = '',
    String type = 'association-membership',
    required String firstName,
    required String fatherName,
    required String lastName,
    required String motherName,
    required String nationalId,
    required AssociationRequestAddress permanentAddress,
    required AssociationRequestAddress currentAddress,
    required List<AssociationRequestAddress> additionalAddresses,
    String? claimedMembershipNumber,
    String? claimedPriorityNumber,
    String? claimedBuildingNumber,
    List<AssociationLinkAttachment> attachments = const [],
  }) async {
    final data = <String, dynamic>{
      'first_name': firstName,
      'father_name': fatherName,
      'last_name': lastName,
      'mother_name': motherName,
      'national_id': nationalId,
      'addresses': {
        'permanent': permanentAddress.toMap(),
        'current': currentAddress.toMap(),
        'additional': additionalAddresses
            .map((address) => address.toMap(includeDetails: true))
            .toList(),
      },
      'customer_note': customerNote,
    };

    void addOptionalField(String key, String? value) {
      final trimmedValue = value?.trim();
      if (trimmedValue == null || trimmedValue.isEmpty) return;
      data[key] = trimmedValue;
    }

    addOptionalField('claimed_membership_number', claimedMembershipNumber);
    addOptionalField('claimed_priority_number', claimedPriorityNumber);
    addOptionalField('claimed_building_number', claimedBuildingNumber);

    final requestDocuments = attachments;
    for (var i = 0; i < requestDocuments.length; i++) {
      final attachment = requestDocuments[i];
      addOptionalField(
        'documents[$i][document_definition_id]',
        attachment.attachmentTypeId,
      );
      data['documents[$i][document]'] = await MultipartFile.fromFile(
        attachment.file.path,
        filename: CustomerApiService.basename(attachment.file.path),
      );
    }
    try {
      final endpointType = type.replaceAll('_', '-');
      await _client.post(
        'customer/requests/$endpointType',
        data: FormData.fromMap(data),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> submitNormalRequest({
    required String type,
    required String customerNote,
    List<AssociationLinkAttachment> attachments = const [],
  }) async {
    final data = <String, dynamic>{'type': type, 'customer_note': customerNote};
    final requestDocuments = attachments;
    for (var i = 0; i < requestDocuments.length; i++) {
      final attachment = requestDocuments[i];
      data['documents[$i][attachment_type_id]'] = attachment.attachmentTypeId;
      data['documents[$i][file]'] = await MultipartFile.fromFile(
        attachment.file.path,
        filename: CustomerApiService.basename(attachment.file.path),
      );
    }
    try {
      await _client.post('customer/requests', data: FormData.fromMap(data));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<AssociationMemberProfileModel> fetchProfile() async {
    final res = await _client.get('customer/association/member');
    final body = res.data;
    final data = body['data'];
    return AssociationMemberProfileModel.fromJson(data);
  }

  Future<List<AssociationNewsModel>> getNews() async {
    final res = await _client.get('customer/association/news');
    final data = res.data['data'];
    if (data is! List) return const [];
    final news =
        data
            .whereType<Map>()
            .map(
              (item) => AssociationNewsModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .where((item) => item.text.isNotEmpty)
            .toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return news;
  }

  Future<List<FaqItemModel>> getFaqs() async {
    final res = await _client.get('faq/association');
    final data = res.data['data'];
    if (data is! List) return const [];
    final faqs =
        data
            .whereType<Map>()
            .map(
              (item) => FaqItemModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .where(
              (item) =>
                  item.question.trim().isNotEmpty &&
                  item.answer.trim().isNotEmpty,
            )
            .toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return faqs;
  }

  Future<List<AssociationAnnouncementModel>> getAnnouncements({
    int perPage = 15,
  }) async {
    final res = await _client.get(
      'customer/association/reports',
      queryParameters: {'per_page': perPage},
    );
    final data = res.data['data'];
    if (data is! List) return const [];

    return data
        .whereType<Map>()
        .map(
          (item) => AssociationAnnouncementModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<AssociationAnnouncementModel> getAnnouncement(int id) async {
    final res = await _client.get('customer/association/reports/$id');
    final data = res.data['data'];
    if (data is Map) {
      return AssociationAnnouncementModel.fromJson(
        Map<String, dynamic>.from(data),
      );
    }

    return AssociationAnnouncementModel.fromJson(
      Map<String, dynamic>.from(res.data as Map),
    );
  }
}
