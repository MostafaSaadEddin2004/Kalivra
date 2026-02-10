import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import '../../widgets/drawer/drawer_screen_app_bar.dart';

/// Favorites: list of saved products (placeholder content).
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'المفضلة'),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border_rounded,
                size: 88.r,
                color: isDark
                    ? AppColors.taupe.withValues(alpha: 0.6)
                    : AppColors.burgundy.withValues(alpha: 0.5),
              ),
              SizedBox(height: 20.h),
              Text(
                'قائمة المفضلة فارغة',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? AppColors.offWhite : AppColors.burgundy,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'أضف المنتجات إلى المفضلة من خلال زر القلب في صفحة المنتج',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.taupe : AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.shopping_bag_rounded, size: 22.r),
                label: const Text('تسوق الآن'),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
