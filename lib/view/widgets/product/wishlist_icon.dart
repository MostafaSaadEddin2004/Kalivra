import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Wishlist heart icon — visual only (no tap or API logic).
class WishlistIcon extends StatelessWidget {
  const WishlistIcon({super.key, required this.isActive, this.size = 22});

  final bool isActive;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return Icon(Icons.favorite_rounded, size: size.r, color: Colors.red);
    }
    return Icon(Icons.favorite_border_rounded, size: size.r);
  }
}
