import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_link_attachment.dart';
import 'package:kalivra/model/association/association_link_request_draft.dart';
import 'package:kalivra/model/association/association_member_profile.dart';
import 'package:kalivra/model/association/association_request_summary.dart';
import 'package:kalivra/model/services/api/association_link_api_service.dart';

part 'association_link_state.dart';

class AssociationLinkCubit extends Cubit<AssociationLinkState> {
  AssociationLinkCubit() : super(AssociationLinkLoading());
  final _api = AssociationLinkApiService();

  Future<void> fetchProfile() async {
    try {
      emit(AssociationLinkLoading());
      final profileInfo = await _api.fetchProfile();
      emit(AssociationProfileFetched(memberInfo: profileInfo!));
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

  Future<void> submitRequest({
    required BuildContext context,
    required AssociationLinkRequestDraft draft,
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
    List<AssociationLinkAttachment> attachments = const [],
  }) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      emit(AssociationLinkLoading());
      await _api.submitRequest(
        draft: draft,
        fatherName: fatherName,
        motherName: motherName,
        officialGovernorate: officialGovernorate,
        officialCity: officialCity,
        officialTown: officialTown,
        officialMunicipalityVillage: officialMunicipalityVillage,
        officialStreet: officialStreet,
        officialBuilding: officialBuilding,
        permanentAddress: permanentAddress,
        phone: phone,
        attachments: attachments,
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

  Future<void> fetchDraftstRequests() async {
    try {
      emit(AssociationLinkLoading());
      final drafts = await _api.fetchDraftsRequests();
      if (drafts == null) {
        emit(AssociationLinkFailure(errorMessage: 'No draft found'));
        return;
      }
      emit(AssociationLinkDraftsFetched(drafts: drafts));
    } catch (e) {
      emit(AssociationLinkFailure(errorMessage: e.toString()));
    }
  }
}
