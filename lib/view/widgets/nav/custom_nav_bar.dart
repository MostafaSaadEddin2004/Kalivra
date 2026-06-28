import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/model/nav/nav_item_model.dart';
import 'package:kalivra/view/widgets/nav/nav_item.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItemModel> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.15),
            blurRadius: 4.r,
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) => NavItem(
            icon: items[index].icon,
            title: items[index].title,
            index: items[index].index,
            currentIndex: currentIndex,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
