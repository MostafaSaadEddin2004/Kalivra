import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/nav_cubit/nav_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/cart/cart_api_model.dart';
import 'package:kalivra/view/widgets/cart/cart_item_card.dart';
import 'package:kalivra/view/widgets/cart/cart_item_edit_dialog.dart';
import 'package:kalivra/view/widgets/confirm_dialog.dart';

class CartItemsView extends StatelessWidget {
  const CartItemsView({super.key, required this.cart});

  final CartApiModel cart;

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.watch<CartCubit>();
    final items = cart.items;
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          sliver: SliverList.builder(
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
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 8.h),
                Divider(height: 1.h, color: theme.colorScheme.primaryFixed),
                SizedBox(height: 8.h),
                _CartActionsBar(
                  isLoading: cartCubit.isClearingCart,
                  onClearPressed: items.isEmpty
                      ? null
                      : () => _confirmClearCart(context),
                ),
                SizedBox(height: 16.h),
                _CouponSection(cart: cart),
                SizedBox(height: 16.h),
                _PriceBreak(cart: cart),
                SizedBox(height: 16.h),
                CartBottomBar(
                  amount:
                      cart.formattedGrandTotal ??
                      cart.grandTotal?.toString() ??
                      '',
                  onProceed: () => context.push(AppRoutes.checkout),
                ),
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    CartItemApiModel item,
  ) async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<CartCubit>(),
        child: CartItemEditDialog(item: item),
      ),
    );
  }

  Future<void> _confirmRemoveItem(
    BuildContext context,
    CartItemApiModel item,
  ) async {
    final l10n = AppLocalizations.of(context)!;
     await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        title: l10n.deleteItem,
        message: l10n.removeItemConfirmation(item.name ?? ''),
        onConfirm: () =>
            context.read<CartCubit>().removeCartItem(context, item.id),
      ),
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

    await context.read<CartCubit>().clearCart(context);
  }
}

class _CartActionsBar extends StatelessWidget {
  const _CartActionsBar({
    required this.onClearPressed,
    required this.isLoading,
  });

  final VoidCallback? onClearPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final foreground = colorScheme.primaryFixed;

    return Card(
      elevation: 1,
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: () => context.read<NavCubit>().goTo(0),
              icon: Icon(Icons.arrow_forward_rounded, size: 28.r),
              label: Text(
                l10n.continueShopping,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: TextButton.styleFrom(
                foregroundColor: foreground,
                textStyle: theme.textTheme.bodyLarge,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              ),
            ),
          ),
          SizedBox(
            height: 34.h,
            child: VerticalDivider(
              width: 1.w,
              color: colorScheme.primary.withValues(alpha: 0.12),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: isLoading ? null : onClearPressed,
              icon: isLoading
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: foreground,
                      ),
                    )
                  : Icon(Icons.delete_outline_rounded, size: 28.r),
              label: Text(
                l10n.emptyCart,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: TextButton.styleFrom(
                foregroundColor: foreground,
                textStyle: theme.textTheme.bodyLarge,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceBreak extends StatelessWidget {
  const _PriceBreak({required this.cart});

  final CartApiModel cart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final rows = <_SummaryRowData>[
      _SummaryRowData(l10n.subtotal, cart.formattedSubTotal),
      _SummaryRowData(l10n.discount, cart.formattedDiscountAmount),
      _SummaryRowData(l10n.deliveryCost, cart.formattedShippingAmount),
      _SummaryRowData(l10n.tax, cart.formattedTaxTotal),
    ];

    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.priceDetails, style: theme.textTheme.headlineSmall),
            SizedBox(height: 26.h),
            ...rows.map(
              (row) => Padding(
                padding: EdgeInsets.only(bottom: 13.h),
                child: _SummaryLine(label: row.label, value: row.value ?? ''),
              ),
            ),
            _SummaryLine(
              label: l10n.total,
              value:
                  cart.formattedGrandTotal ?? cart.grandTotal?.toString() ?? '',
              bold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponSection extends StatefulWidget {
  const _CouponSection({required this.cart});

  final CartApiModel cart;

  @override
  State<_CouponSection> createState() => _CouponSectionState();
}

class _CouponSectionState extends State<_CouponSection> {
  late final TextEditingController _couponController;

  @override
  void initState() {
    super.initState();
    _couponController = TextEditingController();
    _couponController.addListener(_onCouponChanged);
  }

  @override
  void dispose() {
    _couponController
      ..removeListener(_onCouponChanged)
      ..dispose();
    super.dispose();
  }

  void _onCouponChanged() => setState(() {});

  Future<void> _applyCoupon() async {
    final code = _couponController.text.trim();
    final cartCubit = context.read<CartCubit>();
    if (code.isEmpty || cartCubit.isApplyingCoupon) return;

    FocusScope.of(context).unfocus();
    await cartCubit.sendCoupon(context, code);
  }

  Future<void> _removeCoupon() async {
    final cartCubit = context.read<CartCubit>();
    if (cartCubit.isRemovingCoupon) return;

    FocusScope.of(context).unfocus();
    await cartCubit.removeCoupon(context);
    if (mounted) _couponController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cartCubit = context.watch<CartCubit>();
    final couponCode = widget.cart.couponCode?.trim();
    final hasCoupon = couponCode != null && couponCode.isNotEmpty;
    final isApplying = cartCubit.isApplyingCoupon;
    final isRemoving = cartCubit.isRemovingCoupon;
    final canApply = _couponController.text.trim().isNotEmpty && !isApplying;

    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.applyCouponTitle, style: theme.textTheme.headlineSmall),
            SizedBox(height: 20.h),
            if (hasCoupon)
              Row(
                children: [
                  Expanded(
                    child: _SummaryLine(label: l10n.coupon, value: couponCode),
                  ),
                  SizedBox(width: 12.w),
                  OutlinedButton.icon(
                    onPressed: isRemoving ? null : _removeCoupon,
                    icon: isRemoving
                        ? SizedBox(
                            width: 16.r,
                            height: 16.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(Icons.close_rounded, size: 18.r),
                    label: Text(l10n.remove),
                  ),
                ],
              )
            else
              Row(
                spacing: 8.w,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _couponController,
                      enabled: !isApplying,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        if (canApply) _applyCoupon();
                      },
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: l10n.couponCode,
                        labelStyle: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primaryFixed,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: canApply ? _applyCoupon : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.onTertiaryFixed,
                      foregroundColor: colorScheme.secondaryFixed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: isApplying
                        ? SizedBox(
                            width: 18.r,
                            height: 18.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.secondaryFixed,
                            ),
                          )
                        : Text(
                            l10n.applyCoupon,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colorScheme.secondaryFixed,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ],
              ),
          ],
        ),
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
    final colorScheme = theme.colorScheme;
    final style = theme.textTheme.bodyLarge?.copyWith(
      color: colorScheme.primaryFixed,
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              spacing: 4.h,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.amountDue}:',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.primaryFixed,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  amount,
                  style: textTheme.headlineSmall?.copyWith(
                    color: colorScheme.primaryFixed,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            child: FilledButton(
              onPressed: onProceed,
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.onTertiaryFixed,
                foregroundColor: colorScheme.secondaryFixed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.proceed,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.secondaryFixed,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRowData {
  const _SummaryRowData(this.label, this.value);

  final String label;
  final String? value;
}
