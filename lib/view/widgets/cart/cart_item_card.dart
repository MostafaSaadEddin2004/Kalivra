import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/cart/cart_api_model.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    this.isLoading = false,
  });

  final CartItemApiModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final productName = item.name?.trim().isNotEmpty == true
        ? item.name!.trim()
        : l10n.productDetails;
    final quantity = item.quantity ?? 1;
    final unitPrice = item.formattedPrice ?? item.price?.toString() ?? '';
    final itemTotal = item.formattedTotal ?? item.total?.toString() ?? '';

    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                width: 112.w,
                height: 112.w,
                color: colorScheme.tertiaryFixed,
                child: CustomNetworkImage(
                  imageUrl: item.imageUrl,
                  width: 112.w,
                  height: 112.w,
                  defaultIcon: Icons.inventory_2_outlined,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 112.w),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    if (item.options.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: item.options.map((option) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 3.h),
                            child: Text(
                              '${option.attributeName ?? ''}: ${option.optionLabel ?? ''}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.primaryFixed,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    if (item.options.isNotEmpty) SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$unitPrice x  ${l10n.unit} $quantity',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.primaryFixed,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          itemTotal,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.primaryFixed,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _CartActionIcon(
                          icon: Icons.delete_outline_rounded,
                          tooltip: l10n.deleteItem,
                          onPressed: isLoading ? null : onDelete,
                        ),
                        _CartActionIcon(
                          icon: Icons.edit_outlined,
                          tooltip: l10n.editItem,
                          onPressed: isLoading ? null : onEdit,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartActionIcon extends StatelessWidget {
  const _CartActionIcon({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 40.r,
      height: 40.r,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          size: 24.r,
          color: onPressed == null
              ? theme.colorScheme.onSurface
              : theme.colorScheme.primaryFixed,
        ),
      ),
    );
  }
}
