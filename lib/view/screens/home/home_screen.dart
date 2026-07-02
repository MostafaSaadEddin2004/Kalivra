import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/nav_cubit/nav_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/pop_scope_exit_app.dart';
import 'package:kalivra/model/nav/nav_item_model.dart';
import 'package:kalivra/view/screens/home/cart_page.dart';
import 'package:kalivra/view/screens/home/categories_page.dart';
import 'package:kalivra/view/screens/home/home_page.dart';
import 'package:kalivra/view/widgets/nav/custom_nav_bar.dart';
import 'package:kalivra/view/screens/home/profile_page.dart';
import 'package:kalivra/view/widgets/custom_app_bar.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    List<NavItemModel> navItems = [
      NavItemModel(icon: Icons.home_rounded, index: 0, title: l10n.navHome),
      NavItemModel(
        icon: Icons.category_rounded,
        index: 1,
        title: l10n.navCategories,
      ),
      NavItemModel(
        icon: Icons.shopping_cart_rounded,
        index: NavCubit.cart,
        title: l10n.cart,
      ),
      NavItemModel(
        icon: Icons.person_rounded,
        index: NavCubit.profile,
        title: l10n.drawerMyAccount,
      ),
    ];
    return PopScopeExitApp(
      child: BlocProvider(
        create: (_) => NavCubit(),
        child: BlocBuilder<NavCubit, int>(
          builder: (context, index) {
            return Scaffold(
              extendBody: true,
              appBar: CustomAppBar(
                onSearchTap: () => context.push(AppRoutes.search),
                onNotificationsTap: () => context.push(AppRoutes.notifications),
              ),
              body: IndexedStack(sizing: StackFit.passthrough,clipBehavior: Clip.none,
                index: index,
                children: [
                  const HomePage(),
                  const CategoriesPage(),
                  const CartPage(),
                  const ProfilePage(),
                ],
              ),
              bottomNavigationBar: SafeArea(
                top: false,
                maintainBottomViewPadding: true,
                child: CustomNavBar(
                  items: navItems,
                  currentIndex: index,
                  onTap: (i) {
                    context.read<NavCubit>().goTo(i);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
