import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class AssociationFaqScreen extends StatefulWidget {
  const AssociationFaqScreen({super.key});

  @override
  State<AssociationFaqScreen> createState() => _AssociationFaqScreenState();
}

class _AssociationFaqScreenState extends State<AssociationFaqScreen> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final faqs = [
      (
        question: 'ماذا يجب علي ان افعل اذا اردت ان اكون عضوا في الجمعية؟',
        answer: 'ماذا يجب علي ان افعل اذا اردت ان اكون عضوا في الجمعية؟',
      ),
      (
        question: 'ماذا يجب علي ان افعل اذا اردت ان اكون عضوا في الجمعية؟',
        answer: 'ماذا يجب علي ان افعل اذا اردت ان اكون عضوا في الجمعية؟',
      ),
      (
        question: 'ماذا يجب علي ان افعل اذا اردت ان اكون عضوا في الجمعية؟',
        answer: 'ماذا يجب علي ان افعل اذا اردت ان اكون عضوا في الجمعية؟',
      ),
      (
        question: 'ماذا يجب علي ان افعل اذا اردت ان اكون عضوا في الجمعية؟',
        answer: 'ماذا يجب علي ان افعل اذا اردت ان اكون عضوا في الجمعية؟',
      ),
      (
        question: 'ماذا يجب علي ان افعل اذا اردت ان اكون عضوا في الجمعية؟',
        answer: 'ماذا يجب علي ان افعل اذا اردت ان اكون عضوا في الجمعية؟',
      ),
    ];

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.frequentlyAskedQuestion),
      body: ListView.separated(
        clipBehavior: Clip.none,
        padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 32.h),
        itemCount: faqs.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final faq = faqs[index];
          final isExpanded = _expandedIndex == index;
          return Padding(
            padding: EdgeInsets.all(2.r),
            child: AnimatedCrossFade(
              firstChild: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryFixed,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: theme.colorScheme.primaryFixed.withValues(
                      alpha: 0.26,
                    ),
                  ),        
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _expandedIndex = isExpanded ? null : index;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 260.w,
                        child: Text(
                          faq.question,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? AppColors.goldLight
                                : AppColors.burgundy,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color:isDark
                                ? AppColors.goldLight
                                : AppColors.burgundy,
                      ),
                    ],
                  ),
                ),
              ),
              secondChild: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryFixed,
                  borderRadius: BorderRadius.circular(16.r),
                   border: Border.all(
                    color: theme.colorScheme.primaryFixed.withValues(
                      alpha: 0.26,
                    ),
                  ),      
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _expandedIndex = isExpanded ? null : index;
                    });
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 260.w,
                            child: Text(
                              faq.answer,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.goldLight
                                    : AppColors.burgundy,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: isDark
                                ? AppColors.goldLight
                                : AppColors.burgundy,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          faq.answer,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.55,
                            color: isDark
                                ? AppColors.goldLight.withValues(
                              alpha: 0.78)
                                : AppColors.burgundy.withValues(
                              alpha: 0.78,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 400),
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeInToLinear,
            ),
          );
        },
      ),
    );
  }
}
