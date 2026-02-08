import 'dart:ui';

/// Design reference size (e.g. from Figma). Widgets scale relative to this.
/// 375 x 812 matches common iPhone design width and a mid-range height.
const Size kDesignSize = Size(375, 812);

/// Text scale factor limits so font sizes don't get too small or too large.
/// Scale is applied on top of design-based .sp scaling.
/// - Min 0.9: text never goes below 90% of scaled size (avoids tiny text).
/// - Max 1.15: text never goes above 115% of scaled size (avoids huge text).
const double kMinTextScaleFactor = 0.9;
const double kMaxTextScaleFactor = 1.15;

/// Usage (after ScreenUtilInit in main.dart):
/// - 16.w  → width scaled to design
/// - 24.h  → height scaled to design
/// - 14.sp → font size, scaled and clamped by [kMinTextScaleFactor]–[kMaxTextScaleFactor]
/// - 8.r   → radius scaled by the smaller of width/height (good for circles)
/// Import: import 'package:flutter_screenutil/flutter_screenutil.dart';
