part of 'theme_bloc_bloc.dart';

@immutable
sealed class ThemeBlocEvent {}

final class GetThemeMode extends ThemeBlocEvent {}

final class SetDarkMode extends ThemeBlocEvent {}

final class SetLightMode extends ThemeBlocEvent {}

final class SetSystemMode extends ThemeBlocEvent {}
