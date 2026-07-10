import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/view/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/view/widgets/cart/cart_items_view.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/cart/empty_cart_view.dart';
import 'package:kalivra/view/widgets/login_required_placeholder.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
        if (state is CartLoginRequired) {
          return Scaffold(
            appBar: _CartAppBar(title: AppLocalizations.of(context)!.cart),
            body: LoginRequiredPlaceholder(
              icon: Icons.shopping_cart_outlined,
              title: AppLocalizations.of(context)!.loginRequiredForCartView,
              description: AppLocalizations.of(context)!.cartLoginPrompt,
              onLoginTap: () => context.push(AppRoutes.login),
            ),
          );
        }

        if (state is CartLoading && cartCubit.items.isEmpty) {
          return Scaffold(
            appBar: _CartAppBar(title: AppLocalizations.of(context)!.cart),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final items = cartCubit.items;
        return Scaffold(
          appBar: _CartAppBar(title: AppLocalizations.of(context)!.cart),
          body: items.isEmpty
              ? const EmptyCartView()
              : CartItemsView(items: items),
        );
      },
    );
  }
}

class _CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CartAppBar({required this.title});

  final String title;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leading: CustomIconButton(
        icon: Icons.arrow_back_rounded,
        color:
            Theme.of(context).appBarTheme.foregroundColor ?? AppColors.offWhite,
        iconSize: 28.r,
        onPressed: () => context.pop(),
        tooltip: AppLocalizations.of(context)!.back,
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
