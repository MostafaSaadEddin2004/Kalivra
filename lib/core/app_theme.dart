import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Kalivra brand colors from the branding guide.
/// #0A0908 Black, #49111C Burgundy, #F2F4F3 Off-white, #A9927D Taupe, Gold accent.
class AppColors {
  AppColors._();

  static const Color black = Color(0xFF0A0908);
  static const Color burgundy = Color(0xFF49111C);
  static const Color offWhite = Color(0xFFF2F4F3);
  static const Color taupe = Color(0xFFA9927D);
  static const Color goldLight = Color(0xFFD4AF37);
  static const Color goldDark = Color(0xFFA67C00);
  static const Color lightGray = Color(0xFFC0C0C0);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.burgundy,
      secondary: AppColors.black,
      onPrimary: AppColors.taupe,
      onSecondary: AppColors.goldDark,
      surface: AppColors.offWhite,
      onSurface: AppColors.lightGray,
      tertiary: AppColors.goldLight,
      onTertiary: AppColors.burgundy,
      onPrimaryFixed: AppColors.offWhite,
      onSecondaryFixed: AppColors.burgundy.withValues(alpha: 0.12),
      brightness: Brightness.light,
    ),
    textTheme: _lightTextTheme,
    scaffoldBackgroundColor: AppColors.offWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.burgundy,
      foregroundColor: AppColors.offWhite,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.burgundy,
        foregroundColor: AppColors.offWhite,
        textStyle: _lightTextTheme.labelLarge,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.burgundy),
        foregroundColor:  WidgetStatePropertyAll(AppColors.offWhite),
         iconSize: WidgetStatePropertyAll(20.r)
      )
    )
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: AppColors.black,
      secondary: AppColors.burgundy,
      onPrimary: AppColors.goldDark,
      onSecondary: AppColors.taupe,
      surface: AppColors.offWhite,
      onSurface: AppColors.lightGray,
      tertiary: AppColors.goldLight,
      onTertiary: AppColors.offWhite,
      onPrimaryFixed: AppColors.burgundy,
      onSecondaryFixed: AppColors.taupe,
      brightness: Brightness.dark,
    ),
    textTheme: _darkTextTheme,
    scaffoldBackgroundColor: AppColors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.black,
      foregroundColor: AppColors.offWhite,
      elevation: 1,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1A1918),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.burgundy,
        foregroundColor: AppColors.offWhite,
        textStyle: _darkTextTheme.labelLarge,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    ),filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.taupe),
        foregroundColor:  WidgetStatePropertyAll(AppColors.black),
         iconSize: WidgetStatePropertyAll(20.r)
      )
    )
  );

  static TextTheme get _lightTextTheme => TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.offWhite,
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.burgundy,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.burgundy,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppColors.burgundy,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppColors.burgundy,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: AppColors.burgundy,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: AppColors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: AppColors.black,
          fontSize: 12.sp,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: AppColors.offWhite,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: AppColors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: AppColors.burgundy,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      );

  /// Dark theme: titles in offWhite/taupe, body in offWhite, button text in offWhite.
  static TextTheme get _darkTextTheme => TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.offWhite,
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.offWhite,
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.offWhite,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppColors.taupe,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppColors.taupe,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: AppColors.taupe,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.offWhite,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: AppColors.offWhite,
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: AppColors.taupe,
          fontSize: 12.sp,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: AppColors.offWhite,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: AppColors.offWhite,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: AppColors.taupe,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      );
}
