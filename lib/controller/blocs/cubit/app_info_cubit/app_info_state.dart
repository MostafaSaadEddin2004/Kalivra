part of 'app_info_cubit.dart';

@immutable
sealed class AppInfoState {}

final class AppInfoLoading extends AppInfoState {}

final class AppAboutFetched extends AppInfoState {
  final AboutApiModel aboutData;

  AppAboutFetched({required this.aboutData});
}

final class AppContactFetched extends AppInfoState {
  final ContactApiModel contactData;

  AppContactFetched({required this.contactData});
}

final class AppPrivacyPolicyFetched extends AppInfoState {
  final PrivacyPolicyApiModel privacyPolicyData;

  AppPrivacyPolicyFetched({required this.privacyPolicyData});
}

final class AppTermsConditionsFetched extends AppInfoState {
  final TermsConditionsApiModel termaConditionsData;

  AppTermsConditionsFetched({required this.termaConditionsData});
}

final class AppRatingAuthChecking extends AppInfoState {}

final class AppRatingReady extends AppInfoState {}

final class AppRatingLoginRequired extends AppInfoState {}

final class AppRatingSubmitting extends AppInfoState {}

final class AppRatingSubmitted extends AppInfoState {}

final class AppInfoFailure extends AppInfoState {
  final String errorMessage;

  AppInfoFailure({required this.errorMessage});
}
