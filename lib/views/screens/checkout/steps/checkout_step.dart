import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/core/app_theme.dart';

class CheckoutStep extends StatelessWidget {
  const CheckoutStep({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.offWhite : AppColors.burgundy;
    final cartCubit = context.read<CartCubit>();
    final items = cartCubit.state.items;
    final subtotal = cartCubit.subtotal;
    final delivery = CartCubit.deliveryCost;
    final total = cartCubit.total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
          child: Text(
            'ملخص الطلب',
            style: theme.textTheme.titleLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.product.imagePath != null &&
                            item.product.imagePath!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.asset(
                              item.product.imagePath!,
                              width: 64.w,
                              height: 64.w,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _imagePlaceholder(64.w),
                            ),
                          )
                        else
                          _imagePlaceholder(64.w),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: textColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'الكمية: ${item.quantity}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.taupe,
                                ),
                              ),
                              Text(
                                '${item.lineTotal.toStringAsFixed(0)} ل.س',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1A1918)
                : AppColors.offWhite.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.taupe.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              _SummaryRow(
                label: 'المجموع الفرعي',
                value: '${subtotal.toStringAsFixed(0)} ل.س',
                theme: theme,
                textColor: textColor,
              ),
              SizedBox(height: 8.h),
              _SummaryRow(
                label: 'الشحن',
                value: '${delivery.toStringAsFixed(0)} ل.س',
                theme: theme,
                textColor: textColor,
              ),
              SizedBox(height: 12.h),
              Divider(height: 1.h, color: AppColors.taupe.withValues(alpha: 0.4)),
              SizedBox(height: 12.h),
              _SummaryRow(
                label: 'المجموع الكلي',
                value: '${total.toStringAsFixed(0)} ل.س',
                theme: theme,
                textColor: textColor,
                bold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _imagePlaceholder(double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: AppColors.taupe.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Icon(Icons.inventory_2_outlined, color: AppColors.taupe),
  );

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.theme,
    required this.textColor,
    this.bold = false,
  });

  final String label;
  final String value;
  final ThemeData theme;
  final Color textColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
