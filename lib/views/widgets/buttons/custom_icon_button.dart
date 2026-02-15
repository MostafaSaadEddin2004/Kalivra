import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Custom icon button used across the app instead of [IconButton].
/// Supports tooltip, size, color, padding, and constraints for use in app bars, forms, and lists.
class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.iconSize,
    this.color,
    this.backgroundColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double? iconSize;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(padding: EdgeInsets.all(0.w),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: iconSize ?? 24.r, color: color),
      tooltip: tooltip,
    );
  }
}
