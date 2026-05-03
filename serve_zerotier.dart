import 'dart:io';

void main() async {
  final root = File(Platform.script.toFilePath()).parent.path;
  final serverDir = '$root/server';

  final pb = _findBinary(serverDir);
  if (pb == null) {
    stderr.writeln('Error: pocketbase binary not found in PATH or server/');
    exit(1);
  }

  print('Starting PocketBase server for ZeroTier access...');
  print('Data dir:   $serverDir/pb_data');
  print('Hooks dir:  $serverDir/pb_hooks');
  print('Public dir: $serverDir/pb_public');
  print('Migrations: $serverDir/pb_migrations');
  print('Listening on: 0.0.0.0:8091');
  print('Use your host ZeroTier IP: http://<zerotier-ip>:8091');

  final process = await Process.start(
    pb,
    [
      'serve',
      '--dir',
      '$serverDir/pb_data',
      '--hooksDir',
      '$serverDir/pb_hooks',
      '--publicDir',
      '$serverDir/pb_public',
      '--migrationsDir',
      '$serverDir/pb_migrations',
      '--http',
      '0.0.0.0:8091',
      '--dev',
    ],
    mode: ProcessStartMode.inheritStdio,
  );

  exit(await process.exitCode);
}

String? _findBinary(String serverDir) {
  final isWindows = Platform.isWindows;

  // Check PATH first.
  final which = isWindows ? 'where' : 'which';
  final result = Process.runSync(which, ['pocketbase']);
  if (result.exitCode == 0) return 'pocketbase';

  // Fallback to server/ directory.
  final localBin = '$serverDir/pocketbase${isWindows ? '.exe' : ''}';
  if (File(localBin).existsSync()) return localBin;

  return null;
}
