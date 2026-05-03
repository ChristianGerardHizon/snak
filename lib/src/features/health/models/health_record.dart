import 'package:dart_mappable/dart_mappable.dart';

import '../../../core/utils/date_utils.dart';

part 'health_record.mapper.dart';

@MappableEnum(defaultValue: BloodType.unknown)
enum BloodType {
  @MappableValue('A+') aPos,
  @MappableValue('A-') aNeg,
  @MappableValue('B+') bPos,
  @MappableValue('B-') bNeg,
  @MappableValue('AB+') abPos,
  @MappableValue('AB-') abNeg,
  @MappableValue('O+') oPos,
  @MappableValue('O-') oNeg,
  @MappableValue('unknown') unknown;

  String get dbValue => switch (this) {
        BloodType.aPos => 'A+',
        BloodType.aNeg => 'A-',
        BloodType.bPos => 'B+',
        BloodType.bNeg => 'B-',
        BloodType.abPos => 'AB+',
        BloodType.abNeg => 'AB-',
        BloodType.oPos => 'O+',
        BloodType.oNeg => 'O-',
        BloodType.unknown => 'unknown',
      };
}

@MappableClass()
class HealthRecord with HealthRecordMappable {
  const HealthRecord({
    required this.id,
    required this.studentId,
    this.bloodType,
    this.heightCm,
    this.weightKg,
    this.allergies,
    this.chronicConditions,
    this.currentMedications,
    this.immunizations,
    this.emergencyContact,
    this.emergencyPhone,
    this.physicianName,
    this.physicianPhone,
    this.notes,
    required this.recordedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String studentId;
  final BloodType? bloodType;
  final double? heightCm;
  final double? weightKg;
  final String? allergies;
  final String? chronicConditions;
  final String? currentMedications;
  final String? immunizations;
  final String? emergencyContact;
  final String? emergencyPhone;
  final String? physicianName;
  final String? physicianPhone;
  final String? notes;
  final DateTime recordedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  factory HealthRecord.fromRow(Map<String, dynamic> row) => HealthRecord(
        id: row['id'] as String,
        studentId: row['student_id'] as String,
        bloodType:
            BloodTypeMapper.fromValue(row['blood_type'] ?? 'unknown'),
        heightCm: (row['height_cm'] as num?)?.toDouble(),
        weightKg: (row['weight_kg'] as num?)?.toDouble(),
        allergies: row['allergies'] as String?,
        chronicConditions: row['chronic_conditions'] as String?,
        currentMedications: row['current_medications'] as String?,
        immunizations: row['immunizations'] as String?,
        emergencyContact: row['emergency_contact'] as String?,
        emergencyPhone: row['emergency_phone'] as String?,
        physicianName: row['physician_name'] as String?,
        physicianPhone: row['physician_phone'] as String?,
        notes: row['notes'] as String?,
        recordedAt: parseToLocal(row['recorded_at'] as String?) ?? timestampFallback,
        createdAt: parseToLocal(row['created_at'] as String?) ?? timestampFallback,
        updatedAt: parseToLocal(row['updated_at'] as String?) ?? timestampFallback,
        deletedAt: parseToLocal(row['deleted_at'] as String?),
      );

  Map<String, dynamic> toRow() => {
        'student_id': studentId,
        if (bloodType != null) 'blood_type': bloodType!.dbValue,
        if (heightCm != null) 'height_cm': heightCm,
        if (weightKg != null) 'weight_kg': weightKg,
        if (allergies != null) 'allergies': allergies,
        if (chronicConditions != null) 'chronic_conditions': chronicConditions,
        if (currentMedications != null) 'current_medications': currentMedications,
        if (immunizations != null) 'immunizations': immunizations,
        if (emergencyContact != null) 'emergency_contact': emergencyContact,
        if (emergencyPhone != null) 'emergency_phone': emergencyPhone,
        if (physicianName != null) 'physician_name': physicianName,
        if (physicianPhone != null) 'physician_phone': physicianPhone,
        if (notes != null) 'notes': notes,
        'recorded_at': recordedAt.toUtcIso8601(),
      };
}
