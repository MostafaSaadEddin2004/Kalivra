import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final  colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: colorScheme.onTertiaryFixed,
          borderRadius: BorderRadius.circular(12.r),
        ),
        width: double.infinity,
        child: Text(AppLocalizations.of(context)!.confirmOrder, style: textTheme.displayLarge),
      ),
    );
  }
}
