import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../utils/window_storage_service.dart';

/// Widget that listens to window resize events and persists the size.
///
/// Wrap this around your main app widget to enable window size persistence.
class WindowSizeListener extends StatefulWidget {
  const WindowSizeListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<WindowSizeListener> createState() => _WindowSizeListenerState();
}

class _WindowSizeListenerState extends State<WindowSizeListener>
    with WindowListener {
  Timer? _debounceTimer;
  static const _debounceDelay = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _initWindowListener();
  }

  Future<void> _initWindowListener() async {
    // Only add listener on desktop platforms
    if (kIsWeb ||
        ![
          TargetPlatform.linux,
          TargetPlatform.macOS,
          TargetPlatform.windows,
        ].contains(defaultTargetPlatform)) return;

    windowManager.addListener(this);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowResize() {
    _saveCurrentSizeDebounced();
  }

  @override
  void onWindowResized() {
    // Called when resize ends - ensure final size is saved
    _saveCurrentSizeDebounced();
  }

  void _saveCurrentSizeDebounced() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDelay, () async {
      final size = await windowManager.getSize();
      await WindowStorageService.saveWindowSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
