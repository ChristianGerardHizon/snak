// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'health_record.dart';

class BloodTypeMapper extends EnumMapper<BloodType> {
  BloodTypeMapper._();

  static BloodTypeMapper? _instance;
  static BloodTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BloodTypeMapper._());
    }
    return _instance!;
  }

  static BloodType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  BloodType decode(dynamic value) {
    switch (value) {
      case 'A+':
        return BloodType.aPos;
      case 'A-':
        return BloodType.aNeg;
      case 'B+':
        return BloodType.bPos;
      case 'B-':
        return BloodType.bNeg;
      case 'AB+':
        return BloodType.abPos;
      case 'AB-':
        return BloodType.abNeg;
      case 'O+':
        return BloodType.oPos;
      case 'O-':
        return BloodType.oNeg;
      case 'unknown':
        return BloodType.unknown;
      default:
        return BloodType.values[8];
    }
  }

  @override
  dynamic encode(BloodType self) {
    switch (self) {
      case BloodType.aPos:
        return 'A+';
      case BloodType.aNeg:
        return 'A-';
      case BloodType.bPos:
        return 'B+';
      case BloodType.bNeg:
        return 'B-';
      case BloodType.abPos:
        return 'AB+';
      case BloodType.abNeg:
        return 'AB-';
      case BloodType.oPos:
        return 'O+';
      case BloodType.oNeg:
        return 'O-';
      case BloodType.unknown:
        return 'unknown';
    }
  }
}

extension BloodTypeMapperExtension on BloodType {
  dynamic toValue() {
    BloodTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<BloodType>(this);
  }
}

class HealthRecordMapper extends ClassMapperBase<HealthRecord> {
  HealthRecordMapper._();

  static HealthRecordMapper? _instance;
  static HealthRecordMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = HealthRecordMapper._());
      BloodTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'HealthRecord';

  static String _$id(HealthRecord v) => v.id;
  static const Field<HealthRecord, String> _f$id = Field('id', _$id);
  static String _$studentId(HealthRecord v) => v.studentId;
  static const Field<HealthRecord, String> _f$studentId = Field(
    'studentId',
    _$studentId,
  );
  static BloodType? _$bloodType(HealthRecord v) => v.bloodType;
  static const Field<HealthRecord, BloodType> _f$bloodType = Field(
    'bloodType',
    _$bloodType,
    opt: true,
  );
  static double? _$heightCm(HealthRecord v) => v.heightCm;
  static const Field<HealthRecord, double> _f$heightCm = Field(
    'heightCm',
    _$heightCm,
    opt: true,
  );
  static double? _$weightKg(HealthRecord v) => v.weightKg;
  static const Field<HealthRecord, double> _f$weightKg = Field(
    'weightKg',
    _$weightKg,
    opt: true,
  );
  static String? _$allergies(HealthRecord v) => v.allergies;
  static const Field<HealthRecord, String> _f$allergies = Field(
    'allergies',
    _$allergies,
    opt: true,
  );
  static String? _$chronicConditions(HealthRecord v) => v.chronicConditions;
  static const Field<HealthRecord, String> _f$chronicConditions = Field(
    'chronicConditions',
    _$chronicConditions,
    opt: true,
  );
  static String? _$currentMedications(HealthRecord v) => v.currentMedications;
  static const Field<HealthRecord, String> _f$currentMedications = Field(
    'currentMedications',
    _$currentMedications,
    opt: true,
  );
  static String? _$immunizations(HealthRecord v) => v.immunizations;
  static const Field<HealthRecord, String> _f$immunizations = Field(
    'immunizations',
    _$immunizations,
    opt: true,
  );
  static String? _$emergencyContact(HealthRecord v) => v.emergencyContact;
  static const Field<HealthRecord, String> _f$emergencyContact = Field(
    'emergencyContact',
    _$emergencyContact,
    opt: true,
  );
  static String? _$emergencyPhone(HealthRecord v) => v.emergencyPhone;
  static const Field<HealthRecord, String> _f$emergencyPhone = Field(
    'emergencyPhone',
    _$emergencyPhone,
    opt: true,
  );
  static String? _$physicianName(HealthRecord v) => v.physicianName;
  static const Field<HealthRecord, String> _f$physicianName = Field(
    'physicianName',
    _$physicianName,
    opt: true,
  );
  static String? _$physicianPhone(HealthRecord v) => v.physicianPhone;
  static const Field<HealthRecord, String> _f$physicianPhone = Field(
    'physicianPhone',
    _$physicianPhone,
    opt: true,
  );
  static String? _$notes(HealthRecord v) => v.notes;
  static const Field<HealthRecord, String> _f$notes = Field(
    'notes',
    _$notes,
    opt: true,
  );
  static DateTime _$recordedAt(HealthRecord v) => v.recordedAt;
  static const Field<HealthRecord, DateTime> _f$recordedAt = Field(
    'recordedAt',
    _$recordedAt,
  );
  static DateTime _$createdAt(HealthRecord v) => v.createdAt;
  static const Field<HealthRecord, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime _$updatedAt(HealthRecord v) => v.updatedAt;
  static const Field<HealthRecord, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );
  static DateTime? _$deletedAt(HealthRecord v) => v.deletedAt;
  static const Field<HealthRecord, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    opt: true,
  );

  @override
  final MappableFields<HealthRecord> fields = const {
    #id: _f$id,
    #studentId: _f$studentId,
    #bloodType: _f$bloodType,
    #heightCm: _f$heightCm,
    #weightKg: _f$weightKg,
    #allergies: _f$allergies,
    #chronicConditions: _f$chronicConditions,
    #currentMedications: _f$currentMedications,
    #immunizations: _f$immunizations,
    #emergencyContact: _f$emergencyContact,
    #emergencyPhone: _f$emergencyPhone,
    #physicianName: _f$physicianName,
    #physicianPhone: _f$physicianPhone,
    #notes: _f$notes,
    #recordedAt: _f$recordedAt,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #deletedAt: _f$deletedAt,
  };

  static HealthRecord _instantiate(DecodingData data) {
    return HealthRecord(
      id: data.dec(_f$id),
      studentId: data.dec(_f$studentId),
      bloodType: data.dec(_f$bloodType),
      heightCm: data.dec(_f$heightCm),
      weightKg: data.dec(_f$weightKg),
      allergies: data.dec(_f$allergies),
      chronicConditions: data.dec(_f$chronicConditions),
      currentMedications: data.dec(_f$currentMedications),
      immunizations: data.dec(_f$immunizations),
      emergencyContact: data.dec(_f$emergencyContact),
      emergencyPhone: data.dec(_f$emergencyPhone),
      physicianName: data.dec(_f$physicianName),
      physicianPhone: data.dec(_f$physicianPhone),
      notes: data.dec(_f$notes),
      recordedAt: data.dec(_f$recordedAt),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static HealthRecord fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<HealthRecord>(map);
  }

  static HealthRecord fromJson(String json) {
    return ensureInitialized().decodeJson<HealthRecord>(json);
  }
}

mixin HealthRecordMappable {
  String toJson() {
    return HealthRecordMapper.ensureInitialized().encodeJson<HealthRecord>(
      this as HealthRecord,
    );
  }

  Map<String, dynamic> toMap() {
    return HealthRecordMapper.ensureInitialized().encodeMap<HealthRecord>(
      this as HealthRecord,
    );
  }

  HealthRecordCopyWith<HealthRecord, HealthRecord, HealthRecord> get copyWith =>
      _HealthRecordCopyWithImpl<HealthRecord, HealthRecord>(
        this as HealthRecord,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return HealthRecordMapper.ensureInitialized().stringifyValue(
      this as HealthRecord,
    );
  }

  @override
  bool operator ==(Object other) {
    return HealthRecordMapper.ensureInitialized().equalsValue(
      this as HealthRecord,
      other,
    );
  }

  @override
  int get hashCode {
    return HealthRecordMapper.ensureInitialized().hashValue(
      this as HealthRecord,
    );
  }
}

extension HealthRecordValueCopy<$R, $Out>
    on ObjectCopyWith<$R, HealthRecord, $Out> {
  HealthRecordCopyWith<$R, HealthRecord, $Out> get $asHealthRecord =>
      $base.as((v, t, t2) => _HealthRecordCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class HealthRecordCopyWith<$R, $In extends HealthRecord, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? studentId,
    BloodType? bloodType,
    double? heightCm,
    double? weightKg,
    String? allergies,
    String? chronicConditions,
    String? currentMedications,
    String? immunizations,
    String? emergencyContact,
    String? emergencyPhone,
    String? physicianName,
    String? physicianPhone,
    String? notes,
    DateTime? recordedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  HealthRecordCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _HealthRecordCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, HealthRecord, $Out>
    implements HealthRecordCopyWith<$R, HealthRecord, $Out> {
  _HealthRecordCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<HealthRecord> $mapper =
      HealthRecordMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? studentId,
    Object? bloodType = $none,
    Object? heightCm = $none,
    Object? weightKg = $none,
    Object? allergies = $none,
    Object? chronicConditions = $none,
    Object? currentMedications = $none,
    Object? immunizations = $none,
    Object? emergencyContact = $none,
    Object? emergencyPhone = $none,
    Object? physicianName = $none,
    Object? physicianPhone = $none,
    Object? notes = $none,
    DateTime? recordedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (studentId != null) #studentId: studentId,
      if (bloodType != $none) #bloodType: bloodType,
      if (heightCm != $none) #heightCm: heightCm,
      if (weightKg != $none) #weightKg: weightKg,
      if (allergies != $none) #allergies: allergies,
      if (chronicConditions != $none) #chronicConditions: chronicConditions,
      if (currentMedications != $none) #currentMedications: currentMedications,
      if (immunizations != $none) #immunizations: immunizations,
      if (emergencyContact != $none) #emergencyContact: emergencyContact,
      if (emergencyPhone != $none) #emergencyPhone: emergencyPhone,
      if (physicianName != $none) #physicianName: physicianName,
      if (physicianPhone != $none) #physicianPhone: physicianPhone,
      if (notes != $none) #notes: notes,
      if (recordedAt != null) #recordedAt: recordedAt,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  HealthRecord $make(CopyWithData data) => HealthRecord(
    id: data.get(#id, or: $value.id),
    studentId: data.get(#studentId, or: $value.studentId),
    bloodType: data.get(#bloodType, or: $value.bloodType),
    heightCm: data.get(#heightCm, or: $value.heightCm),
    weightKg: data.get(#weightKg, or: $value.weightKg),
    allergies: data.get(#allergies, or: $value.allergies),
    chronicConditions: data.get(
      #chronicConditions,
      or: $value.chronicConditions,
    ),
    currentMedications: data.get(
      #currentMedications,
      or: $value.currentMedications,
    ),
    immunizations: data.get(#immunizations, or: $value.immunizations),
    emergencyContact: data.get(#emergencyContact, or: $value.emergencyContact),
    emergencyPhone: data.get(#emergencyPhone, or: $value.emergencyPhone),
    physicianName: data.get(#physicianName, or: $value.physicianName),
    physicianPhone: data.get(#physicianPhone, or: $value.physicianPhone),
    notes: data.get(#notes, or: $value.notes),
    recordedAt: data.get(#recordedAt, or: $value.recordedAt),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  HealthRecordCopyWith<$R2, HealthRecord, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _HealthRecordCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

