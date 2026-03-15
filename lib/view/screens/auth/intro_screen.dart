import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/pop_scope_exit_app.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/intro/intro_page_model.dart';
import 'package:kalivra/view/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/view/widgets/slider_widgets/custom_indicator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<IntroPage> _pages(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      IntroPage(
        title: l10n.introTitle1,
        description: l10n.introDesc1,
        icon: Icons.storefront_rounded,
      ),
      IntroPage(
        title: l10n.introTitle2,
        description: l10n.introDesc2,
        icon: Icons.construction_rounded,
      ),
      IntroPage(
        title: l10n.introTitle3,
        description: l10n.introDesc3,
        icon: Icons.rocket_launch_rounded,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() async{
    if (_currentPage < _pages(context).length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      context.go(AppRoutes.login);
      await LocalStore.setIntroPass('passed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pages = _pages(context);
    return PopScopeExitApp(
      child: Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140.w,
                          height: 140.w,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSecondaryFixed,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.secondary.withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 24.r,
                                offset: Offset(0, 8.h),
                              ),
                            ],
                          ),
                          child: Icon(
                            page.icon,
                            size: 64.r,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Text(
                          page.title,
                          style: theme.textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          page.description,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w,vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIndicator(
                    itemCount: pages.length,
                    currentPage: _currentPage,
                  ),
                  CustomIconButton(
                    onPressed: _onNext,
                    icon: Icons.arrow_forward_rounded,
                    backgroundColor: theme.colorScheme.onTertiaryFixed,
                    color: theme.colorScheme.secondaryFixed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}