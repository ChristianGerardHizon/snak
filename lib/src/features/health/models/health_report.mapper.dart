// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'health_report.dart';

class ReportFileMapper extends ClassMapperBase<ReportFile> {
  ReportFileMapper._();

  static ReportFileMapper? _instance;
  static ReportFileMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReportFileMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ReportFile';

  static String _$id(ReportFile v) => v.id;
  static const Field<ReportFile, String> _f$id = Field('id', _$id);
  static String _$reportId(ReportFile v) => v.reportId;
  static const Field<ReportFile, String> _f$reportId = Field(
    'reportId',
    _$reportId,
  );
  static String _$storagePath(ReportFile v) => v.storagePath;
  static const Field<ReportFile, String> _f$storagePath = Field(
    'storagePath',
    _$storagePath,
  );
  static String _$fileName(ReportFile v) => v.fileName;
  static const Field<ReportFile, String> _f$fileName = Field(
    'fileName',
    _$fileName,
  );
  static String? _$mimeType(ReportFile v) => v.mimeType;
  static const Field<ReportFile, String> _f$mimeType = Field(
    'mimeType',
    _$mimeType,
    opt: true,
  );
  static int? _$sizeBytes(ReportFile v) => v.sizeBytes;
  static const Field<ReportFile, int> _f$sizeBytes = Field(
    'sizeBytes',
    _$sizeBytes,
    opt: true,
  );
  static DateTime _$createdAt(ReportFile v) => v.createdAt;
  static const Field<ReportFile, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );

  @override
  final MappableFields<ReportFile> fields = const {
    #id: _f$id,
    #reportId: _f$reportId,
    #storagePath: _f$storagePath,
    #fileName: _f$fileName,
    #mimeType: _f$mimeType,
    #sizeBytes: _f$sizeBytes,
    #createdAt: _f$createdAt,
  };

  static ReportFile _instantiate(DecodingData data) {
    return ReportFile(
      id: data.dec(_f$id),
      reportId: data.dec(_f$reportId),
      storagePath: data.dec(_f$storagePath),
      fileName: data.dec(_f$fileName),
      mimeType: data.dec(_f$mimeType),
      sizeBytes: data.dec(_f$sizeBytes),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ReportFile fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReportFile>(map);
  }

  static ReportFile fromJson(String json) {
    return ensureInitialized().decodeJson<ReportFile>(json);
  }
}

mixin ReportFileMappable {
  String toJson() {
    return ReportFileMapper.ensureInitialized().encodeJson<ReportFile>(
      this as ReportFile,
    );
  }

  Map<String, dynamic> toMap() {
    return ReportFileMapper.ensureInitialized().encodeMap<ReportFile>(
      this as ReportFile,
    );
  }

  ReportFileCopyWith<ReportFile, ReportFile, ReportFile> get copyWith =>
      _ReportFileCopyWithImpl<ReportFile, ReportFile>(
        this as ReportFile,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ReportFileMapper.ensureInitialized().stringifyValue(
      this as ReportFile,
    );
  }

  @override
  bool operator ==(Object other) {
    return ReportFileMapper.ensureInitialized().equalsValue(
      this as ReportFile,
      other,
    );
  }

  @override
  int get hashCode {
    return ReportFileMapper.ensureInitialized().hashValue(this as ReportFile);
  }
}

extension ReportFileValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReportFile, $Out> {
  ReportFileCopyWith<$R, ReportFile, $Out> get $asReportFile =>
      $base.as((v, t, t2) => _ReportFileCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReportFileCopyWith<$R, $In extends ReportFile, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? reportId,
    String? storagePath,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    DateTime? createdAt,
  });
  ReportFileCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReportFileCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReportFile, $Out>
    implements ReportFileCopyWith<$R, ReportFile, $Out> {
  _ReportFileCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReportFile> $mapper =
      ReportFileMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? reportId,
    String? storagePath,
    String? fileName,
    Object? mimeType = $none,
    Object? sizeBytes = $none,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (reportId != null) #reportId: reportId,
      if (storagePath != null) #storagePath: storagePath,
      if (fileName != null) #fileName: fileName,
      if (mimeType != $none) #mimeType: mimeType,
      if (sizeBytes != $none) #sizeBytes: sizeBytes,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  ReportFile $make(CopyWithData data) => ReportFile(
    id: data.get(#id, or: $value.id),
    reportId: data.get(#reportId, or: $value.reportId),
    storagePath: data.get(#storagePath, or: $value.storagePath),
    fileName: data.get(#fileName, or: $value.fileName),
    mimeType: data.get(#mimeType, or: $value.mimeType),
    sizeBytes: data.get(#sizeBytes, or: $value.sizeBytes),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  ReportFileCopyWith<$R2, ReportFile, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ReportFileCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class HealthReportMapper extends ClassMapperBase<HealthReport> {
  HealthReportMapper._();

  static HealthReportMapper? _instance;
  static HealthReportMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = HealthReportMapper._());
      ReportFileMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'HealthReport';

  static String _$id(HealthReport v) => v.id;
  static const Field<HealthReport, String> _f$id = Field('id', _$id);
  static String _$studentId(HealthReport v) => v.studentId;
  static const Field<HealthReport, String> _f$studentId = Field(
    'studentId',
    _$studentId,
  );
  static DateTime _$visitDate(HealthReport v) => v.visitDate;
  static const Field<HealthReport, DateTime> _f$visitDate = Field(
    'visitDate',
    _$visitDate,
  );
  static String? _$complaint(HealthReport v) => v.complaint;
  static const Field<HealthReport, String> _f$complaint = Field(
    'complaint',
    _$complaint,
    opt: true,
  );
  static String? _$diagnosis(HealthReport v) => v.diagnosis;
  static const Field<HealthReport, String> _f$diagnosis = Field(
    'diagnosis',
    _$diagnosis,
    opt: true,
  );
  static String? _$treatment(HealthReport v) => v.treatment;
  static const Field<HealthReport, String> _f$treatment = Field(
    'treatment',
    _$treatment,
    opt: true,
  );
  static double? _$vitalsTempC(HealthReport v) => v.vitalsTempC;
  static const Field<HealthReport, double> _f$vitalsTempC = Field(
    'vitalsTempC',
    _$vitalsTempC,
    opt: true,
  );
  static String? _$vitalsBp(HealthReport v) => v.vitalsBp;
  static const Field<HealthReport, String> _f$vitalsBp = Field(
    'vitalsBp',
    _$vitalsBp,
    opt: true,
  );
  static int? _$vitalsHr(HealthReport v) => v.vitalsHr;
  static const Field<HealthReport, int> _f$vitalsHr = Field(
    'vitalsHr',
    _$vitalsHr,
    opt: true,
  );
  static String? _$notes(HealthReport v) => v.notes;
  static const Field<HealthReport, String> _f$notes = Field(
    'notes',
    _$notes,
    opt: true,
  );
  static String? _$reportedBy(HealthReport v) => v.reportedBy;
  static const Field<HealthReport, String> _f$reportedBy = Field(
    'reportedBy',
    _$reportedBy,
    opt: true,
  );
  static List<ReportFile> _$files(HealthReport v) => v.files;
  static const Field<HealthReport, List<ReportFile>> _f$files = Field(
    'files',
    _$files,
    opt: true,
    def: const [],
  );
  static DateTime _$createdAt(HealthReport v) => v.createdAt;
  static const Field<HealthReport, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime _$updatedAt(HealthReport v) => v.updatedAt;
  static const Field<HealthReport, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );
  static DateTime? _$deletedAt(HealthReport v) => v.deletedAt;
  static const Field<HealthReport, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    opt: true,
  );

  @override
  final MappableFields<HealthReport> fields = const {
    #id: _f$id,
    #studentId: _f$studentId,
    #visitDate: _f$visitDate,
    #complaint: _f$complaint,
    #diagnosis: _f$diagnosis,
    #treatment: _f$treatment,
    #vitalsTempC: _f$vitalsTempC,
    #vitalsBp: _f$vitalsBp,
    #vitalsHr: _f$vitalsHr,
    #notes: _f$notes,
    #reportedBy: _f$reportedBy,
    #files: _f$files,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #deletedAt: _f$deletedAt,
  };

  static HealthReport _instantiate(DecodingData data) {
    return HealthReport(
      id: data.dec(_f$id),
      studentId: data.dec(_f$studentId),
      visitDate: data.dec(_f$visitDate),
      complaint: data.dec(_f$complaint),
      diagnosis: data.dec(_f$diagnosis),
      treatment: data.dec(_f$treatment),
      vitalsTempC: data.dec(_f$vitalsTempC),
      vitalsBp: data.dec(_f$vitalsBp),
      vitalsHr: data.dec(_f$vitalsHr),
      notes: data.dec(_f$notes),
      reportedBy: data.dec(_f$reportedBy),
      files: data.dec(_f$files),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static HealthReport fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<HealthReport>(map);
  }

  static HealthReport fromJson(String json) {
    return ensureInitialized().decodeJson<HealthReport>(json);
  }
}

mixin HealthReportMappable {
  String toJson() {
    return HealthReportMapper.ensureInitialized().encodeJson<HealthReport>(
      this as HealthReport,
    );
  }

  Map<String, dynamic> toMap() {
    return HealthReportMapper.ensureInitialized().encodeMap<HealthReport>(
      this as HealthReport,
    );
  }

  HealthReportCopyWith<HealthReport, HealthReport, HealthReport> get copyWith =>
      _HealthReportCopyWithImpl<HealthReport, HealthReport>(
        this as HealthReport,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return HealthReportMapper.ensureInitialized().stringifyValue(
      this as HealthReport,
    );
  }

  @override
  bool operator ==(Object other) {
    return HealthReportMapper.ensureInitialized().equalsValue(
      this as HealthReport,
      other,
    );
  }

  @override
  int get hashCode {
    return HealthReportMapper.ensureInitialized().hashValue(
      this as HealthReport,
    );
  }
}

extension HealthReportValueCopy<$R, $Out>
    on ObjectCopyWith<$R, HealthReport, $Out> {
  HealthReportCopyWith<$R, HealthReport, $Out> get $asHealthReport =>
      $base.as((v, t, t2) => _HealthReportCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class HealthReportCopyWith<$R, $In extends HealthReport, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, ReportFile, ReportFileCopyWith<$R, ReportFile, ReportFile>>
  get files;
  $R call({
    String? id,
    String? studentId,
    DateTime? visitDate,
    String? complaint,
    String? diagnosis,
    String? treatment,
    double? vitalsTempC,
    String? vitalsBp,
    int? vitalsHr,
    String? notes,
    String? reportedBy,
    List<ReportFile>? files,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  HealthReportCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _HealthReportCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, HealthReport, $Out>
    implements HealthReportCopyWith<$R, HealthReport, $Out> {
  _HealthReportCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<HealthReport> $mapper =
      HealthReportMapper.ensureInitialized();
  @override
  ListCopyWith<$R, ReportFile, ReportFileCopyWith<$R, ReportFile, ReportFile>>
  get files => ListCopyWith(
    $value.files,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(files: v),
  );
  @override
  $R call({
    String? id,
    String? studentId,
    DateTime? visitDate,
    Object? complaint = $none,
    Object? diagnosis = $none,
    Object? treatment = $none,
    Object? vitalsTempC = $none,
    Object? vitalsBp = $none,
    Object? vitalsHr = $none,
    Object? notes = $none,
    Object? reportedBy = $none,
    List<ReportFile>? files,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (studentId != null) #studentId: studentId,
      if (visitDate != null) #visitDate: visitDate,
      if (complaint != $none) #complaint: complaint,
      if (diagnosis != $none) #diagnosis: diagnosis,
      if (treatment != $none) #treatment: treatment,
      if (vitalsTempC != $none) #vitalsTempC: vitalsTempC,
      if (vitalsBp != $none) #vitalsBp: vitalsBp,
      if (vitalsHr != $none) #vitalsHr: vitalsHr,
      if (notes != $none) #notes: notes,
      if (reportedBy != $none) #reportedBy: reportedBy,
      if (files != null) #files: files,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  HealthReport $make(CopyWithData data) => HealthReport(
    id: data.get(#id, or: $value.id),
    studentId: data.get(#studentId, or: $value.studentId),
    visitDate: data.get(#visitDate, or: $value.visitDate),
    complaint: data.get(#complaint, or: $value.complaint),
    diagnosis: data.get(#diagnosis, or: $value.diagnosis),
    treatment: data.get(#treatment, or: $value.treatment),
    vitalsTempC: data.get(#vitalsTempC, or: $value.vitalsTempC),
    vitalsBp: data.get(#vitalsBp, or: $value.vitalsBp),
    vitalsHr: data.get(#vitalsHr, or: $value.vitalsHr),
    notes: data.get(#notes, or: $value.notes),
    reportedBy: data.get(#reportedBy, or: $value.reportedBy),
    files: data.get(#files, or: $value.files),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  HealthReportCopyWith<$R2, HealthReport, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _HealthReportCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

