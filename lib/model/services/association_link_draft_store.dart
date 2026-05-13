import 'dart:convert';

import 'package:kalivra/controller/prefs/pref_keys.dart';
import 'package:kalivra/model/association/association_link_request_draft.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssociationLinkDraftStore {
  Future<AssociationLinkRequestDraft?> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(PrefKeys.associationLinkDraftKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return AssociationLinkRequestDraft.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveDraft(AssociationLinkRequestDraft draft) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      PrefKeys.associationLinkDraftKey,
      jsonEncode(draft.toJson()),
    );
  }

  Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PrefKeys.associationLinkDraftKey);
  }

  Future<bool> isSubmitted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(PrefKeys.associationLinkSubmittedKey) ?? false;
  }

  Future<void> markSubmitted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefKeys.associationLinkSubmittedKey, true);
  }

  Future<void> clearSubmitted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PrefKeys.associationLinkSubmittedKey);
  }
}
