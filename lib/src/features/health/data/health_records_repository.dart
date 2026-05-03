import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/packages/supabase/supabase_provider.dart';
import '../models/health_record.dart';

part 'health_records_repository.g.dart';

class HealthRecordsRepository {
  HealthRecordsRepository(this._client);

  final SupabaseClient _client;
  static const String _table = 'health_records';

  SupabaseQueryBuilder get _from => _client.from(_table);

  Future<List<HealthRecord>> listForStudent(String studentId) async {
    final rows = await _from
        .select()
        .eq('student_id', studentId)
        .filter('deleted_at', 'is', null)
        .order('recorded_at', ascending: false);
    return (rows as List)
        .map((r) => HealthRecord.fromRow(r as Map<String, dynamic>))
        .toList();
  }

  Future<HealthRecord?> getLatestForStudent(String studentId) async {
    final row = await _from
        .select()
        .eq('student_id', studentId)
        .filter('deleted_at', 'is', null)
        .order('recorded_at', ascending: false)
        .limit(1)
        .maybeSingle();
    return row == null ? null : HealthRecord.fromRow(row);
  }

  Future<HealthRecord?> getById(String id) async {
    final row = await _from
        .select()
        .eq('id', id)
        .filter('deleted_at', 'is', null)
        .maybeSingle();
    return row == null ? null : HealthRecord.fromRow(row);
  }

  Future<HealthRecord> create(HealthRecord record) async {
    final row = await _from.insert(record.toRow()).select().single();
    return HealthRecord.fromRow(row);
  }

  Future<HealthRecord> update(String id, Map<String, dynamic> patch) async {
    final row = await _from.update(patch).eq('id', id).select().single();
    return HealthRecord.fromRow(row);
  }

  Future<void> softDelete(String id) async {
    await _from
        .update({'deleted_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', id);
  }
}

@Riverpod(keepAlive: true)
HealthRecordsRepository healthRecordsRepository(Ref ref) =>
    HealthRecordsRepository(ref.watch(supabaseProvider));

@riverpod
Future<List<HealthRecord>> healthRecordsForStudent(
  Ref ref,
  String studentId,
) {
  return ref.watch(healthRecordsRepositoryProvider).listForStudent(studentId);
}

@riverpod
Future<HealthRecord?> latestHealthRecord(Ref ref, String studentId) {
  return ref
      .watch(healthRecordsRepositoryProvider)
      .getLatestForStudent(studentId);
}
