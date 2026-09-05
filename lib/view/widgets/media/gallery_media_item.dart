class GalleryMediaItem {
  const GalleryMediaItem({
    required this.url,
    required this.isVideo,
    this.thumbnailUrl,
    this.description = '',
    this.date = '',
  });

  final String url;
  final bool isVideo;
  final String? thumbnailUrl;
  final String description;
  final String date;

  bool get hasDetails =>
      description.trim().isNotEmpty || date.trim().isNotEmpty;

  factory GalleryMediaItem.image(
    String url, {
    String? thumbnailUrl,
    String description = '',
    String date = '',
  }) {
    return GalleryMediaItem(
      url: url,
      isVideo: false,
      thumbnailUrl: thumbnailUrl,
      description: description,
      date: date,
    );
  }

  factory GalleryMediaItem.video(
    String url, {
    String? thumbnailUrl,
    String description = '',
    String date = '',
  }) {
    return GalleryMediaItem(
      url: url,
      isVideo: true,
      thumbnailUrl: thumbnailUrl,
      description: description,
      date: date,
    );
  }

  factory GalleryMediaItem.fromUrl(
    String url, {
    String? thumbnailUrl,
    String description = '',
    String date = '',
  }) {
    return GalleryMediaItem(
      url: url,
      isVideo: isVideoUrl(url),
      thumbnailUrl: thumbnailUrl,
      description: description,
      date: date,
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
