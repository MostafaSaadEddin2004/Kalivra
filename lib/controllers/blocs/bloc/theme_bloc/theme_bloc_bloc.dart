import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kalivra/controllers/prefs/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_bloc_event.dart';
part 'theme_bloc_state.dart';

class ThemeBloc extends Bloc<ThemeBlocEvent, ThemeBlocState> {
  ThemeBloc() : super(ThemeFetched(mode: ThemeMode.system)) {
    on<GetThemeMode>((_, emit) async {
      final sp = await SharedPreferences.getInstance();
      final themeSP = sp.getString(PrefKeys.themeModeKey);
      final themeMode = _getThemeModeFromString(themeSP);
      emit(ThemeFetched(mode: themeMode));
    });

    on<SetDarkMode>((_, emit) async {
      final sp = await SharedPreferences.getInstance();
      sp.setString(PrefKeys.themeModeKey, PrefKeys.darkModeKey);
      emit(ThemeFetched(mode: ThemeMode.dark));
    });

    on<SetLightMode>((_, emit) async {
      final sp = await SharedPreferences.getInstance();
      await sp.setString(PrefKeys.themeModeKey, PrefKeys.lightModeKey);
      emit(ThemeFetched(mode: ThemeMode.light));
    });

    on<SetSystemMode>((_, emit) async {
      final sp = await SharedPreferences.getInstance();
      await sp.setString(PrefKeys.themeModeKey, PrefKeys.systemModeKey);
      emit(ThemeFetched(mode: ThemeMode.system));
    });
  }
  ThemeMode _getThemeModeFromString(String? themeString) =>
      switch (themeString) {
        PrefKeys.darkModeKey => ThemeMode.dark,
        PrefKeys.lightModeKey => ThemeMode.light,
        PrefKeys.systemModeKey => ThemeMode.system,
        _ => ThemeMode.system,
      };
}
