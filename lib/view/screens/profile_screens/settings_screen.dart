import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/bloc/locale_bloc/locale_bloc_bloc.dart';
import 'package:kalivra/controller/blocs/bloc/theme_bloc/theme_bloc_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/notification_preferences_cubit/notification_preferences_cubit.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/controller/prefs/pref_keys.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/screens/profile_screens/change_password_screen.dart';
import 'package:kalivra/view/widgets/confirm_dialog.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import '../../widgets/profile_page/screen_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _openProtectedScreen(
    BuildContext context,
    VoidCallback onAuthenticated,
  ) async {
    final token = await LocalStore.getToken();
    if (token != null && token.isNotEmpty) {
      onAuthenticated();
      return;
    }

    if (!context.mounted) return;

    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        title: l10n.loginRequiredTitle,
        message: l10n.settingsLoginRequiredDescription,
        onConfirm: () {
          dialogContext.pop();
          context.go(AppRoutes.login);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleBlocState>(
      builder: (context, localeState) {
        final l10n = AppLocalizations.of(context)!;
        final localeLabel = localeState is LocaleFetched
            ? (localeState.useSystemLocale
                  ? l10n.languageFollowSystem
                  : (localeState.locale.languageCode == PrefKeys.arLocaleKey
                        ? l10n.languageArabic
                        : l10n.languageEnglish))
            : l10n.languageFollowSystem;

        return Scaffold(
          appBar: ScreenAppBar(title: l10n.settingsTitle),
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
                  _SettingsTile(
                    icon: Icons.language_rounded,
                    label: l10n.settingsLanguage,
                    subtitle: localeLabel,
                    onTap: () => context.push(AppRoutes.language),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              BlocBuilder<AuthCubit, AuthState>(
                bloc: AuthCubit()..loadProfile(context),
                builder: (context, state) {
                  switch (state) {
                    case UnAuthinticated():
                      return const SizedBox.shrink();
                    default:
                      final accountEmail = state is AuthFetchedData
                          ? state.customer.email?.trim()
                          : null;
                      final hasAccount =
                          accountEmail != null && accountEmail.isNotEmpty;
                      return Column(
                        children: [
                          _buildNotificationSection(context),
                          SizedBox(height: 16.h),
                          _SettingsSection(
                            title: l10n.settingsAccountSecurity,
                            children: [
                              _SettingsTile(
                                icon: Icons.lock_outline_rounded,
                                label: l10n.settingsChangePassword,
                                onTap: () => _openProtectedScreen(
                                  context,
                                  () => context.push(AppRoutes.changePassword),
                                ),
                              ),
                              _SettingsTile(
                                icon: Icons.phone_android_rounded,
                                label: l10n.settingsChangePhone,
                                onTap: () => _openProtectedScreen(
                                  context,
                                  () => context.push(
                                    AppRoutes.otp,
                                    extra: OtpScreenMode.changePhone,
                                  ),
                                ),
                              ),
                              _SettingsTile(
                                icon: Icons.alternate_email_rounded,
                                label: hasAccount
                                    ? l10n.settingsChangeAccount
                                    : l10n.settingsAddAccount,
                                subtitle: hasAccount ? accountEmail : null,
                                onTap: () => _openProtectedScreen(
                                  context,
                                  () => context.push(
                                    AppRoutes.accountEmail,
                                    extra: accountEmail,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                  }
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => NotificationPreferencesCubit(),
      child:
          BlocConsumer<
            NotificationPreferencesCubit,
            NotificationPreferencesState
          >(
            listenWhen: (previous, current) =>
                previous.errorMessage != current.errorMessage,
            listener: (context, state) {
              if (state.errorMessage.isNotEmpty) {
                CustomSnackBar.show(context, state.errorMessage);
              }
            },
            builder: (context, state) {
              return _SettingsSection(
                title: l10n.notificationPreferencesSectionTitle,
                children: [
                  _SettingsTile(
                    icon: Icons.tune_rounded,
                    label: l10n.notificationPreferencesChannelsTitle,
                    subtitle: l10n.notificationPreferencesChannelsSubtitle,
                    onTap: () => _openProtectedScreen(
                      context,
                      () => context.push(AppRoutes.notificationPreferences),
                    ),
                  ),
                ],
              );
            },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.h, right: 4.w),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onTertiaryFixed,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
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
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Icon(icon, size: 24.r, color: theme.colorScheme.onTertiaryFixed),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primaryFixed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onTertiaryFixed,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.chevron_right_rounded,
              size: 24.r,
              color: theme.colorScheme.onTertiaryFixed,
            ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: content,
      );
    }
    return content;
  }
}
