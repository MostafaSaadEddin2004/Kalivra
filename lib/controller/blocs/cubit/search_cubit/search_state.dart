import 'package:kalivra/model/search/search_history_model.dart';
import 'package:kalivra/model/search/search_result_model.dart';

abstract class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchHistoryLoading extends SearchState {}

final class SearchHistoryLoaded extends SearchState {
  SearchHistoryLoaded({required this.history});

  final List<SearchHistoryModel> history;
}

final class SearchLoading extends SearchState {
  SearchLoading({required this.query});

  final String query;
}

final class SearchLoaded extends SearchState {
  SearchLoaded({required this.query, required this.result});

  final String query;
  final SearchResultModel result;
}

final class SearchFailed extends SearchState {
  SearchFailed({required this.message});

  final String message;
}
