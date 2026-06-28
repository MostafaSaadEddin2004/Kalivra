import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/services/association_link_draft_store.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class AssociationDraftsScreen extends StatefulWidget {
  const AssociationDraftsScreen({super.key});

  @override
  State<AssociationDraftsScreen> createState() =>
      _AssociationDraftsScreenState();
}

class _AssociationDraftsScreenState extends State<AssociationDraftsScreen> {
  final _store = AssociationLinkDraftStore();
  late Future<List<AssociationLinkDraftEntry>> _draftsFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final future = _store.loadDrafts();
    setState(() {
      _draftsFuture = future;
    });
    await future;
  }

  Future<void> _deleteDraft(AssociationLinkDraftEntry entry) async {
    await _store.deleteDraft(entry.id);
    await _reload();
    if (!mounted) return;
    CustomSnackBar.show(
      context,
      AppLocalizations.of(context)!.associationLinkDraftDeleted,
    );
  }

  Future<void> _confirmDelete(AssociationLinkDraftEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.associationLinkDeleteDraftTitle),
        content: Text(l10n.associationLinkDeleteDraftConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.back),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) await _deleteDraft(entry);
  }

  Future<void> _openDraft(AssociationLinkDraftEntry entry) async {
    // Navigate to the link request screen with the draft's ID.
    // The screen will load the draft and allow editing / submitting.
    await context.push(
      AppRoutes.associationLinkRequest,
      extra: {'draftId': entry.id},
    );
    // Reload in case the draft was submitted (deleted) or updated.
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.associationLinkDraftsTitle),
      body: FutureBuilder<List<AssociationLinkDraftEntry>>(
        future: _draftsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final drafts = snapshot.data ?? [];

          if (drafts.isEmpty) {
            return const _EmptyState();
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
              itemCount: drafts.length,
              itemBuilder: (context, index) {
                final entry = drafts[index];
                return _DraftCard(
                  entry: entry,
                  isDark: isDark,
                  onTap: () => _openDraft(entry),
                  onDelete: () => _confirmDelete(entry),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push(AppRoutes.associationLinkRequest);
          await _reload();
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(AppLocalizations.of(context)!.associationLinkNewDraft),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Draft card
// ─────────────────────────────────────────────────────────────────────────────

class _DraftCard extends StatelessWidget {
  const _DraftCard({
    required this.entry,
    required this.isDark,
    required this.onTap,
    required this.onDelete,
  });

  final AssociationLinkDraftEntry entry;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final titleColor = isDark ? AppColors.offWhite : AppColors.burgundy;
    final subtitleColor = isDark
        ? AppColors.taupe
        : AppColors.burgundy.withValues(alpha: 0.7);
    final borderColor = isDark
        ? AppColors.taupe.withValues(alpha: 0.2)
        : AppColors.burgundy.withValues(alpha: 0.12);

    // Build a meaningful subtitle from the draft data.
    final parts = <String>[
      if (entry.draft.governorate.isNotEmpty) entry.draft.governorate,
      if (entry.draft.membershipNumber.isNotEmpty)
        '${l10n.associationLinkMembershipNumber}: ${entry.draft.membershipNumber}',
    ];
    final subtitle = parts.isNotEmpty
        ? parts.join(' · ')
        : l10n.associationLinkNoData;

    final dateLabel = DateFormat.yMMMd().add_jm().format(
      entry.savedAt.toLocal(),
    );

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 28.r,
        ),
      ),
      confirmDismiss: (_) async {
        onDelete();
        return false; // We handle deletion ourselves via dialog.
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        color: isDark
            ? AppColors.burgundy.withValues(alpha: 0.08)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: borderColor),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Draft icon
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.burgundy.withValues(alpha: 0.25)
                        : AppColors.burgundy.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.edit_note_rounded,
                    color: isDark ? AppColors.goldLight : AppColors.burgundy,
                    size: 26.r,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 13.r,
                            color: subtitleColor,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              dateLabel,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: subtitleColor,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.chevron_right_rounded,
                  color: subtitleColor,
                  size: 22.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.drafts_outlined,
              size: 72.r,
              color: (isDark ? AppColors.taupe : AppColors.burgundy).withValues(
                alpha: 0.4,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              l10n.localeName == 'ar'
                  ? 'لا توجد مسودات مرسلة.'
                  : 'There are no drafts sent.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.taupe : AppColors.burgundy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
