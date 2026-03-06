part of 'theme_bloc_bloc.dart';

@immutable
sealed class ThemeBlocState {}

final class ThemeFetched extends ThemeBlocState {
  final ThemeMode mode;

  ThemeFetched({required this.mode});
}
