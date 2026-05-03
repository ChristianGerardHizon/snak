import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/packages/supabase/supabase_provider.dart';
import '../models/health_report.dart';

part 'health_reports_repository.g.dart';

class HealthReportsRepository {
  HealthReportsRepository(this._client);

  final SupabaseClient _client;
  static const String _table = 'health_reports';
  static const String _filesTable = 'report_files';
  static const String _bucket = 'health-files';

  SupabaseQueryBuilder get _from => _client.from(_table);
  SupabaseQueryBuilder get _filesFrom => _client.from(_filesTable);

  Future<List<HealthReport>> listForStudent(String studentId) async {
    final rows = await _from
        .select('*, $_filesTable(*)')
        .eq('student_id', studentId)
        .filter('deleted_at', 'is', null)
        .order('visit_date', ascending: false);
    return (rows as List).map(_rowToReport).toList();
  }

  Future<HealthReport?> getById(String id) async {
    final row = await _from
        .select('*, $_filesTable(*)')
        .eq('id', id)
        .filter('deleted_at', 'is', null)
        .maybeSingle();
    return row == null ? null : _rowToReport(row);
  }

  Future<HealthReport> create(HealthReport report) async {
    final row = await _from.insert(report.toRow()).select().single();
    return HealthReport.fromRow(row);
  }

  Future<HealthReport> update(String id, Map<String, dynamic> patch) async {
    final row = await _from.update(patch).eq('id', id).select().single();
    return HealthReport.fromRow(row);
  }

  Future<void> softDelete(String id) async {
    await _from
        .update({'deleted_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', id);
  }

  /// Uploads a file to the `health-files` bucket and registers it in `report_files`.
  Future<ReportFile> attachFile({
    required String reportId,
    required String fileName,
    required Uint8List bytes,
    String? mimeType,
  }) async {
    final path = '$reportId/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    await _client.storage.from(_bucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: mimeType,
            upsert: false,
          ),
        );
    final row = await _filesFrom.insert({
      'report_id': reportId,
      'storage_path': path,
      'file_name': fileName,
      if (mimeType != null) 'mime_type': mimeType,
      'size_bytes': bytes.length,
    }).select().single();
    return ReportFile.fromRow(row);
  }

  Future<void> removeFile(ReportFile file) async {
    await _client.storage.from(_bucket).remove([file.storagePath]);
    await _filesFrom.delete().eq('id', file.id);
  }

  /// Returns a signed URL for a private file (default 1h validity).
  Future<String> signedUrlFor(ReportFile file,
      {Duration validity = const Duration(hours: 1)}) {
    return _client.storage
        .from(_bucket)
        .createSignedUrl(file.storagePath, validity.inSeconds);
  }

  HealthReport _rowToReport(dynamic row) {
    final map = row as Map<String, dynamic>;
    final filesRaw = (map[_filesTable] as List?) ?? const [];
    final files = filesRaw
        .map((f) => ReportFile.fromRow(f as Map<String, dynamic>))
        .toList();
    return HealthReport.fromRow(map, files: files);
  }
}

@Riverpod(keepAlive: true)
HealthReportsRepository healthReportsRepository(Ref ref) =>
    HealthReportsRepository(ref.watch(supabaseProvider));

@riverpod
Future<List<HealthReport>> healthReportsForStudent(
  Ref ref,
  String studentId,
) {
  return ref.watch(healthReportsRepositoryProvider).listForStudent(studentId);
}

@riverpod
Future<HealthReport?> healthReportById(Ref ref, String id) {
  return ref.watch(healthReportsRepositoryProvider).getById(id);
}
