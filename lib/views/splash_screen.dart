import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/views/screens/home/home_screen.dart';

/// Native-feel splash screen: Kalivra logo on black, then navigate to home.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), _goToHome);
  }

  void _goToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
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
              Padding(
                padding: EdgeInsets.only(bottom: 48.h),
                child: SizedBox(
                  width: 28.w,
                  height: 28.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.secondary),
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
