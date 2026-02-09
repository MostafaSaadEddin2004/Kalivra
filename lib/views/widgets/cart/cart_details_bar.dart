import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit.dart';
import 'package:kalivra/views/widgets/buttons/custom_button.dart';
import 'package:kalivra/views/widgets/cart/cart_details_row.dart';

class CartDetailsBar extends StatelessWidget {
  const CartDetailsBar({
    super.key,
    required this.cubit,
    required this.onCheckout,
  });

  final CartCubit cubit;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final subtotal = cubit.subtotal;
    final delivery = CartCubit.deliveryCost;
    final total = cubit.total;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16.w,
        16.h,
        16.w,
        16.h + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CartDetailsRow(label: 'إجمالي المنتجات', value: subtotal.toString()),
            SizedBox(height: 8.h),
            CartDetailsRow(label: 'تكلفة التوصيل', value: delivery.toString()),
            SizedBox(height: 12.h),
            Divider(height: 1.h),
            SizedBox(height: 12.h),
            CartDetailsRow(label:  'المجموع الكلي', value: total.toStringAsFixed(0),),
            SizedBox(height: 12.h),
            CustomButton(onTap: () {}),
          ],
        ),
      ),
    );
  }
}
