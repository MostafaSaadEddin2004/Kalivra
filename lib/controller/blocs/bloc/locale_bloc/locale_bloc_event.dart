part of 'locale_bloc_bloc.dart';

@immutable
sealed class LocaleBlocEvent {}
final class GetLocale extends LocaleBlocEvent {}
final class SetArabicLocale extends LocaleBlocEvent {}
final class SetEnglishLocale extends LocaleBlocEvent {}
final class SetSystemLocale extends LocaleBlocEvent {}