import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/orders_cubit/orders_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/network/api_error_handler.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/models/order_model.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';
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
    context.read<OrdersCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'طلباتي'),
      body: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state.hasError) {
            ApiErrorHandler.showSnackBar(
              context,
              state.error!,
              fallbackMessage: 'فشل تحميل الطلبات',
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.orders.isEmpty) {
            return Skeletonizer(
              enabled: true,
              child: ListView.builder(
                padding: EdgeInsets.all(20.w),
                itemCount: 4,
                itemBuilder: (_, i) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                height: 20,
                                color: Colors.grey,
                              ),
                              Container(
                                width: 60,
                                height: 20,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Container(width: 120, height: 16, color: Colors.grey),
                          SizedBox(height: 8.h),
                          Container(width: 60, height: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          final orders = state.orders;
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80.r,
                    color: isDark
                        ? AppColors.taupe.withValues(alpha: 0.6)
                        : AppColors.burgundy.withValues(alpha: 0.5),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'لا توجد طلبات بعد',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isDark ? AppColors.offWhite : AppColors.burgundy,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'طلباتك ستظهر هنا',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.taupe : AppColors.black,
                    ),
                  ),
                ],
              ), 
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(20.w),
            itemCount: orders.length,
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _OrderCard(order: order);
            },
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _statusColor(order.status, isDark);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: InkWell(
        onTap: () => context.push(AppRoutes.orderDetails, extra: order),
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.id,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.offWhite : AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      order.status,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                order.date,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.taupe : AppColors.burgundy,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الإجمالي',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.taupe : AppColors.black,
                    ),
                  ),
                  Text(
                    '${order.total.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currencySYP}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.goldLight : AppColors.burgundy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () =>
                      context.push(AppRoutes.orderDetails, extra: order),
                  icon: Icon(Icons.visibility_rounded, size: 18.r),
                  label: Text(AppLocalizations.of(context)!.viewDetails),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color _statusColor(String status, bool isDark) {
    if (status.contains('مكتمل') || status.toLowerCase().contains('complete')) {
      return AppColors.goldDark;
    }
    if (status.contains('توصيل') || status.toLowerCase().contains('ship')) {
      return AppColors.burgundy;
    }
    return isDark ? AppColors.taupe : AppColors.burgundy;
  }
}
