import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'window_storage_service.dart';

class WindowUtils {
  /// Default sizes.
  static const _mobileSize = Size(380, 700);
  static const _defaultDesktopSize = Size(1000, 800);

  /// Minimum window size.
  static const _minimumSize = Size(380, 700);

  /// Register the WindowManager for desktop platforms.
  ///
  /// Sets window title and size, restoring last used size if available.
  static Future<void> register() async {
    // Skip on web and non-desktop platforms
    if (kIsWeb ||
        ![
          TargetPlatform.linux,
          TargetPlatform.macOS,
          TargetPlatform.windows,
        ].contains(defaultTargetPlatform)) return;

    await windowManager.ensureInitialized();

    // Try to load saved window size
    final savedSize = await WindowStorageService.loadWindowSize();

    // Use saved size if available, otherwise fall back to defaults
    final initialSize =
        savedSize ?? (kDebugMode ? _mobileSize : _defaultDesktopSize);

    final windowOptions = WindowOptions(
      minimumSize: _minimumSize,
      size: initialSize,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}
