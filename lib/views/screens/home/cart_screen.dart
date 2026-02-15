import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/views/widgets/cart/cart_items_view.dart';
import 'package:kalivra/views/widgets/cart/empty_cart_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit.dart';
import 'package:kalivra/models/cart_item_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, List<CartItem>>(
      builder: (context, items) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            leading: CustomIconButton(
              icon: Icons.arrow_back_rounded,
              color: Theme.of(context).appBarTheme.foregroundColor ?? AppColors.offWhite,
              iconSize: 28.r,
              onPressed: () => context.pop(),
              tooltip: 'رجوع',
            ),
            title: Text(
              'السلة',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: items.isEmpty
              ? const EmptyCartView()
              : CartItemsView(items: items),
        );
      },
    );
  }
}
