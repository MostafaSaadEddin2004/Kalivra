import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';

/// Onboarding: 3-page PageView with indicator. What is app, what we offer, join us.
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_IntroPage> _pages = [
    _IntroPage(
      title: 'ما هو كليفرا؟',
      description:
          'تطبيق كليفرا منصتك الموحدة لشراء مواد البناء والديكور. تصفح العلامات التجارية والمنتجات والعروض، واطلب ما تحتاجه بسهولة.',
      icon: Icons.storefront_rounded,
    ),
    _IntroPage(
      title: 'ماذا نقدم؟',
      description:
          'تشكيلة واسعة من الدهانات والسيراميك والحديد والأدوات الصحية والكهربائيات. عروض دورية، توصيل سريع، وخدمة عملاء على مدار الساعة.',
      icon: Icons.construction_rounded,
    ),
    _IntroPage(
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

  void _onNextOrGetStarted() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final surfaceColor = isDark
        ? AppColors.burgundy.withValues(alpha: 0.2)
        : AppColors.burgundy.withValues(alpha: 0.08);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
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
                            color: surfaceColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.2),
                                blurRadius: 24.r,
                                offset: Offset(0, 8.h),
                              ),
                            ],
                          ),
                          child: Icon(
                            page.icon,
                            size: 64.r,
                            color: primary,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Text(
                          page.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: isDark ? AppColors.offWhite : AppColors.burgundy,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          page.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isDark ? AppColors.taupe : AppColors.black,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: _currentPage == index ? 24.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? primary
                        : (isDark ? AppColors.taupe : AppColors.lightGray)
                            .withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _onNextOrGetStarted,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'التالي' : 'ابدأ',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.offWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _IntroPage {
  const _IntroPage({
    required this.title,
    required this.description,
    required this.icon,
  });
  final String title;
  final String description;
  final IconData icon;
}
