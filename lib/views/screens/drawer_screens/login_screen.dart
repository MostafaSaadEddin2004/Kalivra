import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import '../../widgets/drawer/drawer_screen_app_bar.dart';

/// Login / Register: email, password, and actions.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'تسجيل الدخول'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h),
            Text(
              'مرحباً بعودتك',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isDark ? AppColors.offWhite : AppColors.burgundy,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'سجّل دخولك لمتابعة طلباتك والمفضلة',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.taupe : AppColors.black,
              ),
            ),
            SizedBox(height: 28.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني',
                prefixIcon: Icon(Icons.email_outlined, size: 22.r),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                filled: true,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                prefixIcon: Icon(Icons.lock_outline_rounded, size: 22.r),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                filled: true,
              ),
              obscureText: true,
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyle(
                    color: isDark ? AppColors.goldLight : AppColors.burgundy,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تسجيل الدخول'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                minimumSize: Size(double.infinity, 52.h),
              ),
              child: const Text('تسجيل الدخول'),
            ),
            SizedBox(height: 16.h),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                side: BorderSide(
                  color: isDark ? AppColors.taupe : AppColors.burgundy,
                ),
              ),
              child: Text(
                'إنشاء حساب جديد',
                style: TextStyle(
                  color: isDark ? AppColors.taupe : AppColors.burgundy,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
