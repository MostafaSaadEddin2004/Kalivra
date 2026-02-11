import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/models/brand_model.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({
    super.key,
    required this.brand,
    this.onTap,
    this.expanded = false,
  });

  final BrandModel brand;
  final VoidCallback? onTap;
  /// When true, card fills available width (e.g. in grid). When false, uses fixed width for horizontal list.
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: expanded ? null : 90.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 70.h,
                width: double.infinity,
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                child: Icon(
                  Icons.store_rounded,
                  size: 28.r,
                  color: colorScheme.primary.withValues(alpha: 0.6),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
                child: Text(
                  brand.name,
                  style: textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
