import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kalivra/controller/blocs/cubit/orders_cubit/orders_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/order/order_model.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.myOrders),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          switch (state) {
            case OrdersLoginRequired():
              return LoginRequiredPlaceholder(
                icon: Icons.receipt_long_outlined,
                title: l10n.loginRequiredForOrders,
                description: l10n.ordersLoginPrompt,
              );
            case OrdersLoaded():
              if (state.orders.isEmpty) {
                return _OrdersEmptyCard(
                  title: l10n.noOrders,
                  description: l10n.ordersPrompt,
                );
              }
              return _OrdersList(orders: state.orders);
            case OrdersFailed():
              return _OrdersFailureCard(message: state.message);
            case OrdersLoading():
            default:
              return const _OrdersLoadingList();
          }
        },
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
        return _OrderCard(order: orders[index]);
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _statusColor(order.status);
    final orderNumber = order.displayId.isEmpty
        ? '${order.orderId ?? ''}'
        : order.displayId;

    return Material(
      color: theme.cardTheme.color,
      borderRadius: BorderRadius.circular(14.r),
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
                          '#$orderNumber',
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
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => _openOrderDetails(context),
                  child: Text(AppLocalizations.of(context)!.viewDetails),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openOrderDetails(BuildContext context) {
    final id = order.orderId ?? int.tryParse(order.id);
    if (id == null) return;
    context.push(AppRoutes.orderDetails, extra: id);
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
