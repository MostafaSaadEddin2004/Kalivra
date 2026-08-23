import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/orders_cubit/orders_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/order/order_model.dart';
import 'package:kalivra/view/widgets/app_refresh_indicator.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _isCancelling = false;
  bool _isReordering = false;

  Future<void> _refreshOrder(BuildContext context) {
    return context.read<OrdersCubit>().loadOrderDetails(widget.orderId);
  }

  Future<void> _cancelOrder(BuildContext context) async {
    if (_isCancelling) return;
    setState(() => _isCancelling = true);
    final labels = _OrderDetailsLabels.of(context);
    try {
      await context.read<OrdersCubit>().cancelOrder(widget.orderId);
      if (!context.mounted) return;
      CustomSnackBar.show(context, labels.cancelSuccess);
      context.pop(true);
    } catch (e) {
      if (context.mounted) CustomSnackBar.show(context, e.toString());
    } finally {
      if (mounted) setState(() => _isCancelling = false);
    }
  }

  Future<void> _reorder(BuildContext context) async {
    if (_isReordering) return;
    setState(() => _isReordering = true);
    final labels = _OrderDetailsLabels.of(context);
    try {
      await context.read<OrdersCubit>().reorder(widget.orderId);
      if (!context.mounted) return;
      await context.read<CartCubit>().getCart();
      if (!context.mounted) return;
      CustomSnackBar.show(context, labels.reorderSuccess);
    } catch (e) {
      if (context.mounted) CustomSnackBar.show(context, e.toString());
    } finally {
      if (mounted) setState(() => _isReordering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersCubit()..loadOrderDetails(widget.orderId),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: ScreenAppBar(
              title: AppLocalizations.of(context)!.orderDetails,
            ),
            body: AppRefreshIndicator(
              onRefresh: () => _refreshOrder(context),
              child: BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  switch (state) {
                    case OneOrderLoaded():
                      return _OrderDetailsContent(
                        order: state.order,
                        isCancelling: _isCancelling,
                        isReordering: _isReordering,
                        onCancel: () => _cancelOrder(context),
                        onReorder: () => _reorder(context),
                      );
                    case OrdersFailed():
                      return RefreshableStateBox(
                        child: _OrderDetailsFailure(message: state.message),
                      );
                    case OrdersLoading():
                    default:
                      return const _OrderDetailsLoading();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrderDetailsContent extends StatelessWidget {
  const _OrderDetailsContent({
    required this.order,
    this.isCancelling = false,
    this.isReordering = false,
    this.onCancel,
    this.onReorder,
  });

  final OrderModel order;
  final bool isCancelling;
  final bool isReordering;
  final VoidCallback? onCancel;
  final VoidCallback? onReorder;

  @override
  Widget build(BuildContext context) {
    final labels = _OrderDetailsLabels.of(context);
    final formattedDate = _formatDate(context, order);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
      children: [
        _OrderHeaderCard(order: order),
        SizedBox(height: 14.h),
        _OrderActionsCard(
          order: order,
          isCancelling: isCancelling,
          isReordering: isReordering,
          onCancel: onCancel,
          onReorder: onReorder,
        ),
        SizedBox(height: 14.h),
        _SectionCard(
          title: labels.orderSummary,
          icon: Icons.summarize_outlined,
          child: Column(
            children: [
              _DetailsRow(
                label: labels.orderNumber,
                value: '#${order.displayId}',
              ),
              _DetailsRow(
                label: AppLocalizations.of(context)!.status,
                value: order.displayStatus,
              ),
              if (formattedDate.isNotEmpty)
                _DetailsRow(label: labels.placedOn, value: formattedDate),
              if (order.currencyCode.isNotEmpty)
                _DetailsRow(label: labels.currency, value: order.currencyCode),
              if (order.paymentMethod?.isNotEmpty ?? false)
                _DetailsRow(
                  label: AppLocalizations.of(context)!.paymentMethod,
                  value: order.paymentMethod!,
                ),
              _DetailsRow(
                label: AppLocalizations.of(context)!.subtotal,
                value: _formatMoney(context, order.itemSubtotal, order),
              ),
              if (order.deliveryCost > 0)
                _DetailsRow(
                  label: AppLocalizations.of(context)!.deliveryCost,
                  value: _formatMoney(context, order.deliveryCost, order),
                ),
              _DetailsRow(
                label: AppLocalizations.of(context)!.total,
                value: _formatTotal(context, order),
                isEmphasized: true,
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        _SectionCard(
          title: labels.items,
          icon: Icons.inventory_2_outlined,
          trailing: _CountPill(count: order.items.length),
          child: order.items.isEmpty
              ? _EmptyDetailsText(text: labels.noItems)
              : Column(
                  children: [
                    for (var i = 0; i < order.items.length; i++) ...[
                      _OrderItemTile(item: order.items[i], order: order),
                      if (i != order.items.length - 1) const _SoftDivider(),
                    ],
                  ],
                ),
        ),
        SizedBox(height: 14.h),
        _ResponsiveAddressGrid(
          shippingAddress: order.shippingAddress,
          billingAddress: order.billingAddress,
        ),
      ],
    );
  }
}

class _OrderHeaderCard extends StatelessWidget {
  const _OrderHeaderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _statusColor(order.status);
    final labels = _OrderDetailsLabels.of(context);

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.burgundy,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.14),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: AppColors.offWhite.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.offWhite,
                  size: 25.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labels.orderNumber,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.offWhite.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      '#${order.displayId}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.offWhite,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(label: order.displayStatus, color: statusColor),
            ],
          ),
          SizedBox(height: 18.h),
          Text(
            _formatTotal(context, order),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.offWhite,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            _formatDate(context, order),
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.offWhite.withValues(alpha: 0.72),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _HeaderStat(
                  label: labels.items,
                  value: order.items.length.toString(),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _HeaderStat(
                  label: labels.currency,
                  value: order.currencyCode.isEmpty
                      ? AppLocalizations.of(context)!.currencySYP
                      : order.currencyCode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.offWhite.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.offWhite.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.offWhite.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5.h),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.offWhite,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _OrderActionsCard extends StatelessWidget {
  const _OrderActionsCard({
    required this.order,
    required this.isCancelling,
    required this.isReordering,
    this.onCancel,
    this.onReorder,
  });

  final OrderModel order;
  final bool isCancelling;
  final bool isReordering;
  final VoidCallback? onCancel;
  final VoidCallback? onReorder;

  @override
  Widget build(BuildContext context) {
    final labels = _OrderDetailsLabels.of(context);
    final canCancel = _canCancel(order.status);

    return _SectionCard(
      title: labels.actions,
      icon: Icons.touch_app_outlined,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: canCancel && !isCancelling && !isReordering
                  ? onCancel
                  : null,
              icon: isCancelling
                  ? SizedBox(
                      width: 16.r,
                      height: 16.r,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cancel_outlined),
              label: Text(labels.cancelOrder),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.burgundy,
                side: BorderSide(
                  color: AppColors.burgundy.withValues(alpha: 0.34),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: FilledButton.icon(
              onPressed: !isCancelling && !isReordering ? onReorder : null,
              icon: isReordering
                  ? SizedBox(
                      width: 16.r,
                      height: 16.r,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.replay_outlined),
              label: Text(labels.reorder),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colorScheme.primaryFixed.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 12.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.burgundy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: AppColors.burgundy, size: 20.r),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primaryFixed,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          SizedBox(height: 14.h),
          child,
        ],
      ),
    );
  }
}

class _DetailsRow extends StatelessWidget {
  const _DetailsRow({
    required this.label,
    required this.value,
    this.isEmphasized = false,
  });

  final String label;
  final String value;
  final bool isEmphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primaryFixed.withValues(alpha: 0.52),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style:
                  (isEmphasized
                          ? theme.textTheme.titleMedium
                          : theme.textTheme.bodyMedium)
                      ?.copyWith(
                        color: isEmphasized
                            ? AppColors.burgundy
                            : colorScheme.primaryFixed,
                        fontWeight: isEmphasized
                            ? FontWeight.w900
                            : FontWeight.w700,
                      ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile({required this.item, required this.order});

  final OrderLineItem item;
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final labels = _OrderDetailsLabels.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58.w,
            height: 58.w,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colorScheme.primaryFixed.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: CustomNetworkImage(
              imageUrl: item.imageUrl,
              defaultIcon: Icons.inventory_2_outlined,
              defaultIconColor: AppColors.burgundy,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primaryFixed,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (item.sku?.isNotEmpty ?? false) ...[
                  SizedBox(height: 4.h),
                  Text(
                    '${labels.sku}: ${item.sku}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primaryFixed.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: [
                    _ItemChip(
                      label:
                          '${AppLocalizations.of(context)!.quantity}: ${item.quantity}',
                    ),
                    _ItemChip(
                      label:
                          '${labels.unitPrice}: ${_formatItemPrice(context, item, order)}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 96.w),
            child: Text(
              _formatItemTotal(context, item, order),
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.burgundy,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemChip extends StatelessWidget {
  const _ItemChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.taupe.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primaryFixed.withValues(alpha: 0.72),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ResponsiveAddressGrid extends StatelessWidget {
  const _ResponsiveAddressGrid({
    required this.shippingAddress,
    required this.billingAddress,
  });

  final OrderAddressModel? shippingAddress;
  final OrderAddressModel? billingAddress;

  @override
  Widget build(BuildContext context) {
    final labels = _OrderDetailsLabels.of(context);
    final shipping = _AddressCard(
      title: AppLocalizations.of(context)!.shippingAddress,
      icon: Icons.local_shipping_outlined,
      address: shippingAddress,
    );
    final billing = _AddressCard(
      title: labels.billingAddress,
      icon: Icons.payments_outlined,
      address: billingAddress,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 620) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: shipping),
              SizedBox(width: 14.w),
              Expanded(child: billing),
            ],
          );
        }

        return Column(
          children: [
            shipping,
            SizedBox(height: 14.h),
            billing,
          ],
        );
      },
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.title,
    required this.icon,
    required this.address,
  });

  final String title;
  final IconData icon;
  final OrderAddressModel? address;

  @override
  Widget build(BuildContext context) {
    final labels = _OrderDetailsLabels.of(context);

    return _SectionCard(
      title: title,
      icon: icon,
      child: address?.hasData ?? false
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (address!.fullName.isNotEmpty)
                  _AddressLine(
                    icon: Icons.person_outline,
                    text: address!.fullName,
                    isTitle: true,
                  ),
                if (address!.companyName?.isNotEmpty ?? false)
                  _AddressLine(
                    icon: Icons.business_outlined,
                    text: address!.companyName!,
                  ),
                if (address!.locationLine.isNotEmpty)
                  _AddressLine(
                    icon: Icons.location_on_outlined,
                    text: address!.locationLine,
                  ),
                if (address!.email?.isNotEmpty ?? false)
                  _AddressLine(icon: Icons.mail_outline, text: address!.email!),
                if (address!.phone?.isNotEmpty ?? false)
                  _AddressLine(
                    icon: Icons.phone_outlined,
                    text: address!.phone!,
                  ),
                if (address!.vatId?.isNotEmpty ?? false)
                  _AddressLine(
                    icon: Icons.badge_outlined,
                    text: address!.vatId!,
                  ),
              ],
            )
          : _EmptyDetailsText(text: labels.noAddress),
    );
  }
}

class _AddressLine extends StatelessWidget {
  const _AddressLine({
    required this.icon,
    required this.text,
    this.isTitle = false,
  });

  final IconData icon;
  final String text;
  final bool isTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 9.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 17.r,
            color: AppColors.burgundy.withValues(alpha: 0.78),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style:
                  (isTitle
                          ? theme.textTheme.titleSmall
                          : theme.textTheme.bodySmall)
                      ?.copyWith(
                        color: colorScheme.primaryFixed.withValues(
                          alpha: isTitle ? 0.92 : 0.66,
                        ),
                        fontWeight: isTitle ? FontWeight.w800 : FontWeight.w600,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.goldLight.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        count.toString(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.goldDark,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SoftDivider extends StatelessWidget {
  const _SoftDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).colorScheme.primaryFixed.withValues(alpha: 0.08),
    );
  }
}

class _EmptyDetailsText extends StatelessWidget {
  const _EmptyDetailsText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.primaryFixed.withValues(alpha: 0.56),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _OrderDetailsFailure extends StatelessWidget {
  const _OrderDetailsFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labels = _OrderDetailsLabels.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: theme.colorScheme.error.withValues(alpha: 0.18),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: theme.colorScheme.error,
                size: 34.r,
              ),
              SizedBox(height: 12.h),
              Text(
                labels.loadFailed,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primaryFixed,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primaryFixed.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderDetailsLoading extends StatelessWidget {
  const _OrderDetailsLoading();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: _OrderDetailsContent(
        order: OrderModel(
          orderId: 0,
          id: '0000',
          incrementId: '0000',
          date: '2026-08-17T22:41:49.000000Z',
          status: 'pending',
          statusLabel: 'Pending',
          subtotal: 1135,
          deliveryCost: 0,
          total: 1205,
          formattedGrandTotal: '1205',
          currencyCode: 'USD',
          items: const [
            OrderLineItem(
              productName: 'Sample product name',
              quantity: 3,
              unitPrice: 185,
              sku: 'KCM-STS-001',
              lineTotal: 555,
            ),
            OrderLineItem(
              productName: 'Sample product name',
              quantity: 4,
              unitPrice: 145,
              sku: 'KCM-MRB-001',
              lineTotal: 580,
            ),
          ],
          shippingAddress: OrderAddressModel(
            firstName: 'Customer',
            lastName: 'Name',
            address: 'Street address',
            city: 'City',
            state: 'State',
            country: 'Country',
            email: 'email@example.com',
            phone: '000000000',
          ),
          billingAddress: OrderAddressModel(
            firstName: 'Customer',
            lastName: 'Name',
            address: 'Street address',
            city: 'City',
            state: 'State',
            country: 'Country',
            email: 'email@example.com',
            phone: '000000000',
          ),
        ),
      ),
    );
  }
}

class _OrderDetailsLabels {
  const _OrderDetailsLabels({
    required this.orderNumber,
    required this.placedOn,
    required this.items,
    required this.unitPrice,
    required this.sku,
    required this.billingAddress,
    required this.orderSummary,
    required this.currency,
    required this.noItems,
    required this.noAddress,
    required this.loadFailed,
    required this.actions,
    required this.cancelOrder,
    required this.reorder,
    required this.cancelSuccess,
    required this.reorderSuccess,
  });

  final String orderNumber;
  final String placedOn;
  final String items;
  final String unitPrice;
  final String sku;
  final String billingAddress;
  final String orderSummary;
  final String currency;
  final String noItems;
  final String noAddress;
  final String loadFailed;
  final String actions;
  final String cancelOrder;
  final String reorder;
  final String cancelSuccess;
  final String reorderSuccess;

  static _OrderDetailsLabels of(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isArabic) {
      return const _OrderDetailsLabels(
        orderNumber: 'رقم الطلب',
        placedOn: 'تاريخ الطلب',
        items: 'المنتجات',
        unitPrice: 'سعر القطعة',
        sku: 'رمز المنتج',
        billingAddress: 'عنوان الفاتورة',
        orderSummary: 'ملخص الطلب',
        currency: 'العملة',
        noItems: 'لا توجد منتجات في هذا الطلب.',
        noAddress: 'لا توجد بيانات عنوان متاحة.',
        loadFailed: 'تعذر تحميل تفاصيل الطلب',
        actions: 'إجراءات الطلب',
        cancelOrder: 'إلغاء الطلب',
        reorder: 'إعادة الطلب',
        cancelSuccess: 'تم إلغاء الطلب بنجاح',
        reorderSuccess: 'تمت إضافة الطلب إلى السلة بنجاح',
      );
    }

    return const _OrderDetailsLabels(
      orderNumber: 'Order number',
      placedOn: 'Placed on',
      items: 'Items',
      unitPrice: 'Unit price',
      sku: 'SKU',
      billingAddress: 'Billing address',
      orderSummary: 'Order summary',
      currency: 'Currency',
      noItems: 'No items are available for this order.',
      noAddress: 'No address details are available.',
      loadFailed: 'Unable to load order details',
      actions: 'Order actions',
      cancelOrder: 'Cancel order',
      reorder: 'Reorder',
      cancelSuccess: 'Order cancelled successfully',
      reorderSuccess: 'Order added to cart successfully',
    );
  }
}

String _formatDate(BuildContext context, OrderModel order) {
  final createdAt = order.createdAt;
  if (createdAt == null) return order.date;
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.yMMMd(locale).add_Hm().format(createdAt.toLocal());
}

String _formatTotal(BuildContext context, OrderModel order) {
  if (order.formattedGrandTotal.isNotEmpty) {
    return order.formattedGrandTotal;
  }
  return _formatMoney(context, order.total, order);
}

String _formatItemPrice(
  BuildContext context,
  OrderLineItem item,
  OrderModel order,
) {
  if (item.formattedPrice?.isNotEmpty ?? false) {
    return item.formattedPrice!;
  }
  return _formatMoney(context, item.unitPrice, order);
}

String _formatItemTotal(
  BuildContext context,
  OrderLineItem item,
  OrderModel order,
) {
  if (item.formattedTotal?.isNotEmpty ?? false) {
    return item.formattedTotal!;
  }
  return _formatMoney(context, item.total, order);
}

String _formatMoney(BuildContext context, double value, OrderModel order) {
  final currency = order.currencyCode.isNotEmpty
      ? order.currencyCode
      : AppLocalizations.of(context)!.currencySYP;
  final formatted = value % 1 == 0
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);
  return '$formatted $currency';
}

Color _statusColor(String status) {
  final normalized = status.toLowerCase().trim();
  if (normalized.contains('complete') || normalized.contains('مكتمل')) {
    return AppColors.goldDark;
  }
  if (normalized.contains('ship') || normalized.contains('توصيل')) {
    return AppColors.taupe;
  }
  if (normalized.contains('pending') || normalized.contains('قيد')) {
    return AppColors.goldLight;
  }
  if (normalized.contains('cancel') || normalized.contains('ملغ')) {
    return AppColors.red;
  }
  return AppColors.offWhite;
}

bool _canCancel(String status) {
  final normalized = status.toLowerCase().trim();
  return normalized.contains('pending') || normalized.contains('قيد');
}
