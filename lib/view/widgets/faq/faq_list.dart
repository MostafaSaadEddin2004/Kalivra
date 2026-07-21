import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/model/app_info/faq_item_model.dart';

class FaqList extends StatefulWidget {
  const FaqList({super.key, required this.faqs});

  final List<FaqItemModel> faqs;

  @override
  State<FaqList> createState() => _FaqListState();
}

class _FaqListState extends State<FaqList> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      clipBehavior: Clip.none,
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 32.h),
      itemCount: widget.faqs.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final faq = widget.faqs[index];
        final isExpanded = _expandedIndex == index;
        return Padding(
          padding: EdgeInsets.all(2.r),
          child: FaqAnimatedCrossFadeItem(
            faq: faq,
            isExpanded: isExpanded,
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
          ),
        );
      },
    );
  }
}

class FaqAnimatedCrossFadeItem extends StatelessWidget {
  const FaqAnimatedCrossFadeItem({
    super.key,
    required this.faq,
    required this.isExpanded,
    required this.onTap,
  });

  final FaqItemModel faq;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.goldLight : AppColors.burgundy;

    return AnimatedCrossFade(
      firstChild: _FaqQuestionContainer(
        question: faq.question,
        icon: Icons.keyboard_arrow_down_rounded,
        accentColor: accentColor,
        onTap: onTap,
      ),
      secondChild: _FaqAnswerContainer(
        faq: faq,
        accentColor: accentColor,
        onTap: onTap,
      ),
      crossFadeState: isExpanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 400),
      firstCurve: Curves.easeOut,
      secondCurve: Curves.easeInToLinear,
    );
  }
}

class _FaqQuestionContainer extends StatelessWidget {
  const _FaqQuestionContainer({
    required this.question,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  final String question;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryFixed,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: theme.colorScheme.primaryFixed.withValues(alpha: 0.26),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                question,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
            SizedBox(width: 12.w),
            Icon(icon, color: accentColor),
          ],
        ),
      ),
    );
  }
}

class _FaqAnswerContainer extends StatelessWidget {
  const _FaqAnswerContainer({
    required this.faq,
    required this.accentColor,
    required this.onTap,
  });

  final FaqItemModel faq;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryFixed,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: theme.colorScheme.primaryFixed.withValues(alpha: 0.26),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    faq.question,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(Icons.keyboard_arrow_up_rounded, color: accentColor),
              ],
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                faq.answer,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.55,
                  color: accentColor.withValues(alpha: 0.78),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
