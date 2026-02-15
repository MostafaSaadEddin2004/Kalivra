import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/models/cart_item_model.dart';
import 'package:kalivra/views/widgets/cart/cart_item_card.dart';

class CartItemsView extends StatelessWidget {
  const CartItemsView({super.key, required this.items});

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    final subtotal = cartCubit.subtotal;
    final total = cartCubit.total;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return CartItemCard(
                    item: item,
                    onQuantityChanged: (q) =>
                        cartCubit.updateQuantity(item.product.id, q),
                    onRemove: () => cartCubit.removeItem(item.product.id),
                  );
                },
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.arrow_forward_rounded, size: 22.r),
                  label: const Text('متابعة التسوق'),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    cartCubit.clear();
                    if (context.mounted) context.pop();
                  },
                  icon: Icon(Icons.delete_outline_rounded, size: 22.r),
                  label: const Text('تفريغ السلة'),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              _PriceDetailsSection(
                subtotal: subtotal,
                discount: 0,
                tax: 0,
                grandTotal: total,
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
        CartBottomBar(amount: total, onProceed: () {}),
      ],
    );
  }
}

class _PriceDetailsSection extends StatefulWidget {
  const _PriceDetailsSection({
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.grandTotal,
  });

  final double subtotal;
  final double discount;
  final double tax;
  final double grandTotal;

  @override
  State<_PriceDetailsSection> createState() => _PriceDetailsSectionState();
}

class _PriceDetailsSectionState extends State<_PriceDetailsSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final cardColor = theme.cardTheme.color ?? colorScheme.surface;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(8.r),
        child: AnimatedCrossFade(
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
          firstCurve: Curves.decelerate,
          secondCurve: Curves.easeInOut,
          firstChild: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('تفاصيل السعر', style: textTheme.titleSmall),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: colorScheme.onTertiaryFixed,
                  size: 24.r,
                ),
              ],
            ),
          ),
          secondChild: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('تفاصيل السعر', style: textTheme.titleSmall),
                  Icon(
                    Icons.expand_less,
                    color: colorScheme.onTertiaryFixed,
                    size: 24.r,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              PriceRow(label: 'المجموع الفرعي', value: widget.subtotal),
              SizedBox(height: 6.h),
              PriceRow(label: 'الخصم', value: widget.discount),
              SizedBox(height: 6.h),
              PriceRow(label: 'الضريبة', value: widget.tax),
              SizedBox(height: 8.h),
              Divider(
                height: 1.h,
                color: colorScheme.onTertiaryFixed.withValues(alpha: 0.3),
              ),
              SizedBox(height: 8.h),
              PriceRow(
                label: 'المجموع الكلي',
                value: widget.grandTotal,
                bold: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  const PriceRow({
    super.key,
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final double value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textTheme.bodyMedium),
        Text('${value.toStringAsFixed(0)} ل.س', style: textTheme.bodyMedium),
      ],
    );
  }
}

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({
    super.key,
    required this.amount,
    required this.onProceed,
  });

  final double amount;
  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16.w,
        12.h,
        16.w,
        12.h + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 12.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                spacing: 4.h,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المبلغ المستحق',
                    style: textTheme.displayLarge?.copyWith(
                      color: AppColors.offWhite,
                    ),
                  ),
                  Text(
                    '${amount.toStringAsFixed(0)} ل.س',
                    style: textTheme.displayLarge?.copyWith(
                      color: AppColors.offWhite,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 140.w,
              child: FilledButton(
                onPressed: onProceed,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.offWhite,
                  foregroundColor: AppColors.burgundy,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'متابعة',
                  style: textTheme.displayLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
