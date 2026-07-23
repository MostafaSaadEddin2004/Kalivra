import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.defaultIcon,
    this.defaultIconColor,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final IconData? defaultIcon;
  final Color? defaultIconColor;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Center(
        child: Icon(
          defaultIcon ?? Icons.image_outlined,
          size: 35.sp,
          color:
              defaultIconColor ??
              Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        height: height,
        width: width,
        fit: BoxFit.cover,
        placeholder: (context, url) => Skeletonizer(child: Container()),
        errorWidget: (context, url, error) {
          return Center(child: Icon(Icons.broken_image, size: 35.sp));
        },
      );
    }
  }
}
