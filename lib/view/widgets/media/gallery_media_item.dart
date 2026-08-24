class GalleryMediaItem {
  const GalleryMediaItem({
    required this.url,
    required this.isVideo,
    this.thumbnailUrl,
  });

  final String url;
  final bool isVideo;
  final String? thumbnailUrl;

  factory GalleryMediaItem.image(String url, {String? thumbnailUrl}) {
    return GalleryMediaItem(
      url: url,
      isVideo: false,
      thumbnailUrl: thumbnailUrl,
    );
  }

  factory GalleryMediaItem.video(String url, {String? thumbnailUrl}) {
    return GalleryMediaItem(
      url: url,
      isVideo: true,
      thumbnailUrl: thumbnailUrl,
    );
  }

  factory GalleryMediaItem.fromUrl(String url, {String? thumbnailUrl}) {
    return GalleryMediaItem(
      url: url,
      isVideo: isVideoUrl(url),
      thumbnailUrl: thumbnailUrl,
    );
  }

  static bool isVideoUrl(String url) {
    final normalized = url
        .split('?')
        .first
        .split('#')
        .first
        .trim()
        .toLowerCase();
    const videoExtensions = [
      '.mp4',
      '.mov',
      '.m4v',
      '.webm',
      '.mkv',
      '.avi',
      '.wmv',
      '.flv',
      '.3gp',
      '.3gpp',
      '.mpeg',
      '.mpg',
      '.ogv',
    ];

    return videoExtensions.any(normalized.endsWith);
  }
}
