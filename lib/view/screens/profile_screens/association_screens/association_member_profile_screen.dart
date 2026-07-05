import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/assoiciation_link_cubit/association_link_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_member_profile_model.dart';
import 'package:kalivra/view/widgets/association/association_form_section.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class AssociationMemberProfileScreen extends StatefulWidget {
  const AssociationMemberProfileScreen({super.key});

  @override
  State<AssociationMemberProfileScreen> createState() =>
      _AssociationMemberProfileScreenState();
}

class _AssociationMemberProfileScreenState
    extends State<AssociationMemberProfileScreen> {
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AssociationLinkCubit>().fetchProfile();
    });
  }

  Future<void> _reload() async {
    await context.read<AssociationLinkCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: ScreenAppBar(
        title: l10n.associationMemberProfileTitle,
        actions: [
          BlocBuilder<AssociationLinkCubit, AssociationLinkState>(
            builder: (context, state) {
              switch (state) {
                case AssociationProfileFetched():
                  final data = state.memberInfo;
                  return PopupMenuButton<
                    _AccosiciationMemberProfileMenuActions
                  >(
                    position: PopupMenuPosition.under,
                    icon: const Icon(Icons.menu_rounded),
                    onSelected: (value) {
                      switch (value) {
                        case _AccosiciationMemberProfileMenuActions
                            .linkRequests:
                          context.push(AppRoutes.associationSubmittedRequests);
                          break;
                        case _AccosiciationMemberProfileMenuActions
                            .requestsAndServices:
                          context.push(
                            AppRoutes.associationRequestsAndServices,
                          );
                          break;
                        case _AccosiciationMemberProfileMenuActions
                            .associationContactUs:
                          context.push(AppRoutes.associationContactUs);
                          break;
                        case _AccosiciationMemberProfileMenuActions
                            .frequentlyAskedQuestion:
                          context.push(AppRoutes.associationFaq);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      if (data.isAssociationMember)
                        PopupMenuItem(
                          value: _AccosiciationMemberProfileMenuActions
                              .requestsAndServices,
                          child: Row(
                            children: [
                              Icon(
                                Icons.link_rounded,
                                size: 20.r,
                                color: theme.colorScheme.onTertiaryFixed,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.associationRequestsAndServices,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      PopupMenuItem(
                        value:
                            _AccosiciationMemberProfileMenuActions.linkRequests,
                        child: Row(
                          children: [
                            Icon(
                              Icons.upload_file_rounded,
                              size: 20.r,
                              color: theme.colorScheme.onTertiaryFixed,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.linkRequestsScreen,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),

                      PopupMenuItem(
                        value: _AccosiciationMemberProfileMenuActions
                            .associationContactUs,
                        child: Row(
                          children: [
                            Icon(
                              Icons.question_answer_outlined,
                              size: 20.r,
                              color: theme.colorScheme.onTertiaryFixed,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.associationContactUs,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: _AccosiciationMemberProfileMenuActions
                            .frequentlyAskedQuestion,
                        child: Row(
                          children: [
                            Icon(
                              Icons.help_rounded,
                              size: 20.r,
                              color: theme.colorScheme.onTertiaryFixed,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.frequentlyAskedQuestion,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                default:
                  return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<AssociationLinkCubit, AssociationLinkState>(
        builder: (context, state) {
          if (state is AssociationLinkLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AssociationLinkFailure) {
            return _MessageState(
              icon: Icons.error_outline_rounded,
              message: l10n.associationMemberLoadFailed,
              actionLabel: l10n.retry,
              onAction: _reload,
            );
          }
          if (state is! AssociationProfileFetched) {
            return _MessageState(
              icon: Icons.link_off_rounded,
              message: l10n.associationMemberProfileEmpty,
              actionLabel: l10n.associationMemberProfileLinkRequest,
              onAction: () =>
                  context.push(AppRoutes.associationRequestsAndServices),
            );
          }

          final profile = state.memberInfo;
          if (!profile.isAssociationMember) {
            return _MessageState(
              icon: Icons.link_off_rounded,
              message: l10n.associationMemberProfileEmpty,
              actionLabel: l10n.associationRequestsAndServices,
              onAction: () =>
                  context.push(AppRoutes.associationRequestsAndServices),
            );
          }

          final years = _resolveYears(profile);
          final selectedYear = _selectedYear ?? years.firstOrNull;
          final filteredInstallments = _filterByYear(
            profile.installments,
            selectedYear,
            (item) => item.year,
          );
          final filteredOtherPayments = _filterByYear(
            profile.otherPayments,
            selectedYear,
            (item) => item.year,
          );

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
              children: [
                _ProfileHeaderCard(profile: profile, isDark: isDark),
                SizedBox(height: 16.h),
                _ProgressCard(
                  title: l10n.associationMemberMembershipStatus,
                  value: profile.membershipStatusPercent,
                  color: AppColors.burgundy,
                ),
                SizedBox(height: 12.h),
                _ProgressCard(
                  title: l10n.associationMemberPaymentCommitment,
                  value: profile.paymentCommitmentPercent,
                  color: AppColors.goldDark,
                ),
                SizedBox(height: 16.h),
                AssociationFormSection(
                  title: l10n.associationLinkContactSection,
                  icon: Icons.contact_phone_outlined,
                  children: [
                    _InfoRow(
                      label: l10n.associationLinkFirstName,
                      value: profile.personal.fullName,
                    ),
                    _InfoRow(
                      label: l10n.associationLinkMembershipNumber,
                      value: profile.personal.membershipNumber,
                    ),
                    _InfoRow(
                      label: l10n.associationLinkMobile,
                      value: profile.personal.mobile,
                    ),
                    _InfoRow(
                      label: l10n.associationLinkWhatsApp,
                      value: profile.personal.whatsApp,
                    ),
                    _InfoRow(
                      label: l10n.associationLinkEmail,
                      value: profile.personal.email,
                    ),
                    _InfoRow(
                      label: l10n.associationMemberCurrentAddress,
                      value: profile.personal.currentAddress,
                    ),
                    _InfoRow(
                      label: l10n.associationLinkPermanentAddress,
                      value: profile.personal.permanentAddress,
                    ),
                  ],
                ),
                AssociationFormSection(
                  title: l10n.associationLinkMembershipSection,
                  icon: Icons.badge_outlined,
                  children: [
                    _InfoRow(
                      label: l10n.associationLinkPriorityNumber,
                      value: profile.personal.priorityNumber,
                    ),
                    _InfoRow(
                      label: l10n.associationLinkProjectName,
                      value: profile.personal.projectName,
                    ),
                    _InfoRow(
                      label: l10n.associationLinkHousingUnit,
                      value: profile.personal.housingUnit,
                    ),
                    _InfoRow(
                      label: l10n.associationLinkGovernorate,
                      value: profile.personal.governorate,
                    ),
                    _InfoRow(
                      label: l10n.associationLinkCity,
                      value: profile.personal.city,
                    ),
                    _InfoRow(
                      label: l10n.associationLinkTown,
                      value: profile.personal.town,
                    ),
                    _InfoRow(
                      label: l10n.associationLinkVillage,
                      value: profile.personal.village,
                    ),
                    _InfoRow(
                      label: l10n.associationLinkStreet,
                      value: profile.personal.street,
                    ),
                    _InfoRow(
                      label: l10n.associationLinkBuilding,
                      value: profile.personal.building,
                    ),
                  ],
                ),
                if (years.isNotEmpty) ...[
                  _SectionTitle(
                    title: l10n.associationMemberPaymentsByYear,
                    icon: Icons.calendar_month_outlined,
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: years.map((year) {
                      final selected = year == selectedYear;
                      return FilterChip(
                        label: Text(year.toString()),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedYear = year),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h),
                ],
                AssociationFormSection(
                  title: l10n.associationMemberFinancialSummary,
                  icon: Icons.account_balance_wallet_outlined,
                  children: [
                    _SummaryTile(
                      label: l10n.associationMemberTotalAmount,
                      value: _formatMoney(profile.financialSummary.totalAmount),
                    ),
                    _SummaryTile(
                      label: l10n.associationMemberPaidAmount,
                      value: _formatMoney(profile.financialSummary.paidAmount),
                    ),
                    _SummaryTile(
                      label: l10n.associationMemberRemainingInstallments,
                      value: profile.financialSummary.remainingInstallments
                          .toString(),
                    ),
                  ],
                ),
                _DataSection(
                  title: l10n.associationMemberInstallments,
                  icon: Icons.payments_outlined,
                  emptyMessage: l10n.associationMemberNoData,
                  rows: filteredInstallments.isEmpty
                      ? const []
                      : filteredInstallments
                            .map(
                              (item) => [
                                item.label,
                                _formatMoney(item.amount),
                                item.date,
                                item.status,
                                item.notes,
                              ],
                            )
                            .toList(),
                  headers: [
                    l10n.associationMemberPayment,
                    l10n.associationMemberAmount,
                    l10n.associationMemberDate,
                    l10n.associationMemberStatus,
                    l10n.associationMemberNotes,
                  ],
                ),
                _DataSection(
                  title: l10n.associationMemberOtherPayments,
                  icon: Icons.receipt_long_outlined,
                  emptyMessage: l10n.associationMemberNoData,
                  rows: filteredOtherPayments.isEmpty
                      ? const []
                      : filteredOtherPayments
                            .map(
                              (item) => [
                                _formatMoney(item.amount),
                                item.date,
                                item.method,
                                item.bank,
                                item.receipt,
                                item.notes,
                              ],
                            )
                            .toList(),
                  headers: [
                    l10n.associationMemberAmount,
                    l10n.associationMemberDate,
                    l10n.associationMemberMethod,
                    l10n.associationMemberBank,
                    l10n.associationMemberReceipt,
                    l10n.associationMemberNotes,
                  ],
                ),
                _DataSection(
                  title: l10n.associationMemberNotifications,
                  icon: Icons.notifications_outlined,
                  emptyMessage: l10n.associationMemberNoData,
                  rows: profile.notifications
                      .map(
                        (item) => [
                          item.date,
                          item.type,
                          item.title,
                          item.isRead
                              ? l10n.associationMemberReadStatus
                              : l10n.associationMemberUnread,
                        ],
                      )
                      .toList(),
                  headers: [
                    l10n.associationMemberDate,
                    l10n.associationMemberType,
                    l10n.associationMemberTitle,
                    l10n.associationMemberRead,
                  ],
                ),
                _DataSection(
                  title: l10n.associationMemberEvents,
                  icon: Icons.event_outlined,
                  emptyMessage: l10n.associationMemberNoData,
                  rows: profile.events
                      .map(
                        (item) => [
                          item.date,
                          item.title,
                          item.location,
                          item.status,
                        ],
                      )
                      .toList(),
                  headers: [
                    l10n.associationMemberDate,
                    l10n.associationMemberEvent,
                    l10n.associationMemberLocation,
                    l10n.associationMemberStatus,
                  ],
                ),
                _DataSection(
                  title: l10n.associationMemberMeasurements,
                  icon: Icons.straighten_outlined,
                  emptyMessage: l10n.associationMemberNoData,
                  rows: profile.measurements
                      .map((item) => [item.date, item.value, item.notes])
                      .toList(),
                  headers: [
                    l10n.associationMemberDate,
                    l10n.associationMemberValue,
                    l10n.associationMemberNotes,
                  ],
                ),
                AssociationFormSection(
                  title: l10n.associationMemberAttachments,
                  icon: Icons.attach_file_rounded,
                  children: profile.attachments.isEmpty
                      ? [
                          Text(
                            l10n.associationMemberNoData,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ]
                      : profile.attachments
                            .map(
                              (item) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  _attachmentIcon(item.type),
                                  color: isDark
                                      ? AppColors.goldLight
                                      : AppColors.burgundy,
                                ),
                                title: Text(
                                  item.name.isEmpty ? item.type : item.name,
                                ),
                                subtitle: item.url.isEmpty
                                    ? null
                                    : Text(
                                        item.url,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                              ),
                            )
                            .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<int> _resolveYears(AssociationMemberProfileModel profile) {
    if (profile.paymentYears.isNotEmpty) {
      return [...profile.paymentYears]..sort();
    }
    final years = <int>{};
    for (final item in profile.installments) {
      if (item.year != null) years.add(item.year!);
    }
    for (final item in profile.otherPayments) {
      if (item.year != null) years.add(item.year!);
    }
    final sorted = years.toList()..sort();
    return sorted;
  }

  List<T> _filterByYear<T>(
    List<T> items,
    int? year,
    int? Function(T item) yearOf,
  ) {
    if (year == null) return items;
    return items.where((item) => yearOf(item) == year).toList();
  }

  String _formatMoney(double value) {
    if (value == 0) return '0';
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
  }

  IconData _attachmentIcon(String type) {
    final normalized = type.toLowerCase();
    if (normalized.contains('pdf')) return Icons.picture_as_pdf_outlined;
    if (normalized.contains('img') || normalized.contains('image')) {
      return Icons.image_outlined;
    }
    if (normalized.contains('doc')) return Icons.description_outlined;
    return Icons.insert_drive_file_outlined;
  }
}

extension _AssociationMemberProfileModelView on AssociationMemberProfileModel {
  _AssociationMemberPersonalView get personal =>
      _AssociationMemberPersonalView(person, associationMember, memberships);

  double get membershipStatusPercent => hasActiveMemberships ? 1 : 0;

  double get paymentCommitmentPercent => isAssociationMember ? 1 : 0;

  List<int> get paymentYears => const [];

  List<dynamic> get installments => const [];

  List<dynamic> get otherPayments => const [];

  List<dynamic> get notifications => const [];

  List<dynamic> get events => const [];

  List<dynamic> get measurements => const [];

  List<dynamic> get attachments => const [];

  _AssociationMemberFinancialSummaryView get financialSummary =>
      const _AssociationMemberFinancialSummaryView();
}

class _AssociationMemberPersonalView {
  const _AssociationMemberPersonalView(
    this.person,
    this.associationMember,
    this.memberships,
  );

  final dynamic person;
  final dynamic associationMember;
  final List<dynamic> memberships;

  String get fullName =>
      _readString(person, const ['full_name', 'name', 'first_name']);

  String get membershipNumber {
    final direct = _readString(associationMember, const ['membership_number']);
    if (direct.isNotEmpty) return direct;
    if (memberships.isEmpty) return '';
    return _readString(memberships.first, const ['membership_number']);
  }

  String get mobile => _readString(person, const ['mobile', 'phone']);

  String get whatsApp =>
      _readString(person, const ['whatsapp', 'whats_app', 'phone']);

  String get email => _readString(person, const ['email']);

  String get currentAddress =>
      _readString(person, const ['current_address', 'address']);

  String get permanentAddress =>
      _readString(person, const ['permanent_address']);

  String get priorityNumber =>
      _readString(associationMember, const ['priority_number']);

  String get projectName =>
      _readString(associationMember, const ['project_name']);

  String get housingUnit =>
      _readString(associationMember, const ['housing_unit', 'unit_number']);

  String get governorate => _readString(person, const ['governorate']);

  String get city => _readString(person, const ['city']);

  String get town => _readString(person, const ['town']);

  String get village => _readString(person, const ['village']);

  String get street => _readString(person, const ['street']);

  String get building => _readString(person, const ['building']);
}

class _AssociationMemberFinancialSummaryView {
  const _AssociationMemberFinancialSummaryView();

  double get totalAmount => 0;

  double get paidAmount => 0;

  int get remainingInstallments => 0;
}

String _readString(Object? source, List<String> keys) {
  if (source is! Map) return '';

  for (final key in keys) {
    final value = source[key];
    final text = value?.toString().trim() ?? '';
    if (text.isNotEmpty) return text;
  }

  return '';
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({required this.profile, required this.isDark});

  final AssociationMemberProfileModel profile;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final name = profile.personal.fullName.trim().isEmpty
        ? l10n.associationMemberNoData
        : profile.personal.fullName;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: isDark
              ? [
                  AppColors.burgundy.withValues(alpha: 0.85),
                  AppColors.black.withValues(alpha: 0.9),
                ]
              : [AppColors.burgundy, AppColors.goldDark],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                child: Icon(
                  Icons.groups_rounded,
                  color: AppColors.offWhite,
                  size: 30.r,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.offWhite,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (profile.personal.membershipNumber.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        '${l10n.associationLinkMembershipNumber}: ${profile.personal.membershipNumber}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.offWhite.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _AccosiciationMemberProfileMenuActions {
  linkRequests,
  frequentlyAskedQuestion,
  associationContactUs,
  requestsAndServices,
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (value * 100).round();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '$percent%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 10.h,
                value: value.clamp(0, 1),
                backgroundColor: color.withValues(alpha: 0.12),
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      children: [
        Icon(
          icon,
          size: 22.r,
          color: isDark ? AppColors.goldLight : AppColors.burgundy,
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.offWhite : AppColors.burgundy,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final display = value.trim().isEmpty ? '—' : value.trim();

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.taupe : AppColors.burgundy,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            display,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.goldLight : AppColors.burgundy,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DataSection extends StatelessWidget {
  const _DataSection({
    required this.title,
    required this.icon,
    required this.headers,
    required this.rows,
    required this.emptyMessage,
  });

  final String title;
  final IconData icon;
  final List<String> headers;
  final List<List<dynamic>> rows;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return AssociationFormSection(
      title: title,
      icon: icon,
      children: [
        if (rows.isEmpty)
          Text(emptyMessage)
        else
          ...rows.map(
            (row) => Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              ),
              child: Column(
                children: List.generate(headers.length, (index) {
                  final cell = index < row.length
                      ? row[index]?.toString() ?? ''
                      : '';
                  if (cell.trim().isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 110.w,
                          child: Text(
                            headers[index],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            cell,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
      ],
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56.r, color: theme.colorScheme.primary),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 20.h),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

extension _FirstOrNull<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
