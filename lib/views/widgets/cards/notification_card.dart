import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
  });

  final String title;
  final String body;
  final String time;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        leading: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: colorScheme.onSecondaryFixed,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 24.r),
        ),
        title: Text(
          title,
          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            body,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Text(
          time,
          style: Theme.of(context).textTheme.labelSmall
        ),
        onTap: () {},
      ),
    );
  }
}
