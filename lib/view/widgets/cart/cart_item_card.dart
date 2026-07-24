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

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.18),
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
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  width: 88.w,
                  height: 88.w,
                  color: colorScheme.tertiaryFixed,
                  child: CustomNetworkImage(
                    imageUrl: item.imageUrl,
                    width: 88.w,
                    height: 88.w,
                    defaultIcon: Icons.inventory_2_outlined,
                  ),
                ),
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
                            productName,
                            style: textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton<_CartItemAction>(
                          enabled: !isLoading,
                          tooltip: l10n.menu,
                          icon: Icon(Icons.more_vert_rounded, size: 22.r),
                          onSelected: (action) {
                            switch (action) {
                              case _CartItemAction.edit:
                                onEdit();
                                break;
                              case _CartItemAction.delete:
                                onDelete();
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: _CartItemAction.edit,
                              child: _MenuItem(
                                icon: Icons.edit_outlined,
                                label: l10n.editItem,
                              ),
                            ),
                            PopupMenuItem(
                              value: _CartItemAction.delete,
                              child: _MenuItem(
                                icon: Icons.delete_outline_rounded,
                                label: l10n.deleteItem,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    ...item.options.map(
                      (option) => Padding(
                        padding: EdgeInsets.only(bottom: 3.h),
                        child: Text(
                          '${option.attributeName ?? ''}: ${option.optionLabel ?? ''}',
                          style: textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _DetailLine(
                      label: l10n.unitPrice,
                      value:
                          item.formattedPrice ?? item.price?.toString() ?? '',
                    ),
                    SizedBox(height: 4.h),
                    _DetailLine(
                      label: l10n.quantity,
                      value: (item.quantity ?? 1).toString(),
                    ),
                    SizedBox(height: 4.h),
                    _DetailLine(
                      label: l10n.total,
                      value:
                          item.formattedTotal ?? item.total?.toString() ?? '',
                      bold: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isLoading)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
    );

    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        SizedBox(width: 8.w),
        Flexible(
          child: Text(
            value,
            style: style,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.r),
        SizedBox(width: 10.w),
        Text(label),
      ],
    );
  }
}

enum _CartItemAction { edit, delete }
