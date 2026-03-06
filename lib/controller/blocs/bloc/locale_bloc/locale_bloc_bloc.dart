import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:kalivra/controller/prefs/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'locale_bloc_event.dart';
part 'locale_bloc_state.dart';

class LocaleBloc extends Bloc<LocaleBlocEvent, LocaleBlocState> {
  LocaleBloc() : super(LocaleFetched(locale: _getSystemLocale(), useSystemLocale: true)) {
    on<GetLocale>((_, emit) async {
      final sp = await SharedPreferences.getInstance();
      final localeSP = sp.getString(PrefKeys.localeKey);
      final useSystem = localeSP == null || localeSP.isEmpty || localeSP == PrefKeys.systemLocaleKey;
      final locale = _getLocaleFromString(localeSP);
      emit(LocaleFetched(locale: locale, useSystemLocale: useSystem));
    });
    on<SetArabicLocale>((_, emit) async {
      final sp = await SharedPreferences.getInstance();
      sp.setString(PrefKeys.localeKey, PrefKeys.arLocaleKey);
      emit(LocaleFetched(locale: const Locale(PrefKeys.arLocaleKey), useSystemLocale: false));
    });
    on<SetEnglishLocale>((_, emit) async {
      final sp = await SharedPreferences.getInstance();
      sp.setString(PrefKeys.localeKey, PrefKeys.enLocaleKey);
      emit(LocaleFetched(locale: const Locale(PrefKeys.enLocaleKey), useSystemLocale: false));
    });
    on<SetSystemLocale>((_, emit) async {
      final sp = await SharedPreferences.getInstance();
      sp.setString(PrefKeys.localeKey, PrefKeys.systemLocaleKey);
      emit(LocaleFetched(locale: _getSystemLocale(), useSystemLocale: true));
    });
  }

  static Locale _getSystemLocale() {
    return localeFromSystem(PlatformDispatcher.instance.locale);
  }

  static Locale localeFromSystem(Locale systemLocale) {
    if (systemLocale.languageCode == PrefKeys.arLocaleKey) {
      return const Locale(PrefKeys.arLocaleKey);
    }
    return const Locale(PrefKeys.enLocaleKey);
  }

  Locale _getLocaleFromString(String? locale) {
    if (locale == null || locale.isEmpty || locale == PrefKeys.systemLocaleKey) {
      return _getSystemLocale();
    }
    return switch (locale) {
      PrefKeys.arLocaleKey => const Locale(PrefKeys.arLocaleKey),
      PrefKeys.enLocaleKey => const Locale(PrefKeys.enLocaleKey),
      _ => _getSystemLocale(),
    };
  }
}
