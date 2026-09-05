import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';

Future<void> openNetworkVideoPlayer(
  BuildContext context, {
  required String name,
  required String url,
  String description = '',
  String date = '',
}) {
  return Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => NetworkVideoPlayerScreen(
        name: name,
        url: url,
        description: description,
        date: date,
      ),
    ),
  );
}

class NetworkVideoPlayerScreen extends StatefulWidget {
  const NetworkVideoPlayerScreen({
    super.key,
    required this.name,
    required this.url,
    this.description = '',
    this.date = '',
  });

  final String name;
  final String url;
  final String description;
  final String date;

  @override
  State<NetworkVideoPlayerScreen> createState() =>
      _NetworkVideoPlayerScreenState();
}

class _NetworkVideoPlayerScreenState extends State<NetworkVideoPlayerScreen> {
  late final VideoPlayerController _controller;
  late final Future<void> _initializeVideo;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _initializeVideo = _controller.initialize().then((_) {
      if (!mounted) return;
      _controller.play();
      setState(() {});
    });
    _controller.addListener(_onVideoChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onVideoChanged() {
    if (mounted) setState(() {});
  }

  void _togglePlayback() {
    if (!_controller.value.isInitialized) return;
    _controller.value.isPlaying ? _controller.pause() : _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.offWhite,
        title: Text(
          widget.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.offWhite,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: FutureBuilder<void>(
        future: _initializeVideo,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: SpinKitFadingCircle(
                color: AppColors.goldLight,
                size: 42.r,
              ),
            );
          }

          final value = _controller.value;
          if (value.hasError || !value.isInitialized) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 48.r,
                  color: AppColors.offWhite,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _togglePlayback,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        if (!value.isPlaying)
                          Container(
                            width: 72.r,
                            height: 72.r,
                            decoration: BoxDecoration(
                              color: AppColors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 48.r,
                              color: AppColors.offWhite,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              _MediaDetailsPanel(
                description: widget.description,
                date: widget.date,
              ),
              _VideoControls(controller: _controller),
            ],
          );
        },
      ),
    );
  }
}

class _MediaDetailsPanel extends StatefulWidget {
  const _MediaDetailsPanel({required this.description, required this.date});

  final String description;
  final String date;

  @override
  State<_MediaDetailsPanel> createState() => _MediaDetailsPanelState();
}

class _MediaDetailsPanelState extends State<_MediaDetailsPanel> {
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
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 4.h),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.offWhite.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: AppColors.offWhite.withValues(alpha: 0.12),
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
                            color: AppColors.offWhite.withValues(alpha: 0.78),
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

class _VideoControls extends StatelessWidget {
  const _VideoControls({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    final value = controller.value;
    final duration = value.duration;
    final position = value.position;
    final max = duration.inMilliseconds.toDouble().clamp(1, double.infinity);
    final current = position.inMilliseconds.toDouble().clamp(0, max);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                value.isPlaying ? controller.pause() : controller.play();
              },
              color: AppColors.offWhite,
              icon: Icon(
                value.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.goldLight,
                  inactiveTrackColor: AppColors.offWhite.withValues(
                    alpha: 0.28,
                  ),
                  thumbColor: AppColors.goldLight,
                ),
                child: Slider(
                  value: current.toDouble(),
                  max: max.toDouble(),
                  onChanged: (milliseconds) {
                    controller.seekTo(
                      Duration(milliseconds: milliseconds.round()),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '${_formatDuration(position)} / ${_formatDuration(duration)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.offWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) return '$hours:$minutes:$seconds';
    return '$minutes:$seconds';
  }
}
