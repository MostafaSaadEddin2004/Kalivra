import 'dart:convert';

import 'package:kalivra/controller/prefs/pref_keys.dart';
import 'package:kalivra/model/association/association_link_request_draft.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssociationLinkDraftEntry {
  const AssociationLinkDraftEntry({
    required this.id,
    required this.draft,
    required this.savedAt,
  });

  final String id;
  final AssociationLinkRequestDraft draft;
  final DateTime savedAt;

  String get label {
    final parts = [
      draft.firstName,
      draft.fatherName,
    ].where((s) => s.trim().isNotEmpty).toList();
    return parts.isNotEmpty ? parts.join(' ') : id;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'draft': draft.toJson(),
    'savedAt': savedAt.toIso8601String(),
  };

  factory AssociationLinkDraftEntry.fromJson(Map<String, dynamic> json) {
    return AssociationLinkDraftEntry(
      id: json['id'] as String,
      draft: AssociationLinkRequestDraft.fromJson(
        Map<String, dynamic>.from(json['draft'] as Map),
      ),
      savedAt:
          DateTime.tryParse(json['savedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class AssociationLinkDraftStore {
  static const String _draftsKey = 'association_link_drafts_v2';

  Future<List<AssociationLinkDraftEntry>> loadDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map>()
          .map(
            (e) => AssociationLinkDraftEntry.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .where((entry) => _hasUserDraftContent(entry.draft))
          .toList()
        ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    } catch (_) {
      return [];
    }
  }

  Future<AssociationLinkDraftEntry?> loadDraft(String id) async {
    final drafts = await loadDrafts();
    try {
      return drafts.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<AssociationLinkDraftEntry> saveDraft(
    AssociationLinkRequestDraft draft, {
    String? id,
  }) async {
    final drafts = await loadDrafts();
    final draftId = id ?? DateTime.now().microsecondsSinceEpoch.toString();
    final entry = AssociationLinkDraftEntry(
      id: draftId,
      draft: draft,
      savedAt: DateTime.now(),
    );

    final idx = drafts.indexWhere((e) => e.id == draftId);
    if (idx >= 0) {
      drafts[idx] = entry;
    } else {
      drafts.insert(0, entry);
    }

    await _persist(drafts);
    return entry;
  }

  Future<void> deleteDraft(String id) async {
    final drafts = await loadDrafts();
    drafts.removeWhere((e) => e.id == id);
    await _persist(drafts);
  }

  Future<void> clearAllDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftsKey);
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

  Future<void> _persist(List<AssociationLinkDraftEntry> drafts) async {
    final prefs = await SharedPreferences.getInstance();
    final displayableDrafts = drafts
        .where((entry) => _hasUserDraftContent(entry.draft))
        .toList();
    await prefs.setString(
      _draftsKey,
      jsonEncode(displayableDrafts.map((e) => e.toJson()).toList()),
    );
  }

  bool _hasUserDraftContent(AssociationLinkRequestDraft draft) {
    return [
      draft.firstName,
      draft.kunya,
      draft.fatherName,
      draft.motherName,
      draft.governorate,
      draft.city,
      draft.town,
      draft.municipality,
      draft.street,
      draft.building,
      draft.permanentAddress,
      draft.whatsApp,
      draft.email,
      draft.membershipNumber,
      draft.priorityNumber,
      draft.projectName,
      draft.housingUnit,
      draft.totalPayments,
    ].any((value) => value.trim().isNotEmpty);
  }
}
