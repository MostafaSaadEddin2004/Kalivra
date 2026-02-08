import 'package:kalivra/controllers/prefs/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStore {
  static Future<String?> getToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(PrefKeys.accessTokenKey);
  }

  static Future<void> setToken(String value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(PrefKeys.accessTokenKey, value);
    return;
  }

  static Future<void> removeToken() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(PrefKeys.accessTokenKey);
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
}
