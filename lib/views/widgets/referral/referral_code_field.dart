import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/referral/referral_code_source_sheet.dart';

/// Expandable referral code section with AnimatedCrossFade.
/// Collapsed: "لديك كود دعوة من صديق؟" row. Expanded: row + text field (scan/gallery icons).
class ReferralCodeField extends StatefulWidget {
  const ReferralCodeField({
    super.key,
    required this.controller,
    this.bottomSpacing = 12,
  });

  final TextEditingController controller;
  /// Spacing below the expanded field (e.g. 12 for login, 20 for sign up).
  final double bottomSpacing;

  @override
  State<ReferralCodeField> createState() => _ReferralCodeFieldState();
}

class _ReferralCodeFieldState extends State<ReferralCodeField> {
  bool _expanded = false;

  void _openReferralCodeOptions() {
    showReferralCodeSourceSheet(
      context,
      onCode: (value) {
        if (mounted) setState(() => widget.controller.text = value);
      },
      onError: (message) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark
        ? AppColors.taupe.withValues(alpha: 0.5)
        : AppColors.burgundy.withValues(alpha: 0.4);
    final fillColor = isDark
        ? AppColors.burgundy.withValues(alpha: 0.08)
        : AppColors.offWhite;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;

    return AnimatedCrossFade(
      firstChild: _buildCollapsedHeader(context, theme, isDark, labelColor),
      secondChild: _buildExpandedContent(
        context,
        theme,
        isDark,
        labelColor,
        borderColor,
        fillColor,
      ),
      crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 280),
      firstCurve: Curves.decelerate,
      secondCurve: Curves.easeInOut,
      sizeCurve: Curves.easeInOut,
    );
  }

  /// Collapsed: single row "لديك كود دعوة من صديق؟" (tap to expand).
  Widget _buildCollapsedHeader(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    Color labelColor,
  ) {
    return InkWell(
      onTap: () => setState(() => _expanded = true),
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(
              Icons.card_giftcard_rounded,
              size: 22.r,
              color: labelColor,
            ),
            SizedBox(width: 10.w),
            Text(
              'لديك كود دعوة من صديق؟',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.expand_more_rounded,
              size: 22.r,
              color: labelColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    Color labelColor,
    Color borderColor,
    Color fillColor,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = false),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                Icon(
                  Icons.card_giftcard_rounded,
                  size: 22.r,
                  color: labelColor,
                ),
                SizedBox(width: 10.w),
                Text(
                  'لديك كود دعوة من صديق؟',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.goldLight : AppColors.burgundy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.expand_less_rounded,
                  size: 22.r,
                  color: labelColor,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        TextFormField(
          controller: widget.controller,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: 'كود الدعوة',
            hintText: 'أدخل الكود أو اضغط للأيقونة لمسح أو اختيار صورة',
            prefixIcon: IconButton(
              icon: Icon(
                Icons.qr_code_scanner_rounded,
                size: 24.r,
                color: labelColor,
              ),
              onPressed: _openReferralCodeOptions,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.add_a_photo_rounded,
                size: 22.r,
                color: labelColor,
              ),
              onPressed: _openReferralCodeOptions,
            ),
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            labelStyle: TextStyle(color: labelColor),
            hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.6)),
          ),
        ),
        SizedBox(height: widget.bottomSpacing.h),
      ],
    );
  }
}
