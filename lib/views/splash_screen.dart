import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), _goToNext);
  }

  void _goToNext() {
    if (!mounted) return;
    context.go(AppRoutes.intro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/logo_splash.png',
                    fit: BoxFit.contain,
                    width: 220.w,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildFallbackLogo(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackLogo(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'K',
          style: TextStyle(
            fontSize: 72.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.secondary,
            height: 1,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Kalivra',
          style: TextStyle(
            fontSize: 28.sp,
            letterSpacing: 2,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
