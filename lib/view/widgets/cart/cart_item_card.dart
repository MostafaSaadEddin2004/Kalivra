import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    this.quantity,
    this.onQuantityChanged,
  });

  final CartItemApiModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;
  final bool isEditing;
  final int? quantity;
  final ValueChanged<int>? onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final productName = item.name?.trim().isNotEmpty == true
        ? item.name!.trim()
        : l10n.productDetails;
    final quantity = this.quantity ?? item.quantity ?? 1;
    final unitPrice = item.formattedPrice ?? item.price?.toString() ?? '';
    final itemTotal = item.formattedTotal ?? item.total?.toString() ?? '';
    final imageSize = 122.w;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      elevation: theme.cardTheme.elevation ?? 2,
      color: theme.cardTheme.color,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MediaOptionsColumn(
              item: item,
              imageUrl: item.imageUrl,
              imageSize: imageSize,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _DetailsColumn(
                productName: productName,
                unitPrice: unitPrice,
                itemTotal: itemTotal,
                quantity: quantity,
                isDeleting: isDeleting,
                isEditing: isEditing,
                onQuantityChanged: onQuantityChanged,
                onDelete: onDelete,
                onEdit: onEdit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsColumn extends StatelessWidget {
  const _DetailsColumn({
    required this.productName,
    required this.unitPrice,
    required this.itemTotal,
    required this.quantity,
    required this.isDeleting,
    required this.isEditing,
    required this.onQuantityChanged,
    required this.onDelete,
    required this.onEdit,
  });

  final String productName;
  final String unitPrice;
  final String itemTotal;
  final int quantity;
  final bool isDeleting;
  final bool isEditing;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                productName,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primaryFixed,
                  fontWeight: FontWeight.w900,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _InfoLine(label: l10n.unitPrice, value: unitPrice),
        SizedBox(height: 10.h),
        _QuantityPreview(
          quantity: quantity,
          enabled: onQuantityChanged != null,
          isLoading: false,
          onDecrease: quantity <= 1 || onQuantityChanged == null
              ? null
              : () => onQuantityChanged!(quantity - 1),
          onIncrease: onQuantityChanged == null
              ? null
              : () => onQuantityChanged!(quantity + 1),
        ),
        SizedBox(height: 10.h),
        _TotalPanel(label: l10n.total, value: itemTotal),
        SizedBox(height: 14.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _CartActionButton(
              icon: Icons.delete_outline_rounded,
              tooltip: l10n.deleteItem,
              label: l10n.delete,
              onPressed: isDeleting || isEditing ? null : onDelete,
              isLoading: isDeleting,
              color: colorScheme.onError,
            ),
            SizedBox(width: 12.w),
            _CartActionButton(
              icon: Icons.edit_outlined,
              tooltip: l10n.editItem,
              label: _firstWord(l10n.editItem),
              onPressed: isDeleting || isEditing ? null : onEdit,
              isLoading: isEditing,
              color: colorScheme.primary,
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      spacing: 8.w,
      children: [
        Text(
          '$label:',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.primaryFixed.withValues(alpha: 0.54),
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primaryFixed,
              fontWeight: FontWeight.w900,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _TotalPanel extends StatelessWidget {
  const _TotalPanel({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        spacing: 4.w,
        children: [
          Text(
            '$label:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primaryFixed.withValues(alpha: 0.54),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityPreview extends StatelessWidget {
  const _QuantityPreview({
    required this.quantity,
    required this.enabled,
    required this.isLoading,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final bool enabled;
  final bool isLoading;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colorScheme.primaryFixed.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          _QuantityIcon(
            icon: Icons.remove_rounded,
            onTap: enabled ? onDecrease : null,
          ),
          Expanded(
            child: Center(
              child: isLoading
                  ? SpinKitFadingCircle(
                      size: 18.r,
                      color: colorScheme.primaryFixed,
                    )
                  : Text(
                      '$quantity',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primaryFixed,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
          _QuantityIcon(
            icon: Icons.add_rounded,
            onTap: enabled ? onIncrease : null,
          ),
        ],
      ),
    );
  }
}

class _QuantityIcon extends StatelessWidget {
  const _QuantityIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;

    return InkWell(
      borderRadius: BorderRadius.circular(100.r),
      onTap: onTap,
      child: Container(
        width: 28.r,
        height: 28.r,
        decoration: BoxDecoration(
          color: colorScheme.primaryFixed.withValues(alpha: 0.06),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: colorScheme.primaryFixed.withValues(
            alpha: enabled ? 0.76 : 0.24,
          ),
          size: 18.r,
        ),
      ),
    );
  }
}

class _MediaOptionsColumn extends StatelessWidget {
  const _MediaOptionsColumn({
    required this.item,
    required this.imageUrl,
    required this.imageSize,
  });

  final CartItemApiModel item;
  final String? imageUrl;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: imageSize,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: Container(
              width: imageSize,
              height: imageSize,
              color: colorScheme.tertiaryFixed,
              child: CustomNetworkImage(
                imageUrl: imageUrl,
                width: imageSize,
                height: imageSize,
                defaultIcon: Icons.image_outlined,
                defaultIconColor: colorScheme.primary.withValues(alpha: 0.48),
              ),
            ),
          ),
          if (item.colorOption != null && item.sizeOption != null) ...[
            SizedBox(height: 8.h),
            _OptionTile(
              label: AppLocalizations.of(context)!.color,
              value: item.colorOption!.optionLabel!,
              trailing: _ColorDot(color: colorScheme.primary),
            ),
            SizedBox(height: 6.h),
            _OptionTile(
              label: AppLocalizations.of(context)!.size,
              value: item.sizeOption!.optionLabel!,
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.label, required this.value, this.trailing});

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colorScheme.primaryFixed.withValues(alpha: 0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        spacing: 4.w,
        children: [
          trailing ?? SizedBox.shrink(),
          Text(
            '$label:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primaryFixed.withValues(alpha: 0.54),
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primaryFixed,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.72),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.2),
      ),
    );
  }
}

class _CartActionButton extends StatelessWidget {
  const _CartActionButton({
    required this.icon,
    required this.tooltip,
    required this.label,
    required this.onPressed,
    required this.color,
    this.isLoading = false,
  });

  final IconData icon;
  final String tooltip;
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null;
    final contentColor = enabled
        ? color
        : colorScheme.onSurface.withValues(alpha: 0.7);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onPressed,
        child: Container(
          width: 34.r,
          height: 34.r,
          decoration: BoxDecoration(
            color: color.withValues(alpha: enabled ? 0.09 : 0.04),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: isLoading
                ? SpinKitFadingCircle(size: 16.r, color: color)
                : Icon(icon, size: 18.r, color: contentColor),
          ),
        ),
      ),
    );
  }
}

String _firstWord(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return value;
  return trimmed.split(RegExp(r'\s+')).first;
}
