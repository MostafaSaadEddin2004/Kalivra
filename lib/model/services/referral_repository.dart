import 'package:shared_preferences/shared_preferences.dart';

/// Keys for local storage. Replace with API when backend is ready.
abstract class _ReferralKeys {
  static const String myReferralCode = 'referral_my_code';
  static const String pendingReferralSubmission = 'referral_pending_submission';
}

/// Handles user referral code (from API) and submission of referrer code (to API).
/// - [getMyReferralCode]: fetch current user's code from server for QR display.
/// - [submitReferralCode]: send referrer code when a new user enters it at login/signup.
class ReferralRepository {
  ReferralRepository([SharedPreferences? prefs])
      : _prefs = prefs;

  SharedPreferences? _prefs;
  static const String _mockCode = 'KLV-AHM-2024'; // Replace with API response.

  Future<SharedPreferences> get _storage async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Returns the current user's referral code from the server.
  /// Use this for the profile QR card. Replace implementation with API call.
  Future<String> getMyReferralCode() async {
    await _storage;
    final stored = _prefs!.getString(_ReferralKeys.myReferralCode);
    if (stored != null && stored.isNotEmpty) return stored;
    return _mockCode;
  }

  /// Call when user has entered a referrer's code at login or signup.
  /// Sends the code to the server so the referrer can receive their discount.
  Future<void> submitReferralCode(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;
    final storage = await _storage;
    await storage.setString(_ReferralKeys.pendingReferralSubmission, trimmed);
    // Then clear: await storage.remove(_ReferralKeys.pendingReferralSubmission);
  }

  /// Optional: sync stored referral code from API after login.
  Future<void> setMyReferralCodeFromApi(String code) async {
    final storage = await _storage;
    await storage.setString(_ReferralKeys.myReferralCode, code.trim());
  }
}
