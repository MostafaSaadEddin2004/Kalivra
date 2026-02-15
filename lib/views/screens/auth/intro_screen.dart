import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/models/intro_page_model.dart';
import 'package:kalivra/views/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/views/widgets/slider_widgets/custom_indicator.dart';

/// Onboarding: 3-page PageView with indicator. What is app, what we offer, join us.
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<IntroPage> _pages = [
    IntroPage(
      title: 'ما هو كليفرا؟',
      description:
          'تطبيق كليفرا منصتك الموحدة لشراء مواد البناء والديكور. تصفح العلامات التجارية والمنتجات والعروض، واطلب ما تحتاجه بسهولة.',
      icon: Icons.storefront_rounded,
    ),
    IntroPage(
      title: 'ماذا نقدم؟',
      description:
          'تشكيلة واسعة من الدهانات والسيراميك والحديد والأدوات الصحية والكهربائيات. عروض دورية، توصيل سريع، وخدمة عملاء على مدار الساعة.',
      icon: Icons.construction_rounded,
    ),
    IntroPage(
      title: 'انضم إلينا',
      description:
          'سجّل الآن واحصل على تجربة تسوق مريحة. تتبع طلباتك، احفظ المفضلة، وادفع بكل أمان. نرحب بك في عائلة كليفرا.',
      icon: Icons.rocket_launch_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
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
                    itemCount: _pages.length,
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
    );
  }
}
