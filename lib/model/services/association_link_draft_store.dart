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

  /// A human-readable label derived from the draft's content.
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
      savedAt: DateTime.tryParse(json['savedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class AssociationLinkDraftStore {
  static const String _draftsKey = 'association_link_drafts_v2';

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<List<AssociationLinkDraftEntry>> loadDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map>()
          .map((e) => AssociationLinkDraftEntry.fromJson(
                Map<String, dynamic>.from(e),
              ))
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

  // ── Write ─────────────────────────────────────────────────────────────────

  /// Saves (or updates) a draft. Returns the entry with its ID.
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

  // ── Submitted flag (per draft) ────────────────────────────────────────────

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

  // ── Private ───────────────────────────────────────────────────────────────

  Future<void> _persist(List<AssociationLinkDraftEntry> drafts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _draftsKey,
      jsonEncode(drafts.map((e) => e.toJson()).toList()),
    );
  }

  // ── Legacy migration (single draft → multi draft) ─────────────────────────
  // Call once at app start or inside _bootstrap of the link-request screen.
  Future<void> migrateLegacyDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final legacyKey = PrefKeys.associationLinkDraftKey;
    final raw = prefs.getString(legacyKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final legacyDraft = AssociationLinkRequestDraft.fromJson(decoded);
      await saveDraft(legacyDraft);
      await prefs.remove(legacyKey);
    } catch (_) {
      await prefs.remove(legacyKey);
    }
  }
}
