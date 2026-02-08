part of 'locale_bloc_bloc.dart';

@immutable
sealed class LocaleBlocState {}

final class LocaleFetched extends LocaleBlocState {
  final Locale locale;

  LocaleFetched({required this.locale});
}
