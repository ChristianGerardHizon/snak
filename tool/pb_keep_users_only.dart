// Deletes all PocketBase collections except:
// - system collections (internal PocketBase tables)
// - the `users` auth collection
//
// Requires superuser credentials (Dashboard > _superusers), not a regular app user.
//
// Usage:
//   dart run tool/pb_keep_users_only.dart
//       [--url http://127.0.0.1:8091]
//       [--email you@example.com] [--password secret]
//       [--env-file .env]
//       [--yes]
//
// Without --yes: lists what would be deleted and exits 0.
// With --yes: performs DELETE /api/collections/:id for each target.
//
// Env (optional): POCKETBASE_URL, POCKETBASE_SUPERUSER_EMAIL, POCKETBASE_SUPERUSER_PASSWORD
// --env-file: simple KEY=VALUE lines; same keys override if not set in process env.

import 'dart:io';

import 'package:pocketbase/pocketbase.dart';

void main(List<String> args) async {
  final execute = args.contains('--yes');
  final envFile = _readEnvFile(_valueAfter(args, '--env-file'));

  String? envLookup(String key) =>
      Platform.environment[key] ?? envFile[key];

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

  if (email == null ||
      email.isEmpty ||
      password == null ||
      password.isEmpty) {
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
      'Use a _superusers account from the PocketBase dashboard, not a regular users record.',
    );
    stderr.writeln(e.response.toString());
    exitCode = 1;
    return;
  }

  final List<CollectionModel> all;
  try {
    all = await pb.collections.getFullList(batch: 200);
  } on ClientException catch (e) {
    stderr.writeln('Failed to list collections: ${e.statusCode}');
    stderr.writeln(e.response.toString());
    exitCode = 1;
    return;
  }

  bool keep(CollectionModel c) {
    if (c.system) return true;
    if (c.name == 'users') return true;
    return false;
  }

  final toDelete = all.where((c) => !keep(c)).toList()
    ..sort((a, b) {
      if (a.type == 'view' && b.type != 'view') return -1;
      if (a.type != 'view' && b.type == 'view') return 1;
      return a.name.compareTo(b.name);
    });

  stderr.writeln('PocketBase: $baseUrl');
  stderr.writeln(
    'Keeping ${all.length - toDelete.length} collection(s); '
    'would delete ${toDelete.length}:',
  );
  for (final c in toDelete) {
    stderr.writeln('  - ${c.name} (${c.type}, id=${c.id})');
  }

  if (!execute) {
    stderr.writeln('\nDry run only. Re-run with --yes to delete.');
    return;
  }

  // Delete in dependency-safe order: views first, then base/auth collections.
  // PocketBase rejects deleting a collection while others still reference it,
  // so we retry in rounds until everything removable is gone.
  final pending = List<CollectionModel>.from(toDelete);
  final views = pending.where((c) => c.type == 'view').toList();
  final nonViews = pending.where((c) => c.type != 'view').toList();

  Future<bool> tryDelete(CollectionModel c) async {
    try {
      await pb.collections.delete(c.id);
      stdout.writeln('Deleted ${c.name} (${c.id})');
      return true;
    } on ClientException catch (e) {
      if (e.statusCode == 400) {
        return false;
      }
      stderr.writeln('Failed to delete ${c.name}: ${e.statusCode}');
      stderr.writeln(e.response.toString());
      rethrow;
    }
  }

  var deleteFailed = false;

  Future<void> deleteInRounds(List<CollectionModel> list, String label) async {
    var remaining = List<CollectionModel>.from(list);
    while (remaining.isNotEmpty) {
      var progressed = false;
      final nextRound = <CollectionModel>[];
      for (final c in remaining) {
        final ok = await tryDelete(c);
        if (ok) {
          progressed = true;
        } else {
          nextRound.add(c);
        }
      }
      if (!progressed) {
        stderr.writeln(
          '$label: could not delete ${nextRound.length} collection(s) '
          '(still referenced or other error). Remaining:',
        );
        for (final c in nextRound) {
          stderr.writeln('  - ${c.name} (${c.type}, id=${c.id})');
        }
        deleteFailed = true;
        return;
      }
      remaining = nextRound;
    }
  }

  await deleteInRounds(views, 'Views');
  if (deleteFailed) {
    exitCode = 1;
    return;
  }

  await _clearUsersRelationsToCollections(pb, all, toDelete);

  await _stripUsersSchemaRelationsToCollectionIds(
    pb,
    toDelete.map((c) => c.id).toSet(),
  );

  await deleteInRounds(nonViews, 'Collections');
  if (deleteFailed) {
    exitCode = 1;
    return;
  }

  stdout.writeln('Finished. Only system collections + `users` should remain.');
}

/// Nulls relation fields on `users` that point at collections we are removing,
/// so PocketBase can delete those collections (e.g. `branch` -> `branches`).
Future<void> _clearUsersRelationsToCollections(
  PocketBase pb,
  List<CollectionModel> all,
  List<CollectionModel> toDelete,
) async {
  final deleteIds = toDelete.map((c) => c.id).toSet();
  CollectionModel? users;
  try {
    users = all.firstWhere((c) => c.name == 'users');
  } catch (_) {
    return;
  }

  final bodyTemplate = <String, dynamic>{};
  for (final f in users.fields) {
    if (f.type != 'relation') continue;
    // PocketBase stores target id as top-level `collectionId` on the field;
    // some setups nest it under `options.collectionId`.
    var targetId = f.get<String>('collectionId', '');
    if (targetId.isEmpty) {
      targetId = f.get<String>('options.collectionId', '');
    }
    if (targetId.isEmpty || !deleteIds.contains(targetId)) continue;
    final maxSelect = f.get<int>('options.maxSelect', 1);
    bodyTemplate[f.name] = maxSelect > 1 ? <String>[] : null;
  }

  if (bodyTemplate.isEmpty) return;

  stdout.writeln(
    'Clearing `users` relation fields that reference deleted collections: '
    '${bodyTemplate.keys.join(", ")}',
  );

  final records = await pb.collection('users').getFullList(batch: 200);
  for (final r in records) {
    await pb.collection('users').update(r.id, body: bodyTemplate);
  }
}

/// Removes `users` relation *fields* that point at collections we delete.
/// Clearing record values is not enough: PocketBase still blocks dropping the
/// target collection while the auth schema defines a relation to it.
Future<void> _stripUsersSchemaRelationsToCollectionIds(
  PocketBase pb,
  Set<String> deleteCollectionIds,
) async {
  final users = await pb.collections.getFirstListItem('name="users"');
  final newFields = users.fields.where((f) {
    if (f.type != 'relation') return true;
    var targetId = f.get<String>('collectionId', '');
    if (targetId.isEmpty) {
      targetId = f.get<String>('options.collectionId', '');
    }
    if (targetId.isEmpty) return true;
    return !deleteCollectionIds.contains(targetId);
  }).toList();

  if (newFields.length == users.fields.length) return;

  users.fields = newFields;
  stdout.writeln(
    'Patching `users` collection schema (dropping relation fields to deleted collections)...',
  );
  await pb.collections.update(users.id, body: users.toJson());
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
