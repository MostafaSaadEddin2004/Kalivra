import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/nav_cubit/nav_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/notifications_cubit/notifications_cubit.dart';
import 'package:kalivra/models/nav_item_model.dart';
import 'package:kalivra/views/screens/home/categories_page.dart';
import 'package:kalivra/views/screens/home/home_page.dart';
import 'package:kalivra/views/screens/home/notifications_page.dart';
import 'package:kalivra/views/screens/home/search_page.dart';
import 'package:kalivra/views/widgets/nav/custom_nav_bar.dart';
import 'package:kalivra/views/widgets/drawer/app_drawer.dart';
import 'package:kalivra/views/widgets/custom_app_bar.dart';
import 'package:kalivra/views/widgets/search_app_bar.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<NavItemModel> _buildNavItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      NavItemModel(icon: Icons.home_rounded, index: 0, title: l10n.navHome),
      NavItemModel(icon: Icons.category_rounded, index: 1, title: l10n.navCategories),
      NavItemModel(icon: Icons.notifications_rounded, index: 2, title: l10n.navNotifications),
      NavItemModel(icon: Icons.search_rounded, index: 3, title: l10n.navSearch),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavCubit(),
      child: BlocBuilder<NavCubit, int>(
        builder: (context, index) {
          return Scaffold(
            key: _scaffoldKey,
            extendBody: true,
            appBar: index == NavCubit.search
                ? SearchAppBar(onChanged: (_) {})
                : CustomAppBar(
                    onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                    onCartTap: () => context.pushNamed('cart'),
                  ),
            drawer: const AppDrawer(),
            body: Padding(
              padding: EdgeInsets.only(bottom: 100.h),
              child: IndexedStack(
                index: index,
                children: const [
                  HomePage(),
                  CategoriesPage(),
                  NotificationsPage(),
                  SearchPage(),
                ],
              ),
            ),
            bottomNavigationBar: CustomNavBar(
              items: _buildNavItems(context),
              currentIndex: index,
              onTap: (i) {
              context.read<NavCubit>().goTo(i);
              if (i == NavCubit.notifications) {
                context.read<NotificationsCubit>().refresh();
              }
            },
            ),
          );
        },
      ),
    );
  }
}
