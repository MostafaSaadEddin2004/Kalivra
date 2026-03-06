import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Displays a single product image from URL or asset path.
class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  final String imageUrl;
  final double width;
  final double height;

  bool get _isNetworkUrl =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isNetworkUrl) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: colorScheme.surfaceContainerHighest,
            child: Center(
              child: SizedBox(
                width: 32.r,
                height: 32.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              ),
            ),
          );
        },
        errorBuilder: (_, _, _) => _placeholder(colorScheme),
      );
    }

    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _placeholder(colorScheme),
    );
  }

  Widget _placeholder(ColorScheme colorScheme) {
    return Container(
      width: width,
      height: height,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.inventory_2_outlined,
        size: 48.r,
        color: colorScheme.primary.withValues(alpha: 0.5),
      ),
    );
  }
}

/// Product image gallery with main view and thumbnail strip.
/// Uses local state only (no Bloc).
class ProductGalleryCard extends StatefulWidget {
  const ProductGalleryCard({
    super.key,
    required this.imageUrls,
    this.mainHeight = 330,
    this.mainWidth = 330,
    this.thumbnailSize = 64,
    this.borderRadius = 20,
  });

  final List<String> imageUrls;
  final double mainHeight;
  final double mainWidth;
  final double thumbnailSize;
  final double borderRadius;

  @override
  State<ProductGalleryCard> createState() => _ProductGalleryCardState();
}

class _ProductGalleryCardState extends State<ProductGalleryCard> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  void _goToPage(int index) {
    if (index == _currentIndex) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls;
    if (images.isEmpty) {
      return SizedBox(
        height: widget.mainHeight.h,
        width: widget.mainWidth.w,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 64.r,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return SizedBox(
      height: widget.mainHeight.h + 15.h + widget.thumbnailSize.h,
      width: widget.mainWidth.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: widget.mainHeight.h,
            width: widget.mainWidth.w,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: images.length,
              itemBuilder: (_, index) => Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius.r),
                ),
                child: _ProductImage(
                  imageUrl: images[index],
                  width: widget.mainWidth.w,
                  height: widget.mainHeight.h,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          SizedBox(
            height: widget.thumbnailSize.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: images.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (_, index) {
                final isSelected = index == _currentIndex;
                return GestureDetector(
                  onTap: () => _goToPage(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.all(isSelected ? 3.w : 0),
                    height: widget.thumbnailSize.h,
                    width: widget.thumbnailSize.w,
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(color: primary, width: 2.w)
                          : null,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: _ProductImage(
                        imageUrl: images[index],
                        width: widget.thumbnailSize.w,
                        height: widget.thumbnailSize.h,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
