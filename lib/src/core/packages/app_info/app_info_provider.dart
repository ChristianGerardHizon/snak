import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_info_provider.g.dart';

/// Provides app package information (version, build number, etc.).
///
/// Uses package_info_plus to get the actual values from pubspec.yaml.
@Riverpod(keepAlive: true)
Future<PackageInfo> appInfo(Ref ref) async {
  return PackageInfo.fromPlatform();
}
