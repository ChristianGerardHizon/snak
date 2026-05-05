import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_provider.g.dart';

class _RuntimeDeployConfig {
  const _RuntimeDeployConfig({
    this.environment,
    this.apiUrl,
    this.anonKey,
  });

  final String? environment;
  final String? apiUrl;
  final String? anonKey;
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
      anonKey: (json['anonKey'] as String?)?.trim(),
    );
  } catch (_) {
    // Ignore config fetch errors; compile-time/env fallback still works.
  }
}

/// Default Supabase project URL + anon key (single project across envs for now).
abstract class SupabaseConfig {
  static const String defaultUrl = 'https://yfhroqrcdykcbgofkoqy.supabase.co';
  static const String defaultAnonKey =
      'sb_publishable_xgFXpMlwB4BTuf9WS5cdZg_TeumESWK';
}

const String _env = String.fromEnvironment('ENV', defaultValue: '');
const String _apiUrlOverride =
    String.fromEnvironment('API_URL', defaultValue: '');
const String _anonKeyOverride =
    String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

/// Resolves the Supabase project URL.
String get supabaseUrl {
  if (_apiUrlOverride.isNotEmpty) return _apiUrlOverride;
  if (_runtimeDeployConfig?.apiUrl case final apiUrl? when apiUrl.isNotEmpty) {
    return apiUrl;
  }
  return SupabaseConfig.defaultUrl;
}

/// Resolves the Supabase anon (publishable) key.
String get supabaseAnonKey {
  if (_anonKeyOverride.isNotEmpty) return _anonKeyOverride;
  if (_runtimeDeployConfig?.anonKey case final key? when key.isNotEmpty) {
    return key;
  }
  return SupabaseConfig.defaultAnonKey;
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
String get appTitle {
  switch (currentEnvironment) {
    case 'dev':
      return 'Snack [Dev]';
    case 'staging':
      return 'Snack [Stg]';
    default:
      return 'Snack';
  }
}

/// Provides the singleton SupabaseClient.
@Riverpod(keepAlive: true)
SupabaseClient supabase(Ref ref) {
  return Supabase.instance.client;
}
