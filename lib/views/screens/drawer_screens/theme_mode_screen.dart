import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controllers/blocs/bloc/theme_bloc/theme_bloc_bloc.dart';
import 'package:kalivra/controllers/prefs/pref_keys.dart';
import 'package:kalivra/models/theme_mode_model.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:kalivra/views/widgets/selectable_card.dart';

/// Theme mode selection: Dark, Light, System.
class ThemeModeScreen extends StatelessWidget {
  const ThemeModeScreen({super.key});

  static const List<ThemeModeModel> _themeModes = [
    ThemeModeModel(
      label: 'الوضع الليلي',
      subtitle: 'Dark mode',
      icon: Icons.dark_mode_rounded,
      index: 0,
      prefValue: PrefKeys.darkModeKey,
    ),
    ThemeModeModel(
      label: 'الوضع النهاري',
      subtitle: 'Light mode',
      icon: Icons.light_mode_rounded,
      index: 1,
      prefValue: PrefKeys.lightModeKey,
    ),
    ThemeModeModel(
      label: 'نظام الجهاز',
      subtitle: 'System default',
      icon: Icons.settings_brightness_rounded,
      index: 2,
      prefValue: PrefKeys.systemModeKey,
    ),
  ];

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

  static void _applyThemeByIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.read<ThemeBloc>().add(SetDarkMode());
        break;
      case 1:
        context.read<ThemeBloc>().add(SetLightMode());
        break;
      case 2:
        context.read<ThemeBloc>().add(SetSystemMode());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'المظهر'),
      body: BlocBuilder<ThemeBloc, ThemeBlocState>(
        builder: (context, state) {
          final currentMode = state is ThemeFetched ? state.mode : ThemeMode.system;
          final currentValue = _modeToValue(currentMode);
          return ListView(
            padding: EdgeInsets.all(16.w),
            children: List.generate(_themeModes.length, (index) {
              final model = _themeModes[index];
              final isSelected = model.prefValue == currentValue;
              return SelectableCard(
                label: model.label,
                subtitle: model.subtitle,
                icon: model.icon,
                isSelected: isSelected,
                onTap: () => _applyThemeByIndex(context, model.index),
              );
            }),
          );
        },
      ),
    );
  }
}
