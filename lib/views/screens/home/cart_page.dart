import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controllers/blocs/cubit/nav_cubit.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80.r,
                  color: colorScheme.outline.withValues(alpha: 0.6),
                ),
                SizedBox(height: 16.h),
                Text(
                  'السلة فارغة',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8.h),
                Text(
                  'تصفح التصنيفات وأضف المنتجات هنا',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                FilledButton.icon(
                  onPressed: () =>
                    context.read<NavCubit>().goTo(1)
                  ,
                  icon: Icon(Icons.storefront_rounded),
                  label: const Text('تسوق الآن'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
