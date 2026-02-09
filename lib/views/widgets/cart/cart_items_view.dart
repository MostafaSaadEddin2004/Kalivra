import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit.dart';
import 'package:kalivra/models/cart_item_model.dart';
import 'package:kalivra/views/widgets/cart/cart_details_bar.dart';
import 'package:kalivra/views/widgets/cart/cart_item_card.dart';

class CartItemsView extends StatelessWidget {
  const CartItemsView({super.key, required this.items});

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 16.h),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return CartItemCard(
                item: item,
                onQuantityChanged: (q) =>
                    cartCubit.updateQuantity(item.product.id, q),
                onRemove: () => cartCubit.removeItem(item.product.id),
              );
            },
          ),
        ),
        CartDetailsBar(cubit: cartCubit, onCheckout: () {}),
      ],
    );
  }
}
