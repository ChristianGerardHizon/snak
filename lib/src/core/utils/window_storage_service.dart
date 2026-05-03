import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Storage key for window size persistence.
const _windowSizeKey = 'WINDOW_SIZE';

/// Service for persisting window size without Riverpod dependency.
///
/// Used in main.dart before ProviderScope is available.
class WindowStorageService {
  static const _storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Loads saved window size from storage.
  /// Returns null if no saved size exists.
  static Future<Size?> loadWindowSize() async {
    try {
      final json = await _storage.read(key: _windowSizeKey);
      if (json == null) return null;

      final data = jsonDecode(json) as Map<String, dynamic>;
      return Size(
        (data['width'] as num).toDouble(),
        (data['height'] as num).toDouble(),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to load window size: $e');
      }
      return null;
    }
  }

  /// Saves window size to storage.
  static Future<void> saveWindowSize(Size size) async {
    try {
      final json = jsonEncode({
        'width': size.width,
        'height': size.height,
      });
      await _storage.write(key: _windowSizeKey, value: json);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to save window size: $e');
      }
    }
  }
}
