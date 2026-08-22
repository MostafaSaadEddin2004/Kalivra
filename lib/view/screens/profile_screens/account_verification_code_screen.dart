import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AccountVerificationCodeScreen extends StatefulWidget {
  const AccountVerificationCodeScreen({super.key, this.accountEmail});

  final String? accountEmail;

  @override
  State<AccountVerificationCodeScreen> createState() =>
      _AccountVerificationCodeScreenState();
}

class _AccountVerificationCodeScreenState
    extends State<AccountVerificationCodeScreen> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final accountEmail = widget.accountEmail?.trim();

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.accountVerificationCodeTitle),
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
                  Container(
                    width: 54.r,
                    height: 54.r,
                    decoration: BoxDecoration(
                      color: colorScheme.onTertiaryFixed.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.password_rounded,
                      size: 28.r,
                      color: colorScheme.onTertiaryFixed,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    l10n.accountVerificationCodeTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.primaryFixed,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    l10n.accountVerificationCodeDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primaryFixed.withValues(alpha: 0.72),
                      height: 1.4,
                    ),
                  ),
                  if (accountEmail != null && accountEmail.isNotEmpty) ...[
                    SizedBox(height: 10.h),
                    Text(
                      accountEmail,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onTertiaryFixed,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  SizedBox(height: 24.h),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: PinCodeTextField(
                      appContext: context,
                      controller: _codeController,
                      autoDisposeControllers: false,
                      length: 6,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      textStyle: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.primaryFixed,
                        fontWeight: FontWeight.w700,
                      ),
                      cursorColor: colorScheme.onTertiaryFixed,
                      enableActiveFill: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(12.r),
                        fieldHeight: 52.r,
                        fieldWidth: 44.w,
                        activeColor: colorScheme.onTertiaryFixed,
                        selectedColor: colorScheme.onTertiaryFixed,
                        inactiveColor: colorScheme.onTertiaryFixed.withValues(
                          alpha: 0.35,
                        ),
                        activeFillColor: AppColors.offWhite,
                        selectedFillColor: AppColors.offWhite,
                        inactiveFillColor: AppColors.offWhite,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        l10n.authOtpResendCode,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onTertiaryFixed,
                          decoration: TextDecoration.underline,
                          decorationColor: colorScheme.onTertiaryFixed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.verified_user_rounded, size: 20.r),
                      label: Text(
                        l10n.verifyAccount,
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
