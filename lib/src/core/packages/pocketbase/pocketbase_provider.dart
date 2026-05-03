import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/secure_storage_provider.dart';

part 'pocketbase_provider.g.dart';

class _RuntimeDeployConfig {
  const _RuntimeDeployConfig({
    this.environment,
    this.apiUrl,
  });

  final String? environment;
  final String? apiUrl;
}

_RuntimeDeployConfig? _runtimeDeployConfig;

/// Loads optional runtime deploy config from web `config.json`.
///
/// This is best-effort and intentionally silent on failures so local
/// development and non-web platforms continue to work as before.
Future<void> initializeRuntimeDeployConfig() async {
  if (!kIsWeb) return;
  if (_runtimeDeployConfig != null) return;

  try {
    final uri = Uri.base.resolve('config.json');
    final response = await http.get(uri).timeout(const Duration(seconds: 3));
    if (response.statusCode != 200) return;

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    _runtimeDeployConfig = _RuntimeDeployConfig(
      environment: (json['environment'] as String?)?.trim(),
      apiUrl: (json['apiUrl'] as String?)?.trim(),
    );
  } catch (_) {
    // Ignore config fetch errors; compile-time/env fallback still works.
  }
}

/// Environment URLs for PocketBase
abstract class PocketBaseUrls {
  static const String dev = 'http://127.0.0.1:8091';
  static const String staging = 'https://staging.snak.hznsystems.com';
  static const String prod = 'https://snak.hznsystems.com';
}

/// Environment passed via --dart-define=ENV=<value>
/// Valid values: 'dev', 'staging', 'prod'
const String _env = String.fromEnvironment('ENV', defaultValue: '');

/// Optional URL override via --dart-define=API_URL=<url>
/// If set, this takes priority over ENV-based URL resolution.
const String _apiUrlOverride =
    String.fromEnvironment('API_URL', defaultValue: '');

/// Resolves the PocketBase URL based on environment configuration.
/// Priority:
/// 1) API_URL dart-define
/// 2) web config.json apiUrl
/// 3) ENV-based URL mapping
/// 4) web config.json environment mapping
/// 5) kDebugMode fallback
String get pocketbaseUrl {
  if (_apiUrlOverride.isNotEmpty) return _apiUrlOverride;
  if (_runtimeDeployConfig?.apiUrl case final apiUrl? when apiUrl.isNotEmpty) {
    return apiUrl;
  }

  switch (_env) {
    case 'prod':
      return PocketBaseUrls.prod;
    case 'staging':
      return PocketBaseUrls.staging;
    case 'dev':
      return PocketBaseUrls.dev;
    default:
      final configEnv = _runtimeDeployConfig?.environment;
      switch (configEnv) {
        case 'prod':
          return PocketBaseUrls.prod;
        case 'staging':
          return PocketBaseUrls.staging;
        case 'dev':
          return PocketBaseUrls.dev;
      }

      // Fallback: use kDebugMode for local development
      return kDebugMode ? PocketBaseUrls.dev : PocketBaseUrls.prod;
  }
}

/// Returns the current environment name for display/logging.
String get currentEnvironment {
  if (_env.isNotEmpty) return _env;
  if (_runtimeDeployConfig?.environment case final env? when env.isNotEmpty) {
    return env;
  }
  return kDebugMode ? 'dev' : 'prod';
}

/// Returns the app title based on environment.
/// - Dev: "Snak [Dev]"
/// - Staging: "Snak [Stg]"
/// - Production: "Snak"
String get appTitle {
  switch (currentEnvironment) {
    case 'dev':
      return 'Snak [Dev]';
    case 'staging':
      return 'Snak [Stg]';
    default:
      return 'Snak';
  }
}

/// Controller for toggling between dev and production PocketBase instances.
///
/// Stores the preference in secure storage and provides methods to toggle.
@Riverpod(keepAlive: true)
class PbDebugController extends _$PbDebugController {
  static const _key = 'pb_debug_mode';

  FlutterSecureStorage get _storage => ref.read(secureStorageProvider);

  @override
  Future<bool> build() async {
    final value = await _storage.read(key: _key);
    return value == 'true';
  }

  /// Toggle between dev and production mode.
  Future<void> toggle() async {
    final current = state.value ?? false;
    await _storage.write(key: _key, value: (!current).toString());
    ref.invalidateSelf();
  }

  /// Get the current debug mode value.
  Future<bool> get() async {
    final value = await _storage.read(key: _key);
    return value == 'true';
  }
}

/// Provides a singleton PocketBase instance.
///
/// The instance uses the URL resolved from --dart-define=ENV or falls back
/// to kDebugMode-based selection.
@Riverpod(keepAlive: true)
PocketBase pocketbase(Ref ref) {
  return PocketBase(pocketbaseUrl);
}
