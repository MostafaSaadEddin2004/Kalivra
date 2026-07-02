import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_link_attachment.dart';
import 'package:kalivra/model/association/association_member_profile.dart';
import 'package:kalivra/model/association/association_request_summary.dart';
import 'package:kalivra/model/association/association_request_type.dart';
import 'package:kalivra/model/services/api/association_link_api_service.dart';

part 'association_link_state.dart';

class AssociationLinkCubit extends Cubit<AssociationLinkState> {
  AssociationLinkCubit() : super(AssociationLinkLoading());
  final _api = AssociationLinkApiService();

  Future<void> fetchProfile() async {
    try {
      emit(AssociationLinkLoading());
      final profileInfo = await _api.fetchProfile();
      emit(AssociationProfileFetched(memberInfo: profileInfo));
    } catch (e) {
      emit(AssociationLinkFailure(errorMessage: e.toString()));
    }
  }

  Future<void> fetchRequests() async {
    try {
      emit(AssociationLinkLoading());
      final requests = await _api.fetchRequests();
      emit(AssociationLinkRequestsFetched(linkRequests: requests));
    } catch (e) {
      emit(AssociationLinkFailure(errorMessage: e.toString()));
    }
  }

  Future<void> fetchRequestTypes() async {
    try {
      emit(AssociationLinkLoading());
      final requestTypes = await _api.fetchRequestTypes();
      emit(AssociationRequestTypesFetched(requestTypes: requestTypes));
    } catch (e) {
      emit(AssociationLinkFailure(errorMessage: e.toString()));
    }
  }

  Future<void> submitRequest({
    required BuildContext context,
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
    final l10n = AppLocalizations.of(context)!;
    try {
      emit(AssociationLinkLoading());
      await _api.submitRequest(
        customerNote: customerNote,
        type: type,
        membershipId: membershipId,
        requestedMembershipType: requestedMembershipType,
        fatherName: fatherName,
        motherName: motherName,
        nationalId: nationalId,
        permanentCapitalId: permanentCapitalId,
        permanentCityId: permanentCityId,
        permanentTownId: permanentTownId,
        permanentVillageId: permanentVillageId,
        officialStreet: officialStreet,
        officialBuilding: officialBuilding,
        permanentAddress: permanentAddress,
        phone: phone,
        additionalAddresses: additionalAddresses,
        claimedMembershipNumber: claimedMembershipNumber,
        claimedPriorityNumber: claimedPriorityNumber,
        claimedBuildingNumber: claimedBuildingNumber,
        claimedUnitNumber: claimedUnitNumber,
        attachments: attachments,
        documents: documents,
      );
      emit(
        AssociationLinkSubmittedSuccessfully(
          successMessage: l10n.linkRequestSentSuccessfully,
        ),
      );
    } catch (e) {
      emit(AssociationLinkFailure(errorMessage: e.toString()));
    }
  }
}
