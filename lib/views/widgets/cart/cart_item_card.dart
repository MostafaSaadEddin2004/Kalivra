import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/models/cart_item_model.dart';
import 'package:kalivra/views/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/views/widgets/cart/quantity_counter.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final CartItem item;
  final void Function(int quantity) onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: 8.h,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  width: 88.w,
                  height: 88.w,
                  color: colorScheme.tertiaryFixed,
                  child: item.product.imagePath != null
                      ? Image.asset(
                          item.product.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.inventory_2_outlined,
                            size: 36.r,
                            color: colorScheme.primary.withValues(alpha: 0.6),
                          ),
                        )
                      : Icon(
                          Icons.inventory_2_outlined,
                          size: 36.r,
                          color: colorScheme.primary.withValues(alpha: 0.6),
                        ),
                ),
              ),
              QuantityCounter(
                value: item.quantity,
                maxQuantity: item.product.quantity,
                onChanged: onQuantityChanged,
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name.toUpperCase(),
                        style: textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CustomIconButton(
                      icon: Icons.delete_outline_rounded,
                      iconSize: 22.r,
                      color: colorScheme.onError,
                      onPressed: onRemove,
                      tooltip: l10n.remove,
                    ),
                  ],
                ),

                Text(l10n.sizePlaceholder, style: textTheme.bodySmall),
                SizedBox(height: 4.h),
                Text(l10n.colorPlaceholder, style: textTheme.bodySmall),
                SizedBox(height: 8.h),
                Text(
                  '${item.unitPrice.toStringAsFixed(0)} ${l10n.currencySYP}',
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
