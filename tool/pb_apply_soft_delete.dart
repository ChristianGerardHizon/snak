// Applies soft-delete schema and API rules via PocketBase Admin API
// (PATCH /api/collections/:id). No migration files.
//
// For each base collection: finance_accounts, finance_transactions,
// transaction_categories, budgets:
// - adds `isDeleted` (bool) if missing
// - sets deleteRule to `false` (hard delete denied for API clients; superusers
//   still manage data in the dashboard)
// - appends `&& isDeleted != true` to non-empty listRule / viewRule when
//   `isDeleted` is not already referenced
//
// For view `vw_finance_account_totals`:
// - appends `AND COALESCE(isDeleted, false) = false` to the SQL when absent
//
// Usage:
//   dart run tool/pb_apply_soft_delete.dart
//       [--url http://127.0.0.1:8091]
//       [--email you@example.com] [--password secret]
//       [--env-file .env]
//       [--yes]
//
// Without --yes: prints planned changes only.
// With --yes: applies updates.

import 'dart:io';

import 'package:pocketbase/pocketbase.dart';

const _baseCollections = <String>[
  'finance_accounts',
  'finance_transactions',
  'transaction_categories',
  'budgets',
];

const _accountTotalsView = 'vw_finance_account_totals';

/// Stable field ids (PocketBase requires an `id` on schema fields).
const _isDeletedFieldIds = <String, String>{
  'finance_accounts': 'bool_sd_finance_accounts',
  'finance_transactions': 'bool_sd_finance_transactions',
  'transaction_categories': 'bool_sd_transaction_categories',
  'budgets': 'bool_sd_budgets',
};

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
      envLookup('STAGING_POCKETBASE_EMAIL') ??
      envLookup('PB_PROD_EMAIL') ??
      envLookup('PB_STAGING_EMAIL');

  final password = _valueAfter(args, '--password') ??
      envLookup('POCKETBASE_SUPERUSER_PASSWORD') ??
      envLookup('LOCAL_POCKETBASE_PASSWORD') ??
      envLookup('PROD_POCKETBASE_PASSWORD') ??
      envLookup('STAGING_POCKETBASE_PASSWORD') ??
      envLookup('PB_PROD_PASSWORD') ??
      envLookup('PB_STAGING_PASSWORD');

  if (email == null || email.isEmpty || password == null || password.isEmpty) {
    stderr.writeln(
      'Missing superuser credentials. Pass --email / --password or set '
      'POCKETBASE_SUPERUSER_EMAIL + POCKETBASE_SUPERUSER_PASSWORD '
      '(or LOCAL_* / PROD_* / PB_* via --env-file).',
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

  stderr.writeln('PocketBase: $baseUrl');

  final patches = <String, Map<String, dynamic>>{};

  for (final name in _baseCollections) {
    final CollectionModel c;
    try {
      c = await pb.collections.getFirstListItem('name="$name"');
    } on ClientException catch (e) {
      stderr.writeln('Skip missing collection `$name` (${e.statusCode}).');
      continue;
    }

    if (c.type != 'base') {
      stderr.writeln('Skip `$name`: expected type base, got ${c.type}.');
      continue;
    }

    final before = c.toJson();
    final changed = _patchBaseCollection(c);
    if (changed) {
      patches[name] = _diffMaps(before, c.toJson());
    }
  }

  final CollectionModel? view = await _loadView(pb);
  if (view != null) {
    final before = view.toJson();
    final changed = _patchAccountTotalsView(view);
    if (changed) {
      patches[_accountTotalsView] = _diffMaps(before, view.toJson());
    }
  }

  if (patches.isEmpty) {
    stdout
        .writeln('Nothing to change (already applied or collections missing).');
    return;
  }

  for (final e in patches.entries) {
    stdout.writeln('\n=== ${e.key} ===');
    _printPatch(e.value);
  }

  if (!apply) {
    stderr.writeln(
      '\nDry run only. Re-run with --yes to PATCH collections via Admin API.',
    );
    return;
  }

  for (final name in _baseCollections) {
    if (!patches.containsKey(name)) continue;
    final c = await pb.collections.getFirstListItem('name="$name"');
    _patchBaseCollection(c);
    try {
      await pb.collections.update(c.id, body: c.toJson());
    } on ClientException catch (e) {
      stderr.writeln('PATCH failed for `$name` (${e.statusCode}):');
      stderr.writeln(e.response.toString());
      exitCode = 1;
      return;
    }
    stdout.writeln('Updated `$name`.');
  }

  if (patches.containsKey(_accountTotalsView) && view != null) {
    final v = await pb.collections.getFirstListItem(
      'name="$_accountTotalsView"',
    );
    _patchAccountTotalsView(v);
    try {
      await pb.collections.update(v.id, body: v.toJson());
    } on ClientException catch (e) {
      stderr.writeln(
        'PATCH failed for `$_accountTotalsView` (${e.statusCode}):',
      );
      stderr.writeln(e.response.toString());
      exitCode = 1;
      return;
    }
    stdout.writeln('Updated `$_accountTotalsView`.');
  }
}

Future<CollectionModel?> _loadView(PocketBase pb) async {
  try {
    return await pb.collections.getFirstListItem(
      'name="$_accountTotalsView"',
    );
  } on ClientException catch (e) {
    stderr.writeln(
      'Skip view `$_accountTotalsView` (${e.statusCode}).',
    );
    return null;
  }
}

bool _patchBaseCollection(CollectionModel c) {
  var changed = false;

  if (!c.fields.any((f) => f.name == 'isDeleted')) {
    final id = _isDeletedFieldIds[c.name];
    if (id == null) {
      stderr.writeln('No field id mapping for `${c.name}`.');
      return false;
    }
    c.fields = [
      ...c.fields,
      CollectionField({
        'id': id,
        'name': 'isDeleted',
        'type': 'bool',
        'system': false,
        'required': false,
        'presentable': false,
        'hidden': false,
      }),
    ];
    changed = true;
  }

  if (c.deleteRule != 'false') {
    c.deleteRule = 'false';
    changed = true;
  }

  final newList = _mergeSoftDeleteRule(c.listRule);
  if (newList != c.listRule) {
    c.listRule = newList;
    changed = true;
  }

  final newView = _mergeSoftDeleteRule(c.viewRule);
  if (newView != c.viewRule) {
    c.viewRule = newView;
    changed = true;
  }

  return changed;
}

/// Keeps `null`/empty rules unchanged (admin-only / inherited). Otherwise ensures
/// clients cannot see rows with `isDeleted = true`.
String? _mergeSoftDeleteRule(String? rule) {
  final r = rule?.trim();
  if (r == null || r.isEmpty) return rule;
  if (r.contains('isDeleted')) return rule;
  return '$r && isDeleted != true';
}

bool _patchAccountTotalsView(CollectionModel c) {
  if (c.type != 'view') {
    stderr.writeln(
      '`$_accountTotalsView` is not a view (type=${c.type}).',
    );
    return false;
  }
  var q = c.viewQuery ?? '';
  if (q.contains('isDeleted')) return false;
  q = q.trim();
  if (q.isEmpty) return false;
  c.viewQuery = '$q AND COALESCE(isDeleted, false) = false';
  return true;
}

Map<String, dynamic> _diffMaps(
  Map<String, dynamic> before,
  Map<String, dynamic> after,
) {
  final out = <String, dynamic>{};
  for (final key in {...before.keys, ...after.keys}) {
    final vb = before[key];
    final va = after[key];
    if (_deepEquals(vb, va)) continue;
    out[key] = va;
  }
  return out;
}

void _printPatch(Map<String, dynamic> patch) {
  for (final e in patch.entries) {
    stdout.writeln('  ${e.key}: ${e.value}');
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
