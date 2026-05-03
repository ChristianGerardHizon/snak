import 'package:dart_mappable/dart_mappable.dart';

import '../../../core/utils/date_utils.dart';

part 'health_report.mapper.dart';

@MappableClass()
class ReportFile with ReportFileMappable {
  const ReportFile({
    required this.id,
    required this.reportId,
    required this.storagePath,
    required this.fileName,
    this.mimeType,
    this.sizeBytes,
    required this.createdAt,
  });

  final String id;
  final String reportId;
  final String storagePath;
  final String fileName;
  final String? mimeType;
  final int? sizeBytes;
  final DateTime createdAt;

  factory ReportFile.fromRow(Map<String, dynamic> row) => ReportFile(
        id: row['id'] as String,
        reportId: row['report_id'] as String,
        storagePath: row['storage_path'] as String,
        fileName: row['file_name'] as String,
        mimeType: row['mime_type'] as String?,
        sizeBytes: (row['size_bytes'] as num?)?.toInt(),
        createdAt: parseToLocal(row['created_at'] as String?) ?? timestampFallback,
      );

  Map<String, dynamic> toRow() => {
        'report_id': reportId,
        'storage_path': storagePath,
        'file_name': fileName,
        if (mimeType != null) 'mime_type': mimeType,
        if (sizeBytes != null) 'size_bytes': sizeBytes,
      };
}

@MappableClass()
class HealthReport with HealthReportMappable {
  const HealthReport({
    required this.id,
    required this.studentId,
    required this.visitDate,
    this.complaint,
    this.diagnosis,
    this.treatment,
    this.vitalsTempC,
    this.vitalsBp,
    this.vitalsHr,
    this.notes,
    this.reportedBy,
    this.files = const [],
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String studentId;
  final DateTime visitDate;
  final String? complaint;
  final String? diagnosis;
  final String? treatment;
  final double? vitalsTempC;
  final String? vitalsBp;
  final int? vitalsHr;
  final String? notes;
  final String? reportedBy;
  final List<ReportFile> files;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  factory HealthReport.fromRow(
    Map<String, dynamic> row, {
    List<ReportFile> files = const [],
  }) =>
      HealthReport(
        id: row['id'] as String,
        studentId: row['student_id'] as String,
        visitDate: parseToLocal(row['visit_date'] as String?) ?? timestampFallback,
        complaint: row['complaint'] as String?,
        diagnosis: row['diagnosis'] as String?,
        treatment: row['treatment'] as String?,
        vitalsTempC: (row['vitals_temp_c'] as num?)?.toDouble(),
        vitalsBp: row['vitals_bp'] as String?,
        vitalsHr: (row['vitals_hr'] as num?)?.toInt(),
        notes: row['notes'] as String?,
        reportedBy: row['reported_by'] as String?,
        files: files,
        createdAt: parseToLocal(row['created_at'] as String?) ?? timestampFallback,
        updatedAt: parseToLocal(row['updated_at'] as String?) ?? timestampFallback,
        deletedAt: parseToLocal(row['deleted_at'] as String?),
      );

  Map<String, dynamic> toRow() => {
        'student_id': studentId,
        'visit_date': visitDate.toUtcIso8601(),
        if (complaint != null) 'complaint': complaint,
        if (diagnosis != null) 'diagnosis': diagnosis,
        if (treatment != null) 'treatment': treatment,
        if (vitalsTempC != null) 'vitals_temp_c': vitalsTempC,
        if (vitalsBp != null) 'vitals_bp': vitalsBp,
        if (vitalsHr != null) 'vitals_hr': vitalsHr,
        if (notes != null) 'notes': notes,
        if (reportedBy != null) 'reported_by': reportedBy,
      };
}
