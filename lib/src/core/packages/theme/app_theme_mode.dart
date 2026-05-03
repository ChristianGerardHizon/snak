import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'app_theme_mode.mapper.dart';

/// Theme mode preference for the application.
@MappableEnum()
enum AppThemeMode {
  light,
  dark,
  system;

  /// Display name for UI.
  String get displayName {
    switch (this) {
      case light:
        return 'Light';
      case dark:
        return 'Dark';
      case system:
        return 'System';
    }
  }

  /// Icon for this theme mode.
  IconData get icon {
    switch (this) {
      case light:
        return Icons.light_mode;
      case dark:
        return Icons.dark_mode;
      case system:
        return Icons.brightness_auto;
    }
  }

  /// Subtitle description.
  String get description {
    switch (this) {
      case light:
        return 'Always use light theme';
      case dark:
        return 'Always use dark theme';
      case system:
        return 'Follow device settings';
    }
  }
}
