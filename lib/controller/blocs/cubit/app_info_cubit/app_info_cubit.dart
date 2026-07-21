import 'package:bloc/bloc.dart';
import 'package:kalivra/model/app_info/about_api_model.dart';
import 'package:kalivra/model/app_info/contact_api_model.dart';
import 'package:kalivra/model/app_info/faq_item_model.dart';
import 'package:kalivra/model/app_info/privacy_policy_api_model.dart';
import 'package:kalivra/model/app_info/terms_conditions_api_model.dart';
import 'package:kalivra/model/services/api/app_info_services.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
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

  Future<void> getKalivraFaqs() async {
    try {
      emit(AppInfoLoading());
      final faqs = await AppInfoServices().getKalivraFaqs();
      emit(AppFaqsFetched(faqs: faqs));
    } catch (e) {
      emit(AppInfoFailure(errorMessage: e.toString()));
    }
  }

  Future<void> checkRatingLoginStatus() async {
    emit(AppRatingAuthChecking());
    final token = await LocalStore.getToken();
    if (token == null || token.isEmpty) {
      emit(AppRatingLoginRequired());
      return;
    }

    emit(AppRatingReady());
  }

  Future<void> postAppRating({
    required int rating,
    required String comment,
  }) async {
    try {
      final token = await LocalStore.getToken();
      if (token == null || token.isEmpty) {
        emit(AppRatingLoginRequired());
        return;
      }

      emit(AppRatingSubmitting());
      await AppInfoServices().postAppRating(rating: rating, comment: comment);
      emit(AppRatingSubmitted());
    } catch (e) {
      emit(AppInfoFailure(errorMessage: e.toString()));
    }
  }
}
