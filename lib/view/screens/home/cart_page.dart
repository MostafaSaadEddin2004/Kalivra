import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/view/widgets/cart/cart_items_view.dart';
import 'package:kalivra/view/widgets/cart/empty_cart_view.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().getCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoading && cartCubit.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = cartCubit.items;
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
