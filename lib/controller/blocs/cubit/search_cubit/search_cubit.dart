import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/search_cubit/search_state.dart';
import 'package:kalivra/model/services/api/search_api_service.dart';

export 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  final SearchApiService _searchService = SearchApiService();
  int _requestId = 0;

  Future<void> search(String query) async {
    final trimmedQuery = query.trim();
    final requestId = ++_requestId;

    if (trimmedQuery.isEmpty) {
      emit(SearchInitial());
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
}
