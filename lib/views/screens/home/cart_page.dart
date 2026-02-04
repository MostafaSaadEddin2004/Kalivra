import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  size: 80,
                  color: AppColors.taupe.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 16),
                Text(
                  'السلة فارغة',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.burgundy,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'تصفح التصنيفات وأضف المنتجات هنا',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.black.withValues(alpha: 0.6),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.storefront_rounded, size: 20),
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
