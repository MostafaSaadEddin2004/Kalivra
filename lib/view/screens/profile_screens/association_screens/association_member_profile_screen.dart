import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/assoiciation_link_cubit/association_link_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_member_profile_model.dart';
import 'package:kalivra/model/association/association_news_model.dart';
import 'package:kalivra/view/widgets/association/association_form_section.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';
import 'package:kalivra/view/widgets/cards/text_slider.dart';
import 'package:kalivra/view/widgets/files/network_file_action_tile.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class AssociationMemberProfileScreen extends StatefulWidget {
  const AssociationMemberProfileScreen({super.key});

  @override
  State<AssociationMemberProfileScreen> createState() =>
      _AssociationMemberProfileScreenState();
}

class _AssociationMemberProfileScreenState
    extends State<AssociationMemberProfileScreen> {
  int _selectedMembershipIndex = 0;

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
                            .announcements:
                          context.push(AppRoutes.associationAnnouncements);
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
                      if (data.isAssociationMember)
                        PopupMenuItem(
                          value: _AccosiciationMemberProfileMenuActions
                              .announcements,
                          child: Row(
                            children: [
                              Icon(
                                Icons.campaign_rounded,
                                size: 20.r,
                                color: theme.colorScheme.onTertiaryFixed,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.associationAnnouncementsTitle,
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

          final memberships = profile.memberships;
          final selectedIndex = memberships.isEmpty
              ? 0
              : _selectedMembershipIndex
                    .clamp(0, memberships.length - 1)
                    .toInt();
          final selectedMembership = memberships.isEmpty
              ? null
              : memberships[selectedIndex];

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
              children: [
                _ProfileHeaderCard(profile: profile, isDark: isDark),
                SizedBox(height: 16.h),
                _AssociationNewsFeedSlider(news: state.news),
                SizedBox(height: 16.h),
                if (memberships.isEmpty)
                  _AcceptedLinkEmptyMemberships(profile: profile)
                else ...[
                  _MembershipTabs(
                    memberships: memberships,
                    selectedIndex: selectedIndex,
                    onSelected: (index) {
                      setState(() => _selectedMembershipIndex = index);
                    },
                  ),
                  SizedBox(height: 16.h),
                  _MemberContactSection(profile: profile),
                  if (selectedMembership != null)
                    _MembershipDetailsSection(
                      profile: profile,
                      membership: selectedMembership,
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AssociationNewsFeedSlider extends StatelessWidget {
  const _AssociationNewsFeedSlider({required this.news});

  final List<AssociationNewsModel> news;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final items = _newsItems(context);
    final sliderText = _sliderText(context, items);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.black.withValues(alpha: 0.52)
              : AppColors.goldLight.withValues(alpha: 0.22),
          border: Border.all(
            color: isDark
                ? AppColors.goldLight.withValues(alpha: 0.22)
                : AppColors.goldDark.withValues(alpha: 0.24),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.goldLight.withValues(alpha: 0.16)
                    : AppColors.burgundy.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.newspaper_rounded,
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
                size: 22.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.associationNewsFeedTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isDark ? AppColors.taupe : AppColors.burgundy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  SizedBox(
                    height: 30.h,
                    child: TextSlider(
                      key: ValueKey(sliderText),
                      text: sliderText,
                      height: 30.h,
                      sliderSpeed: 28,
                      textStyle: theme.textTheme.titleSmall?.copyWith(
                        color: isDark ? AppColors.offWhite : AppColors.black,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_AssociationNewsItem> _newsItems(BuildContext context) {
    if (news.isNotEmpty) {
      return news.map((item) => _AssociationNewsItem(text: item.text)).toList();
    }
    final l10n = AppLocalizations.of(context)!;
    return [
      _AssociationNewsItem(
        text: l10n.associationNewsFeedSample1,
        isImportant: true,
      ),
      _AssociationNewsItem(text: l10n.associationNewsFeedSample2),
      _AssociationNewsItem(text: l10n.associationNewsFeedSample3),
    ];
  }

  String _sliderText(BuildContext context, List<_AssociationNewsItem> items) {
    final l10n = AppLocalizations.of(context)!;
    return items
        .map((item) {
          if (!item.isImportant) return item.text;
          return '${l10n.associationNewsFeedImportant}: ${item.text}';
        })
        .join('   -   ');
  }
}

class _AssociationNewsItem {
  const _AssociationNewsItem({required this.text, this.isImportant = false});

  final String text;
  final bool isImportant;
}

class _AcceptedLinkEmptyMemberships extends StatelessWidget {
  const _AcceptedLinkEmptyMemberships({required this.profile});

  final AssociationMemberProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final personName = profile.person.displayName.isEmpty
        ? _localizedText(context, arabic: 'العضو', english: 'the member')
        : profile.person.displayName;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.burgundy.withValues(alpha: 0.12)
            : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? AppColors.taupe.withValues(alpha: 0.32)
              : AppColors.burgundy.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.goldLight.withValues(alpha: 0.14)
                  : AppColors.burgundy.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_user_outlined,
              size: 34.r,
              color: isDark ? AppColors.goldLight : AppColors.burgundy,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            _localizedText(
              context,
              arabic: 'تم قبول طلب الربط',
              english: 'Linking request accepted',
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.offWhite : AppColors.burgundy,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            _localizedText(
              context,
              arabic:
                  'تم قبول طلب الربط من السيد $personName، وسيتم عرض المعلومات الخاصة بالعضويات الخاصة بك عند الانتهاء من استكمالها.',
              english:
                  'Your linking request for Mr. $personName has been accepted. Your membership information will appear once it is completed.',
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _MembershipTabs extends StatelessWidget {
  const _MembershipTabs({
    required this.memberships,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<AssociationMembership> memberships;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(memberships.length, (index) {
          final membership = memberships[index];
          final selected = index == selectedIndex;
          final color = isDark ? AppColors.goldLight : AppColors.burgundy;
          final label = membership.displayType.isEmpty
              ? _localizedText(
                  context,
                  arabic: 'عضوية ${index + 1}',
                  english: 'Membership ${index + 1}',
                )
              : membership.displayType;

          return Padding(
            padding: EdgeInsetsDirectional.only(end: 10.w),
            child: InkWell(
              borderRadius: BorderRadius.circular(14.r),
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: selected
                      ? color.withValues(alpha: isDark ? 0.18 : 0.1)
                      : (isDark
                            ? AppColors.burgundy.withValues(alpha: 0.08)
                            : Colors.white),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: selected
                        ? color
                        : color.withValues(alpha: isDark ? 0.22 : 0.16),
                    width: selected ? 1.4 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _membershipIcon(membership.membershipType),
                      size: 21.r,
                      color: color,
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: isDark ? AppColors.offWhite : color,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (membership.membershipNumber.isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            '#${membership.membershipNumber}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.taupe : AppColors.black,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _MemberContactSection extends StatelessWidget {
  const _MemberContactSection({required this.profile});

  final AssociationMemberProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final person = profile.person;

    return AssociationFormSection(
      title: l10n.associationLinkContactSection,
      icon: Icons.contact_phone_outlined,
      children: [
        _InfoRow(
          label: l10n.associationLinkFirstName,
          value: person.displayName,
        ),
        _InfoRow(
          label: l10n.associationLinkFatherName,
          value: person.fatherName,
        ),
        _InfoRow(
          label: l10n.associationLinkMotherName,
          value: person.motherName,
        ),
        _InfoRow(
          label: l10n.associationLinkNationalId,
          value: person.nationalId,
        ),
        _InfoRow(
          label: l10n.genderLabel,
          value: _genderLabel(context, person.gender),
        ),
        _InfoRow(label: l10n.associationLinkMobile, value: person.phone),
        _InfoRow(
          label: l10n.associationLinkWhatsApp,
          value: person.whatsappNumber,
        ),
        _InfoRow(label: l10n.associationLinkEmail, value: person.email),
        _InfoRow(
          label: l10n.associationMemberCurrentAddress,
          value: person.address,
        ),
      ],
    );
  }
}

class _MembershipDetailsSection extends StatelessWidget {
  const _MembershipDetailsSection({
    required this.profile,
    required this.membership,
  });

  final AssociationMemberProfileModel profile;
  final AssociationMembership membership;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final project = membership.project;
    final building = membership.building ?? membership.unit?.building;
    final unit = membership.unit;
    final lifecycle = profile.membershipLifecycle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MembershipSummaryCard(membership: membership),
        SizedBox(height: 16.h),
        _FinancialOverviewCard(membership: membership),
        SizedBox(height: 16.h),
        AssociationFormSection(
          title: l10n.associationLinkMembershipSection,
          icon: Icons.badge_outlined,
          children: [
            _InfoRow(
              label: l10n.associationLinkMembershipNumber,
              value: membership.membershipNumber,
            ),
            _InfoRow(
              label: l10n.associationMemberType,
              value: membership.displayType,
            ),
            _InfoRow(
              label: l10n.associationMemberStatus,
              value: membership.displayStatus,
            ),
            _InfoRow(
              label: l10n.associationMemberFinancialSummary,
              value: membership.displayFinancialStatus,
            ),
            _InfoRow(
              label: l10n.associationMemberDate,
              value: membership.joinDate,
            ),
            _InfoRow(
              label: l10n.associationLinkPriorityNumber,
              value: _formatNullableNumber(membership.priorityNumber),
            ),
            _InfoRow(
              label: _localizedText(
                context,
                arabic: 'حالة الدور',
                english: 'Priority Status',
              ),
              value: membership.priorityStatusLabel.isNotEmpty
                  ? membership.priorityStatusLabel
                  : membership.priorityStatus,
            ),
            _InfoRow(
              label: _localizedText(
                context,
                arabic: 'قرار العضوية',
                english: 'Membership Decision',
              ),
              value: membership.membershipDecision,
            ),
            _ProfileFilesSection(
              title: _localizedText(
                context,
                arabic: 'وثائق الانتساب',
                english: 'Join Documents',
              ),
              fileUrls: _fileUrlsFromValue(membership.joinDocuments),
              fallbackName: _localizedText(
                context,
                arabic: 'وثيقة انتساب',
                english: 'Join document',
              ),
            ),
            _InfoRow(
              label: _localizedText(
                context,
                arabic: 'وثائق الانتساب',
                english: 'Join Documents',
              ),
              value: membership.joinDocuments,
            ),
            _InfoRow(
              label: _localizedText(
                context,
                arabic: 'تاريخ الإغلاق',
                english: 'Closed At',
              ),
              value: membership.closedAt,
            ),
            _InfoRow(
              label: l10n.associationMemberPaidAmount,
              value: _formatNullableNumber(membership.totalPaymentsMade),
            ),
          ],
        ),
        if (lifecycle != null)
          AssociationFormSection(
            title: _localizedText(
              context,
              arabic: 'حالة الملف',
              english: 'Profile Status',
            ),
            icon: Icons.route_outlined,
            children: [
              _InfoRow(
                label: l10n.associationMemberStatus,
                value: lifecycle.title,
              ),
              _InfoRow(
                label: _localizedText(
                  context,
                  arabic: 'المرحلة',
                  english: 'Stage',
                ),
                value: lifecycle.statusLabel.isNotEmpty
                    ? lifecycle.statusLabel
                    : lifecycle.stage,
              ),
              _InfoRow(
                label: _localizedText(
                  context,
                  arabic: 'الرسالة',
                  english: 'Message',
                ),
                value: lifecycle.message,
              ),
              _InfoRow(
                label: l10n.associationMemberNotes,
                value: lifecycle.adminNotes,
              ),
            ],
          ),
        if (project != null) _ProjectDetailsSection(project: project),
        if (building != null) _BuildingDetailsSection(building: building),
        if (unit != null) _UnitDetailsSection(unit: unit),
      ],
    );
  }
}

class _FinancialOverviewCard extends StatelessWidget {
  const _FinancialOverviewCard({required this.membership});

  final AssociationMembership membership;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final total = membership.unit?.price ?? membership.project?.price;
    final paid = membership.totalPaymentsMade;
    final remaining = total != null && paid != null ? total - paid : null;
    final progress = total == null || total == 0 || paid == null
        ? null
        : (paid / total).clamp(0, 1).toDouble();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.burgundy.withValues(alpha: 0.12)
            : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? AppColors.taupe.withValues(alpha: 0.32)
              : AppColors.burgundy.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
                size: 24.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  l10n.associationMemberFinancialSummary,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.offWhite : AppColors.burgundy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          if (progress != null) ...[
            SizedBox(height: 14.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 9.h,
                backgroundColor: isDark
                    ? AppColors.taupe.withValues(alpha: 0.22)
                    : AppColors.burgundy.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? AppColors.goldLight : AppColors.goldDark,
                ),
              ),
            ),
          ],
          SizedBox(height: 14.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              _FinanceMetric(
                label: l10n.associationMemberTotalAmount,
                value: _formatNullableNumber(total),
                icon: Icons.request_quote_outlined,
              ),
              _FinanceMetric(
                label: l10n.associationMemberPaidAmount,
                value: _formatNullableNumber(paid),
                icon: Icons.check_circle_outline_rounded,
              ),
              _FinanceMetric(
                label: l10n.associationMemberRemainingInstallments,
                value: _formatNullableNumber(remaining),
                icon: Icons.pending_actions_outlined,
              ),
              _FinanceMetric(
                label: l10n.associationMemberPaymentCommitment,
                value: membership.displayFinancialStatus,
                icon: Icons.verified_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FinanceMetric extends StatelessWidget {
  const _FinanceMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 145.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.taupe.withValues(alpha: 0.1)
            : AppColors.burgundy.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20.r,
            color: isDark ? AppColors.goldLight : AppColors.burgundy,
          ),
          SizedBox(height: 8.h),
          Text(
            value.trim().isEmpty ? '-' : value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ProjectDetailsSection extends StatelessWidget {
  const _ProjectDetailsSection({required this.project});

  final AssociationProject project;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AssociationFormSection(
      title: l10n.associationLinkProjectName,
      icon: Icons.apartment_rounded,
      children: [
        _MediaGallery(
          title: _localizedText(
            context,
            arabic: 'معرض المشروع',
            english: 'Project Gallery',
          ),
          imageUrl: project.imageUrl,
          galleryImages: [...project.images, ...project.galleryImages],
          fallbackIcon: Icons.apartment_rounded,
        ),
        _ProgressBlock(
          label: _localizedText(
            context,
            arabic: 'نسبة الإنجاز',
            english: 'Completion',
          ),
          value: project.completionPercentage,
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'نسبة الإنجاز',
            english: 'Completion Percentage',
          ),
          value: _formatNullablePercent(project.completionPercentage),
        ),
        _InfoRow(label: l10n.associationLinkProjectName, value: project.name),
        _InfoRow(
          label: l10n.associationMemberType,
          value: project.typeLabel.isNotEmpty
              ? project.typeLabel
              : project.type,
        ),
        _InfoRow(
          label: _localizedText(context, arabic: 'الوصف', english: 'Subtitle'),
          value: project.subtitle,
        ),
        _InfoRow(
          label: l10n.associationMemberAmount,
          value: _formatNullableNumber(project.price),
        ),
        _InfoRow(
          label: l10n.associationMemberStatus,
          value: project.displayStatus,
        ),
        _InfoRow(
          label: l10n.associationMemberLocation,
          value: _joinValues([
            project.governorate,
            project.region,
            project.address,
          ]),
        ),
        _ProjectLocationButton(project: project),
        _ProfileFilesSection(
          title: _localizedText(
            context,
            arabic: 'مخطط المشروع',
            english: 'Project Master Plan',
          ),
          fileUrls: _fileUrlsFromValue(project.masterPlanUrl),
          fallbackName: _localizedText(
            context,
            arabic: 'مخطط المشروع',
            english: 'Project master plan',
          ),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'عدد الأبنية',
            english: 'Buildings',
          ),
          value: _formatNullableNumber(
            project.numberOfBuildings ?? project.buildings.length,
          ),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'إجمالي الوحدات',
            english: 'Total Units',
          ),
          value: _formatNullableNumber(
            project.totalUnits ?? project.totalNumberOfUnits,
          ),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'الوحدات المتاحة',
            english: 'Available Units',
          ),
          value: _formatNullableNumber(project.availableUnits),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'الوحدات المخصصة',
            english: 'Allocated Units',
          ),
          value: _formatNullableNumber(project.allocatedUnits),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'الوحدات المسلمة',
            english: 'Delivered Units',
          ),
          value: _formatNullableNumber(project.deliveredUnits),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'الوحدات المتبقية',
            english: 'Remaining Units',
          ),
          value: _formatNullableNumber(project.remainingUnits),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'الكلفة التقديرية',
            english: 'Estimated Cost',
          ),
          value: _formatNullableNumber(project.estimatedCost),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'المهندس',
            english: 'Engineer',
          ),
          value: project.projectEngineer,
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'مساحة الأرض',
            english: 'Land Area',
          ),
          value: _formatNullableNumber(project.landArea),
        ),
        _StagesTimeline(stages: project.stages),
        _ProjectBuildingsGallery(buildings: project.buildings),
      ],
    );
  }
}

class _ProjectLocationButton extends StatelessWidget {
  const _ProjectLocationButton({required this.project});

  final AssociationProject project;

  @override
  Widget build(BuildContext context) {
    final latitude = project.latitude;
    final longitude = project.longitude;
    if (!_hasValidCoordinates(latitude, longitude)) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.taupe.withValues(alpha: 0.12)
            : AppColors.burgundy.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDark
              ? AppColors.taupe.withValues(alpha: 0.24)
              : AppColors.burgundy.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
            ),
            child: Icon(
              Icons.location_on_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _localizedText(
                    context,
                    arabic: 'موقع المشروع',
                    english: 'Project Location',
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${_formatCoordinate(latitude!)}, ${_formatCoordinate(longitude!)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.taupe : AppColors.burgundy,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          IconButton.filledTonal(
            tooltip: _localizedText(
              context,
              arabic: 'فتح في خرائط Google',
              english: 'Open in Google Maps',
            ),
            onPressed: () => _openProjectLocation(context, project),
            icon: const Icon(Icons.map_rounded),
          ),
        ],
      ),
    );
  }
}

class _BuildingDetailsSection extends StatelessWidget {
  const _BuildingDetailsSection({required this.building});

  final AssociationBuilding building;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AssociationFormSection(
      title: l10n.associationLinkBuilding,
      icon: Icons.business_rounded,
      children: [
        _MediaGallery(
          title: _localizedText(
            context,
            arabic: 'معرض البناء',
            english: 'Building Gallery',
          ),
          imageUrl: building.buildingPlanUrl,
          galleryImages: [
            ...building.floorPlanImages,
            ...building.galleryImages,
          ],
          fallbackIcon: Icons.business_rounded,
        ),
        _ProgressBlock(
          label: _localizedText(
            context,
            arabic: 'نسبة الإنجاز',
            english: 'Completion',
          ),
          value: building.completionPercentage,
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'نسبة الإنجاز',
            english: 'Completion Percentage',
          ),
          value: _formatNullablePercent(building.completionPercentage),
        ),
        _InfoRow(
          label: l10n.associationLinkBuilding,
          value: building.displayName,
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'رقم البناء',
            english: 'Building Number',
          ),
          value: building.buildingNumber,
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'الوصف',
            english: 'Description',
          ),
          value: building.description,
        ),
        _InfoRow(
          label: l10n.associationMemberLocation,
          value: building.physicalAddress,
        ),
        _ProfileFilesSection(
          title: _localizedText(
            context,
            arabic: 'مخطط البناء',
            english: 'Building Plan',
          ),
          fileUrls: _fileUrlsFromValue(building.buildingPlanUrl),
          fallbackName: _localizedText(
            context,
            arabic: 'مخطط البناء',
            english: 'Building plan',
          ),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'عدد الطوابق',
            english: 'Floors',
          ),
          value: _formatNullableNumber(building.numberOfFloors),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'عدد الوحدات',
            english: 'Units',
          ),
          value: _formatNullableNumber(
            building.numberOfUnits ?? building.totalUnits,
          ),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'الوحدات المتاحة',
            english: 'Available Units',
          ),
          value: _formatNullableNumber(building.availableUnits),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'الوحدات المخصصة',
            english: 'Allocated Units',
          ),
          value: _formatNullableNumber(building.allocatedUnits),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'المواصفات',
            english: 'Specifications',
          ),
          value: building.specifications,
        ),
        _StagesTimeline(stages: building.stages),
      ],
    );
  }
}

class _UnitDetailsSection extends StatelessWidget {
  const _UnitDetailsSection({required this.unit});

  final AssociationUnit unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AssociationFormSection(
      title: l10n.unit,
      icon: Icons.home_work_outlined,
      children: [
        _MediaGallery(
          title: _localizedText(
            context,
            arabic: 'معرض الوحدة',
            english: 'Unit Gallery',
          ),
          imageUrl: unit.unitPlanUrl,
          galleryImages: [...unit.images, ...unit.galleryImages],
          fallbackIcon: Icons.home_work_outlined,
        ),
        _InfoRow(label: l10n.unit, value: unit.unitNumber),
        _InfoRow(
          label: _localizedText(context, arabic: 'الطابق', english: 'Floor'),
          value: _formatNullableNumber(unit.floorNumber),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'الاتجاه',
            english: 'Orientation',
          ),
          value: unit.orientationLabel.isNotEmpty
              ? unit.orientationLabel
              : unit.orientation,
        ),
        _InfoRow(
          label: _localizedText(context, arabic: 'المساحة', english: 'Area'),
          value: _formatNullableNumber(unit.area),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'مساحة الحديقة / التراس',
            english: 'Garden / Terrace Area',
          ),
          value: _formatNullableNumber(unit.gardenTerraceArea),
        ),
        _InfoRow(
          label: l10n.associationMemberAmount,
          value: _formatNullableNumber(unit.price),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'المواصفات',
            english: 'Specifications',
          ),
          value: unit.specifications,
        ),
        _InfoRow(
          label: l10n.associationMemberStatus,
          value: unit.statusLabel.isNotEmpty ? unit.statusLabel : unit.status,
        ),
        _ProfileFilesSection(
          title: _localizedText(
            context,
            arabic: 'مخطط الوحدة',
            english: 'Unit Plan',
          ),
          fileUrls: _fileUrlsFromValue(unit.unitPlanUrl),
          fallbackName: _localizedText(
            context,
            arabic: 'مخطط الوحدة',
            english: 'Unit plan',
          ),
        ),
        _InfoRow(
          label: _localizedText(
            context,
            arabic: 'مخطط الوحدة',
            english: 'Unit Plan',
          ),
          value: unit.unitPlanUrl,
        ),
      ],
    );
  }
}

class _ProfileFilesSection extends StatelessWidget {
  const _ProfileFilesSection({
    required this.title,
    required this.fileUrls,
    required this.fallbackName,
  });

  final String title;
  final List<String> fileUrls;
  final String fallbackName;

  @override
  Widget build(BuildContext context) {
    final visibleFiles = fileUrls
        .where((fileUrl) => fileUrl.trim().isNotEmpty)
        .toSet()
        .toList();
    if (visibleFiles.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8.h),
          for (var index = 0; index < visibleFiles.length; index++)
            NetworkFileActionTile(
              name: visibleFiles.length == 1
                  ? fallbackName
                  : '$fallbackName ${index + 1}',
              url: visibleFiles[index],
            ),
        ],
      ),
    );
  }
}

class _MediaGallery extends StatefulWidget {
  const _MediaGallery({
    required this.title,
    required this.imageUrl,
    required this.galleryImages,
    required this.fallbackIcon,
  });

  final String title;
  final String imageUrl;
  final List<String> galleryImages;
  final IconData fallbackIcon;

  @override
  State<_MediaGallery> createState() => _MediaGalleryState();
}

class _MediaGalleryState extends State<_MediaGallery> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(covariant _MediaGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl ||
        oldWidget.galleryImages != widget.galleryImages) {
      _currentIndex = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    if (index == _currentIndex) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final galleryImages = widget.galleryImages
        .where((image) => image.trim().isNotEmpty)
        .toSet()
        .toList();
    final fallbackImage = widget.imageUrl.trim();
    final visibleImages = galleryImages.isNotEmpty
        ? galleryImages
        : fallbackImage.isNotEmpty
        ? [fallbackImage]
        : const <String>[];
    if (visibleImages.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: visibleImages.length == 1 ? 220.h : 290.h,
            child: Column(
              children: [
                SizedBox(
                  height: 220.h,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: visibleImages.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      final imageUrl = visibleImages[index];
                      return _GalleryMainImage(
                        title: widget.title,
                        imageUrl: imageUrl,
                        index: index,
                        fallbackIcon: widget.fallbackIcon,
                      );
                    },
                  ),
                ),
                if (visibleImages.length > 1) ...[
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 58.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: visibleImages.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 8.w),
                      itemBuilder: (context, index) {
                        final isSelected = index == _currentIndex;
                        final imageUrl = visibleImages[index];
                        return GestureDetector(
                          onTap: () => _goToPage(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeInOut,
                            width: 58.w,
                            height: 58.h,
                            padding: EdgeInsets.all(isSelected ? 3.w : 0),
                            decoration: BoxDecoration(
                              border: isSelected
                                  ? Border.all(
                                      color: theme.colorScheme.primary,
                                      width: 2.w,
                                    )
                                  : null,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: CustomNetworkImage(
                                imageUrl: imageUrl,
                                defaultIcon: widget.fallbackIcon,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryMainImage extends StatelessWidget {
  const _GalleryMainImage({
    required this.title,
    required this.imageUrl,
    required this.index,
    required this.fallbackIcon,
  });

  final String title;
  final String imageUrl;
  final int index;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () => handleNetworkFileTap(
          context,
          name: '$title ${index + 1}',
          url: imageUrl,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: CustomNetworkImage(
            imageUrl: imageUrl,
            defaultIcon: fallbackIcon,
          ),
        ),
      ),
    );
  }
}

class _ProgressBlock extends StatelessWidget {
  const _ProgressBlock({required this.label, required this.value});

  final String label;
  final num? value;

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = (value! / 100).clamp(0, 1).toDouble();

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${_formatNullableNumber(value)}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: isDark
                  ? AppColors.taupe.withValues(alpha: 0.2)
                  : AppColors.burgundy.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.goldLight : AppColors.goldDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StagesTimeline extends StatelessWidget {
  const _StagesTimeline({required this.stages});

  final List<AssociationProjectStage> stages;

  @override
  Widget build(BuildContext context) {
    if (stages.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _localizedText(context, arabic: 'مراحل التنفيذ', english: 'Stages'),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10.h),
          ...stages.map((stage) => _StageTile(stage: stage)),
        ],
      ),
    );
  }
}

class _StageTile extends StatelessWidget {
  const _StageTile({required this.stage});

  final AssociationProjectStage stage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            stage.isActive ? Icons.radio_button_checked : Icons.check_circle,
            size: 20.r,
            color: stage.isActive ? AppColors.goldDark : Colors.green,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stage.stageName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  _joinValues([
                    stage.startDate,
                    stage.endDate,
                    '${_formatNullableNumber(stage.completionPercentage)}%',
                    stage.notes,
                  ]),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectBuildingsGallery extends StatelessWidget {
  const _ProjectBuildingsGallery({required this.buildings});

  final List<AssociationBuilding> buildings;

  @override
  Widget build(BuildContext context) {
    if (buildings.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _localizedText(
              context,
              arabic: 'الأبنية ضمن المشروع',
              english: 'Project Buildings',
            ),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10.h),
          ...buildings.map(
            (building) => _BuildingSummaryCard(building: building),
          ),
        ],
      ),
    );
  }
}

class _BuildingSummaryCard extends StatelessWidget {
  const _BuildingSummaryCard({required this.building});

  final AssociationBuilding building;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.taupe.withValues(alpha: 0.1)
            : AppColors.burgundy.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              width: 74.r,
              height: 74.r,
              child: CustomNetworkImage(
                imageUrl: building.allImages.isEmpty
                    ? null
                    : building.allImages.first,
                defaultIcon: Icons.business_rounded,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  building.displayName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _joinValues([
                    building.physicalAddress,
                    _formatNullableNumber(building.numberOfFloors),
                    _formatNullableNumber(
                      building.numberOfUnits ?? building.totalUnits,
                    ),
                  ]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
                _ProgressBlock(
                  label: _localizedText(
                    context,
                    arabic: 'الإنجاز',
                    english: 'Progress',
                  ),
                  value: building.completionPercentage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MembershipSummaryCard extends StatelessWidget {
  const _MembershipSummaryCard({required this.membership});

  final AssociationMembership membership;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.goldLight : AppColors.burgundy;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.burgundy.withValues(alpha: 0.1)
            : AppColors.goldLight.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _membershipIcon(membership.membershipType),
                size: 24.r,
                color: accent,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  membership.displayType,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.offWhite : AppColors.burgundy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _StatusPill(
                label: membership.isActive
                    ? _localizedText(
                        context,
                        arabic: 'فعالة',
                        english: 'Active',
                      )
                    : _localizedText(
                        context,
                        arabic: 'غير فعالة',
                        english: 'Inactive',
                      ),
                color: membership.isActive ? Colors.green : AppColors.red,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _StatusPill(label: membership.displayStatus, color: accent),
              _StatusPill(
                label: membership.displayFinancialStatus,
                color: AppColors.goldDark,
              ),
              _StatusPill(
                label: membership.isAssignedToProject
                    ? _localizedText(
                        context,
                        arabic: 'مخصص لمشروع',
                        english: 'Assigned to project',
                      )
                    : _localizedText(
                        context,
                        arabic: 'غير مخصص لمشروع',
                        english: 'No project assignment',
                      ),
                color: membership.isAssignedToProject ? accent : AppColors.red,
              ),
              _StatusPill(
                label: membership.isAssignedToUnit
                    ? _localizedText(
                        context,
                        arabic: 'مخصص لوحدة',
                        english: 'Assigned to unit',
                      )
                    : _localizedText(
                        context,
                        arabic: 'غير مخصص لوحدة',
                        english: 'No unit assignment',
                      ),
                color: membership.isAssignedToUnit ? accent : AppColors.red,
              ),
            ].where((item) => item.label.trim().isNotEmpty).toList(),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({required this.profile, required this.isDark});

  final AssociationMemberProfileModel profile;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final name = profile.person.displayName.trim().isEmpty
        ? l10n.associationMemberNoData
        : profile.person.displayName;

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
                child: Text(
                  name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.offWhite,
                    fontWeight: FontWeight.w800,
                  ),
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
  announcements,
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final display = value.trim().isEmpty ? '-' : value.trim();
    if (_looksLikeFileReference(display)) {
      return const SizedBox.shrink();
    }

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

String _localizedText(
  BuildContext context, {
  required String arabic,
  required String english,
}) {
  final locale = Localizations.localeOf(context).languageCode.toLowerCase();
  return locale == 'ar' ? arabic : english;
}

String _genderLabel(BuildContext context, String gender) {
  final normalized = gender.toLowerCase();
  if (normalized == 'male') return AppLocalizations.of(context)!.genderMale;
  if (normalized == 'female') return AppLocalizations.of(context)!.genderFemale;
  return gender;
}

IconData _membershipIcon(String type) {
  final normalized = type.toLowerCase();
  if (normalized.contains('residential')) return Icons.home_work_outlined;
  if (normalized.contains('tourism')) return Icons.luggage_outlined;
  return Icons.badge_outlined;
}

String _formatNullableNumber(num? value) {
  if (value == null) return '';
  final asDouble = value.toDouble();
  if (asDouble == asDouble.truncateToDouble()) {
    return asDouble.toInt().toString();
  }
  return asDouble.toStringAsFixed(2);
}

String _formatNullablePercent(num? value) {
  final formatted = _formatNullableNumber(value);
  return formatted.isEmpty ? '' : '$formatted%';
}

List<String> _fileUrlsFromValue(Object? value) {
  final text = value?.toString().trim() ?? '';
  if (text.isEmpty || text == '-' || text == '[]' || text == '{}') {
    return const [];
  }

  if (text.startsWith('[') || text.startsWith('{')) {
    try {
      return _fileUrlsFromDecodedValue(jsonDecode(text));
    } catch (_) {
      return const [];
    }
  }

  return text
      .split(RegExp(r'[\n,]'))
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toSet()
      .toList();
}

List<String> _fileUrlsFromDecodedValue(Object? value) {
  if (value is List) {
    return value.expand(_fileUrlsFromDecodedValue).toSet().toList();
  }

  if (value is Map) {
    final fileUrl =
        value['url'] ??
        value['file_url'] ??
        value['download_url'] ??
        value['full_url'] ??
        value['media_url'] ??
        value['src'] ??
        value['link'] ??
        value['path'] ??
        value['file'];
    return _fileUrlsFromDecodedValue(fileUrl);
  }

  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? const [] : [text];
}

bool _looksLikeFileReference(String value) {
  final text = value.trim();
  if (text.isEmpty || text == '-') return false;

  final uri = Uri.tryParse(text);
  if (uri != null && uri.hasScheme) return true;
  if (text.startsWith('/storage/') || text.startsWith('storage/')) {
    return true;
  }

  return RegExp(
    r'\.(pdf|docx?|xlsx?|pptx?|png|jpe?g|webp|gif|zip|rar)(\?.*)?$',
    caseSensitive: false,
  ).hasMatch(text);
}

bool _hasValidCoordinates(num? latitude, num? longitude) {
  if (latitude == null || longitude == null) return false;
  return latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;
}

String _formatCoordinate(num value) {
  return value.toDouble().toStringAsFixed(6);
}

Future<void> _openProjectLocation(
  BuildContext context,
  AssociationProject project,
) async {
  final latitude = project.latitude;
  final longitude = project.longitude;
  if (!_hasValidCoordinates(latitude, longitude)) {
    _showProjectLocationError(context);
    return;
  }

  final uri = Uri.https('www.google.com', '/maps/search/', {
    'api': '1',
    'query': '$latitude,$longitude',
  });

  try {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      _showProjectLocationError(context);
    }
  } catch (_) {
    if (context.mounted) {
      _showProjectLocationError(context);
    }
  }
}

void _showProjectLocationError(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        _localizedText(
          context,
          arabic: 'تعذر فتح موقع المشروع',
          english: 'Could not open the project location',
        ),
      ),
    ),
  );
}

String _joinValues(List<Object?> values) {
  return values
      .map((value) => value?.toString().trim() ?? '')
      .where((value) => value.isNotEmpty && value != '-')
      .join(' • ');
}
