part of 'association_link_cubit.dart';

@immutable
sealed class AssociationLinkState {}

final class AssociationLinkLoading extends AssociationLinkState {}

final class AssociationProfileFetched extends AssociationLinkState {
  final AssociationMemberProfile memberInfo;

  AssociationProfileFetched({required this.memberInfo});
}

final class AssociationLinkRequestsFetched extends AssociationLinkState {
  final List<AssociationRequestSummary> linkRequests;

  AssociationLinkRequestsFetched({required this.linkRequests});
}

final class AssociationLinkDraftsFetched extends AssociationLinkState {
  final AssociationLinkRequestDraft drafts;

  AssociationLinkDraftsFetched({required this.drafts});
}

final class AssociationLinkSubmittedSuccessfully extends AssociationLinkState {
  final String successMessage;

  AssociationLinkSubmittedSuccessfully({required this.successMessage});
}

final class AssociationLinkFailure extends AssociationLinkState {
  final String errorMessage;

  AssociationLinkFailure({required this.errorMessage});
}
