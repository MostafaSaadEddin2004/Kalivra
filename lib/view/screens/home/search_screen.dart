import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/search_cubit/search_cubit.dart';
import 'package:kalivra/view/screens/home/search_page.dart';
import 'package:kalivra/view/widgets/search_app_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit()..loadHistory(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: SearchAppBar(
              controller: _searchController,
              onChanged: (value) {
                context.read<SearchCubit>().search(value);
              },
              onSubmitted: (value) {
                context.read<SearchCubit>().submitSearch(value);
              },
            ),
            body: SearchPage(
              onHistorySelected: (query) {
                _searchController.text = query;
                _searchController.selection = TextSelection.collapsed(
                  offset: query.length,
                );
                context.read<SearchCubit>().search(query);
              },
            ),
          );
        },
      ),
    );
  }
}
