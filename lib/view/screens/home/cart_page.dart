import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/cart/cart_items_view.dart';
import 'package:kalivra/view/widgets/cart/empty_cart_view.dart';
import 'package:kalivra/view/widgets/login_required_placeholder.dart';

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

  Future<void> _refreshCart() {
    return context.read<CartCubit>().getCart();
  }

  Widget _refreshable(Widget child) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onTertiaryFixed,
      onRefresh: _refreshCart,
      child: child,
    );
  }

  Widget _refreshableBox(Widget child) {
    return _refreshable(
      SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.68,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final currentCart = state is CartLoaded ? state.cart : cartCubit.cart;
        if (currentCart != null) {
          final items = currentCart.items;
          if (items.isEmpty) {
            return _refreshableBox(const EmptyCartView());
          }
          return _refreshable(CartItemsView(cart: currentCart));
        }

        switch (state) {
          case CartLoginRequired():
            return _refreshableBox(
              LoginRequiredPlaceholder(
                icon: Icons.shopping_cart_outlined,
                title: AppLocalizations.of(context)!.loginRequiredForCartView,
                description: AppLocalizations.of(context)!.cartLoginPrompt,
              ),
            );
          case CartLoading():
            return _refreshableBox(
              SpinKitFadingCircle(
                color: theme.colorScheme.onTertiaryFixed,
                size: 40.r,
              ),
            );
          case CartFailure():
            return _refreshableBox(
              Center(
                child: Text(state.message.isEmpty ? l10n.error : state.message),
              ),
            );
          default:
            return _refreshableBox(
              SpinKitFadingCircle(
                color: theme.colorScheme.onTertiaryFixed,
                size: 40.r,
              ),
            );
        }
      },
    );
  }
}
