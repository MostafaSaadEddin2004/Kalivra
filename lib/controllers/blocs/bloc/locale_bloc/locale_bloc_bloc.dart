import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:kalivra/controllers/prefs/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'locale_bloc_event.dart';
part 'locale_bloc_state.dart';

class LocaleBloc extends Bloc<LocaleBlocEvent, LocaleBlocState> {
  LocaleBloc() : super(LocaleFetched(locale: Locale('ar'))) {
    on<GetLocale>((_, emit) async {
      final sp = await SharedPreferences.getInstance();
      final localeSP = sp.getString(PrefKeys.localeKey);
      final locale = _getLocaleFromString(localeSP);
      emit(LocaleFetched(locale: locale));
    });
    on<SetArabicLocale>((_, emit) async {
      final sp = await SharedPreferences.getInstance();
      sp.setString(PrefKeys.localeKey, PrefKeys.arLocaleKey);
      emit(LocaleFetched(locale: Locale(PrefKeys.arLocaleKey)));
    });
    on<SetEnglishLocale>((_, emit) async {
      final sp = await SharedPreferences.getInstance();
      sp.setString(PrefKeys.localeKey, PrefKeys.enLocaleKey);
      emit(LocaleFetched(locale: Locale(PrefKeys.enLocaleKey)));
    });
  }
  Locale _getLocaleFromString(String? locale) => switch (locale) {
    PrefKeys.arLocaleKey => Locale(PrefKeys.arLocaleKey),
    PrefKeys.enLocaleKey => Locale(PrefKeys.enLocaleKey),
    _ => Locale(PrefKeys.arLocaleKey),
  };
}
