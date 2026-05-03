// Patches the `users` auth collection via PocketBase Admin API
// (`PATCH /api/collections/:id`):
// - `passwordAuth.identityFields` -> `["email"]` only
// - removes the `username` schema field (if present)
// - drops SQL indexes that reference the `username` column
// - sets the system `email` field to required
//
// Requires superuser credentials (_superusers), same as `pb_keep_users_only.dart`.
//
// Usage:
//   dart run tool/pb_users_email_only.dart
//       [--url http://127.0.0.1:8091]
//       [--email you@example.com] [--password secret]
//       [--env-file .env]
//       [--yes]
//
// Without --yes: prints the diff and exits 0.
// With --yes: applies the update.

import 'dart:io';

import 'package:pocketbase/pocketbase.dart';

void main(List<String> args) async {
  final apply = args.contains('--yes');
  final envFile = _readEnvFile(_valueAfter(args, '--env-file'));

  String? envLookup(String key) => Platform.environment[key] ?? envFile[key];

  final baseUrl = _valueAfter(args, '--url') ??
      envLookup('POCKETBASE_URL') ??
      envLookup('LOCAL_POCKETBASE_URL') ??
      envLookup('PROD_POCKETBASE_URL') ??
      envLookup('STAGING_POCKETBASE_URL') ??
      'http://127.0.0.1:8091';

  final email = _valueAfter(args, '--email') ??
      envLookup('POCKETBASE_SUPERUSER_EMAIL') ??
      envLookup('LOCAL_POCKETBASE_EMAIL') ??
      envLookup('PROD_POCKETBASE_EMAIL') ??
      envLookup('STAGING_POCKETBASE_EMAIL');

  final password = _valueAfter(args, '--password') ??
      envLookup('POCKETBASE_SUPERUSER_PASSWORD') ??
      envLookup('LOCAL_POCKETBASE_PASSWORD') ??
      envLookup('PROD_POCKETBASE_PASSWORD') ??
      envLookup('STAGING_POCKETBASE_PASSWORD');

  if (email == null || email.isEmpty || password == null || password.isEmpty) {
    stderr.writeln(
      'Missing superuser credentials. Pass --email / --password or set '
      'POCKETBASE_SUPERUSER_EMAIL and POCKETBASE_SUPERUSER_PASSWORD '
      '(or LOCAL_* / PROD_* keys via --env-file).',
    );
    exitCode = 64;
    return;
  }

  final pb = PocketBase(baseUrl.trimRight().replaceAll(RegExp(r'/+$'), ''));

  try {
    await pb.collection('_superusers').authWithPassword(
          email.trim(),
          password.trim(),
        );
  } on ClientException catch (e) {
    stderr.writeln(
      'Superuser auth failed (${e.statusCode}). '
      'Use a _superusers account from the PocketBase dashboard.',
    );
    stderr.writeln(e.response.toString());
    exitCode = 1;
    return;
  }

  final CollectionModel users;
  try {
    users = await pb.collections.getFirstListItem('name="users"');
  } on ClientException catch (e) {
    stderr.writeln('Failed to load users collection: ${e.statusCode}');
    stderr.writeln(e.response.toString());
    exitCode = 1;
    return;
  }

  if (users.type != 'auth') {
    stderr.writeln(
        'Collection `users` is not an auth collection (type=${users.type}).');
    exitCode = 1;
    return;
  }

  final before = users.toJson();
  final changed = _applyEmailOnlyAuth(users);

  if (!changed) {
    stderr.writeln('PocketBase: $baseUrl');
    stderr.writeln(
        '`users` is already email-only (no username field / index). Nothing to do.');
    return;
  }

  stderr.writeln('PocketBase: $baseUrl');
  stderr.writeln('Proposed changes to `users` collection:');
  _printJsonDiff(before, users.toJson());

  if (!apply) {
    stderr.writeln(
        '\nDry run only. Re-run with --yes to PATCH /api/collections/${users.id}.');
    return;
  }

  try {
    await pb.collections.update(users.id, body: users.toJson());
  } on ClientException catch (e) {
    stderr.writeln('Update failed (${e.statusCode}):');
    stderr.writeln(e.response.toString());
    exitCode = 1;
    return;
  }

  stdout.writeln('Updated `users` via Admin API (email-only password auth).');
}

/// Returns whether the model was modified.
bool _applyEmailOnlyAuth(CollectionModel c) {
  var changed = false;

  final existing = c.passwordAuth;
  const target = ['email'];
  if (existing == null || !_listEquals(existing.identityFields, target)) {
    c.passwordAuth = PasswordAuthConfig(
      enabled: existing?.enabled ?? true,
      identityFields: List<String>.from(target),
    );
    changed = true;
  }

  final withoutUsernameField =
      c.fields.where((f) => f.name != 'username').toList();
  if (withoutUsernameField.length != c.fields.length) {
    c.fields = withoutUsernameField;
    changed = true;
  }

  final withoutUsernameIndexes =
      c.indexes.where((sql) => !_indexReferencesUsernameColumn(sql)).toList();
  if (withoutUsernameIndexes.length != c.indexes.length) {
    c.indexes = withoutUsernameIndexes;
    changed = true;
  }

  for (final f in c.fields) {
    if (f.name == 'email' && f.type == 'email' && !f.required) {
      f.required = true;
      changed = true;
    }
  }

  return changed;
}

bool _indexReferencesUsernameColumn(String sql) {
  if (sql.contains('`username`')) return true;
  return RegExp(r'\(\s*username\s*\)').hasMatch(sql);
}

bool _listEquals(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

void _printJsonDiff(Map<String, dynamic> before, Map<String, dynamic> after) {
  for (final key in {...before.keys, ...after.keys}) {
    final vb = before[key];
    final va = after[key];
    if (_deepEquals(vb, va)) continue;
    stdout.writeln('  $key:');
    stdout.writeln('    - ${vb ?? '(null)'}');
    stdout.writeln('    + ${va ?? '(null)'}');
  }
}

bool _deepEquals(Object? a, Object? b) {
  if (a is Map && b is Map) {
    if (a.length != b.length) return false;
    for (final e in a.entries) {
      if (!_deepEquals(e.value, b[e.key])) return false;
    }
    return true;
  }
  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!_deepEquals(a[i], b[i])) return false;
    }
    return true;
  }
  return a == b;
}

String? _valueAfter(List<String> args, String flag) {
  final i = args.indexOf(flag);
  if (i < 0 || i + 1 >= args.length) return null;
  final v = args[i + 1];
  return v.isEmpty ? null : v;
}

Map<String, String> _readEnvFile(String? path) {
  if (path == null || path.isEmpty) return {};
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('Warning: env file not found: $path');
    return {};
  }
  final map = <String, String>{};
  for (final raw in file.readAsLinesSync()) {
    var line = raw.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final eq = line.indexOf('=');
    if (eq <= 0) continue;
    final key = line.substring(0, eq).trim();
    var value = line.substring(eq + 1).trim();
    if ((value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'"))) {
      value = value.substring(1, value.length - 1);
    }
    map[key] = value;
  }
  return map;
}
