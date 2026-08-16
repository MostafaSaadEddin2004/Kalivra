import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/cart/cart_api_model.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    this.isDeleting = false,
    this.isEditing = false,
  });

  final CartItemApiModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final productName = item.name?.trim().isNotEmpty == true
        ? item.name!.trim()
        : l10n.productDetails;
    final quantity = item.quantity ?? 1;
    final unitPrice = item.formattedPrice ?? item.price?.toString() ?? '';
    final itemTotal = item.formattedTotal ?? item.total?.toString() ?? '';
    final imageSize = 118.w;
    final horizontalImageInset = imageSize + 14.w;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      elevation: 2,
      color: theme.cardTheme.color,
      shadowColor: AppColors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: SizedBox(
          height: 132.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0,
                right: isRtl ? 0 : null,
                left: isRtl ? null : 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: imageSize,
                    height: imageSize,
                    color: colorScheme.tertiaryFixed,
                    child: CustomNetworkImage(
                      imageUrl: item.imageUrl,
                      width: imageSize,
                      height: imageSize,
                      defaultIcon: Icons.image_outlined,
                      defaultIconColor: AppColors.burgundy.withValues(
                        alpha: 0.48,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 4.h,
                left: isRtl ? 0 : horizontalImageInset,
                right: isRtl ? horizontalImageInset : 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: isRtl
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primaryFixed,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: isRtl ? TextAlign.right : TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '$unitPrice x $quantity',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primaryFixed.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.options.isNotEmpty)
                      Column(
                        crossAxisAlignment: isRtl
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: item.options.map((option) {
                          return Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Text(
                              '${option.attributeName ?? ''}: ${option.optionLabel ?? ''}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.primaryFixed.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              textAlign: isRtl
                                  ? TextAlign.right
                                  : TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                bottom: 2.h,
                child: Text(
                  itemTotal,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.primaryFixed,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CartActionIcon(
                      icon: Icons.delete_outline_rounded,
                      tooltip: l10n.deleteItem,
                      onPressed: isDeleting || isEditing ? null : onDelete,
                      isLoading: isDeleting,
                    ),
                    SizedBox(width: 12.w),
                    _CartActionIcon(
                      icon: Icons.edit_outlined,
                      tooltip: l10n.editItem,
                      onPressed: isDeleting || isEditing ? null : onEdit,
                      isLoading: isEditing,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    this.isLoading = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onPressed != null;

    return SizedBox(
      width: 42.r,
      height: 42.r,
      child: Material(
        color: AppColors.burgundy.withValues(alpha: enabled ? 0.08 : 0.04),
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.r),
          onTap: onPressed,
          child: Tooltip(
            message: tooltip,
            child: Center(
              child: isLoading
                  ? SpinKitFadingCircle(
                      size: 22.r,
                      color: theme.colorScheme.primaryFixed,
                    )
                  : Icon(
                      icon,
                      size: 22.r,
                      color: enabled
                          ? theme.colorScheme.primaryFixed
                          : theme.colorScheme.onSurface,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
