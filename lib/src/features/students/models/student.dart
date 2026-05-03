import 'package:dart_mappable/dart_mappable.dart';

import '../../../core/utils/date_utils.dart';

part 'student.mapper.dart';

@MappableEnum(defaultValue: StudentSex.other)
enum StudentSex {
  @MappableValue('male') male,
  @MappableValue('female') female,
  @MappableValue('other') other;

  String get dbValue => switch (this) {
        StudentSex.male => 'male',
        StudentSex.female => 'female',
        StudentSex.other => 'other',
      };
}

@MappableClass()
class Student with StudentMappable {
  const Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.dateOfBirth,
    this.sex,
    this.gradeLevel,
    this.section,
    this.studentNumber,
    this.contactPhone,
    this.contactEmail,
    this.guardianName,
    this.guardianPhone,
    this.address,
    this.photoUrl,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? middleName;
  final DateTime? dateOfBirth;
  final StudentSex? sex;
  final String? gradeLevel;
  final String? section;
  final String? studentNumber;
  final String? contactPhone;
  final String? contactEmail;
  final String? guardianName;
  final String? guardianPhone;
  final String? address;
  final String? photoUrl;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  String get fullName =>
      [firstName, middleName, lastName].where((p) => p != null && p.isNotEmpty).join(' ');

  /// Build from a Supabase row (snake_case JSON).
  factory Student.fromRow(Map<String, dynamic> row) => Student(
        id: row['id'] as String,
        firstName: row['first_name'] as String,
        lastName: row['last_name'] as String,
        middleName: row['middle_name'] as String?,
        dateOfBirth: parseToLocal(row['date_of_birth'] as String?),
        sex: StudentSexMapper.fromValue(row['sex'] ?? 'other'),
        gradeLevel: row['grade_level'] as String?,
        section: row['section'] as String?,
        studentNumber: row['student_number'] as String?,
        contactPhone: row['contact_phone'] as String?,
        contactEmail: row['contact_email'] as String?,
        guardianName: row['guardian_name'] as String?,
        guardianPhone: row['guardian_phone'] as String?,
        address: row['address'] as String?,
        photoUrl: row['photo_url'] as String?,
        notes: row['notes'] as String?,
        createdAt: parseToLocal(row['created_at'] as String?) ?? timestampFallback,
        updatedAt: parseToLocal(row['updated_at'] as String?) ?? timestampFallback,
        deletedAt: parseToLocal(row['deleted_at'] as String?),
      );

  /// Insert/update payload — id/created_at/updated_at omitted (DB-managed).
  Map<String, dynamic> toRow() => {
        'first_name': firstName,
        'last_name': lastName,
        if (middleName != null) 'middle_name': middleName,
        if (dateOfBirth != null) 'date_of_birth': dateOfBirth!.toUtcIso8601(),
        if (sex != null) 'sex': sex!.dbValue,
        if (gradeLevel != null) 'grade_level': gradeLevel,
        if (section != null) 'section': section,
        if (studentNumber != null) 'student_number': studentNumber,
        if (contactPhone != null) 'contact_phone': contactPhone,
        if (contactEmail != null) 'contact_email': contactEmail,
        if (guardianName != null) 'guardian_name': guardianName,
        if (guardianPhone != null) 'guardian_phone': guardianPhone,
        if (address != null) 'address': address,
        if (photoUrl != null) 'photo_url': photoUrl,
        if (notes != null) 'notes': notes,
      };
}
