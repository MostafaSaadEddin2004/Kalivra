import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/app_info/about_api_model.dart';
import 'package:kalivra/model/app_info/contact_api_model.dart';
import 'package:kalivra/model/app_info/privacy_policy_api_model.dart';
import 'package:kalivra/model/app_info/terms_conditions_api_model.dart';

class AppInfoServices {
  AppInfoServices({DioClient? client}) : _client = client ?? DioClient();

  final DioClient _client;

  Future<AboutApiModel> getAboutInfo() async {
    final res = await _client.get('content/about');
    return AboutApiModel.fromJson((res.data['data']));
  }

  Future<PrivacyPolicyApiModel> getPrivacyPolicyInfo() async {
    final res = await _client.get('content/privacy-policy');
    return PrivacyPolicyApiModel.fromJson((res.data['data']));
  }

  Future<TermsConditionsApiModel> getTermsConditionsInfo() async {
    final res = await _client.get('content/terms-conditions');
    return TermsConditionsApiModel.fromJson((res.data['data']));
  }

  Future<ContactApiModel> getContactInfo() async {
    final res = await _client.get('contact');
    return ContactApiModel.fromJson((res.data['data']));
  }

  Future<void> postAppRating({
    required int rating,
    required String comment,
  }) async {
    await _client.post(
      'customer/app-rating',
      data: {'rating': rating, 'comment': comment},
    );
  }
}
