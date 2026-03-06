import 'package:kalivra/controller/prefs/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Single source of truth for the auth token. Use this instead of reading
/// from AuthCubit or the HTTP client. AuthCubit writes here on login/logout;
/// DioClient reads here via getToken.
class TokenService {
  TokenService._();

  static String? _cachedToken;
  static bool _initialized = false;

  /// Call once at app startup (e.g. in main() before runApp).
  static Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(PrefKeys.accessTokenKey);
    _initialized = true;
  }

  /// Async token for DioClient and other async callers.
  static Future<String?> getToken() async {
    if (!_initialized) await init();
    return _cachedToken;
  }

  /// Synchronous token for UI checks (e.g. is logged in). Use after init.
  static String? getTokenSync() => _cachedToken;

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefKeys.accessTokenKey, token);
    _cachedToken = token;
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PrefKeys.accessTokenKey);
    _cachedToken = null;
  }
}
