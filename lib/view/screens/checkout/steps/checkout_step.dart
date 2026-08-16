import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/checkout_cubit/checkout_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/cart/cart_api_model.dart';
import 'package:kalivra/model/checkout/checkout_summary_model.dart';
import 'package:kalivra/view/screens/checkout/steps/address_step.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';

class CheckoutStep extends StatelessWidget {
  const CheckoutStep({
    super.key,
    required this.onConfirm,
    required this.isLoading,
  });

  final VoidCallback? onConfirm;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final checkoutState = context.watch<CheckoutCubit>().state;
    final cartCubit = context.watch<CartCubit>();
    final summary = checkoutState.summary;
    final cart = summary?.cart ?? cartCubit.cart;
    final items = cart?.items ?? cartCubit.apiItems;
    final shippingMethod = _selectedShippingMethod(checkoutState);
    final paymentMethod = _selectedPaymentMethod(checkoutState);
    final address = CheckoutAddressData.fromSummary(summary).firstOrNull;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProductsSummaryCard(items: items),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _SmallInfoCard(
                  icon: Icons.local_shipping_outlined,
                  title: AppLocalizations.of(context)!.shippingMethod,
                  primary: shippingMethod?.title ?? '',
                  secondary: shippingMethod?.description ?? '',
                  tertiary: _formatShippingPrice(context, shippingMethod),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _SmallInfoCard(
                  icon: Icons.payment_rounded,
                  title: AppLocalizations.of(context)!.paymentMethod,
                  primary:
                      paymentMethod?.title ??
                      AppLocalizations.of(context)!.cashOnDelivery,
                  secondary:
                      paymentMethod?.description ??
                      AppLocalizations.of(context)!.cashOnDeliverySubtitle,
                ),
              ),
            ],
          ),
          if (address != null) ...[
            SizedBox(height: 14.h),
            _AddressSummaryCard(address: address),
          ],
          SizedBox(height: 14.h),
          _OrderDetailsCard(cart: cart, shippingMethod: shippingMethod),
          SizedBox(height: 18.h),
          FilledButton.icon(
            onPressed: isLoading ? null : onConfirm,
            icon: isLoading
                ? SpinKitFadingCircle(
                    itemSize: 18.r,
                    size: 20.r,
                    color: AppColors.offWhite,
                  )
                : Icon(Icons.lock_rounded, size: 21.r),
            label: Text(
              AppLocalizations.of(context)!.confirmOrder,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.burgundy,
              foregroundColor: AppColors.offWhite,
              padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 18.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  CheckoutShippingMethodModel? _selectedShippingMethod(CheckoutState state) {
    final selectedCode = state.selectedShippingMethod;
    for (final method in state.shippingMethods) {
      if (method.method == selectedCode) return method;
    }
    return state.shippingMethods.isNotEmpty
        ? state.shippingMethods.first
        : null;
  }

  CheckoutPaymentMethodModel? _selectedPaymentMethod(CheckoutState state) {
    final selectedCode = state.selectedPaymentMethod;
    for (final method in state.paymentMethods) {
      if (method.method == selectedCode) return method;
    }
    if (state.paymentMethods.isEmpty) return null;
    return state.paymentMethods.firstWhere((method) {
      final value = method.method.toLowerCase();
      return value == 'cashondelivery' ||
          value == 'cash_on_delivery' ||
          value == 'cod';
    }, orElse: () => state.paymentMethods.first);
  }

  String _formatShippingPrice(
    BuildContext context,
    CheckoutShippingMethodModel? method,
  ) {
    if (method == null) return '';
    if (method.formattedPrice?.isNotEmpty == true) {
      return method.formattedPrice!;
    }
    if (method.price == null || method.price == 0) {
      return AppLocalizations.of(context)!.checkoutFree;
    }
    return method.price!.toStringAsFixed(0);
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class _ProductsSummaryCard extends StatelessWidget {
  const _ProductsSummaryCard({required this.items});

  final List<CartItemApiModel> items;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _SummaryContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            icon: Icons.shopping_bag_outlined,
            title: l10n.checkoutProducts(items.length),
          ),
          SizedBox(height: 12.h),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      width: 78.w,
                      height: 78.w,
                      color: colorScheme.tertiaryFixed,
                      child: CustomNetworkImage(
                        imageUrl: item.imageUrl,
                        width: 78.w,
                        height: 78.w,
                        defaultIcon: Icons.image_outlined,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? l10n.productDetails,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.primaryFixed,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        ...item.options
                            .take(1)
                            .map(
                              (option) => Text(
                                '${option.attributeName ?? ''}: ${option.optionLabel ?? ''}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primaryFixed.withValues(
                                    alpha: 0.55,
                                  ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        SizedBox(height: 4.h),
                        Text(
                          l10n.quantityLabel(item.quantity ?? 1),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primaryFixed.withValues(
                              alpha: 0.55,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    item.formattedTotal ??
                        item.formattedPrice ??
                        item.total?.toStringAsFixed(0) ??
                        '',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.burgundy,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallInfoCard extends StatelessWidget {
  const _SmallInfoCard({
    required this.icon,
    required this.title,
    required this.primary,
    this.secondary = '',
    this.tertiary = '',
  });

  final IconData icon;
  final String title;
  final String primary;
  final String secondary;
  final String tertiary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return _SummaryContainer(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 126.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(icon: icon, title: title),
            SizedBox(height: 12.h),
            Text(
              primary,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primaryFixed,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (secondary.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                secondary,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primaryFixed.withValues(alpha: 0.55),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (tertiary.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                tertiary,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primaryFixed,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddressSummaryCard extends StatelessWidget {
  const _AddressSummaryCard({required this.address});

  final CheckoutAddressData address;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return _SummaryContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.location_on_outlined,
            title: AppLocalizations.of(context)!.checkoutDeliveryAddress,
          ),
          SizedBox(height: 12.h),
          Text(
            address.fullName,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.primaryFixed,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 7.h),
          if (address.phone.isNotEmpty)
            Text(address.phone, style: theme.textTheme.bodyMedium),
          if (address.address.isNotEmpty) ...[
            SizedBox(height: 7.h),
            Text(
              address.address,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primaryFixed.withValues(alpha: 0.55),
              ),
            ),
          ],
          if (address.cityLine.isNotEmpty) ...[
            SizedBox(height: 5.h),
            Text(
              address.cityLine,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primaryFixed.withValues(alpha: 0.55),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderDetailsCard extends StatelessWidget {
  const _OrderDetailsCard({required this.cart, required this.shippingMethod});

  final CartApiModel? cart;
  final CheckoutShippingMethodModel? shippingMethod;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _SummaryContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            icon: Icons.receipt_long_outlined,
            title: l10n.checkoutOrderDetails,
          ),
          SizedBox(height: 18.h),
          _TotalRow(label: l10n.subtotal, value: cart?.formattedSubTotal ?? ''),
          SizedBox(height: 10.h),
          _TotalRow(
            label:
                '${l10n.deliveryCost}${shippingMethod == null ? '' : ' (${shippingMethod!.title})'}',
            value:
                shippingMethod?.formattedPrice ??
                cart?.formattedShippingAmount ??
                '',
          ),
          SizedBox(height: 10.h),
          _TotalRow(
            label: l10n.discount,
            value: cart?.formattedDiscountAmount ?? '',
          ),
          SizedBox(height: 10.h),
          _TotalRow(label: l10n.tax, value: cart?.formattedTaxTotal ?? ''),
          Divider(
            height: 26.h,
            color: colorScheme.primaryFixed.withValues(alpha: 0.1),
          ),
          _TotalRow(
            label: l10n.total,
            value: cart?.formattedGrandTotal ?? '',
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryContainer extends StatelessWidget {
  const _SummaryContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.primaryFixed.withValues(alpha: 0.07),
        ),
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 34.r,
          height: 34.r,
          decoration: BoxDecoration(
            color: AppColors.burgundy.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: AppColors.burgundy, size: 21.r),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primaryFixed,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
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
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.primaryFixed,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: bold ? AppColors.burgundy : colorScheme.primaryFixed,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
