import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/search_cubit/search_state.dart';
import 'package:kalivra/model/services/api/search_api_service.dart';

export 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final SearchApiService _searchService = SearchApiService();
  int _requestId = 0;

  Future<void> loadHistory() async {
    final requestId = ++_requestId;
    emit(SearchHistoryLoading());
    try {
      final history = await _searchService.getSearchHistory();
      if (requestId != _requestId) {
        return;
      }
      emit(SearchHistoryLoaded(history: history));
    } catch (e) {
      if (requestId != _requestId) {
        return;
      }
      emit(SearchFailed(message: e.toString()));
    }
  }

  Future<void> search(String query) async {
    final trimmedQuery = query.trim();
    final requestId = ++_requestId;

    if (trimmedQuery.isEmpty) {
      await loadHistory();
      return;
    }

    emit(SearchLoading(query: trimmedQuery));
    try {
      final result = await _searchService.search(trimmedQuery);
      if (requestId != _requestId) {
        return;
      }
      emit(SearchLoaded(query: trimmedQuery, result: result));
    } catch (e) {
      if (requestId != _requestId) {
        return;
      }
      emit(SearchFailed(message: e.toString()));
    }
  }

  Future<void> submitSearch(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      await loadHistory();
      return;
    }
    await recordSearchHistory(trimmedQuery);
    await search(trimmedQuery);
  }

  Future<void> recordSearchHistory(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;
    try {
      await _searchService.postSearchHistory(trimmedQuery);
    } catch (_) {}
  }
}
