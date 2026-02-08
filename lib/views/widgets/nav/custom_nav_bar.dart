import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/models/nav_item_model.dart';
import 'package:kalivra/views/widgets/nav/nav_item.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key, 
    required this.currentIndex,
    required this.onTap,
    required  this.items
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItemModel>items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.08),
            blurRadius: 12.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
            List.generate(items.length, (index) => NavItem(
                icon: items[index].icon,
                index: items[index].index,
                currentIndex: currentIndex,
                onTap: onTap,
              ),),
          ),
        ),
      ),
    );
  }
}

