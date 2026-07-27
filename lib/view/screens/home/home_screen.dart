import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/nav_cubit/nav_cubit.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/network/api_exception.dart';
import 'package:kalivra/core/pop_scope_exit_app.dart';
import 'package:kalivra/model/category/category_api_model.dart';
import 'package:kalivra/model/nav/nav_item_model.dart';
import 'package:kalivra/model/services/api/customer_api_service.dart';
import 'package:kalivra/view/screens/home/cart_page.dart';
import 'package:kalivra/view/screens/home/categories_page.dart';
import 'package:kalivra/view/screens/home/home_page.dart';
import 'package:kalivra/view/widgets/nav/custom_nav_bar.dart';
import 'package:kalivra/view/screens/home/profile_page.dart';
import 'package:kalivra/view/widgets/custom_app_bar.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialCategory});

  final CategoryApiModel? initialCategory;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CustomerApiService _customerApiService = CustomerApiService();
  bool _didCheckAuthSession = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthSession();
    });
  }

  Future<void> _checkAuthSession() async {
    if (_didCheckAuthSession || !mounted) return;
    _didCheckAuthSession = true;

    final token = await LocalStore.getToken();
    if (!mounted || token == null || token.isEmpty) return;

    try {
      await _customerApiService.getProfile();
    } catch (e) {
      if (!mounted) return;
      final apiError = e is ApiException ? e : null;
      if (apiError == null || !apiError.requiresForcedLogin) {
        return;
      }

      await LocalStore.removeToken();
      await LocalStore.removeUserId();
      if (!mounted) return;
      await _showForcedLoginDialog(apiError.message);
    }
  }

  Future<void> _showForcedLoginDialog(String message) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(l10n.loginRequiredTitle),
            content: Text(message),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                  if (mounted) {
                    context.go(AppRoutes.login);
                  }
                },
                child: Text(l10n.login),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    List<NavItemModel> navItems = [
      NavItemModel(
        icon: Icons.home_rounded,
        index: NavCubit.home,
        title: l10n.navHome,
      ),
      NavItemModel(
        icon: Icons.category_rounded,
        index: NavCubit.categories,
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
        create: (_) => NavCubit(
          initialIndex: widget.initialCategory == null
              ? NavCubit.home
              : NavCubit.categories,
        ),
        child: BlocBuilder<NavCubit, int>(
          builder: (context, index) {
            return Scaffold(
              extendBody: true,
              appBar: CustomAppBar(
                onSearchTap: () => context.push(AppRoutes.search),
                onNotificationsTap: () => context.push(AppRoutes.notifications),
              ),
              body: IndexedStack(
                sizing: StackFit.passthrough,
                clipBehavior: Clip.none,
                index: index,
                children: [
                  const HomePage(),
                  CategoriesPage(initialCategory: widget.initialCategory),
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
