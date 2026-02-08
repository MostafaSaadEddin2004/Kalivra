import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.burgundy,
          primary: AppColors.burgundy,
          secondary: AppColors.goldLight,
          surface: AppColors.offWhite,
          onSurface: AppColors.black,
          onPrimary: AppColors.offWhite,
          brightness: Brightness.light,
        ),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.burgundy,
            foregroundColor: AppColors.offWhite,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.burgundy,
          primary: AppColors.burgundy,
          secondary: AppColors.goldLight,
          surface: AppColors.black,
          onSurface: AppColors.offWhite,
          onPrimary: AppColors.offWhite,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.burgundy,
          foregroundColor: AppColors.offWhite,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1A1918),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.burgundy,
            foregroundColor: AppColors.offWhite,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
}
