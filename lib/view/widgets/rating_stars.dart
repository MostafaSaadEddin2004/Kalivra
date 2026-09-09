import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/view/widgets/buttons/custom_icon_button.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.enabled = true,
    this.size,
    this.spacing,
    this.activeColor,
    this.inactiveColor,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  final int rating;
  final ValueChanged<int>? onRatingChanged;
  final bool enabled;
  final double? size;
  final double? spacing;
  final Color? activeColor;
  final Color? inactiveColor;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final starSize = size ?? 40.r;

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final value = index + 1;
        final isSelected = value <= rating;

        return CustomIconButton(
          icon: isSelected ? Icons.star_rounded : Icons.star_border_rounded,
          iconSize: starSize,
          color: isSelected ? AppColors.burgundy : AppColors.burgundy.withValues(alpha: 0.5),
          onPressed: enabled && onRatingChanged != null
              ? () => onRatingChanged!(value)
              : null,
        );
      }),
    );
  }
}
