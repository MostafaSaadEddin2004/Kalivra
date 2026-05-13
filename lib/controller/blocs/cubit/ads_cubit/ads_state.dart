part of 'ads_cubit.dart';

@immutable
sealed class AdsState {}

final class AdsLoading extends AdsState {}

final class AdsFetched extends AdsState {
  final List<AdsModel> ads;

  AdsFetched({required this.ads});
}

final class AdsFailed extends AdsState {
  final String errorMessage;

  AdsFailed({required this.errorMessage});
}
