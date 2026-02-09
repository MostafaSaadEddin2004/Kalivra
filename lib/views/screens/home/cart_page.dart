import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit.dart';
import 'package:kalivra/models/cart_item_model.dart';
import 'package:kalivra/views/widgets/cart/cart_items_view.dart';
import 'package:kalivra/views/widgets/cart/empty_cart_view.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, List<CartItem>>(
      builder: (context, items) {
        if (items.isEmpty) {
          return EmptyCartView(key: const ValueKey('empty_cart'));
        }
        return CartItemsView(
          key: const ValueKey('cart_items'),
          items: items,
        );
      },
    );
  }
}






