import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';

class AdCard extends StatelessWidget {
  const AdCard({super.key, required this.imageUrl, this.onTap});

  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CustomNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: 152.h,
      ),
    );
  }
}
