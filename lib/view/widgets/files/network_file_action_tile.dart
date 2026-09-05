import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/network/dio_client.dart' as network;
import 'package:kalivra/l10n/app_localizations.dart';
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
    final fileName = _displayFileName(name, url);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryFixed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                size: 20.r,
                color: theme.colorScheme.primaryFixed,
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
            InkWell(
              onTap: () =>
                  handleNetworkFileTap(context, name: fileName, url: url),
              child: Icon(
                _isImageFileReference(url ?? fileName)
                    ? Icons.zoom_out_map_rounded
                    : Icons.download_rounded,
                size: 20.r,
                color: theme.colorScheme.onTertiaryFixed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> handleNetworkFileTap(
  BuildContext context, {
  required String name,
  required String? url,
  String description = '',
  String date = '',
}) async {
  final uri = _fileUriOrNull(url ?? name);
  if (uri == null) {
    _showFileSnackBar(
      context,
      AppLocalizations.of(context)!.fileActionCouldNotOpenFile,
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
          description: description,
          date: date,
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
      AppLocalizations.of(context)!.fileActionCouldNotOpenFile,
    );
    return;
  }

  final fileName = _safeFileName(_displayFileName(name, uri.toString()));
  final shouldDownload = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(AppLocalizations.of(dialogContext)!.fileActionDownloadFile),
        content: Text(
          AppLocalizations.of(dialogContext)!.fileActionDownloadPrompt,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(AppLocalizations.of(dialogContext)!.fileActionOpenOnly),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Icons.download_rounded),
            label: Text(
              AppLocalizations.of(dialogContext)!.fileActionDownloadConfirm,
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
    AppLocalizations.of(context)!.fileActionDownloading,
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
      dialogTitle: AppLocalizations.of(context)!.fileActionSaveFile,
      fileName: fileName,
      bytes: Uint8List.fromList(bytes),
    );
  } catch (_) {
    if (!context.mounted) return;
    _showFileSnackBar(
      context,
      AppLocalizations.of(context)!.fileActionDownloadFailedOpenInstead,
    );
  }
}

Future<void> _openFileUri(BuildContext context, Uri uri) async {
  try {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      _showFileSnackBar(
        context,
        AppLocalizations.of(context)!.fileActionCouldNotOpenFile,
      );
    }
  } catch (_) {
    if (!context.mounted) return;
    _showFileSnackBar(
      context,
      AppLocalizations.of(context)!.fileActionCouldNotOpenFile,
    );
  }
}

class _NetworkImagePhotoViewScreen extends StatelessWidget {
  const _NetworkImagePhotoViewScreen({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.date,
  });

  final String title;
  final String imageUrl;
  final String description;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Stack(
        children: [
          PhotoView(
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
                child: SpinKitFadingCircle(
                  size: progress == null ? 42.r : 42.r,
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
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: _ImageDetailsPanel(description: description, date: date),
          ),
        ],
      ),
    );
  }
}

class _ImageDetailsPanel extends StatefulWidget {
  const _ImageDetailsPanel({required this.description, required this.date});

  final String description;
  final String date;

  @override
  State<_ImageDetailsPanel> createState() => _ImageDetailsPanelState();
}

class _ImageDetailsPanelState extends State<_ImageDetailsPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final description = widget.description.trim();
    final date = _formatMediaDate(widget.date);
    if (description.isEmpty && date.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: AppColors.offWhite.withValues(alpha: 0.14),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (date.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 15.r,
                        color: AppColors.goldLight,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.offWhite.withValues(alpha: 0.82),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (description.isNotEmpty) SizedBox(height: 8.h),
                ],
                if (description.isNotEmpty) ...[
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final style = theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.offWhite,
                        height: 1.35,
                      );
                      final textPainter = TextPainter(
                        text: TextSpan(text: description, style: style),
                        maxLines: 2,
                        textDirection: Directionality.of(context),
                      )..layout(maxWidth: constraints.maxWidth);
                      final needsToggle = textPainter.didExceedMaxLines;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            description,
                            maxLines: _expanded ? null : 2,
                            overflow: _expanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: style,
                          ),
                          if (needsToggle) ...[
                            SizedBox(height: 4.h),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.goldLight,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(0, 32.h),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  setState(() => _expanded = !_expanded);
                                },
                                child: Text(
                                  _expanded ? l10n.showLess : l10n.showMore,
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatMediaDate(String value) {
  final text = value.trim();
  final parsedDate = DateTime.tryParse(text);
  if (parsedDate == null) return text;

  final month = parsedDate.month.toString().padLeft(2, '0');
  final day = parsedDate.day.toString().padLeft(2, '0');
  return '${parsedDate.year}-$month-$day';
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

void _showFileSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
