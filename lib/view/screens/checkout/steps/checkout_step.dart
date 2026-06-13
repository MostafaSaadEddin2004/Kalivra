import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/checkout_cubit/checkout_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/cart/cart_item_model.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';

class CheckoutStep extends StatelessWidget {
  const CheckoutStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.offWhite : AppColors.burgundy;
    final cartCubit = context.read<CartCubit>();
    final checkoutState = context.watch<CheckoutCubit>().state;
    final summary = checkoutState.summary;
    final items = cartCubit.items;
    final subtotal = summary?.cart?.subTotal ?? cartCubit.subtotal;
    final grandTotal = summary?.cart?.grandTotal ?? cartCubit.total;
    final formattedSubtotal =
        summary?.cart?.formattedSubTotal ?? subtotal.toStringAsFixed(0);
    final formattedGrandTotal =
        summary?.cart?.formattedGrandTotal ?? grandTotal.toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
          child: Text(
            l10n.orderSummary,
            style: theme.textTheme.titleLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Text(
                    l10n.emptyCart,
                    style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
                  ),
                )
              : ListView.builder(
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
                              _ItemImage(item: item),
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
                                      l10n.quantityLabel(item.quantity),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: AppColors.taupe,
                                      ),
                                    ),
                                    Text(
                                      '${item.lineTotal.toStringAsFixed(0)} ${l10n.currencySYP}',
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
                label: l10n.subtotal,
                value: '$formattedSubtotal ${l10n.currencySYP}',
                theme: theme,
                textColor: textColor,
              ),
              if (summary?.cart?.formattedTaxTotal != null) ...[
                SizedBox(height: 8.h),
                _SummaryRow(
                  label: l10n.tax,
                  value: summary!.cart!.formattedTaxTotal!,
                  theme: theme,
                  textColor: textColor,
                ),
              ],
              SizedBox(height: 12.h),
              Divider(height: 1.h, color: AppColors.taupe.withValues(alpha: 0.4)),
              SizedBox(height: 12.h),
              _SummaryRow(
                label: l10n.total,
                value: '$formattedGrandTotal ${l10n.currencySYP}',
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

class _ItemImage extends StatelessWidget {
  const _ItemImage({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.product.baseImage?.largeImageUrl ??
        item.product.baseImage?.originalImageUrl;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: CustomNetworkImage(
          imageUrl: imageUrl,
          width: 64.w,
          height: 64.w,
          defaultIcon: Icons.inventory_2_outlined,
        ),
      );
    }
    return _imagePlaceholder(64.w);
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
