import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

/// Holds a single looping, muted [VideoPlayerController] so multiple
/// [LoopingVideoBackground] mounts share one decode and stay in sync as
/// the user navigates between pages.
class _SharedVideoController {
  _SharedVideoController(this.assetPath);

  final String assetPath;
  VideoPlayerController? controller;
  Future<void>? _initFuture;

  Future<VideoPlayerController> ensure() async {
    final existing = controller;
    if (existing != null) {
      await _initFuture;
      return existing;
    }
    final created = VideoPlayerController.asset(assetPath);
    controller = created;
    _initFuture = () async {
      await created.initialize();
      await created.setLooping(true);
      await created.setVolume(0);
      await created.play();
    }();
    await _initFuture;
    return created;
  }

  void dispose() {
    controller?.dispose();
    controller = null;
    _initFuture = null;
  }
}

final _sharedVideoControllerProvider =
    Provider.family<_SharedVideoController, String>((ref, assetPath) {
  final shared = _SharedVideoController(assetPath);
  ref.onDispose(shared.dispose);
  return shared;
});

/// Plays an mp4 asset on loop, muted, as a full-bleed background. Multiple
/// instances pointed at the same asset share a single underlying controller.
class LoopingVideoBackground extends ConsumerStatefulWidget {
  const LoopingVideoBackground({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.zoom = 1.0,
  });

  final String assetPath;
  final BoxFit fit;
  final double zoom;

  @override
  ConsumerState<LoopingVideoBackground> createState() =>
      _LoopingVideoBackgroundState();
}

class _LoopingVideoBackgroundState
    extends ConsumerState<LoopingVideoBackground> with WidgetsBindingObserver {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _attach();
  }

  @override
  void dispose() {
    _controller?.removeListener(_onTick);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resumeIfPaused();
    }
  }

  Future<void> _attach() async {
    final shared = ref.read(_sharedVideoControllerProvider(widget.assetPath));
    final controller = await shared.ensure();
    if (!mounted) return;
    controller.addListener(_onTick);
    setState(() => _controller = controller);
  }

  void _onTick() {
    final controller = _controller;
    if (controller == null) return;
    final value = controller.value;
    if (value.isInitialized && !value.isPlaying && !value.hasError) {
      controller.play();
    }
  }

  void _resumeIfPaused() {
    final controller = _controller;
    if (controller != null &&
        controller.value.isInitialized &&
        !controller.value.isPlaying) {
      controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const SizedBox.expand();
    }
    return ClipRect(
      child: SizedBox.expand(
        child: Transform.scale(
          scale: widget.zoom,
          child: FittedBox(
            fit: widget.fit,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        ),
      ),
    );
  }
}
