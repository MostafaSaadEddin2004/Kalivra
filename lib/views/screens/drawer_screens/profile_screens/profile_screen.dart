import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/services/referral_repository.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:kalivra/views/widgets/profile/referral_qr_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late final Future<String> _referralCodeFuture;
  bool _referralCardExpanded = false;

  @override
  void initState() {
    super.initState();
    _referralCodeFuture = ReferralRepository().getMyReferralCode();
    context.read<AuthCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;
    final valueColor = isDark ? AppColors.offWhite : AppColors.black;

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'حسابي'),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState.token == null || authState.token!.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'سجّل الدخول لعرض الملف الشخصي',
                      style: textTheme.bodyLarge?.copyWith(color: labelColor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    FilledButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: const Text('تسجيل الدخول'),
                    ),
                  ],
                ),
              ),
            );
          }

          final customer = authState.customer;
          final profileLoading = customer == null && authState.isLoading;
          final displayName = customer != null
              ? (customer.name ?? '${customer.firstName ?? ''} ${customer.lastName ?? ''}'.trim())
              : '---';
          final memberSince = _formatMemberSince(customer?.createdAt);

          if (profileLoading) {
            return Skeletonizer(
              enabled: true,
              child: ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(radius: 48.r),
                        SizedBox(height: 12.h),
                        Text('أحمد محمد', style: textTheme.headlineSmall),
                        Text('عميل منذ 2024', style: textTheme.bodySmall),
                        SizedBox(height: 8.h),
                        FilledButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.edit_rounded, size: 18.r),
                          label: const Text('تعديل الملف الشخصي'),
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),
                  _SectionCard(
                    title: 'معلومات الحساب',
                    children: [
                      _InfoRow(label: 'الاسم', value: '---', icon: Icons.person_outline_rounded),
                      _InfoRow(label: 'البريد', value: '---', icon: Icons.email_outlined),
                    ],
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.all(20.w),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48.r,
                      backgroundColor: isDark
                          ? AppColors.burgundy.withValues(alpha: 0.3)
                          : AppColors.burgundy.withValues(alpha: 0.15),
                      child: Icon(
                        Icons.person_rounded,
                        size: 56.r,
                        color: isDark ? AppColors.goldLight : AppColors.burgundy,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      displayName.isEmpty ? 'حسابي' : displayName,
                      style: textTheme.headlineSmall?.copyWith(
                        color: valueColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      memberSince,
                      style: textTheme.bodySmall?.copyWith(
                        color: labelColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    FilledButton.icon(
                      onPressed: () => context.push(AppRoutes.editProfile),
                      icon: Icon(Icons.edit_rounded, size: 18.r),
                      label: const Text('تعديل الملف الشخصي'),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28.h),
          FutureBuilder<String>(
            future: _referralCodeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Center(
                      child: SizedBox(
                        width: 32.w,
                        height: 32.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                );
              }
              final code = snapshot.data ?? '';
              if (code.isEmpty) return const SizedBox.shrink();
              final primary = theme.colorScheme.primary;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _referralCardExpanded = !_referralCardExpanded),
                  borderRadius: BorderRadius.circular(20.r),
                  child: AnimatedCrossFade(
                    firstChild: _ReferralCardCollapsed(
                      primary: primary,
                      isDark: isDark,
                      theme: theme,
                    ),
                    secondChild: ReferralQrCard(referralCode: code),
                    crossFadeState: _referralCardExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 280),
                    firstCurve: Curves.decelerate,
                    secondCurve: Curves.easeInOut,
                    sizeCurve: Curves.easeInOut,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16.h),
          _SectionCard(
            title: 'معلومات الحساب',
            children: [
              _InfoRow(label: 'الاسم الكامل', value: displayName.isEmpty ? '---' : displayName, icon: Icons.person_outline_rounded),
              _InfoRow(label: 'البريد الإلكتروني', value: customer?.email ?? '---', icon: Icons.email_outlined),
              _InfoRow(label: 'رقم الجوال', value: customer?.phone ?? '---', icon: Icons.phone_android_rounded),
              _InfoRow(label: 'تاريخ التسجيل', value: memberSince, icon: Icons.calendar_today_rounded),
            ],
          ),
          SizedBox(height: 16.h),
          _SectionCard(
            title: 'العنوان',
            children: [
              _InfoRow(
                label: 'العنوان الرئيسي',
                value: 'الرياض، حي النخيل، شارع الملك فهد',
                icon: Icons.location_on_outlined,
              ),
              _InfoRow(label: 'الرمز البريدي', value: '12345', icon: Icons.markunread_mailbox_rounded),
            ],
          ),
          SizedBox(height: 16.h),
          _SectionCard(
            title: 'إحصائيات',
            children: [
              _StatRow(label: 'عدد الطلبات', value: '12', icon: Icons.receipt_long_rounded),
              _StatRow(label: 'طلبات قيد التنفيذ', value: '2', icon: Icons.hourglass_top_rounded),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      );
        },
      ),
    );
  }

  static String _formatMemberSince(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return '---';
    try {
      final d = DateTime.tryParse(createdAt);
      if (d != null) return 'عميل منذ ${d.year}';
    } catch (_) {}
    return '---';
  }
}

/// Collapsed state: QR icon, title, and description (tap to expand).
class _ReferralCardCollapsed extends StatelessWidget {
  const _ReferralCardCollapsed({
    required this.primary,
    required this.isDark,
    required this.theme,
  });

  final Color primary;
  final bool isDark;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: primary.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Row(
          children: [
            Icon(
              Icons.qr_code_2_rounded,
              size: 40.r,
              color: primary,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'كود الدعوة',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isDark ? AppColors.offWhite : AppColors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'شارك هذا الكود أو المسح مع الأصدقاء ليحصلوا على خصم عند التسجيل، وتستفيد أنت أيضاً',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.taupe : AppColors.burgundy,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.expand_more_rounded,
              size: 28.r,
              color: primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12.h),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
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
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;
    final valueColor = isDark ? AppColors.offWhite : AppColors.black;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22.r, color: labelColor),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(color: labelColor),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.w500,
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

class _StatRow extends StatelessWidget {
  const _StatRow({
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

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 22.r, color: isDark ? AppColors.goldLight : AppColors.burgundy),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.offWhite : AppColors.black,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.burgundy.withValues(alpha: 0.3)
                  : AppColors.burgundy.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
