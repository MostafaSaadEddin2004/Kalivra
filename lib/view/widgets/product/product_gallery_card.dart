import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';
import 'package:kalivra/view/widgets/media/gallery_media_item.dart';
import 'package:kalivra/view/widgets/media/network_video_player_screen.dart';

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
              child: SpinKitFadingCircle(
                size: 32.r,
                color: colorScheme.primary,
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

class ProductGalleryCard extends StatefulWidget {
  const ProductGalleryCard({
    super.key,
    required this.imageUrls,
    this.mainWidth,
    this.mainHeight = 330,
    this.thumbnailSize = 64,
    this.borderRadius = 20,
  });

  final List<ProductImage> imageUrls;
  final double? mainWidth;
  final double mainHeight;
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

  String _mediaUrl(ProductImage image) {
    return image.videoUrl ??
        image.fileUrl ??
        image.url ??
        image.largeImageUrl ??
        image.originalImageUrl ??
        image.mediumImageUrl ??
        image.smallImageUrl ??
        '';
  }

  String? _imageUrl(ProductImage image) {
    return image.largeImageUrl ??
        image.originalImageUrl ??
        image.mediumImageUrl ??
        image.smallImageUrl ??
        image.previewImageUrl ??
        image.url ??
        image.fileUrl;
  }

  GalleryMediaItem _mediaItem(ProductImage image) {
    final type = image.type?.toLowerCase() ?? '';
    final mimeType = image.mimeType?.toLowerCase() ?? '';
    final url = _mediaUrl(image);
    final isVideo =
        type.contains('video') ||
        mimeType.startsWith('video/') ||
        image.videoUrl?.trim().isNotEmpty == true ||
        GalleryMediaItem.isVideoUrl(url);

    return GalleryMediaItem(
      url: url,
      isVideo: isVideo,
      thumbnailUrl: image.previewImageUrl ?? _imageUrl(image),
    );
  }

  void _openMedia(BuildContext context, GalleryMediaItem media, int index) {
    if (!media.isVideo) return;
    openNetworkVideoPlayer(context, name: 'Video ${index + 1}', url: media.url);
  }

  @override
  Widget build(BuildContext context) {
    final mediaItems = widget.imageUrls
        .map(_mediaItem)
        .where((item) => item.url.trim().isNotEmpty)
        .toList();
    if (mediaItems.isEmpty) {
      return SizedBox(
        height: widget.mainHeight.h,
        width: widget.mainWidth?.w ?? double.infinity,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 64.r,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    if (mediaItems.length == 1) {
      final media = mediaItems.first;
      return SizedBox(
        height: widget.mainHeight.h,
        width: widget.mainWidth?.w ?? double.infinity,
        child: GestureDetector(
          onTap: () => _openMedia(context, media, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            child: _ProductMediaPreview(
              media: media,
              width: widget.mainWidth?.w ?? double.infinity,
              height: widget.mainHeight.h,
              fallbackIcon: Icons.inventory_2_outlined,
              imageBuilder: (url) => _ProductImage(
                imageUrl: url,
                width: widget.mainWidth?.w ?? double.infinity,
                height: widget.mainHeight.h,
              ),
            ),
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return SizedBox(
      height: widget.mainHeight.h + 15.h + widget.thumbnailSize.h,
      width: widget.mainWidth?.w ?? double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: widget.mainHeight.h,
            width: widget.mainWidth?.w ?? double.infinity,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: mediaItems.length,
              itemBuilder: (_, index) {
                final media = mediaItems[index];
                return GestureDetector(
                  onTap: () => _openMedia(context, media, index),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius.r,
                      ),
                    ),
                    child: _ProductMediaPreview(
                      media: media,
                      width: widget.mainWidth?.w ?? double.infinity,
                      height: widget.mainHeight.h,
                      fallbackIcon: Icons.inventory_2_outlined,
                      imageBuilder: (url) => _ProductImage(
                        imageUrl: url,
                        width: widget.mainWidth?.w ?? double.infinity,
                        height: widget.mainHeight.h,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 15.h),
          SizedBox(
            height: widget.thumbnailSize.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: mediaItems.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (_, index) {
                final media = mediaItems[index];
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
                      child: _ProductMediaPreview(
                        media: media,
                        width: widget.thumbnailSize.w,
                        height: widget.thumbnailSize.h,
                        fallbackIcon: Icons.inventory_2_outlined,
                        imageBuilder: (url) => _ProductImage(
                          imageUrl: url,
                          width: widget.thumbnailSize.w,
                          height: widget.thumbnailSize.h,
                        ),
                        compact: true,
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

class _ProductMediaPreview extends StatelessWidget {
  const _ProductMediaPreview({
    required this.media,
    required this.width,
    required this.height,
    required this.fallbackIcon,
    required this.imageBuilder,
    this.compact = false,
  });

  final GalleryMediaItem media;
  final double width;
  final double height;
  final IconData fallbackIcon;
  final Widget Function(String url) imageBuilder;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (!media.isVideo) {
      return imageBuilder(media.url);
    }

    final thumbnail = media.thumbnailUrl?.trim() ?? '';

    return Stack(
      fit: StackFit.expand,
      children: [
        if (thumbnail.isNotEmpty && !GalleryMediaItem.isVideoUrl(thumbnail))
          CustomNetworkImage(
            imageUrl: thumbnail,
            width: width,
            height: height,
            defaultIcon: fallbackIcon,
          )
        else
          Container(
            width: width,
            height: height,
            color: AppColors.black,
            child: Icon(
              Icons.videocam_outlined,
              color: AppColors.offWhite.withValues(alpha: 0.72),
              size: compact ? 24.r : 54.r,
            ),
          ),
        Container(
          color: AppColors.black.withValues(alpha: compact ? 0.18 : 0.28),
        ),
        Center(
          child: Container(
            width: compact ? 30.r : 64.r,
            height: compact ? 30.r : 64.r,
            decoration: BoxDecoration(
              color: AppColors.burgundy.withValues(alpha: 0.88),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: AppColors.offWhite,
              size: compact ? 22.r : 42.r,
            ),
          ),
        ),
      ],
    );
  }
}
