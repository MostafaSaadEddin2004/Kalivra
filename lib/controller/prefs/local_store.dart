import 'package:kalivra/controller/prefs/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStore {
  static Future<String?> getToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(PrefKeys.tokenKey);
  }

  static Future<void> setToken(String value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(PrefKeys.tokenKey, value);
    return;
  }

  static Future<void> removeToken() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(PrefKeys.tokenKey);
    return;
  }

  static Future<String?> getUserId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(PrefKeys.userIdKey);
  }

  static Future<void> setUserId(String value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(PrefKeys.userIdKey, value);
    return;
  }

  static Future<void> removeUserId() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(PrefKeys.userIdKey);
    return;
  }

  static Future<String?> getFCMToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(PrefKeys.fcmTokenKey);
  }

  static Future<void> setFCMToken(String value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(PrefKeys.fcmTokenKey, value);
    return;
  }

  static Future<void> removeFCMToken() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(PrefKeys.fcmTokenKey);
    return;
  }

  static Future<String?> getIntroPass() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(PrefKeys.introPassKey);
  }

  static Future<void> setIntroPass(String value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(PrefKeys.introPassKey, value);
    return;
  }

  static Future<int?> getCheckoutStep() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(PrefKeys.checkoutStepKey);
  }

  static Future<void> setCheckoutStep(int value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(PrefKeys.checkoutStepKey, value);
  }

  static Future<String?> getCheckoutShippingMethod() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(PrefKeys.checkoutShippingMethodKey);
  }

  static Future<void> setCheckoutShippingMethod(String value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(PrefKeys.checkoutShippingMethodKey, value);
  }

  static Future<String?> getCheckoutPaymentMethod() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(PrefKeys.checkoutPaymentMethodKey);
  }

  static Future<void> setCheckoutPaymentMethod(String value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(PrefKeys.checkoutPaymentMethodKey, value);
  }

  static Future<void> resetCheckoutProgress() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(PrefKeys.checkoutStepKey);
    await sp.remove(PrefKeys.checkoutShippingMethodKey);
    await sp.remove(PrefKeys.checkoutPaymentMethodKey);
  }
}
