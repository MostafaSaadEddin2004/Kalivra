import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';

class TextSlider extends StatelessWidget {
  const TextSlider({
    super.key,
    required this.text,
    this.textStyle,
    this.sliderSpeed,
    this.height,
  });

  final String text;
  final TextStyle? textStyle;
  final double? sliderSpeed;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: height ?? 20.h,
      child: text.trim().isEmpty
          ? const SizedBox.shrink()
          : Marquee(
              text: text,
              style:
                  textStyle ??
                  theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primaryFixed,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    height: 1.2,
                  ),
              blankSpace: 40.w,
              velocity: sliderSpeed ?? 40,
              startAfter: const Duration(seconds: 2),
              numberOfRounds: 3,
            ),
    );
  }
}
