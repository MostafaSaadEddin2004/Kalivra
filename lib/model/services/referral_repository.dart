import 'package:shared_preferences/shared_preferences.dart';

abstract class _ReferralKeys {
  static const String myReferralCode = 'referral_my_code';
  static const String pendingReferralSubmission = 'referral_pending_submission';
}

class ReferralRepository {
  ReferralRepository([SharedPreferences? prefs])
      : _prefs = prefs;

  SharedPreferences? _prefs;
  static const String _mockCode = 'KLV-AHM-2024'; 

  Future<SharedPreferences> get _storage async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<String> getMyReferralCode() async {
    await _storage;
    final stored = _prefs!.getString(_ReferralKeys.myReferralCode);
    if (stored != null && stored.isNotEmpty) return stored;
    return _mockCode;
  }

Future<void> submitReferralCode(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;
    final storage = await _storage;
    await storage.setString(_ReferralKeys.pendingReferralSubmission, trimmed);
  }

Future<void> setMyReferralCodeFromApi(String code) async {
    final storage = await _storage;
    await storage.setString(_ReferralKeys.myReferralCode, code.trim());
  }
}
