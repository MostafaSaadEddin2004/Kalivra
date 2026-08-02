import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReferralQrCard extends StatefulWidget {
  const ReferralQrCard({super.key, required this.referralCode, this.onCopy});

  final String referralCode;
  final VoidCallback? onCopy;

  @override
  State<ReferralQrCard> createState() => _ReferralQrCardState();
}

class _ReferralQrCardState extends State<ReferralQrCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedCrossFade(
        crossFadeState: isExpanded
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 400),
        secondCurve: Curves.linear,
        firstCurve: Curves.linear,
        firstChild: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.all(16.w),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    spacing: 8.h,
                    children: [
                      Row(
                        spacing: 8.w,
                        children: [
                          Icon(
                            Icons.qr_code_2_rounded,
                            size: 24.r,
                            color: theme.colorScheme.onTertiaryFixed,
                          ),
                          Text(
                            AppLocalizations.of(context)!.referralCode,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onTertiaryFixed,
                              fontWeight: FontWeight.w800,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                      Text(
                        AppLocalizations.of(context)!.referralCodeHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primaryFixed,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.expand_more_rounded, size: 28.r, color: theme.colorScheme.primaryFixed),
              ],
            ),
          ),
        ),
        secondChild: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),        
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Column(
                        spacing: 8.h,
                        children: [
                          Row(
                            spacing: 8.w,
                            children: [
                              Icon(
                                Icons.qr_code_2_rounded,
                                size: 24.r,
                                color: theme.colorScheme.onTertiaryFixed,
                              ),
                              Text(
                                AppLocalizations.of(context)!.referralCode,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onTertiaryFixed,
                                  fontWeight: FontWeight.w800,
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                          Text(
                            AppLocalizations.of(context)!.referralCodeHint,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primaryFixed,
                              height: 1.35,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.expand_less_rounded, size: 28.r, color: theme.colorScheme.primaryFixed),
                  ],
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
                        blurRadius: 10.r,
                        offset: Offset(0, 8.h),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius:102.r,
                        offset: Offset(8.w, 0),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: widget.referralCode,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.referralCode,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primaryFixed,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: widget.referralCode),
                          );
                          CustomSnackBar.show(
                            context,
                            AppLocalizations.of(context)!.codeCopied,
                          );
                          widget.onCopy?.call();
                        },
                        borderRadius: BorderRadius.circular(10.r),
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.copy_rounded,
                            size: 22.r,
                            color: theme.colorScheme.primaryFixed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
