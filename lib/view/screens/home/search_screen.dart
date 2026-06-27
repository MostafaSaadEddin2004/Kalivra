import 'package:flutter/material.dart';
import 'package:kalivra/view/screens/home/search_page.dart';
import 'package:kalivra/view/widgets/search_app_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(onChanged: (_) {}),
      body: const SearchPage(),
    );
  }
}
