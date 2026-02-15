import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/models/order_model.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';

/// Full order details: header, status, items, totals, address.
class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final OrderModel order;

  static Color _statusColor(String status, bool isDark) {
    if (status == 'مكتمل') return AppColors.goldDark;
    if (status == 'قيد التوصيل') return AppColors.burgundy;
    return isDark ? AppColors.taupe : AppColors.burgundy;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _statusColor(order.status, isDark);

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'تفاصيل الطلب'),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        children: [
          _HeaderCard(
            orderId: order.id,
            date: order.date,
            status: order.status,
            statusColor: statusColor,
            isDark: isDark,
          ),
          if (order.shippingAddress != null) ...[
            SizedBox(height: 16.h),
            _SectionCard(
              title: 'عنوان التوصيل',
              icon: Icons.location_on_outlined,
              isDark: isDark,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.place_rounded,
                    size: 20.r,
                    color: isDark ? AppColors.taupe : AppColors.burgundy,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      order.shippingAddress!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark ? AppColors.offWhite : AppColors.black,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 16.h),
          _SectionCard(
            title: 'المنتجات',
            icon: Icons.shopping_bag_outlined,
            isDark: isDark,
            child: Column(
              children: [
                ...order.items.asMap().entries.map((e) {
                  final item = e.value;
                  final isLast = e.key == order.items.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
                    child: _OrderLineRow(
                      name: item.productName,
                      qty: item.quantity,
                      unitPrice: item.unitPrice,
                      total: item.total,
                      isDark: isDark,
                    ),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _TotalsCard(
            subtotal: order.subtotal,
            deliveryCost: order.deliveryCost,
            total: order.total,
            isDark: isDark,
          ),
          if (order.paymentMethod != null) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.payment_rounded,
                  size: 20.r,
                  color: isDark ? AppColors.taupe : AppColors.burgundy,
                ),
                SizedBox(width: 8.w),
                Text(
                  'طريقة الدفع: ${order.paymentMethod}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.taupe : AppColors.black,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.orderId,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.isDark,
  });

  final String orderId;
  final String date;
  final String status;
  final Color statusColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderId,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: isDark ? AppColors.offWhite : AppColors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    status,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 18.r,
                  color: isDark ? AppColors.taupe : AppColors.burgundy,
                ),
                SizedBox(width: 8.w),
                Text(
                  date,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.taupe : AppColors.burgundy,
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.isDark,
    required this.child,
  });

  final String title;
  final IconData icon;
  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 22.r,
                  color: isDark ? AppColors.goldLight : AppColors.burgundy,
                ),
                SizedBox(width: 10.w),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.goldLight : AppColors.burgundy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            child,
          ],
        ),
      ),
    );
  }
}

class _OrderLineRow extends StatelessWidget {
  const _OrderLineRow({
    required this.name,
    required this.qty,
    required this.unitPrice,
    required this.total,
    required this.isDark,
  });

  final String name;
  final int qty;
  final double unitPrice;
  final double total;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.burgundy.withValues(alpha: 0.2)
                : AppColors.burgundy.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.inventory_2_outlined,
            size: 22.r,
            color: isDark ? AppColors.goldLight : AppColors.burgundy,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppColors.offWhite : AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '$qty × ${unitPrice.toStringAsFixed(0)} ر.س',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.taupe : AppColors.burgundy,
                ),
              ),
            ],
          ),
        ),
        Text(
          '${total.toStringAsFixed(0)} ر.س',
          style: theme.textTheme.titleMedium?.copyWith(
            color: isDark ? AppColors.goldLight : AppColors.burgundy,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({
    required this.subtotal,
    required this.deliveryCost,
    required this.total,
    required this.isDark,
  });

  final double subtotal;
  final double deliveryCost;
  final double total;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            _TotalRow(
              label: 'المجموع الفرعي',
              value: subtotal,
              isDark: isDark,
            ),
            SizedBox(height: 10.h),
            _TotalRow(
              label: 'التوصيل',
              value: deliveryCost,
              isDark: isDark,
            ),
            SizedBox(height: 14.h),
            Divider(height: 1, color: isDark ? AppColors.taupe.withValues(alpha: 0.3) : AppColors.burgundy.withValues(alpha: 0.3)),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الإجمالي',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.offWhite : AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${total.toStringAsFixed(0)} ر.س',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDark ? AppColors.goldLight : AppColors.burgundy,
                    fontWeight: FontWeight.w800,
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

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    required this.isDark,
  });

  final String label;
  final double value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.taupe : AppColors.black,
          ),
        ),
        Text(
          '${value.toStringAsFixed(0)} ر.س',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isDark ? AppColors.offWhite : AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
