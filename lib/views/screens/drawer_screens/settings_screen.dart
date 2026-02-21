import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/bloc/locale_bloc/locale_bloc_bloc.dart';
import 'package:kalivra/controllers/blocs/bloc/theme_bloc/theme_bloc_bloc.dart';
import 'package:kalivra/controllers/prefs/pref_keys.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/views/screens/drawer_screens/change_password_screen.dart';
import '../../widgets/drawer/drawer_screen_app_bar.dart';

/// Settings: theme, language, account & security.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: DrawerScreenAppBar(title: l10n.settingsTitle),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          _SettingsSection(
            title: l10n.settingsAppearance,
            children: [
              BlocBuilder<ThemeBloc, ThemeBlocState>(
                buildWhen: (prev, curr) => prev != curr,
                builder: (context, state) {
                  final modeLabel = state is ThemeFetched
                      ? (state.mode == ThemeMode.dark
                          ? l10n.themeDark
                          : state.mode == ThemeMode.light
                              ? l10n.themeLight
                              : l10n.themeSystem)
                      : l10n.themeSystem;
                  return _SettingsTile(
                    icon: Icons.dark_mode_rounded,
                    label: l10n.settingsAppearance,
                    subtitle: modeLabel,
                    onTap: () => context.push(AppRoutes.themeMode),
                  );
                },
              ),
              BlocBuilder<LocaleBloc, LocaleBlocState>(
                builder: (context, state) {
                  final localeLabel = state is LocaleFetched
                      ? (state.useSystemLocale
                          ? l10n.languageFollowSystem
                          : (state.locale.languageCode == PrefKeys.arLocaleKey
                              ? l10n.languageArabic
                              : l10n.languageEnglish))
                      : l10n.languageFollowSystem;
                  return _SettingsTile(
                    icon: Icons.language_rounded,
                    label: l10n.settingsLanguage,
                    subtitle: localeLabel,
                    onTap: () => context.push(AppRoutes.language),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _SettingsSection(
            title: l10n.settingsAccountSecurity,
            children: [
              _SettingsTile(
                icon: Icons.lock_outline_rounded,
                label: l10n.settingsChangePassword,
                onTap: () => context.push(AppRoutes.changePassword),
              ),
              _SettingsTile(
                icon: Icons.phone_android_rounded,
                label: l10n.settingsChangePhone,
                onTap: () => context.push(
                  AppRoutes.otp,
                  extra: OtpScreenMode.changePhone,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.h, right: 4.w),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.goldLight : AppColors.burgundy,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.offWhite : AppColors.black;
    final iconColor = isDark ? AppColors.goldLight : AppColors.burgundy;

    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Icon(icon, size: 24.r, color: iconColor),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.taupe : AppColors.burgundy,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ?trailing,
          if (trailing == null && onTap != null)
            Icon(
              Icons.chevron_left_rounded,
              size: 24.r,
              color: isDark ? AppColors.taupe : AppColors.burgundy,
            ),
        ],
      ),
    );

    if (onTap != null && trailing == null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: content,
      );
    }
    return content;
  }
}
