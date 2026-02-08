import 'package:shared_preferences/shared_preferences.dart';

abstract class StorePref {
  static Future<String?> getString(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  static Future<void> setString(String key, String value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(key, value);
    return;
  }

  static Future<void> clearStorage(String key) async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(key);
    return;
  }
}
