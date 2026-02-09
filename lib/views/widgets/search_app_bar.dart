import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';

/// App bar with only a search bar on top (for Search page).
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({
    super.key,
    this.hintText = 'ابحث عن منتجات، تصنيفات...',
    this.onChanged,
    this.controller,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      elevation: 0,
      title: TextField(
        cursorColor: AppColors.burgundy,
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(color: AppColors.burgundy, fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: textTheme.displaySmall?.copyWith(color: AppColors.burgundy),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.burgundy,
            size: 22.r,
          ),
          filled: true,
          fillColor: AppColors.lightGray,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.onPrimary, width: 1.5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.onError, width: 1.0),
            borderRadius: BorderRadius.circular(12.r),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 10.h,
          ),
        ),
      ),
    );
  }
}
