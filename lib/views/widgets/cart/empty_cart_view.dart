import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controllers/blocs/cubit/nav_cubit.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 72.r,
                color: colorScheme.onSurface,
              ),
              SizedBox(height: 24.h),
              Text(
                'السلة فارغة',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'تصفح التصنيفات وأضف المنتجات هنا',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              FilledButton.icon(
                onPressed: () =>
                    context.read<NavCubit>().goTo(NavCubit.categories),
                icon: Icon(Icons.storefront_rounded, size: 22.r),
                label: const Text('تسوق الآن'),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                    vertical: 14.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
