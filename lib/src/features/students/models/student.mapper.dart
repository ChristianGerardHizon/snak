// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'student.dart';

class StudentSexMapper extends EnumMapper<StudentSex> {
  StudentSexMapper._();

  static StudentSexMapper? _instance;
  static StudentSexMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StudentSexMapper._());
    }
    return _instance!;
  }

  static StudentSex fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  StudentSex decode(dynamic value) {
    switch (value) {
      case 'male':
        return StudentSex.male;
      case 'female':
        return StudentSex.female;
      case 'other':
        return StudentSex.other;
      default:
        return StudentSex.values[2];
    }
  }

  @override
  dynamic encode(StudentSex self) {
    switch (self) {
      case StudentSex.male:
        return 'male';
      case StudentSex.female:
        return 'female';
      case StudentSex.other:
        return 'other';
    }
  }
}

extension StudentSexMapperExtension on StudentSex {
  dynamic toValue() {
    StudentSexMapper.ensureInitialized();
    return MapperContainer.globals.toValue<StudentSex>(this);
  }
}

class StudentMapper extends ClassMapperBase<Student> {
  StudentMapper._();

  static StudentMapper? _instance;
  static StudentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StudentMapper._());
      StudentSexMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Student';

  static String _$id(Student v) => v.id;
  static const Field<Student, String> _f$id = Field('id', _$id);
  static String _$firstName(Student v) => v.firstName;
  static const Field<Student, String> _f$firstName = Field(
    'firstName',
    _$firstName,
  );
  static String _$lastName(Student v) => v.lastName;
  static const Field<Student, String> _f$lastName = Field(
    'lastName',
    _$lastName,
  );
  static String? _$middleName(Student v) => v.middleName;
  static const Field<Student, String> _f$middleName = Field(
    'middleName',
    _$middleName,
    opt: true,
  );
  static DateTime? _$dateOfBirth(Student v) => v.dateOfBirth;
  static const Field<Student, DateTime> _f$dateOfBirth = Field(
    'dateOfBirth',
    _$dateOfBirth,
    opt: true,
  );
  static StudentSex? _$sex(Student v) => v.sex;
  static const Field<Student, StudentSex> _f$sex = Field(
    'sex',
    _$sex,
    opt: true,
  );
  static String? _$gradeLevel(Student v) => v.gradeLevel;
  static const Field<Student, String> _f$gradeLevel = Field(
    'gradeLevel',
    _$gradeLevel,
    opt: true,
  );
  static String? _$section(Student v) => v.section;
  static const Field<Student, String> _f$section = Field(
    'section',
    _$section,
    opt: true,
  );
  static String? _$studentNumber(Student v) => v.studentNumber;
  static const Field<Student, String> _f$studentNumber = Field(
    'studentNumber',
    _$studentNumber,
    opt: true,
  );
  static String? _$contactPhone(Student v) => v.contactPhone;
  static const Field<Student, String> _f$contactPhone = Field(
    'contactPhone',
    _$contactPhone,
    opt: true,
  );
  static String? _$contactEmail(Student v) => v.contactEmail;
  static const Field<Student, String> _f$contactEmail = Field(
    'contactEmail',
    _$contactEmail,
    opt: true,
  );
  static String? _$guardianName(Student v) => v.guardianName;
  static const Field<Student, String> _f$guardianName = Field(
    'guardianName',
    _$guardianName,
    opt: true,
  );
  static String? _$guardianPhone(Student v) => v.guardianPhone;
  static const Field<Student, String> _f$guardianPhone = Field(
    'guardianPhone',
    _$guardianPhone,
    opt: true,
  );
  static String? _$address(Student v) => v.address;
  static const Field<Student, String> _f$address = Field(
    'address',
    _$address,
    opt: true,
  );
  static String? _$photoUrl(Student v) => v.photoUrl;
  static const Field<Student, String> _f$photoUrl = Field(
    'photoUrl',
    _$photoUrl,
    opt: true,
  );
  static String? _$notes(Student v) => v.notes;
  static const Field<Student, String> _f$notes = Field(
    'notes',
    _$notes,
    opt: true,
  );
  static DateTime _$createdAt(Student v) => v.createdAt;
  static const Field<Student, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime _$updatedAt(Student v) => v.updatedAt;
  static const Field<Student, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );
  static DateTime? _$deletedAt(Student v) => v.deletedAt;
  static const Field<Student, DateTime> _f$deletedAt = Field(
    'deletedAt',
    _$deletedAt,
    opt: true,
  );

  @override
  final MappableFields<Student> fields = const {
    #id: _f$id,
    #firstName: _f$firstName,
    #lastName: _f$lastName,
    #middleName: _f$middleName,
    #dateOfBirth: _f$dateOfBirth,
    #sex: _f$sex,
    #gradeLevel: _f$gradeLevel,
    #section: _f$section,
    #studentNumber: _f$studentNumber,
    #contactPhone: _f$contactPhone,
    #contactEmail: _f$contactEmail,
    #guardianName: _f$guardianName,
    #guardianPhone: _f$guardianPhone,
    #address: _f$address,
    #photoUrl: _f$photoUrl,
    #notes: _f$notes,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #deletedAt: _f$deletedAt,
  };

  static Student _instantiate(DecodingData data) {
    return Student(
      id: data.dec(_f$id),
      firstName: data.dec(_f$firstName),
      lastName: data.dec(_f$lastName),
      middleName: data.dec(_f$middleName),
      dateOfBirth: data.dec(_f$dateOfBirth),
      sex: data.dec(_f$sex),
      gradeLevel: data.dec(_f$gradeLevel),
      section: data.dec(_f$section),
      studentNumber: data.dec(_f$studentNumber),
      contactPhone: data.dec(_f$contactPhone),
      contactEmail: data.dec(_f$contactEmail),
      guardianName: data.dec(_f$guardianName),
      guardianPhone: data.dec(_f$guardianPhone),
      address: data.dec(_f$address),
      photoUrl: data.dec(_f$photoUrl),
      notes: data.dec(_f$notes),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      deletedAt: data.dec(_f$deletedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Student fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Student>(map);
  }

  static Student fromJson(String json) {
    return ensureInitialized().decodeJson<Student>(json);
  }
}

mixin StudentMappable {
  String toJson() {
    return StudentMapper.ensureInitialized().encodeJson<Student>(
      this as Student,
    );
  }

  Map<String, dynamic> toMap() {
    return StudentMapper.ensureInitialized().encodeMap<Student>(
      this as Student,
    );
  }

  StudentCopyWith<Student, Student, Student> get copyWith =>
      _StudentCopyWithImpl<Student, Student>(
        this as Student,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return StudentMapper.ensureInitialized().stringifyValue(this as Student);
  }

  @override
  bool operator ==(Object other) {
    return StudentMapper.ensureInitialized().equalsValue(
      this as Student,
      other,
    );
  }

  @override
  int get hashCode {
    return StudentMapper.ensureInitialized().hashValue(this as Student);
  }
}

extension StudentValueCopy<$R, $Out> on ObjectCopyWith<$R, Student, $Out> {
  StudentCopyWith<$R, Student, $Out> get $asStudent =>
      $base.as((v, t, t2) => _StudentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StudentCopyWith<$R, $In extends Student, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? firstName,
    String? lastName,
    String? middleName,
    DateTime? dateOfBirth,
    StudentSex? sex,
    String? gradeLevel,
    String? section,
    String? studentNumber,
    String? contactPhone,
    String? contactEmail,
    String? guardianName,
    String? guardianPhone,
    String? address,
    String? photoUrl,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
  StudentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _StudentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Student, $Out>
    implements StudentCopyWith<$R, Student, $Out> {
  _StudentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Student> $mapper =
      StudentMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? firstName,
    String? lastName,
    Object? middleName = $none,
    Object? dateOfBirth = $none,
    Object? sex = $none,
    Object? gradeLevel = $none,
    Object? section = $none,
    Object? studentNumber = $none,
    Object? contactPhone = $none,
    Object? contactEmail = $none,
    Object? guardianName = $none,
    Object? guardianPhone = $none,
    Object? address = $none,
    Object? photoUrl = $none,
    Object? notes = $none,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (firstName != null) #firstName: firstName,
      if (lastName != null) #lastName: lastName,
      if (middleName != $none) #middleName: middleName,
      if (dateOfBirth != $none) #dateOfBirth: dateOfBirth,
      if (sex != $none) #sex: sex,
      if (gradeLevel != $none) #gradeLevel: gradeLevel,
      if (section != $none) #section: section,
      if (studentNumber != $none) #studentNumber: studentNumber,
      if (contactPhone != $none) #contactPhone: contactPhone,
      if (contactEmail != $none) #contactEmail: contactEmail,
      if (guardianName != $none) #guardianName: guardianName,
      if (guardianPhone != $none) #guardianPhone: guardianPhone,
      if (address != $none) #address: address,
      if (photoUrl != $none) #photoUrl: photoUrl,
      if (notes != $none) #notes: notes,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (deletedAt != $none) #deletedAt: deletedAt,
    }),
  );
  @override
  Student $make(CopyWithData data) => Student(
    id: data.get(#id, or: $value.id),
    firstName: data.get(#firstName, or: $value.firstName),
    lastName: data.get(#lastName, or: $value.lastName),
    middleName: data.get(#middleName, or: $value.middleName),
    dateOfBirth: data.get(#dateOfBirth, or: $value.dateOfBirth),
    sex: data.get(#sex, or: $value.sex),
    gradeLevel: data.get(#gradeLevel, or: $value.gradeLevel),
    section: data.get(#section, or: $value.section),
    studentNumber: data.get(#studentNumber, or: $value.studentNumber),
    contactPhone: data.get(#contactPhone, or: $value.contactPhone),
    contactEmail: data.get(#contactEmail, or: $value.contactEmail),
    guardianName: data.get(#guardianName, or: $value.guardianName),
    guardianPhone: data.get(#guardianPhone, or: $value.guardianPhone),
    address: data.get(#address, or: $value.address),
    photoUrl: data.get(#photoUrl, or: $value.photoUrl),
    notes: data.get(#notes, or: $value.notes),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    deletedAt: data.get(#deletedAt, or: $value.deletedAt),
  );

  @override
  StudentCopyWith<$R2, Student, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _StudentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

