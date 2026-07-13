import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_attachment_type.dart';
import 'package:kalivra/model/association/association_link_attachment.dart';
import 'package:kalivra/model/association/association_member_profile_model.dart';
import 'package:kalivra/model/association/association_request_address.dart';
import 'package:kalivra/model/association/association_request_summary.dart';
import 'package:kalivra/model/association/association_request_type.dart';
import 'package:kalivra/model/services/api/association_api_service.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';

part 'association_link_state.dart';

class AssociationLinkCubit extends Cubit<AssociationLinkState> {
  AssociationLinkCubit() : super(AssociationLinkLoading());
  final _api = AssociationApiService();

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

  Future<void> fetchAttachmentTypes() async {
    try {
      emit(AssociationLinkLoading());
      final attachmentTypes = await _api.fetchAttachmentTypes();
      emit(AssociationAttachmentTypesFetched(attachmentTypes: attachmentTypes));
    } catch (e) {
      emit(AssociationLinkFailure(errorMessage: e.toString()));
    }
  }

  Future<void> submitLinkRequest({
    required BuildContext context,
    String customerNote = '',
    required String type,
    required String fatherName,
    required String motherName,
    required String nationalId,
    required AssociationRequestAddress permanentAddress,
    required AssociationRequestAddress currentAddress,
    required List<AssociationRequestAddress> additionalAddresses,
    String? claimedMembershipNumber,
    String? claimedPriorityNumber,
    String? claimedBuildingNumber,
    String? claimedUnitNumber,
    List<AssociationLinkAttachment> attachments = const [],
  }) async {
    final l10n = AppLocalizations.of(context)!;
      emit(AssociationLinkLoading());
    try {
      await _api.submitLinkRequest(
        customerNote: customerNote,
        type: type,
        fatherName: fatherName,
        motherName: motherName,
        nationalId: nationalId,
        permanentAddress: permanentAddress,
        currentAddress: currentAddress,
        additionalAddresses: additionalAddresses,
        claimedMembershipNumber: claimedMembershipNumber,
        claimedPriorityNumber: claimedPriorityNumber,
        claimedBuildingNumber: claimedBuildingNumber,
        claimedUnitNumber: claimedUnitNumber,
        attachments: attachments,
      );
      emit(
        AssociationLinkSubmittedSuccessfully(
          successMessage: l10n.linkRequestSentSuccessfully,
        ),
      );
      CustomSnackBar.show(context, l10n.linkRequestSentSuccessfully);
    } catch (e) {
      emit(AssociationLinkFailure(errorMessage: e.toString()));
      CustomSnackBar.show(context, e.toString());
    }
  }

  Future<void> submitNormalRequest({
    required BuildContext context,
    required String type,
    String customerNote = '',
    List<AssociationLinkAttachment> attachments = const [],
  }) async {
    final l10n = AppLocalizations.of(context)!;
      emit(AssociationLinkLoading());
    try {
      await _api.submitNormalRequest(
        type: type,
        customerNot: customerNote,
        attachments: attachments,
      );
      emit(
        AssociationLinkSubmittedSuccessfully(
          successMessage: l10n.requestSentSuccessfully,
        ),
      );
      CustomSnackBar.show(context, l10n.requestSentSuccessfully);
    } catch (e) {
      emit(AssociationLinkFailure(errorMessage: e.toString()));
      CustomSnackBar.show(context, e.toString());
    }
  }
}
