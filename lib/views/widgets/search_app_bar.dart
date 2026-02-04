import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.burgundy,
      foregroundColor: AppColors.offWhite,
      elevation: 0,
      title: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: AppColors.offWhite, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.offWhite.withValues(alpha: 0.7),
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.offWhite.withValues(alpha: 0.9),
            size: 22,
          ),
          filled: true,
          fillColor: AppColors.burgundy.withValues(alpha: 0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }
}
