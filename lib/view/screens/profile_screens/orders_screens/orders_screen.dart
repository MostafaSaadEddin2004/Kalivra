import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/orders_cubit/orders_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/order/order_model.dart';
import 'package:kalivra/view/widgets/app_refresh_indicator.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/login_required_placeholder.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersCubit>().loadOrders();
    });
  }

  Future<void> _refreshOrders() {
    return context.read<OrdersCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.myOrders),
      body: AppRefreshIndicator(
        onRefresh: _refreshOrders,
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            switch (state) {
              case OrdersLoginRequired():
                return RefreshableStateBox(
                  child: LoginRequiredPlaceholder(
                    icon: Icons.receipt_long_outlined,
                    title: l10n.loginRequiredForOrders,
                    description: l10n.ordersLoginPrompt,
                  ),
                );
              case OrdersLoaded():
                if (state.orders.isEmpty) {
                  return RefreshableStateBox(
                    child: _OrdersEmptyCard(
                      title: l10n.noOrders,
                      description: l10n.ordersPrompt,
                    ),
                  );
                }
                return _OrdersList(orders: state.orders);
              case OrdersFailed():
                return RefreshableStateBox(
                  child: _OrdersFailureCard(message: state.message),
                );
              case OrdersLoading():
              default:
                return const _OrdersLoadingList();
            }
          },
        ),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.orders});

  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
      itemCount: orders.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return _OrderCard(order: orders[index], index: getIndexReversed(orders.length));
      },
    );
  }
}

int getIndexReversed(int length){
  int index = 0;
  for(int i = 0; i <length;  ){
    index == i;
  }
  return index;
}

class _OrderCard extends StatefulWidget {
  const _OrderCard({required this.order, required this.index});

  final OrderModel order;
  final int index;

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _isCancelling = false;
  bool _isReordering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final labels = _OrderActionLabels.of(context);
    final order = widget.order;
    final statusColor = _statusColor(order.status);
    final canCancel = _canCancel(order.status);
    final isBusy = _isCancelling || _isReordering;
    final String index = '# ${widget.index + 1}';

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () => _openOrderDetails(context),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: colorScheme.primaryFixed.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.06),
                blurRadius: 14.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      color: AppColors.burgundy.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.receipt_long_outlined,
                      color: AppColors.burgundy,
                      size: 23.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          index,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primaryFixed,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _formatDate(context, order),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primaryFixed.withValues(
                              alpha: 0.58,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _StatusBadge(label: order.displayStatus, color: statusColor),
                ],
              ),
              SizedBox(height: 16.h),
              Divider(
                height: 1,
                color: colorScheme.primaryFixed.withValues(alpha: 0.08),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: _OrderMetaItem(
                      label: AppLocalizations.of(context)!.status,
                      value: order.displayStatus,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _OrderMetaItem(
                      label: AppLocalizations.of(context)!.total,
                      value: _formatTotal(context, order),
                      alignEnd: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: canCancel && !isBusy
                          ? () => _cancelOrder(context)
                          : null,
                      icon: _isCancelling
                          ? SizedBox(
                              width: 16.r,
                              height: 16.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
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
                  SizedBox(width: 8.w),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: !isBusy ? () => _reorder(context) : null,
                      icon: _isReordering
                          ? SizedBox(
                              width: 16.r,
                              height: 16.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.replay_outlined),
                      label: Text(labels.reorder),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: isBusy ? null : () => _openOrderDetails(context),
                  child: Text(AppLocalizations.of(context)!.viewDetails),
                ),
              ),
              if (!canCancel) ...[
                Text(
                  labels.cancelUnavailable,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primaryFixed.withValues(alpha: 0.46),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openOrderDetails(BuildContext context) async {
    final id = widget.order.orderId ?? int.tryParse(widget.order.id);
    if (id == null) return;
    final shouldReload = await context.push<bool>(
      AppRoutes.orderDetails,
      extra: id,
    );
    if (shouldReload == true && context.mounted) {
      context.read<OrdersCubit>().loadOrders();
    }
  }

  Future<void> _cancelOrder(BuildContext context) async {
    final id = widget.order.orderId ?? int.tryParse(widget.order.id);
    if (id == null || _isCancelling) return;

    setState(() => _isCancelling = true);
    final labels = _OrderActionLabels.of(context);
    try {
      await context.read<OrdersCubit>().cancelOrder(id);
      if (!context.mounted) return;
      CustomSnackBar.show(context, labels.cancelSuccess);
      await context.read<OrdersCubit>().loadOrders();
    } catch (e) {
      if (context.mounted) CustomSnackBar.show(context, e.toString());
    } finally {
      if (mounted) setState(() => _isCancelling = false);
    }
  }

  Future<void> _reorder(BuildContext context) async {
    final id = widget.order.orderId ?? int.tryParse(widget.order.id);
    if (id == null || _isReordering) return;

    setState(() => _isReordering = true);
    final labels = _OrderActionLabels.of(context);
    try {
      await context.read<OrdersCubit>().reorder(id);
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

  static String _formatDate(BuildContext context, OrderModel order) {
    final createdAt = order.createdAt;
    if (createdAt == null) return order.date;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(locale).add_Hm().format(createdAt.toLocal());
  }

  static String _formatTotal(BuildContext context, OrderModel order) {
    if (order.formattedGrandTotal.isNotEmpty) {
      return order.formattedGrandTotal;
    }
    final currency = order.currencyCode.isNotEmpty
        ? order.currencyCode
        : AppLocalizations.of(context)!.currencySYP;
    return '${order.total.toStringAsFixed(0)} $currency';
  }

  static Color _statusColor(String status) {
    final normalized = status.toLowerCase().trim();
    if (normalized.contains('complete') || normalized.contains('مكتمل')) {
      return AppColors.goldDark;
    }
    if (normalized.contains('ship') || normalized.contains('توصيل')) {
      return AppColors.burgundy;
    }
    if (normalized.contains('pending') || normalized.contains('قيد')) {
      return AppColors.goldLight;
    }
    return AppColors.taupe;
  }

  static bool _canCancel(String status) {
    final normalized = status.toLowerCase().trim();
    return normalized.contains('pending') || normalized.contains('قيد');
  }
}

class _OrderActionLabels {
  const _OrderActionLabels({
    required this.cancelOrder,
    required this.reorder,
    required this.cancelSuccess,
    required this.reorderSuccess,
    required this.cancelUnavailable,
  });

  final String cancelOrder;
  final String reorder;
  final String cancelSuccess;
  final String reorderSuccess;
  final String cancelUnavailable;

  static _OrderActionLabels of(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isArabic) {
      return const _OrderActionLabels(
        cancelOrder: 'إلغاء الطلب',
        reorder: 'إعادة الطلب',
        cancelSuccess: 'تم إلغاء الطلب بنجاح',
        reorderSuccess: 'تمت إضافة الطلب إلى السلة بنجاح',
        cancelUnavailable: 'لا يمكن إلغاء هذا الطلب حالياً',
      );
    }

    return const _OrderActionLabels(
      cancelOrder: 'Cancel',
      reorder: 'Reorder',
      cancelSuccess: 'Order cancelled successfully',
      reorderSuccess: 'Order added to cart successfully',
      cancelUnavailable: 'This order cannot be cancelled now',
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _OrderMetaItem extends StatelessWidget {
  const _OrderMetaItem({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.primaryFixed.withValues(alpha: 0.48),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            color: alignEnd ? AppColors.burgundy : colorScheme.primaryFixed,
            fontWeight: FontWeight.w800,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),
      ],
    );
  }
}

class _OrdersLoadingList extends StatelessWidget {
  const _OrdersLoadingList();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
        itemCount: 4,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          return const _OrderCard(
            index: 0,
            order: OrderModel(
              orderId: 0,
              id: '0000',
              incrementId: '0000',
              date: '2026-08-17T22:41:49.000000Z',
              status: 'pending',
              statusLabel: 'Pending',
              subtotal: 0,
              deliveryCost: 0,
              total: 1205,
              formattedGrandTotal: '1205',
              items: [],
            ),
          );
        },
      ),
    );
  }
}

class _OrdersFailureCard extends StatelessWidget {
  const _OrdersFailureCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
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
                l10n.loadOrdersFailed,
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

class _OrdersEmptyCard extends StatelessWidget {
  const _OrdersEmptyCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 26.h),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: colorScheme.primaryFixed.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58.w,
                height: 58.w,
                decoration: BoxDecoration(
                  color: AppColors.burgundy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.burgundy,
                  size: 30.r,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primaryFixed,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.h),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primaryFixed.withValues(alpha: 0.55),
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
