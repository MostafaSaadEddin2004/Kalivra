import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/nav_cubit.dart';
import 'package:kalivra/models/nav_item_model.dart';
import 'package:kalivra/views/screens/home/cart_page.dart';
import 'package:kalivra/views/screens/home/categories_page.dart';
import 'package:kalivra/views/screens/home/home_page.dart';
import 'package:kalivra/views/screens/home/notifications_page.dart';
import 'package:kalivra/views/screens/home/search_page.dart';
import 'package:kalivra/views/widgets/nav/custom_nav_bar.dart';
import 'package:kalivra/views/widgets/app_drawer.dart';
import 'package:kalivra/views/widgets/custom_app_bar.dart';
import 'package:kalivra/views/widgets/search_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<NavItemModel> navItems = [
  NavItemModel(icon: Icons.home_rounded,index: 0,title: 'الرئيسية'),
  NavItemModel(icon: Icons.category_rounded,index: 1,title: 'التصنيفات'),
  NavItemModel(icon: Icons.shopping_cart_rounded,index: 2,title: 'السلة'),
  NavItemModel(icon: Icons.notifications_rounded,index: 3,title: 'الإشعارات'),
  NavItemModel(icon: Icons.search_rounded,index: 4,title: 'البحث'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(),
      child: BlocProvider(
        create: (_) => NavCubit(),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocBuilder<NavCubit, int>(
          builder: (context, index) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: index == NavCubit.search
                  ? SearchAppBar(
                      onChanged: (_) {},
                    )
                  : CustomAppBar(
                      title: navItems[index].title,
                      onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
              drawer: const AppDrawer(),
              body: IndexedStack(
                index: index,
                children: const [
                  HomePage(),
                  CategoriesPage(),
                  CartPage(),
                  NotificationsPage(),
                  SearchPage(),
                ],
              ),
              bottomNavigationBar: CustomNavBar(
                items: navItems,
                currentIndex: index,
                onTap: (i) => context.read<NavCubit>().goTo(i),
              ),
            );
          },
        ),
        ),
      ),
    );
  }
}