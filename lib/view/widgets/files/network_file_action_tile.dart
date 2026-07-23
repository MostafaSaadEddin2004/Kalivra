import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/network/dio_client.dart' as network;
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class NetworkFileActionTile extends StatelessWidget {
  const NetworkFileActionTile({
    super.key,
    required this.name,
    required this.url,
    this.subtitle,
    this.icon = Icons.insert_drive_file_outlined,
  });

  final String name;
  final String? url;
  final String? subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fileName = _displayFileName(name, url);

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: isDark
            ? AppColors.taupe.withValues(alpha: 0.1)
            : AppColors.burgundy.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => handleNetworkFileTap(context, name: fileName, url: url),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              children: [
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    icon,
                    size: 20.r,
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle?.trim().isNotEmpty == true) ...[
                        SizedBox(height: 2.h),
                        Text(
                          subtitle!.trim(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  _isImageFileReference(url ?? fileName)
                      ? Icons.zoom_out_map_rounded
                      : Icons.download_rounded,
                  size: 20.r,
                  color: isDark ? AppColors.goldLight : AppColors.burgundy,
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.open_in_new_rounded,
                  size: 19.r,
                  color: isDark ? AppColors.taupe : AppColors.burgundy,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> handleNetworkFileTap(
  BuildContext context, {
  required String name,
  required String? url,
}) async {
  final uri = _fileUriOrNull(url ?? name);
  if (uri == null) {
    _showFileSnackBar(
      context,
      arabic: 'ØªØ¹Ø°Ø± ÙØªØ­ Ø§Ù„Ù…Ù„Ù',
      english: 'Could not open this file',
    );
    return;
  }

  final fileName = _displayFileName(name, uri.toString());
  if (_isImageFileReference(name) ||
      _isImageFileReference(url ?? '') ||
      _isImageFileReference(uri.path)) {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _NetworkImagePhotoViewScreen(
          title: fileName,
          imageUrl: uri.toString(),
        ),
      ),
    );
    return;
  }

  await showNetworkFileActionDialog(
    context,
    name: fileName,
    url: uri.toString(),
  );
}

Future<void> showNetworkFileActionDialog(
  BuildContext context, {
  required String name,
  required String? url,
}) async {
  final uri = _fileUriOrNull(url ?? name);
  if (uri == null) {
    _showFileSnackBar(
      context,
      arabic: 'تعذر فتح الملف',
      english: 'Could not open this file',
    );
    return;
  }

  final fileName = _safeFileName(_displayFileName(name, uri.toString()));
  final shouldDownload = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          _localizedText(
            dialogContext,
            arabic: 'تحميل الملف',
            english: 'Download file',
          ),
        ),
        content: Text(
          _localizedText(
            dialogContext,
            arabic: 'هل تريد تحميل الملف؟',
            english: 'Do you want to download this file?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              _localizedText(
                dialogContext,
                arabic: 'لا، فتح فقط',
                english: 'No, open only',
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Icons.download_rounded),
            label: Text(
              _localizedText(
                dialogContext,
                arabic: 'نعم، تحميل',
                english: 'Yes, download',
              ),
            ),
          ),
        ],
      );
    },
  );

  if (shouldDownload == null || !context.mounted) return;

  if (shouldDownload) {
    await _downloadFile(context, uri, fileName);
    if (!context.mounted) return;
  }

  await _openFileUri(context, uri);
}

Future<void> _downloadFile(
  BuildContext context,
  Uri uri,
  String fileName,
) async {
  _showFileSnackBar(
    context,
    arabic: 'جاري تحميل الملف...',
    english: 'Downloading file...',
  );

  try {
    final response = await Dio().get<List<int>>(
      uri.toString(),
      options: Options(responseType: ResponseType.bytes),
    );
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw StateError('Empty file response');
    }

    await FilePicker.saveFile(
      dialogTitle: _localizedText(
        context,
        arabic: 'حفظ الملف',
        english: 'Save file',
      ),
      fileName: fileName,
      bytes: Uint8List.fromList(bytes),
    );
  } catch (_) {
    if (!context.mounted) return;
    _showFileSnackBar(
      context,
      arabic: 'تعذر تحميل الملف، سيتم فتحه فقط',
      english: 'Could not download the file. Opening it instead.',
    );
  }
}

Future<void> _openFileUri(BuildContext context, Uri uri) async {
  try {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      _showFileSnackBar(
        context,
        arabic: 'تعذر فتح الملف',
        english: 'Could not open this file',
      );
    }
  } catch (_) {
    if (!context.mounted) return;
    _showFileSnackBar(
      context,
      arabic: 'تعذر فتح الملف',
      english: 'Could not open this file',
    );
  }
}

class _NetworkImagePhotoViewScreen extends StatelessWidget {
  const _NetworkImagePhotoViewScreen({
    required this.title,
    required this.imageUrl,
  });

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 4,
        loadingBuilder: (context, event) {
          final expectedBytes = event?.expectedTotalBytes;
          final loadedBytes = event?.cumulativeBytesLoaded ?? 0;
          final progress = expectedBytes == null || expectedBytes == 0
              ? null
              : loadedBytes / expectedBytes;

          return Center(
            child: CircularProgressIndicator(
              value: progress,
              color: Colors.white,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: Colors.white.withValues(alpha: 0.75),
              size: 58.r,
            ),
          );
        },
      ),
    );
  }
}

Uri? _fileUriOrNull(String value) {
  final trimmedValue = value.trim();
  if (trimmedValue.isEmpty) return null;

  final uri = Uri.tryParse(trimmedValue);
  if (uri != null && uri.hasScheme) return uri;

  if (trimmedValue.startsWith('//')) {
    return Uri.tryParse('https:$trimmedValue');
  }

  final baseUri = Uri.parse(network.baseUrl);
  final relativeUri = Uri.tryParse(trimmedValue);
  final relativePath = relativeUri?.path.trim().isNotEmpty == true
      ? relativeUri!.path
      : trimmedValue;
  final normalizedPath = relativePath.startsWith('/')
      ? relativePath
      : '/$relativePath';

  return Uri(
    scheme: baseUri.scheme,
    host: baseUri.host,
    path: normalizedPath,
    query: relativeUri?.query.trim().isNotEmpty == true
        ? relativeUri!.query
        : null,
  );
}

String _displayFileName(String name, String? url) {
  final trimmedName = name.trim();
  if (trimmedName.isNotEmpty && !_looksLikeUrl(trimmedName)) {
    return trimmedName;
  }

  final fromUrl = _fileNameFromUrl(url ?? trimmedName);
  return fromUrl.isNotEmpty ? fromUrl : 'file';
}

String _fileNameFromUrl(String value) {
  final uri = Uri.tryParse(value.trim());
  final segments = uri?.pathSegments.where((segment) => segment.isNotEmpty);
  if (segments == null || segments.isEmpty) return '';
  return Uri.decodeComponent(segments.last);
}

String _safeFileName(String value) {
  final cleaned = value
      .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_')
      .trim();
  final fileName = cleaned.isEmpty ? 'file' : cleaned;
  return fileName.contains('.') ? fileName : '$fileName.file';
}

bool _looksLikeUrl(String value) {
  final uri = Uri.tryParse(value);
  return uri != null && (uri.hasScheme || value.startsWith('/'));
}

bool _isImageFileReference(String value) {
  final text = value.trim();
  if (text.isEmpty) return false;

  final uri = Uri.tryParse(text);
  final path = uri?.path.isNotEmpty == true ? uri!.path : text;

  return RegExp(
    r'\.(png|jpe?g|webp|gif|bmp|heic|heif)(\?.*)?$',
    caseSensitive: false,
  ).hasMatch(path);
}

String _localizedText(
  BuildContext context, {
  required String arabic,
  required String english,
}) {
  final locale = Localizations.localeOf(context).languageCode.toLowerCase();
  return locale == 'ar' ? arabic : english;
}

void _showFileSnackBar(
  BuildContext context, {
  required String arabic,
  required String english,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(_localizedText(context, arabic: arabic, english: english)),
    ),
  );
}
