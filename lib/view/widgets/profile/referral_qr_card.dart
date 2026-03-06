import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Displays the user's referral code as a QR code and as text with copy action.
/// The [referralCode] should come from the server API.
class ReferralQrCard extends StatelessWidget {
  const ReferralQrCard({
    super.key,
    required this.referralCode,
    this.onCopy,
  });

  final String referralCode;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final surfaceColor = isDark
        ? AppColors.burgundy.withValues(alpha: 0.2)
        : AppColors.burgundy.withValues(alpha: 0.06);

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
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.qr_code_2_rounded,
                  size: 26.r,
                  color: primary,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'كود الدعوة',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isDark ? AppColors.offWhite : AppColors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'شارك هذا الكود أو المسح مع الأصدقاء ليحصلوا على خصم عند التسجيل، وتستفيد أنت أيضاً',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.taupe : AppColors.burgundy,
                height: 1.35,
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: QrImageView(
                data: referralCode,
                version: QrVersions.auto,
                size: 180.r,
                backgroundColor: Colors.white,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: AppColors.black,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: AppColors.black,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    referralCode,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.goldLight : AppColors.burgundy,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: referralCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.codeCopied),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        onCopy?.call();
                      },
                      borderRadius: BorderRadius.circular(10.r),
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Icon(
                          Icons.copy_rounded,
                          size: 22.r,
                          color: primary,
                        ),
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
}
