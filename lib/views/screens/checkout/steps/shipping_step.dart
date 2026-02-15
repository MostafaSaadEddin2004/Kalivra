import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';

class ShippingStep extends StatefulWidget {
  const ShippingStep({super.key});

  @override
  State<ShippingStep> createState() => ShippingStepState();
}

class ShippingStepState extends State<ShippingStep> {
  int _selectedMethod = 0;
  DateTime? _preferredDate;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  /// Called by parent to validate before allowing proceed to next step.
  bool validateStep() => _preferredDate != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.offWhite : AppColors.burgundy;

    final methods = [
      {'title': 'توصيل عادي', 'desc': '5-7 أيام عمل', 'price': '15 ل.س'},
      {'title': 'توصيل سريع', 'desc': '2-3 أيام عمل', 'price': '30 ل.س'},
      {'title': 'نفس اليوم', 'desc': 'طلب قبل 12 ظهراً', 'price': '50 ل.س'},
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'طريقة الشحن',
            style: theme.textTheme.titleMedium?.copyWith(color: textColor),
          ),
          SizedBox(height: 12.h),
          ...List.generate(methods.length, (i) {
            final m = methods[i];
            final selected = _selectedMethod == i;
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: InkWell(
                onTap: () => setState(() => _selectedMethod = i),
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1A1918)
                        : AppColors.offWhite.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: selected
                          ? (isDark ? AppColors.goldLight : AppColors.burgundy)
                          : AppColors.taupe.withValues(alpha: 0.3),
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: selected
                            ? (isDark ? AppColors.goldLight : AppColors.burgundy)
                            : AppColors.taupe,
                        size: 24.r,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m['title']!,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: textColor,
                              ),
                            ),
                            Text(
                              m['desc']!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.taupe,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        m['price']!,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 24.h),
          Text(
            'تاريخ التوصيل المفضل',
            style: theme.textTheme.titleMedium?.copyWith(color: textColor),
          ),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _preferredDate ?? DateTime.now().add(const Duration(days: 3)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 60)),
              );
              if (date != null) setState(() => _preferredDate = date);
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1A1918)
                    : AppColors.offWhite.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.taupe.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.taupe,
                    size: 22.r,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    _preferredDate != null
                        ? '${_preferredDate!.day}/${_preferredDate!.month}/${_preferredDate!.year}'
                        : 'اختر التاريخ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _preferredDate != null
                          ? textColor
                          : textColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'ملاحظات التوصيل (اختياري)',
            style: theme.textTheme.titleMedium?.copyWith(color: textColor),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _notesController,
            maxLines: 3,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'مثال: اترك عند الباب، اتصل عند الوصول...',
              hintStyle: TextStyle(
                color: textColor.withValues(alpha: 0.5),
                fontSize: 14.sp,
              ),
              filled: true,
              fillColor: isDark
                  ? const Color(0xFF1A1918)
                  : AppColors.offWhite.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.taupe.withValues(alpha: 0.4),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.taupe.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
