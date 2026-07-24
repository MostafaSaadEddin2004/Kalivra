import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/cart/cart_api_model.dart';
import 'package:kalivra/view/widgets/cart/cart_item_card.dart';
import 'package:kalivra/view/widgets/cart/cart_item_edit_dialog.dart';
import 'package:kalivra/view/widgets/confirm_dialog.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';

class CartItemsView extends StatelessWidget {
  const CartItemsView({super.key, required this.cart});

  final CartApiModel cart;

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.watch<CartCubit>();
    final items = cart.items;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h),
            itemCount: items.length,
            itemBuilder: (context, index) {
                final item = items[index];
                return CartItemCard(
                  item: item,
                  isLoading:
                      cartCubit.isRemovingItem(item.id) ||
                      cartCubit.isUpdatingItem(item.id),
                  onEdit: () => _showEditDialog(context, item),
                  onDelete: () => _confirmRemoveItem(context, item),
                );
            },
          ),
        ),
        _ClearCartButton(
          isLoading: cartCubit.isClearingCart,
          onPressed: items.isEmpty ? null : () => _confirmClearCart(context),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: _CartSummary(cart: cart),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_forward_rounded, size: 22.r),
              label: Text(AppLocalizations.of(context)!.continueShopping),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ),
        CartBottomBar(
          amount: cart.formattedGrandTotal ?? cart.grandTotal?.toString() ?? '',
          onProceed: () => context.push(AppRoutes.checkout),
        ),
      ],
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    CartItemApiModel item,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final updated = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<CartCubit>(),
        child: CartItemEditDialog(item: item),
      ),
    );
    if (!context.mounted || updated != true) return;
    CustomSnackBar.show(context, l10n.itemUpdatedSuccessfully);
  }

  Future<void> _confirmRemoveItem(
    BuildContext context,
    CartItemApiModel item,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        title: l10n.deleteItem,
        message: l10n.removeItemConfirmation(item.name ?? ''),
        onConfirm: () => Navigator.of(dialogContext).pop(true),
      ),
    );
    if (!context.mounted || confirmed != true) return;

    final removed = await context.read<CartCubit>().removeCartItem(item.id);
    if (!context.mounted) return;
    CustomSnackBar.show(
      context,
      removed ? l10n.itemDeletedSuccessfully : l10n.unableToDeleteItem,
    );
  }

  Future<void> _confirmClearCart(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        title: l10n.clearCart,
        message: l10n.clearCartConfirmation,
        onConfirm: () => Navigator.of(dialogContext).pop(true),
      ),
    );
    if (!context.mounted || confirmed != true) return;

    final cleared = await context.read<CartCubit>().clearCart();
    if (!context.mounted) return;
    CustomSnackBar.show(
      context,
      cleared ? l10n.cartClearedSuccessfully : l10n.unableToClearCart,
    );
  }
}

class _ClearCartButton extends StatelessWidget {
  const _ClearCartButton({required this.onPressed, required this.isLoading});

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 18.r,
                height: 18.r,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(Icons.delete_outline_rounded, size: 20.r),
        label: Text(l10n.clearCart),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.cart});

  final CartApiModel cart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final rows = <_SummaryRowData>[
      _SummaryRowData(l10n.subtotal, cart.formattedSubTotal, alwaysShow: true),
      _SummaryRowData(l10n.discount, cart.formattedDiscountAmount),
      _SummaryRowData(l10n.tax, cart.formattedTaxTotal, alwaysShow: true),
      _SummaryRowData(
        l10n.shipping,
        cart.formattedShippingAmount,
        alwaysShow: true,
      ),
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.priceDetails, style: theme.textTheme.titleMedium),
              Text(
                '${cart.itemQuantity ?? cart.items.length}',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...rows
              .where((row) => row.alwaysShow || _hasNonZeroMoney(row.value))
              .map(
                (row) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: _SummaryLine(label: row.label, value: row.value ?? ''),
                ),
              ),
          Divider(height: 18.h),
          _SummaryLine(
            label: l10n.total,
            value:
                cart.formattedGrandTotal ?? cart.grandTotal?.toString() ?? '',
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
      color: bold ? theme.colorScheme.primary : null,
    );

    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        SizedBox(width: 12.w),
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

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({
    super.key,
    required this.amount,
    required this.onProceed,
  });

  final String amount;
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
                    AppLocalizations.of(context)!.amountDue,
                    style: textTheme.displayLarge?.copyWith(
                      color: AppColors.offWhite,
                    ),
                  ),
                  Text(
                    amount,
                    style: textTheme.displayLarge?.copyWith(
                      color: AppColors.offWhite,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
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
                  AppLocalizations.of(context)!.proceed,
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

class _SummaryRowData {
  const _SummaryRowData(this.label, this.value, {this.alwaysShow = false});

  final String label;
  final String? value;
  final bool alwaysShow;
}

bool _hasNonZeroMoney(String? value) {
  if (value == null || value.trim().isEmpty) return false;
  return RegExp(r'[1-9١-٩]').hasMatch(value);
}
