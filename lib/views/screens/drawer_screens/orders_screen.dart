import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/models/order_model.dart';
import '../../widgets/drawer/drawer_screen_app_bar.dart';

/// My Orders: list of orders with status, date, and total.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const List<OrderModel> _orders = [
    OrderModel(
      id: 'ORD-2024-001',
      date: '15 يناير 2024',
      status: 'مكتمل',
      subtotal: 1180,
      deliveryCost: 70,
      total: 1250,
      shippingAddress: 'الرياض، حي النخيل، شارع الملك فهد، مبنى ٤',
      paymentMethod: 'الدفع عند الاستلام',
      items:  [
        OrderLineItem(productName: 'منتج فاخر أ', quantity: 2, unitPrice: 350),
        OrderLineItem(productName: 'منتج ب', quantity: 1, unitPrice: 480),
      ],
    ),
    OrderModel(
      id: 'ORD-2024-002',
      date: '10 يناير 2024',
      status: 'قيد التوصيل',
      subtotal: 840,
      deliveryCost: 50,
      total: 890,
      shippingAddress: 'جدة، حي الروضة، شارع التحلية',
      paymentMethod: 'بطاقة ائتمان',
      items:  [
        OrderLineItem(productName: 'منتج ج', quantity: 3, unitPrice: 280),
      ],
    ),
    OrderModel(
      id: 'ORD-2024-003',
      date: '5 يناير 2024',
      status: 'قيد المعالجة',
      subtotal: 406,
      deliveryCost: 50,
      total: 456,
      shippingAddress: 'الرياض، حي العليا',
      paymentMethod: 'الدفع عند الاستلام',
      items:  [
        OrderLineItem(productName: 'منتج د', quantity: 1, unitPrice: 256),
        OrderLineItem(productName: 'منتج هـ', quantity: 1, unitPrice: 150),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'طلباتي'),
      body: _orders.isEmpty
          ? _EmptyOrders(isDark: isDark)
          : ListView.separated(
              padding: EdgeInsets.all(20.w),
              itemCount: _orders.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final order = _orders[index];
                return _OrderCard(order: order);
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
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
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
                    '${order.total.toStringAsFixed(0)} ر.س',
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
                  onPressed: () => context.push(AppRoutes.orderDetails, extra: order),
                  icon: Icon(Icons.visibility_rounded, size: 18.r),
                  label: const Text('عرض التفاصيل'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color _statusColor(String status, bool isDark) {
    if (status == 'مكتمل') return AppColors.goldDark;
    if (status == 'قيد التوصيل') return AppColors.burgundy;
    return isDark ? AppColors.taupe : AppColors.burgundy;
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80.r,
            color: isDark ? AppColors.taupe.withValues(alpha: 0.6) : AppColors.burgundy.withValues(alpha: 0.5),
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
}
