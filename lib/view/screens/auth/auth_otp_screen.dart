import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/pop_scope_exit_app.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';

class AuthOtpArgs {
  const AuthOtpArgs({this.email, this.phone, this.token});

  final String? email;
  final String? phone;
  final String? token;
}

class AuthOtpScreen extends StatefulWidget {
  const AuthOtpScreen({super.key, required this.args});

  final AuthOtpArgs args;

  @override
  State<AuthOtpScreen> createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends State<AuthOtpScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  String _maskedDestination(BuildContext context) {
    if ((widget.args.email ?? '').trim().isNotEmpty) {
      return widget.args.email!.trim();
    }
    if ((widget.args.phone ?? '').trim().isNotEmpty) {
      return widget.args.phone!.trim();
    }
    return AppLocalizations.of(context)!.yourAccount;
  }

  void _verify() {
    final l10n = AppLocalizations.of(context)!;
    if (_otpController.text.trim().length < 4) {
      CustomSnackBar.show(context, l10n.enterCodeHintSnack);
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.go(AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;
    final l10n = AppLocalizations.of(context)!;

    return PopScopeExitApp(
      child: Scaffold(
        appBar: DrawerScreenAppBar(title: l10n.authOtpTitle),
        body: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
          children: [
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
                    Text(
                      l10n.authOtpSentTo(_maskedDestination(context)),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    AppTextField(
                      controller: _otpController,
                      label: l10n.otpCodeLabel,
                      hint: '••••',
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      prefixIcon: Icon(
                        Icons.pin_rounded,
                        size: 22.r,
                        color: labelColor,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isLoading ? null : _verify,
                        icon: _isLoading
                            ? SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.offWhite,
                                ),
                              )
                            : Icon(Icons.verified_user_rounded, size: 20.r),
                        label: Text(
                          l10n.verify,
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
      ),
    );
  }
}
