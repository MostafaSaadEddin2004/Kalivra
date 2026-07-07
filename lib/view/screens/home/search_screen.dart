import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/search_cubit/search_cubit.dart';
import 'package:kalivra/view/screens/home/search_page.dart';
import 'package:kalivra/view/widgets/search_app_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: SearchAppBar(
              onChanged: (value) {
                context.read<SearchCubit>().search(value);
              },
              onSubmitted: (value) {
                context.read<SearchCubit>().search(value);
              },
            ),
            body: const SearchPage(),
          );
        },
      ),
    );
  }
}
