import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

Future<DateTime?> showDateOfBirthScrollPicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime minimumDate,
  required DateTime maximumDate,
}) {
  var selectedDate = _clampDate(initialDate, minimumDate, maximumDate);

  return showModalBottomSheet<DateTime>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);
      final l10n = AppLocalizations.of(sheetContext)!;
      final surfaceColor = theme.cardTheme.color ?? theme.colorScheme.surface;
      final primaryColor = theme.colorScheme.onTertiaryFixed;
      final selectedTextStyle = theme.textTheme.titleMedium?.copyWith(
        color: primaryColor,
        fontWeight: FontWeight.w700,
      );
      final textStyle = theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.primaryFixed,
      );

      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  l10n.dateOfBirthLabel,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  height: 240.h,
                  child: ScrollDatePicker(
                    selectedDate: selectedDate,
                    minimumDate: minimumDate,
                    maximumDate: maximumDate,
                    locale: Localizations.localeOf(context),
                    options: DatePickerOptions(
                      isLoop: true,
                      itemExtent: 42.h,
                      backgroundColor: surfaceColor,
                    ),
                    scrollViewOptions: DatePickerScrollViewOptions.all(
                      ScrollViewDetailOptions(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        selectedTextStyle: selectedTextStyle!,
                        textStyle: textStyle!,
                        isLoop: false,
                      ),
                    ),
                    indicator: Container(
                      height: 42.h,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.18),
                        ),
                      ),
                    ),
                    onDateTimeChanged: (value) {
                      setModalState(() {
                        selectedDate = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: primaryColor,
                          textStyle: theme.textTheme.titleSmall,
                        ),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: FilledButton(
                        onPressed: () =>
                            Navigator.of(context).pop(selectedDate),
                        child: Text(l10n.ok),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

DateTime _clampDate(
  DateTime value,
  DateTime minimumDate,
  DateTime maximumDate,
) {
  if (value.isBefore(minimumDate)) return minimumDate;
  if (value.isAfter(maximumDate)) return maximumDate;
  return value;
}
