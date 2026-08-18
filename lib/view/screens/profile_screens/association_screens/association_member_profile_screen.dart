import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/assoiciation_link_cubit/association_link_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_member_profile_model.dart';
import 'package:kalivra/model/association/association_news_model.dart';
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
                          context.push(AppRoutes.associationChat);
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
                                color: AppColors.burgundy,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.associationRequestsAndServices,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: AppColors.burgundy,
                                ),
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
                                color: AppColors.burgundy,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.associationAnnouncementsTitle,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: AppColors.burgundy,
                                ),
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
                              color: AppColors.burgundy,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.linkRequestsScreen,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: AppColors.burgundy,
                              ),
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
                              color: AppColors.burgundy,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.associationContactUs,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: AppColors.burgundy,
                              ),
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
                              color: AppColors.burgundy,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.frequentlyAskedQuestion,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: AppColors.burgundy,
                              ),
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
          switch (state) {
            case AssociationLinkLoading():
              return Center(
                child: SpinKitFadingCircle(
                  color: theme.colorScheme.onTertiary,
                  size: 40.r,
                  itemCount: 12,
                ),
              );
            case AssociationLinkFailure():
              return _MessageState(
                icon: Icons.error_outline_rounded,
                message: l10n.associationMemberLoadFailed,
                actionLabel: l10n.retry,
                onAction: _reload,
              );
            case AssociationProfileFetched():
              final profile = state.memberInfo;
              if (!profile.isAssociationMember && profile.isLinkedPerson) {
                return _MessageState(
                  icon: Icons.person_pin_circle_outlined,
                  title: AppLocalizations.of(
                    context,
                  )!.associationMemberRequestAcceptedTitle,
                  message: AppLocalizations.of(
                    context,
                  )!.associationMemberRequestAcceptedMessage,
                  actionLabel: l10n.retry,
                  onAction: _reload,
                );
              }
              if (!profile.isAssociationMember) {
                return Column(
                  spacing: 16.h,
                  children: [
                    _MessageState(
                      icon: Icons.info_outline_rounded,
                      title: AppLocalizations.of(
                        context,
                      )!.associationMemberNoMembershipTitle,
                      message: AppLocalizations.of(
                        context,
                      )!.associationMemberNoMembershipMessage,
                      actionLabel: l10n.retry,
                      onAction: _reload,
                    ),
                    FilledButton(
                      onPressed: () => context.push(
                        AppRoutes.associationRequestsAndServices,
                      ),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.associaitionSendLinkRequest,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.offWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
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
            default:
              return Center(child: Text('Something happened'));
          }
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
        ? AppLocalizations.of(context)!.associationMemberFallbackPersonName
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
            AppLocalizations.of(
              context,
            )!.associationMemberLinkingRequestAcceptedTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.offWhite : AppColors.burgundy,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            AppLocalizations.of(
              context,
            )!.associationMemberLinkAcceptedMessage(personName),
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
              ? AppLocalizations.of(
                  context,
                )!.associationMemberIndexedMembership(index + 1)
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

class _ExpandableProfileSection extends StatefulWidget {
  const _ExpandableProfileSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  State<_ExpandableProfileSection> createState() =>
      _ExpandableProfileSectionState();
}

class _ExpandableProfileSectionState extends State<_ExpandableProfileSection> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = false;
  }

  @override
  void didUpdateWidget(covariant _ExpandableProfileSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title) {
      _expanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.offWhite : AppColors.burgundy;
    final borderColor = isDark
        ? AppColors.taupe.withValues(alpha: 0.35)
        : AppColors.burgundy.withValues(alpha: 0.12);

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      color: isDark ? AppColors.burgundy.withValues(alpha: 0.08) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, _expanded ? 20.h : 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  children: [
                    Icon(widget.icon, size: 22.r, color: titleColor),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: titleColor,
                        size: 24.r,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: widget.children,
                ),
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 240),
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeOut,
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
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

    return _ExpandableProfileSection(
      title: l10n.associationLinkContactSection,
      icon: Icons.contact_phone_outlined,
      children: [
        InfoRow(
          label: l10n.associationLinkFirstName,
          value: person.displayName,
        ),
        InfoRow(
          label: l10n.associationLinkFatherName,
          value: person.fatherName,
        ),
        InfoRow(
          label: l10n.associationLinkMotherName,
          value: person.motherName,
        ),
        InfoRow(
          label: l10n.associationLinkNationalId,
          value: person.nationalId,
        ),
        InfoRow(
          label: l10n.genderLabel,
          value: _genderLabel(context, person.gender),
        ),
        InfoRow(label: l10n.associationLinkMobile, value: person.phone),
        InfoRow(
          label: l10n.associationLinkWhatsApp,
          value: person.whatsappNumber,
        ),
        InfoRow(label: l10n.associationLinkEmail, value: person.email),
        InfoRow(
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
    final unit = membership.unit ?? membership.allocatedUnit;
    final projects = _projectsForMembership(profile, membership);
    final buildings = _buildingsForMembership(membership);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MembershipSummaryCard(membership: membership),
        SizedBox(height: 16.h),
        _FinancialInformationSection(membership: membership),
        SizedBox(height: 16.h),
        _PaymentsSection(payments: membership.payments),
        SizedBox(height: 16.h),
        _FinancialObligationsSection(
          obligations: membership.financialObligations,
        ),
        SizedBox(height: 16.h),
        _ExpandableProfileSection(
          title: l10n.associationLinkMembershipSection,
          icon: Icons.badge_outlined,
          children: [
            InfoRow(
              label: l10n.associationLinkMembershipNumber,
              value: membership.membershipNumber,
            ),
            InfoRow(
              label: l10n.associationLinkPriorityNumber,
              value: _formatNullableNumber(membership.priorityNumber),
            ),
            InfoRow(
              label: l10n.associationMemberType,
              value: membership.displayType,
            ),
            InfoRow(
              label: l10n.associationMemberStatus,
              value: membership.displayStatus,
            ),
            InfoRow(
              label: l10n.associationMemberDate,
              value: membership.joinDate,
            ),
            InfoRow(
              label: AppLocalizations.of(
                context,
              )!.associationMemberMembershipDecision,
              value: membership.membershipDecision,
            ),
            InfoRow(
              label: AppLocalizations.of(context)!.associationMemberClosedAt,
              value: membership.closedAt,
            ),
          ],
        ),
        _ProjectsInformationSection(projects: projects),
        _BuildingsInformationSection(projects: projects, buildings: buildings),
        if (unit != null) _UnitDetailsSection(unit: unit),
      ],
    );
  }

  List<AssociationProject> _projectsForMembership(
    AssociationMemberProfileModel profile,
    AssociationMembership membership,
  ) {
    final membershipProject = membership.project;
    if (membershipProject == null) return const [];

    for (final project in profile.projects) {
      if (project.id != null && project.id == membershipProject.id) {
        return [project];
      }
    }
    return [membershipProject];
  }

  List<AssociationBuilding> _buildingsForMembership(
    AssociationMembership membership,
  ) {
    final membershipBuilding = membership.building;
    if (membershipBuilding != null) return [membershipBuilding];

    final unitBuilding = membership.unit?.building;
    if (unitBuilding != null) return [unitBuilding];

    return const [];
  }
}

class _FinancialInformationSection extends StatelessWidget {
  const _FinancialInformationSection({required this.membership});

  final AssociationMembership membership;

  @override
  Widget build(BuildContext context) {
    final financial = membership.financialInformation;
    if (financial == null) return const SizedBox.shrink();

    return _ExpandableProfileSection(
      title: AppLocalizations.of(
        context,
      )!.associationMemberFinancialInformation,
      icon: Icons.account_balance_wallet_outlined,
      children: [
        InfoRow(
          label: AppLocalizations.of(
            context,
          )!.associationMemberTotalObligations,
          value: _formatNullableMoney(context, financial.totalObligations),
        ),
        InfoRow(
          label: AppLocalizations.of(context)!.associationMemberTotalPayments,
          value: _formatNullableMoney(context, financial.totalPayments),
        ),
        InfoRow(
          label: AppLocalizations.of(
            context,
          )!.associationMemberCoveredObligations,
          value: _formatNullableMoney(context, financial.coveredObligations),
        ),
        InfoRow(
          label: AppLocalizations.of(
            context,
          )!.associationMemberUncoveredObligations,
          value: _formatNullableMoney(context, financial.uncoveredObligations),
          labelNumber: _formatNullableNumber(financial.openObligationsCount),
        ),
        InfoRow(
          label: AppLocalizations.of(
            context,
          )!.associationMemberOverdueObligationsAmount,
          value: _formatNullableMoney(
            context,
            financial.overdueObligationsAmount,
          ),
          labelNumber: _formatNullableNumber(financial.overdueObligationsCount),
        ),
        InfoRow(
          label: AppLocalizations.of(context)!.associationMemberCurrentBalance,
          value: _formatNullableMoney(context, financial.currentBalance),
        ),
        InfoRow(
          label: AppLocalizations.of(context)!.associationMemberFinancialStatus,
          value: financial.memberFinancialStatusLabel.isNotEmpty
              ? financial.memberFinancialStatusLabel
              : financial.memberFinancialStatus,
        ),
      ],
    );
  }
}

class _PaymentsSection extends StatelessWidget {
  const _PaymentsSection({required this.payments});

  final List<AssociationPayment> payments;

  @override
  Widget build(BuildContext context) {
    return _ExpandableProfileSection(
      title: AppLocalizations.of(context)!.associationMemberPayments,
      icon: Icons.payments_outlined,
      children: payments.isEmpty
          ? [
              _EmptyInlineState(
                icon: Icons.receipt_long_outlined,
                text: AppLocalizations.of(
                  context,
                )!.associationMemberNoRecordedPayments,
              ),
            ]
          : [
              _PaginatedSectionList<AssociationPayment>(
                items: payments,
                pageHeight: 420.h,
                itemBuilder: (payment) => _PaymentTile(payment: payment),
              ),
            ],
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.payment});

  final AssociationPayment payment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l1on = AppLocalizations.of(context)!;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.goldDark.withValues(alpha: 0.14),
            child: Icon(
              Icons.receipt_long_outlined,
              color: AppColors.goldDark,
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _formatNullableMoney(context, payment.amount),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _StatusPill(
                      label: payment.approvalStatusLabel.isNotEmpty
                          ? payment.approvalStatusLabel
                          : payment.approvalStatus,
                      color: _statusColor(payment.approvalStatus),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  _joinValues([
                    '${l1on.payDate} ${payment.paymentDate}',
                    payment.paymentMethodLabel.isNotEmpty
                        ? payment.paymentMethodLabel
                        : payment.paymentMethod,
                    payment.voucherNumber.isNotEmpty
                        ? '${l1on.associationMemberVoucher} ${payment.voucherNumber}'
                        : '',
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

class _FinancialObligationsSection extends StatelessWidget {
  const _FinancialObligationsSection({required this.obligations});

  final List<AssociationFinancialObligation> obligations;

  @override
  Widget build(BuildContext context) {
    return _ExpandableProfileSection(
      title: AppLocalizations.of(
        context,
      )!.associationMemberFinancialObligations,
      icon: Icons.assignment_outlined,
      children: obligations.isEmpty
          ? [
              _EmptyInlineState(
                icon: Icons.task_alt_rounded,
                text: AppLocalizations.of(
                  context,
                )!.associationMemberNoFinancialObligations,
              ),
            ]
          : [
              _PaginatedSectionList<AssociationFinancialObligation>(
                items: obligations,
                pageHeight: 460.h,
                itemBuilder: (obligation) =>
                    _ObligationTile(obligation: obligation),
              ),
            ],
    );
  }
}

class _ObligationTile extends StatelessWidget {
  const _ObligationTile({required this.obligation});

  final AssociationFinancialObligation obligation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusText = obligation.statusLabel.isNotEmpty
        ? obligation.statusLabel
        : obligation.status;
    final statusColor = obligation.isCovered
        ? Colors.green
        : _statusColor(obligation.status);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: statusColor.withValues(alpha: 0.12),
            child: Icon(
              obligation.isCovered
                  ? Icons.check_circle_outline_rounded
                  : Icons.pending_actions_outlined,
              color: statusColor,
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        obligation.name.isEmpty ? '-' : obligation.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _StatusPill(label: statusText, color: statusColor),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  _formatNullableMoney(context, obligation.amount),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _joinValues([
                    obligation.dueDate.isNotEmpty
                        ? '${AppLocalizations.of(context)!.associationMemberDue} ${obligation.dueDate}'
                        : '',
                    obligation.paymentDeadline.isNotEmpty
                        ? '${AppLocalizations.of(context)!.associationMemberDeadline} ${obligation.paymentDeadline}'
                        : '',
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

class _PaginatedSectionList<T> extends StatefulWidget {
  const _PaginatedSectionList({
    required this.items,
    required this.itemBuilder,
    required this.pageHeight,
  });

  static const int pageSize = 5;

  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final double pageHeight;

  @override
  State<_PaginatedSectionList<T>> createState() =>
      _PaginatedSectionListState<T>();
}

class _PaginatedSectionListState<T> extends State<_PaginatedSectionList<T>> {
  late final PageController _pageController;
  int _currentPage = 0;

  int get _pageCount =>
      (widget.items.length / _PaginatedSectionList.pageSize).ceil();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(covariant _PaginatedSectionList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length == oldWidget.items.length) return;

    final lastPage = _pageCount - 1;
    if (_currentPage > lastPage) {
      _currentPage = lastPage.clamp(0, lastPage);
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_currentPage);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateToPage(int page) {
    if (page < 0 || page >= _pageCount || page == _currentPage) return;
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.length <= _PaginatedSectionList.pageSize) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.items.map(widget.itemBuilder).toList(),
      );
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.goldLight : AppColors.burgundy;
    final canGoBack = _currentPage > 0;
    final canGoForward = _currentPage < _pageCount - 1;

    return Column(
      children: [
        SizedBox(
          height: widget.pageHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _pageCount,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, pageIndex) {
              final start = pageIndex * _PaginatedSectionList.pageSize;
              final pageItems = widget.items
                  .skip(start)
                  .take(_PaginatedSectionList.pageSize);

              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: pageItems.map(widget.itemBuilder).toList(),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              onPressed: canGoBack
                  ? () => _animateToPage(_currentPage - 1)
                  : null,
              icon: const Icon(Icons.chevron_left_rounded),
              color: accentColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Text(
                '${_currentPage + 1} / $_pageCount',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton.filledTonal(
              onPressed: canGoForward
                  ? () => _animateToPage(_currentPage + 1)
                  : null,
              icon: const Icon(Icons.chevron_right_rounded),
              color: accentColor,
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyInlineState extends StatelessWidget {
  const _EmptyInlineState({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryFixed.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 22.r),
          SizedBox(width: 10.w),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _ProjectsInformationSection extends StatelessWidget {
  const _ProjectsInformationSection({required this.projects});

  final List<AssociationProject> projects;

  @override
  Widget build(BuildContext context) {
    return _ExpandableProfileSection(
      title: AppLocalizations.of(context)!.associationMemberProjects,
      icon: Icons.apartment_rounded,
      children: projects.isEmpty
          ? [
              _EmptyInlineState(
                icon: Icons.apartment_rounded,
                text: AppLocalizations.of(
                  context,
                )!.associationMemberNoProjectsAvailable,
              ),
            ]
          : projects
                .map((project) => _ProjectDetailsSection(project: project))
                .toList(),
    );
  }
}

class _ProjectDetailsSection extends StatelessWidget {
  const _ProjectDetailsSection({required this.project});

  final AssociationProject project;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          project.name,
          style: theme.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.offWhite : AppColors.burgundy,
            fontWeight: FontWeight.w800,
          ),
        ),

        _MediaGallery(
          title: AppLocalizations.of(context)!.associationMemberProjectGallery,
          imageUrl: project.imageUrl,
          galleryImages: [...project.images, ...project.galleryImages],
          fallbackIcon: Icons.apartment_rounded,
        ),
        SizedBox(height: 12.h),
        _infoRowIfValue(
          label: l10n.associationMemberLocation,
          value: _joinValues([
            project.governorate,
            project.region,
            project.address,
          ]),
        ),
        _ProjectLocationButton(project: project),
        _ProfileFilesSection(
          title: AppLocalizations.of(
            context,
          )!.associationMemberProjectMasterPlan,
          fileUrls: _fileUrlsFromValue(project.masterPlanUrl),
          fallbackName: AppLocalizations.of(
            context,
          )!.associationMemberProjectMasterPlanFile,
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberBuildings,
          value: _formatNullableNumber(
            project.numberOfBuildings ?? project.buildings.length,
          ),
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberTotalUnits,
          value: _formatNullableNumber(
            project.totalUnits ?? project.totalNumberOfUnits,
          ),
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberAvailableUnits,
          value: _formatNullableNumber(project.availableUnits),
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberAllocatedUnits,
          value: _formatNullableNumber(project.allocatedUnits),
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberDeliveredUnits,
          value: _formatNullableNumber(project.deliveredUnits),
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberRemainingUnits,
          value: _formatNullableNumber(project.remainingUnits),
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberEstimatedCost,
          value: _formatNullableMoney(context, project.estimatedCost),
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberEngineer,
          value: project.projectEngineer,
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberLandArea,
          value: _formatNullableNumber(project.landArea),
        ),
        _StagesTimeline(
          title: AppLocalizations.of(context)!.associationMemberProjectStages,
          stages: project.stages,
          emptyText: AppLocalizations.of(
            context,
          )!.associationMemberNoProjectStagesAvailable,
        ),
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
    final displayLatitude = latitude ?? 0;
    final displayLongitude = longitude ?? 0;

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
                  AppLocalizations.of(
                    context,
                  )!.associationMemberProjectLocation,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${_formatCoordinate(displayLatitude)}, ${_formatCoordinate(displayLongitude)}',
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
            tooltip: AppLocalizations.of(
              context,
            )!.associationMemberOpenGoogleMaps,
            onPressed: () => _openProjectLocation(context, project),
            icon: const Icon(Icons.map_rounded),
          ),
        ],
      ),
    );
  }
}

class _BuildingsInformationSection extends StatelessWidget {
  const _BuildingsInformationSection({
    required this.projects,
    this.buildings = const [],
  });

  final List<AssociationProject> projects;
  final List<AssociationBuilding> buildings;

  @override
  Widget build(BuildContext context) {
    final projectsWithBuildings = projects
        .where((project) => project.buildings.isNotEmpty)
        .toList();
    final hasMembershipBuildings = buildings.isNotEmpty;

    return _ExpandableProfileSection(
      title: AppLocalizations.of(context)!.associationMemberBuildingInformation,
      icon: Icons.business_rounded,
      children: hasMembershipBuildings
          ? buildings
                .map((building) => _BuildingDetailsSection(building: building))
                .toList()
          : projectsWithBuildings.isEmpty
          ? [
              _EmptyInlineState(
                icon: Icons.business_rounded,
                text: AppLocalizations.of(
                  context,
                )!.associationMemberNoBuildingsAvailable,
              ),
            ]
          : projectsWithBuildings
                .map((project) => _ProjectBuildingsGroup(project: project))
                .toList(),
    );
  }
}

class _ProjectBuildingsGroup extends StatelessWidget {
  const _ProjectBuildingsGroup({required this.project});

  final AssociationProject project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (project.name.trim().isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.apartment_rounded,
                  size: 18.r,
                  color: isDark ? AppColors.goldLight : AppColors.burgundy,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    project.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.offWhite : AppColors.burgundy,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
          ...project.buildings.map(
            (building) => _BuildingDetailsSection(building: building),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MediaGallery(
          title: AppLocalizations.of(context)!.associationMemberBuildingGallery,
          imageUrl: building.buildingPlanUrl,
          galleryImages: [
            ...building.floorPlanImages,
            ...building.galleryImages,
          ],
          fallbackIcon: Icons.business_rounded,
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(
            context,
          )!.associationMemberCompletionPercentage,
          value: _formatNullablePercent(building.completionPercentage),
        ),
        _infoRowIfValue(
          label: l10n.associationLinkBuilding,
          value: building.displayName,
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberBuildingNumber,
          value: building.buildingNumber,
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberDescription,
          value: building.description,
        ),
        _infoRowIfValue(
          label: l10n.associationMemberLocation,
          value: building.physicalAddress,
        ),
        _ProfileFilesSection(
          title: AppLocalizations.of(context)!.associationMemberBuildingPlan,
          fileUrls: _fileUrlsFromValue(building.buildingPlanUrl),
          fallbackName: AppLocalizations.of(
            context,
          )!.associationMemberBuildingPlanFile,
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberFloors,
          value: _formatNullableNumber(building.numberOfFloors),
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberUnits,
          value: _formatNullableNumber(building.numberOfUnits),
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberTotalUnits,
          value: _formatNullableNumber(building.totalUnits),
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberAvailableUnits,
          value: _formatNullableNumber(building.availableUnits),
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberAllocatedUnits,
          value: _formatNullableNumber(building.allocatedUnits),
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberDeliveredUnits,
          value: _formatNullableNumber(building.deliveredUnits),
        ),
        _infoRowIfValue(
          label: AppLocalizations.of(context)!.associationMemberSpecifications,
          value: building.specifications,
        ),
        _StagesTimeline(
          title: AppLocalizations.of(context)!.associationMemberBuildingStages,
          stages: building.stages,
          emptyText: AppLocalizations.of(
            context,
          )!.associationMemberNoBuildingStagesAvailable,
        ),
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

    return _ExpandableProfileSection(
      title: l10n.residentialUnit,
      icon: Icons.home_work_outlined,
      children: [
        _MediaGallery(
          title: AppLocalizations.of(context)!.associationMemberUnitGallery,
          imageUrl: unit.unitPlanUrl,
          galleryImages: [...unit.images, ...unit.galleryImages],
          fallbackIcon: Icons.home_work_outlined,
        ),
        InfoRow(label: l10n.unit, value: unit.unitNumber),
        InfoRow(
          label: AppLocalizations.of(context)!.associationMemberFloor,
          value: _formatNullableNumber(unit.floorNumber),
        ),
        InfoRow(
          label: AppLocalizations.of(context)!.associationMemberOrientation,
          value: unit.orientationLabel.isNotEmpty
              ? unit.orientationLabel
              : unit.orientation,
        ),
        InfoRow(
          label: AppLocalizations.of(context)!.associationMemberArea,
          value: _formatNullableNumber(unit.area),
        ),
        InfoRow(
          label: AppLocalizations.of(
            context,
          )!.associationMemberGardenTerraceArea,
          value: _formatNullableNumber(unit.gardenTerraceArea),
        ),
        InfoRow(
          label: l10n.associationMemberAmount,
          value: _formatNullableMoney(context, unit.price),
        ),
        InfoRow(
          label: AppLocalizations.of(context)!.associationMemberSpecifications,
          value: unit.specifications,
        ),
        InfoRow(
          label: l10n.associationMemberStatus,
          value: unit.statusLabel.isNotEmpty ? unit.statusLabel : unit.status,
        ),
        _ProfileFilesSection(
          title: AppLocalizations.of(context)!.associationMemberUnitPlan,
          fileUrls: _fileUrlsFromValue(unit.unitPlanUrl),
          fallbackName: AppLocalizations.of(
            context,
          )!.associationMemberUnitPlanFile,
        ),
        InfoRow(
          label: AppLocalizations.of(context)!.associationMemberUnitPlan,
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
  final String? imageUrl;
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
    final visibleImages = galleryImages;

    return SizedBox(
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
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
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

class _StagesTimeline extends StatelessWidget {
  const _StagesTimeline({
    required this.title,
    required this.stages,
    required this.emptyText,
  });

  final String title;
  final List<StageModel> stages;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 10.h),
        if (stages.isEmpty)
          _EmptyInlineState(icon: Icons.construction_rounded, text: emptyText)
        else
          ...List.generate(
            stages.length,
            (index) => _StageTile(stage: stages[index], index: index),
          ),
      ],
    );
  }
}

class _StageTile extends StatelessWidget {
  const _StageTile({required this.stage, required this.index});

  final StageModel stage;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.goldLight : AppColors.burgundy;
    final stageName = stage.stageName?.trim() ?? '';
    final title = stageName.isEmpty
        ? '${AppLocalizations.of(context)!.associationMemberStages} ${index + 1}'
        : stageName;
    final notes = stage.notes?.trim() ?? '';
    final images = stage.allImages;
    final percentText = _formatNullablePercent(stage.completionPercentage);
    final displayPercent = percentText.isEmpty ? '-' : percentText;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryFixed.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${l10n.associationMemberStage} ${(index + 1).toString()}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onTertiaryFixed,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 16.h),
          _StageHero(
            title: title,
            percentText: displayPercent,
            imageUrl: images.isEmpty ? null : images.first,
            fallbackIcon: Icons.business_rounded,
          ),
          SizedBox(height: 16.h),
          Divider(color: accent.withValues(alpha: 0.12), height: 1),
          SizedBox(height: 16.h),
          Text(
            AppLocalizations.of(context)!.associationMemberCompletion,
            style: theme.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.taupe : AppColors.burgundy,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 16.h),
          _StageProgressRow(
            percentage: stage.completionPercentage,
            accent: accent,
            isDark: isDark,
          ),
          SizedBox(height: 16.h),
          _StageDatesColumn(stage: stage),
          ...[
            Text(
              notes,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.taupe : AppColors.black,
                height: 1.35,
              ),
            ),
          ],
          if (images.isNotEmpty) ...[
            SizedBox(height: 16.h),
            _StageGalleryPanel(
              title: title,
              images: images,
              fallbackIcon: Icons.image_outlined,
            ),
          ],
        ],
      ),
    );
  }
}

class _StageHero extends StatelessWidget {
  const _StageHero({
    required this.title,
    required this.percentText,
    required this.imageUrl,
    required this.fallbackIcon,
  });

  final String title;
  final String percentText;
  final String? imageUrl;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: SizedBox(
        height: 210.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomNetworkImage(
              imageUrl: imageUrl,
              defaultIcon: fallbackIcon,
              defaultIconColor: AppColors.burgundy,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: AppColors.burgundy.withValues(alpha: 0.58),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.black.withValues(alpha: 0.12),
                  ),
                ),
              ],
            ),
            PositionedDirectional(
              top: 34.h,
              start: 28.w,
              end: 28.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    percentText,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: AppColors.offWhite,
                      fontSize: 44.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.offWhite,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
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
}

class _StageProgressRow extends StatelessWidget {
  const _StageProgressRow({
    required this.percentage,
    required this.accent,
    required this.isDark,
  });

  final num? percentage;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = _formatNullablePercent(percentage);

    return Row(
      spacing: 8.w,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: _percentRatio(percentage),
              minHeight: 9.h,
              backgroundColor: AppColors.burgundy.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
        ),
        Text(
          percent.isEmpty ? '-' : percent,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.burgundy,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _StageDatesColumn extends StatelessWidget {
  const _StageDatesColumn({required this.stage});

  final StageModel stage;

  @override
  Widget build(BuildContext context) {
    final dates = [
      _StageDateData(
        label: AppLocalizations.of(context)!.associationMemberStartDate,
        value: stage.startDate,
      ),
      _StageDateData(
        label: AppLocalizations.of(context)!.associationMemberEndDate,
        value: stage.endDate,
      ),
    ].where((date) => date.hasValue).toList();

    if (dates.isEmpty) return const SizedBox.shrink();

    return Column(
      spacing: 4.h,
      children: List.generate(dates.length, (index) {
        return SizedBox(
          width: double.infinity,
          child: _StageDateCard(data: dates[index]),
        );
      }),
    );
  }
}

class _StageDateData {
  const _StageDateData({required this.label, required this.value});

  final String label;
  final String? value;

  bool get hasValue => value?.trim().isNotEmpty == true;
}

class _StageDateCard extends StatelessWidget {
  const _StageDateCard({required this.data});

  final _StageDateData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.burgundy.withValues(alpha: 0.12),
              ),
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              color: AppColors.burgundy,
              size: 22.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.black.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  data.value!.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.burgundy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StageGalleryPanel extends StatelessWidget {
  const _StageGalleryPanel({
    required this.title,
    required this.images,
    required this.fallbackIcon,
  });

  final String title;
  final List<String> images;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleImages = images
        .where((image) => image.trim().isNotEmpty)
        .toSet()
        .toList();

    return Column(
      spacing: 8.h,
      children: [
        Row(
          spacing: 8.w,
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: AppColors.burgundy.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.image_outlined,
                color: AppColors.burgundy,
                size: 24.r,
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.associationMemberStageGallery,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onTertiaryFixed,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        _MediaGallery(
          title: title,
          imageUrl: visibleImages.first,
          galleryImages: visibleImages,
          fallbackIcon: fallbackIcon,
        ),
      ],
    );
  }
}

double _percentRatio(num? value) {
  if (value == null) return 0;
  return (value.toDouble() / 100).clamp(0, 1).toDouble();
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
        color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.1),
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
                    ? AppLocalizations.of(context)!.active
                    : AppLocalizations.of(context)!.inactive,
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
                    ? AppLocalizations.of(
                        context,
                      )!.associationMemberAssignedToProject
                    : AppLocalizations.of(
                        context,
                      )!.associationMemberNoProjectAssignment,
                color: membership.isAssignedToProject ? accent : AppColors.red,
              ),
              _StatusPill(
                label: membership.isAssignedToUnit
                    ? AppLocalizations.of(
                        context,
                      )!.associationMemberAssignedToUnit
                    : AppLocalizations.of(
                        context,
                      )!.associationMemberNoUnitAssignment,
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

Widget _infoRowIfValue({
  required String label,
  required Object? value,
  String? labelNumber,
}) {
  final display = value?.toString().trim() ?? '';
  if (display.isEmpty || display == '-') return const SizedBox.shrink();
  return InfoRow(label: label, value: display, labelNumber: labelNumber);
}

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.labelNumber,
  });

  final String label;
  final String value;
  final String? labelNumber;

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
          Row(
            spacing: 16.w,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.taupe : AppColors.burgundy,
                ),
              ),
              labelNumber != null
                  ? Text(
                      '(${labelNumber!})',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
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
    this.title = '',
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
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
            if (title.trim().isNotEmpty) ...[
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8.h),
            ],
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

Color _statusColor(String status) {
  final normalized = status.toLowerCase();
  if (normalized.contains('approved') ||
      normalized.contains('paid') ||
      normalized.contains('success') ||
      normalized.contains('covered')) {
    return Colors.green;
  }
  if (normalized.contains('pending') || normalized.contains('due')) {
    return AppColors.goldDark;
  }
  if (normalized.contains('rejected') ||
      normalized.contains('failed') ||
      normalized.contains('overdue')) {
    return AppColors.red;
  }
  return AppColors.burgundy;
}

String _formatNullableNumber(num? value) {
  if (value == null) return '';
  final asDouble = value.toDouble();
  if (asDouble == asDouble.truncateToDouble()) {
    return asDouble.toInt().toString();
  }
  return asDouble.toStringAsFixed(2);
}

String _formatNullableMoney(BuildContext context, num? value) {
  final formatted = _formatNullableNumber(value);
  if (formatted.isEmpty) return '';
  return '$formatted ${AppLocalizations.of(context)!.currencySYP}';
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
        AppLocalizations.of(
          context,
        )!.associationMemberProjectLocationOpenFailed,
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
