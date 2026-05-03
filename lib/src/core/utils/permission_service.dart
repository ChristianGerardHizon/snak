import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

/// Exception thrown when a required permission is denied.
class PermissionDeniedException implements Exception {
  const PermissionDeniedException(this.message, {this.isPermanent = false});

  final String message;

  /// Whether the permission was permanently denied (user must go to settings).
  final bool isPermanent;

  @override
  String toString() => message;
}

/// Centralized service for handling runtime permission requests.
class PermissionService {
  /// Ensures Bluetooth permissions are granted (Android/iOS only).
  ///
  /// On Android 12+ (API 31+): requests bluetoothConnect, bluetoothScan,
  /// and locationWhenInUse.
  /// On iOS: requests bluetooth permission.
  /// On web/desktop: returns true (no permissions needed).
  ///
  /// Throws [PermissionDeniedException] if permissions are denied.
  static Future<bool> ensureBluetoothPermissions() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return true;

    List<Permission> permissions = [];

    if (Platform.isAndroid) {
      permissions = [
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
        Permission.locationWhenInUse,
      ];
    } else if (Platform.isIOS) {
      permissions = [Permission.bluetooth];
    }

    final statuses = await permissions.request();

    // Check if any are permanently denied
    final permanentlyDenied =
        statuses.entries.where((e) => e.value.isPermanentlyDenied).toList();
    if (permanentlyDenied.isNotEmpty) {
      throw const PermissionDeniedException(
        'Bluetooth permissions are permanently denied. '
        'Please enable them in app settings.',
        isPermanent: true,
      );
    }

    // Check if all granted
    final allGranted = statuses.values.every((s) => s.isGranted);
    if (!allGranted) {
      throw const PermissionDeniedException(
        'Bluetooth permissions are required to discover and connect to printers.',
      );
    }

    return true;
  }

  /// Ensures storage permissions for file saving (Android only).
  ///
  /// On Android < 13 (API 33): requests WRITE_EXTERNAL_STORAGE.
  /// On Android 13+, iOS, web, desktop: returns true (not needed).
  ///
  /// Throws [PermissionDeniedException] if permission is denied.
  static Future<bool> ensureStoragePermissions() async {
    if (kIsWeb || !Platform.isAndroid) return true;

    final status = await Permission.storage.request();

    if (status.isPermanentlyDenied) {
      throw const PermissionDeniedException(
        'Storage permission is permanently denied. '
        'Please enable it in app settings.',
        isPermanent: true,
      );
    }

    // On Android 13+, storage permission returns denied but
    // file_saver/printing handle their own scoped access, so we allow it.
    return status.isGranted || status.isLimited;
  }

  /// Opens the app settings page so the user can manually grant permissions.
  static Future<bool> openSettings() => openAppSettings();
}
