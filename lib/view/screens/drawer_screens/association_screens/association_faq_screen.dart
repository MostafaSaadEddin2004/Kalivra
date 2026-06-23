import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';

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
      appBar: DrawerScreenAppBar(title: l10n.frequentlyAskedQuestion),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 32.h),
        itemCount: faqs.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final faq = faqs[index];
          final isExpanded = _expandedIndex == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isExpanded
                    ? [
                        AppColors.burgundy.withValues(
                          alpha: isDark ? 0.55 : 0.12,
                        ),
                        AppColors.goldDark.withValues(
                          alpha: isDark ? 0.22 : 0.1,
                        ),
                      ]
                    : [theme.cardColor, theme.cardColor],
              ),
              border: Border.all(
                color: isExpanded
                    ? AppColors.goldDark.withValues(alpha: 0.45)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: ExpansionTile(
                key: PageStorageKey(index),
                initiallyExpanded: isExpanded,
                onExpansionChanged: (expanded) {
                  setState(() => _expandedIndex = expanded ? index : null);
                },
                tilePadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 4.h,
                ),
                childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                trailing: AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: isExpanded
                        ? AppColors.goldDark
                        : theme.iconTheme.color,
                  ),
                ),
                title: Text(
                  faq.question,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isExpanded
                        ? (isDark ? AppColors.goldLight : AppColors.burgundy)
                        : null,
                  ),
                ),
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      faq.answer,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.55,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.78,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
