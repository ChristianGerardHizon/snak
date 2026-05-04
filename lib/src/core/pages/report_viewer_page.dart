import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/health/data/health_records_repository.dart';
import '../../features/health/data/health_reports_repository.dart';
import '../../features/students/data/students_repository.dart';
import '../../features/students/models/student.dart';
import 'measurement_result_page.dart';

/// Renders the health-findings report for a given report id.
///
/// Used when a user enters a report code or scans a report QR from
/// [SplashPage]. Looks up the [HealthReport] and reuses
/// [MeasurementResultPage] to render it.
class ReportViewerPage extends ConsumerWidget {
  const ReportViewerPage({super.key, required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(healthReportByIdProvider(reportId));

    return reportAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => _ErrorScaffold(
        message: 'Could not load report: $e',
        onClose: () => Navigator.of(context).pop(),
      ),
      data: (report) {
        if (report == null) {
          return _ErrorScaffold(
            message: 'Report not found.\nCode: $reportId',
            onClose: () => Navigator.of(context).pop(),
          );
        }
        final studentAsync = ref.watch(studentByIdProvider(report.studentId));
        final recordAsync =
            ref.watch(latestHealthRecordProvider(report.studentId));
        final student = studentAsync.value;
        final record = recordAsync.value;
        final heightM = record?.heightCm == null
            ? null
            : record!.heightCm! / 100.0;
        final weightKg = record?.weightKg;
        final bmi = (heightM != null && weightKg != null && heightM > 0)
            ? weightKg / (heightM * heightM)
            : null;
        return MeasurementResultPage(
          outcome: _outcomeFrom(report.diagnosis),
          reportId: report.id,
          studentName: student?.fullName,
          schoolId: student?.studentNumber,
          age: _ageFromDob(student?.dateOfBirth),
          sex: _sexLabel(student?.sex),
          heightMeters: heightM,
          weightKg: weightKg,
          bmi: bmi,
          visitDate: report.visitDate,
          onDone: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  static int? _ageFromDob(DateTime? dob) {
    if (dob == null) return null;
    final now = DateTime.now();
    var age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age -= 1;
    }
    return age < 0 ? null : age;
  }

  static String? _sexLabel(StudentSex? sex) => switch (sex) {
        StudentSex.male => 'Male',
        StudentSex.female => 'Female',
        StudentSex.other => 'Other',
        null => null,
      };

  static MeasurementResultOutcome _outcomeFrom(String? diagnosis) {
    return MeasurementResultOutcome.values.firstWhere(
      (v) => v.name == diagnosis,
      orElse: () => MeasurementResultOutcome.normal,
    );
  }
}

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({required this.message, required this.onClose});

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
