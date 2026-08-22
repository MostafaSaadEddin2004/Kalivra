import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class AccountEmailScreen extends StatefulWidget {
  const AccountEmailScreen({super.key, this.accountEmail});

  final String? accountEmail;

  @override
  State<AccountEmailScreen> createState() => _AccountEmailScreenState();
}

class _AccountEmailScreenState extends State<AccountEmailScreen> {
  late final TextEditingController _emailController;
  late bool _showEmailForm;

  bool get _hasAccount =>
      widget.accountEmail != null && widget.accountEmail!.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.accountEmail ?? '');
    _showEmailForm = !_hasAccount;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _openVerificationCodeScreen() {
    final email = _emailController.text.trim();
    context.push(
      AppRoutes.accountVerificationCode,
      extra: email.isEmpty ? widget.accountEmail : email,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: ScreenAppBar(
        title: _hasAccount
            ? l10n.settingsChangeAccount
            : l10n.settingsAddAccount,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
        children: [
          if (_hasAccount && !_showEmailForm)
            _ConnectedAccountCard(
              accountEmail: widget.accountEmail!.trim(),
              onChangePressed: () => setState(() => _showEmailForm = true),
            )
          else
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 54.r,
                      height: 54.r,
                      decoration: BoxDecoration(
                        color: colorScheme.onTertiaryFixed.withValues(
                          alpha: 0.1,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.alternate_email_rounded,
                        size: 28.r,
                        color: colorScheme.onTertiaryFixed,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      _hasAccount
                          ? l10n.settingsChangeAccount
                          : l10n.settingsAddAccount,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.primaryFixed,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      l10n.accountEmailDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primaryFixed.withValues(alpha: 0.72),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    AppTextField(
                      controller: _emailController,
                      label: l10n.email,
                      hint: 'name@example.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 22.r,
                        color: colorScheme.onTertiaryFixed,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _openVerificationCodeScreen,
                        icon: Icon(Icons.mark_email_read_outlined, size: 20.r),
                        label: Text(
                          l10n.sendVerificationCode,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.offWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ConnectedAccountCard extends StatelessWidget {
  const _ConnectedAccountCard({
    required this.accountEmail,
    required this.onChangePressed,
  });

  final String accountEmail;
  final VoidCallback onChangePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Row(
          children: [
            Container(
              width: 50.r,
              height: 50.r,
              decoration: BoxDecoration(
                color: colorScheme.onTertiaryFixed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.verified_user_outlined,
                color: colorScheme.onTertiaryFixed,
                size: 26.r,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.connectedAccount,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primaryFixed.withValues(alpha: 0.68),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    accountEmail,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.primaryFixed,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: onChangePressed,
              icon: Icon(Icons.edit_outlined, size: 18.r),
              label: Text(l10n.settingsChangeAccount),
            ),
          ],
        ),
      ),
    );
  }
}
