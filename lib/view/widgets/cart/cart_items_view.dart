import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/nav_cubit/nav_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
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
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          sliver: SliverList.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isDetailsUpdating =
                  cartCubit.operation == CartOperation.updatingDetails &&
                  cartCubit.activeItemId == item.id;
              final canChangeQuantity = item.canChangeQty ?? true;
              return CartItemCard(
                item: item,
                quantity: cartCubit.quantityForItem(item),
                isDeleting: cartCubit.isRemovingItem(item.id),
                isEditing: isDetailsUpdating,
                onEdit: () => _showEditSheet(context, item),
                onDelete: () => _confirmRemoveItem(context, item),
                onQuantityChanged: canChangeQuantity
                    ? (quantity) {
                        context.read<CartCubit>().scheduleItemQuantityUpdate(
                          context,
                          item.id,
                          quantity,
                        );
                      }
                    : null,
              );
            },
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 12.h),
                _PriceBreak(cart: cart),
                SizedBox(height: 12.h),
                _CouponSection(cart: cart),
                SizedBox(height: 12.h),
                _CartActionsBar(
                  isLoading: cartCubit.isClearingCart,
                  onClearPressed: items.isEmpty
                      ? null
                      : () => _confirmClearCart(context),
                ),
                SizedBox(height: 12.h),
                CartBottomBar(
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

  Future<void> _showEditSheet(
    BuildContext context,
    CartItemApiModel item,
  ) async {
    final theme = Theme.of(context);

    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<CartCubit>(),
        child: CartItemEditDialog(item: item, isBottomSheet: true),
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
        onConfirm: () async {
          final removed = await context.read<CartCubit>().removeCartItem(
            context,
            item.id,
          );
          if (removed) Navigator.of(dialogContext).pop(true);
        },
      ),
    );
  }

  Future<void> _confirmClearCart(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        title: l10n.clearCart,
        message: l10n.clearCartConfirmation,
        onConfirm: () async {
          final cleared = await context.read<CartCubit>().clearCart(context);
          if (cleared) Navigator.of(dialogContext).pop(true);
        },
      ),
    );
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

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => context.read<NavCubit>().goTo(0),
            icon: Icon(Icons.arrow_back_rounded, size: 20.r),
            label: Text(
              l10n.continueShopping,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.onTertiaryFixed,
              foregroundColor: colorScheme.secondaryFixed,
              textStyle: theme.textTheme.titleMedium,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onClearPressed,
            icon: isLoading
                ? SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: SpinKitFadingCircle(
                      itemSize: 20.r,
                      color: colorScheme.primaryFixed,
                    ),
                  )
                : Icon(Icons.delete_outline_rounded, size: 22.r),
            label: Text(
              l10n.emptyCart,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.primaryFixed,
              side: BorderSide(color: AppColors.burgundy),
              textStyle: theme.textTheme.titleMedium,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        ),
      ],
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
    final colorScheme = theme.colorScheme;
    final rows = <_SummaryRowData>[
      _SummaryRowData(l10n.subtotal, cart.formattedSubTotal),
      _SummaryRowData(l10n.discount, cart.formattedDiscountAmount),
      _SummaryRowData(l10n.deliveryCost, cart.formattedShippingAmount),
      _SummaryRowData(l10n.tax, cart.formattedTaxTotal),
    ];

    return Card(
      elevation: 2,
      color: theme.cardTheme.color,
      shadowColor: AppColors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionTitle(
              icon: Icons.receipt_long_outlined,
              title: l10n.orderSummary,
              iconColor: colorScheme.onTertiaryFixed,
            ),
            SizedBox(height: 24.h),
            ...rows.map(
              (row) => Padding(
                padding: EdgeInsets.only(bottom: 13.h),
                child: _SummaryLine(label: row.label, value: row.value ?? ''),
              ),
            ),
            Divider(
              height: 24.h,
              color: colorScheme.primaryFixed.withValues(alpha: 0.08),
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
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _couponController = TextEditingController();
    _couponController.addListener(_onCouponChanged);
  }

  @override
  void dispose() {
    _isDisposed = true;
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
    if (_isDisposed) return;
    _couponController.clear();
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
      elevation: 2,
      color: theme.cardTheme.color,
      shadowColor: AppColors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionTitle(
              icon: Icons.local_offer_outlined,
              title: l10n.applyCouponTitle,
              iconColor: colorScheme.primaryFixed,
            ),
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
                spacing: 10.w,
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
                        hintText: l10n.couponCode,
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primaryFixed.withValues(
                            alpha: 0.52,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 14.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                            color: colorScheme.primaryFixed.withValues(
                              alpha: 0.12,
                            ),
                          ),
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
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 22.w,
                        vertical: 16.h,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24.r),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.primaryFixed,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
    final labelStyle = theme.textTheme.bodyLarge?.copyWith(
      color: colorScheme.primaryFixed,
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
    );
    final valueStyle = theme.textTheme.bodyLarge?.copyWith(
      color: bold ? colorScheme.onTertiaryFixed : colorScheme.primaryFixed,
      fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
    );

    return Row(
      children: [
        Expanded(child: Text(label, style: labelStyle)),
        SizedBox(width: 12.w),
        Flexible(
          child: Text(
            value,
            style: valueStyle,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({super.key, required this.onProceed});

  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onProceed,
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.onTertiaryFixed,
          foregroundColor: colorScheme.secondaryFixed,
          textStyle: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.secondaryFixed,
            fontWeight: FontWeight.w800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.proceed,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _SummaryRowData {
  const _SummaryRowData(this.label, this.value);

  final String label;
  final String? value;
}
