import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../assets/assets.gen.dart';

/// Singleton, looping, muted [VideoPlayerController] keyed by asset path.
/// One controller per asset for the lifetime of the process. The host
/// [LoopingVideoBackground] widget is meant to be mounted exactly once (at
/// the app shell, behind the page switcher) so the underlying texture is
/// never handed off between widgets — which is what was previously breaking
/// the iOS background video on page transitions.
class _BackgroundVideo {
  _BackgroundVideo._(this.assetPath);

  final String assetPath;
  VideoPlayerController? controller;
  Future<void>? initFuture;

  static final Map<String, _BackgroundVideo> _instances = {};

  static _BackgroundVideo of(String assetPath) {
    final entry = _instances.putIfAbsent(
      assetPath,
      () => _BackgroundVideo._(assetPath),
    );
    if (entry.controller == null) {
      final created = VideoPlayerController.asset(assetPath);
      entry.controller = created;
      entry.initFuture = () async {
        await created.initialize();
        await created.setLooping(true);
        await created.setVolume(0);
        await created.play();
      }();
    }
    return entry;
  }
}

/// Plays an mp4 asset on loop, muted, as a full-bleed background. Renders a
/// static image fallback while the video initializes so there's never an
/// empty frame.
///
/// Mount this exactly once at the app shell (behind the page switcher).
/// Pages should be transparent overlays.
class LoopingVideoBackground extends StatefulWidget {
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
  State<LoopingVideoBackground> createState() => _LoopingVideoBackgroundState();
}

class _LoopingVideoBackgroundState extends State<LoopingVideoBackground>
    with WidgetsBindingObserver {
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
      final controller = _controller;
      if (controller != null &&
          controller.value.isInitialized &&
          !controller.value.isPlaying) {
        controller.play();
      }
    }
  }

  Future<void> _attach() async {
    final entry = _BackgroundVideo.of(widget.assetPath);
    try {
      await entry.initFuture;
    } catch (_) {
      return;
    }
    if (!mounted) return;
    final controller = entry.controller;
    if (controller == null) return;
    controller.addListener(_onTick);
    if (controller.value.isInitialized && !controller.value.isPlaying) {
      await controller.play();
    }
    if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final fallback = Assets.images.background.image(
      fit: widget.fit,
      width: double.infinity,
      height: double.infinity,
    );
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.size.width == 0) {
      return fallback;
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        fallback,
        ClipRect(
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
        ),
      ],
    );
  }
}
