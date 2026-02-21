part of 'locale_bloc_bloc.dart';

@immutable
sealed class LocaleBlocState {}

final class LocaleFetched extends LocaleBlocState {
  final Locale locale;
  final bool useSystemLocale;

  LocaleFetched({required this.locale, this.useSystemLocale = false});
}
