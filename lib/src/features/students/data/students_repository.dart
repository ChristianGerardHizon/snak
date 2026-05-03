import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/foundation/sort_config.dart';
import '../../../core/packages/supabase/supabase_provider.dart';
import '../models/student.dart';

part 'students_repository.g.dart';

class StudentsRepository {
  StudentsRepository(this._client);

  final SupabaseClient _client;
  static const String _table = 'students';

  SupabaseQueryBuilder get _from => _client.from(_table);

  Future<List<Student>> list({
    String? search,
    String? gradeLevel,
    String? section,
    SortConfig sort = const SortConfig(field: 'last_name', descending: false),
    int limit = 50,
    int offset = 0,
  }) async {
    var q = _from.select().filter('deleted_at', 'is', null);
    if (gradeLevel != null && gradeLevel.isNotEmpty) {
      q = q.eq('grade_level', gradeLevel);
    }
    if (section != null && section.isNotEmpty) {
      q = q.eq('section', section);
    }
    if (search != null && search.isNotEmpty) {
      final term = '%$search%';
      q = q.or(
        'first_name.ilike.$term,last_name.ilike.$term,student_number.ilike.$term',
      );
    }
    final rows = await q
        .order(sort.field, ascending: !sort.descending)
        .range(offset, offset + limit - 1);
    return (rows as List)
        .map((r) => Student.fromRow(r as Map<String, dynamic>))
        .toList();
  }

  Future<Student?> getById(String id) async {
    final row = await _from
        .select()
        .eq('id', id)
        .filter('deleted_at', 'is', null)
        .maybeSingle();
    return row == null ? null : Student.fromRow(row);
  }

  Future<Student> create(Student student) async {
    final row = await _from.insert(student.toRow()).select().single();
    return Student.fromRow(row);
  }

  Future<Student> update(String id, Map<String, dynamic> patch) async {
    final row = await _from.update(patch).eq('id', id).select().single();
    return Student.fromRow(row);
  }

  /// Soft delete — sets `deleted_at` to now.
  Future<void> softDelete(String id) async {
    await _from
        .update({'deleted_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', id);
  }
}

@Riverpod(keepAlive: true)
StudentsRepository studentsRepository(Ref ref) =>
    StudentsRepository(ref.watch(supabaseProvider));

@riverpod
Future<List<Student>> studentsList(
  Ref ref, {
  String? search,
  String? gradeLevel,
  String? section,
}) {
  return ref.watch(studentsRepositoryProvider).list(
        search: search,
        gradeLevel: gradeLevel,
        section: section,
      );
}

@riverpod
Future<Student?> studentById(Ref ref, String id) {
  return ref.watch(studentsRepositoryProvider).getById(id);
}
