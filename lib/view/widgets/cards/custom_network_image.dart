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
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final IconData? defaultIcon;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _FallbackIcon(
        width: width,
        height: height,
        icon: defaultIcon ?? Icons.image_not_supported_outlined,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      height: height,
      width: width,
      fit: BoxFit.cover,
      errorListener: (_) {},
      placeholder: (context, url) => SizedBox(
        width: width,
        height: height,
        child: Skeletonizer(child: Container(color: Colors.white)),
      ),
      errorWidget: (context, url, error) {
        return _FallbackIcon(
          width: width,
          height: height,
          icon: defaultIcon ?? Icons.broken_image_outlined,
        );
      },
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon({
    required this.width,
    required this.height,
    required this.icon,
  });

  final double? width;
  final double? height;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Icon(
          icon,
          size: 35.sp,
          color: colorScheme.primary.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}
