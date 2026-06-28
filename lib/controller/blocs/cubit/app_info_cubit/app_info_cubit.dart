import 'package:bloc/bloc.dart';
import 'package:kalivra/model/app_info/about_api_model.dart';
import 'package:kalivra/model/app_info/contact_api_model.dart';
import 'package:kalivra/model/app_info/privacy_policy_api_model.dart';
import 'package:kalivra/model/app_info/terms_conditions_api_model.dart';
import 'package:kalivra/model/services/api/app_info_services.dart';
import 'package:meta/meta.dart';

part 'app_info_state.dart';

class AppInfoCubit extends Cubit<AppInfoState> {
  AppInfoCubit() : super(AppInfoLoading());

  Future<void> getAboutInfo() async {
    try {
      emit(AppInfoLoading());
      final aboutData = await AppInfoServices().getAboutInfo();
      emit(AppAboutFetched(aboutData: aboutData));
    } catch (e) {
      emit(AppInfoFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getPrivacyPolicyInfo() async {
    try {
      emit(AppInfoLoading());
      final privacyPolicyData = await AppInfoServices().getPrivacyPolicyInfo();
      emit(AppPrivacyPolicyFetched(privacyPolicyData: privacyPolicyData));
    } catch (e) {
      emit(AppInfoFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getTermsConditionsInfo() async {
    try {
      emit(AppInfoLoading());
      final termaConditionsData = await AppInfoServices()
          .getTermsConditionsInfo();
      emit(AppTermsConditionsFetched(termaConditionsData: termaConditionsData));
    } catch (e) {
      emit(AppInfoFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getContactInfo() async {
    try {
      emit(AppInfoLoading());
      final contactData = await AppInfoServices().getContactInfo();
      emit(AppContactFetched(contactData: contactData));
    } catch (e) {
      emit(AppInfoFailure(errorMessage: e.toString()));
    }
  }
}
