import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controllers/blocs/bloc/theme_bloc/theme_bloc_bloc.dart';
import 'package:kalivra/controllers/prefs/pref_keys.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';

/// Theme mode selection: Dark, Light, System (radio list).
class ThemeModeScreen extends StatelessWidget {
  const ThemeModeScreen({super.key});

  static String _modeToValue(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return PrefKeys.darkModeKey;
      case ThemeMode.light:
        return PrefKeys.lightModeKey;
      case ThemeMode.system:
        return PrefKeys.systemModeKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'المظهر'),
      body: BlocBuilder<ThemeBloc, ThemeBlocState>(
        builder: (context, state) {
          final currentMode = state is ThemeFetched ? state.mode : ThemeMode.system;
          final groupValue = _modeToValue(currentMode);

          return ListView(
            padding: EdgeInsets.all(20.w),
            children: [
              _ModeRadioTile(
                value: PrefKeys.darkModeKey,
                label: 'الوضع الليلي',
                subtitle: 'Dark mode',
                icon: Icons.dark_mode_rounded,
                groupValue: groupValue,
                onChanged: () => context.read<ThemeBloc>().add(SetDarkMode()),
              ),
              SizedBox(height: 12.h),
              _ModeRadioTile(
                value: PrefKeys.lightModeKey,
                label: 'الوضع النهاري',
                subtitle: 'Light mode',
                icon: Icons.light_mode_rounded,
                groupValue: groupValue,
                onChanged: () => context.read<ThemeBloc>().add(SetLightMode()),
              ),
              SizedBox(height: 12.h),
              _ModeRadioTile(
                value: PrefKeys.systemModeKey,
                label: 'نظام الجهاز',
                subtitle: 'System default',
                icon: Icons.settings_brightness_rounded,
                groupValue: groupValue,
                onChanged: () => context.read<ThemeBloc>().add(SetSystemMode()),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ModeRadioTile extends StatelessWidget {
  const _ModeRadioTile({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.groupValue,
    required this.onChanged,
  });

  final String value;
  final String label;
  final String subtitle;
  final IconData icon;
  final String groupValue;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = groupValue == value;
    final accentColor = isDark ? AppColors.goldLight : AppColors.burgundy;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: isSelected
            ? BorderSide(color: accentColor, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onChanged,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            children: [
              Radio<String>(
                value: value,
                activeColor: accentColor,
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) return accentColor;
                  return isDark ? AppColors.taupe : AppColors.burgundy.withValues(alpha: 0.5);
                }),
              ),
              Icon(icon, size: 24.r, color: isSelected ? accentColor : (isDark ? AppColors.taupe : AppColors.burgundy)),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDark ? AppColors.offWhite : AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle_rounded, color: accentColor, size: 24.r),
            ],
          ),
        ),
      ),
    );
  }
}
