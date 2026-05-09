import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../assets/assets.gen.dart';

/// Refcounted, looping, muted [VideoPlayerController] keyed by asset path.
/// While at least one [LoopingVideoBackground] is mounted, the controller is
/// shared across pages. The release is deferred a frame so overlapping
/// AnimatedSwitcher transitions (old widget unmounting while new widget is
/// still acquiring) don't bounce the refcount through zero, which would
/// dispose+recreate the controller and break the iOS texture handoff.
class _RefcountedVideo {
  _RefcountedVideo._(this.assetPath);

  final String assetPath;
  VideoPlayerController? controller;
  Future<void>? _initFuture;
  int _refs = 0;
  Timer? _pendingRelease;

  static final Map<String, _RefcountedVideo> _instances = {};

  static _RefcountedVideo acquireSync(String assetPath) {
    final entry = _instances.putIfAbsent(
      assetPath,
      () => _RefcountedVideo._(assetPath),
    );
    entry._refs += 1;
    entry._pendingRelease?.cancel();
    entry._pendingRelease = null;
    if (entry.controller == null) {
      final created = VideoPlayerController.asset(assetPath);
      entry.controller = created;
      entry._initFuture = () async {
        await created.initialize();
        await created.setLooping(true);
        await created.setVolume(0);
        await created.play();
      }();
    }
    return entry;
  }

  static void release(String assetPath) {
    final entry = _instances[assetPath];
    if (entry == null) return;
    entry._refs -= 1;
    if (entry._refs <= 0) {
      // Defer the actual dispose so a near-immediate acquire (next page
      // mounting during a transition) can reclaim the live controller.
      entry._pendingRelease?.cancel();
      entry._pendingRelease = Timer(const Duration(milliseconds: 250), () {
        if (entry._refs > 0) return;
        entry.controller?.dispose();
        entry.controller = null;
        entry._initFuture = null;
        _instances.remove(assetPath);
      });
    }
  }
}

/// Plays an mp4 asset on loop, muted, as a full-bleed background. Falls back
/// to a static image while the video initializes so there's never an empty
/// frame.
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
  bool _released = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Bump the refcount synchronously so a sibling widget unmounting in the
    // same frame can't trigger a dispose before our async init runs.
    final entry = _RefcountedVideo.acquireSync(widget.assetPath);
    _attach(entry);
  }

  @override
  void dispose() {
    _controller?.removeListener(_onTick);
    WidgetsBinding.instance.removeObserver(this);
    if (!_released) {
      _released = true;
      _RefcountedVideo.release(widget.assetPath);
    }
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

  Future<void> _attach(_RefcountedVideo entry) async {
    try {
      await entry._initFuture;
    } catch (_) {
      // Initialization failed; static fallback will render.
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
