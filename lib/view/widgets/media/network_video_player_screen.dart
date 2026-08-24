import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:video_player/video_player.dart';

Future<void> openNetworkVideoPlayer(
  BuildContext context, {
  required String name,
  required String url,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => NetworkVideoPlayerScreen(name: name, url: url),
    ),
  );
}

class NetworkVideoPlayerScreen extends StatefulWidget {
  const NetworkVideoPlayerScreen({
    super.key,
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

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
              child: CircularProgressIndicator(color: AppColors.goldLight),
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
              _VideoControls(controller: _controller),
            ],
          );
        },
      ),
    );
  }
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
