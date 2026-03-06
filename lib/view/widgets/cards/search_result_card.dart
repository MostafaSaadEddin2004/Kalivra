import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12.r),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium
          ),
        ),
      ),
    );
  }
}
