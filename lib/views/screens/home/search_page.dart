import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/views/widgets/cards/search_result_card.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
            child: Text(
              'اقتراحات سريعة',
              style: Theme.of(context).textTheme.titleMedium
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 1.2,
            ),
            delegate: SliverChildListDelegate([
              SearchResultCard(label: 'دهانات'),
              SearchResultCard(label: 'سيراميك'),
              SearchResultCard(label: 'أدوات صحية'),
              SearchResultCard(label: 'حديد'),
              SearchResultCard(label: 'كهربائيات'),
              SearchResultCard(label: 'ديكور'),
            ]),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'آخر البحث',
              style: Theme.of(context).textTheme.titleMedium
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            child: Text(
              'لم تبحث عن شيء بعد. اكتب في شريط البحث أعلاه.',
              style: Theme.of(context).textTheme.bodyMedium
            ),
          ),
        ),
      ],
    );
  }
}

