import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/secure_storage_provider.dart';
import 'app_theme_mode.dart';
import 'app_themes.dart';

part 'theme_controller.g.dart';

/// Storage key for persisting theme preference.
const _themePreferenceKey = 'THEME_PREFERENCE';

/// Controller for managing app theme mode.
///
/// Handles light/dark/system theme switching with persistence.
@Riverpod(keepAlive: true)
class ThemeController extends _$ThemeController {
  @override
  Future<AppThemeMode> build() async {
    return await _loadPersistedTheme() ?? AppThemeMode.system;
  }

  /// Gets the current effective theme ID based on mode and system brightness.
  String getEffectiveThemeId(Brightness systemBrightness) {
    final mode = state.value ?? AppThemeMode.system;

    switch (mode) {
      case AppThemeMode.light:
        return AppThemes.lightId;
      case AppThemeMode.dark:
        return AppThemes.darkId;
      case AppThemeMode.system:
        return systemBrightness == Brightness.dark
            ? AppThemes.darkId
            : AppThemes.lightId;
    }
  }

  /// Sets the theme mode and persists the preference.
  Future<void> setThemeMode(AppThemeMode mode) async {
    state = const AsyncLoading();
    await _persistTheme(mode);
    state = AsyncData(mode);
  }

  Future<AppThemeMode?> _loadPersistedTheme() async {
    final storage = ref.read(secureStorageProvider);
    final value = await storage.read(key: _themePreferenceKey);
    if (value == null) return null;

    return AppThemeMode.values.cast<AppThemeMode?>().firstWhere(
          (m) => m?.name == value,
          orElse: () => null,
        );
  }

  Future<void> _persistTheme(AppThemeMode mode) async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: _themePreferenceKey, value: mode.name);
  }
}

/// Convenience provider for current theme mode.
@Riverpod(keepAlive: true)
AppThemeMode currentThemeMode(Ref ref) {
  return ref.watch(themeControllerProvider).value ?? AppThemeMode.system;
}
