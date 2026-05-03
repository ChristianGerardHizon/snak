// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'students_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(studentsRepository)
final studentsRepositoryProvider = StudentsRepositoryProvider._();

final class StudentsRepositoryProvider extends $FunctionalProvider<
    StudentsRepository,
    StudentsRepository,
    StudentsRepository> with $Provider<StudentsRepository> {
  StudentsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'studentsRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$studentsRepositoryHash();

  @$internal
  @override
  $ProviderElement<StudentsRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StudentsRepository create(Ref ref) {
    return studentsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StudentsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StudentsRepository>(value),
    );
  }
}

String _$studentsRepositoryHash() =>
    r'b9ce680c6fa277304c9551c8ece9e368a481af96';

@ProviderFor(studentsList)
final studentsListProvider = StudentsListFamily._();

final class StudentsListProvider extends $FunctionalProvider<
        AsyncValue<List<Student>>, List<Student>, FutureOr<List<Student>>>
    with $FutureModifier<List<Student>>, $FutureProvider<List<Student>> {
  StudentsListProvider._(
      {required StudentsListFamily super.from,
      required ({
        String? search,
        String? gradeLevel,
        String? section,
      })
          super.argument})
      : super(
          retry: null,
          name: r'studentsListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$studentsListHash();

  @override
  String toString() {
    return r'studentsListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Student>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Student>> create(Ref ref) {
    final argument = this.argument as ({
      String? search,
      String? gradeLevel,
      String? section,
    });
    return studentsList(
      ref,
      search: argument.search,
      gradeLevel: argument.gradeLevel,
      section: argument.section,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StudentsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$studentsListHash() => r'80f4c0b457c1651013b8ef83524fcd3c4ec776a4';

final class StudentsListFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<Student>>,
            ({
              String? search,
              String? gradeLevel,
              String? section,
            })> {
  StudentsListFamily._()
      : super(
          retry: null,
          name: r'studentsListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  StudentsListProvider call({
    String? search,
    String? gradeLevel,
    String? section,
  }) =>
      StudentsListProvider._(argument: (
        search: search,
        gradeLevel: gradeLevel,
        section: section,
      ), from: this);

  @override
  String toString() => r'studentsListProvider';
}

@ProviderFor(studentById)
final studentByIdProvider = StudentByIdFamily._();

final class StudentByIdProvider extends $FunctionalProvider<
        AsyncValue<Student?>, Student?, FutureOr<Student?>>
    with $FutureModifier<Student?>, $FutureProvider<Student?> {
  StudentByIdProvider._(
      {required StudentByIdFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'studentByIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$studentByIdHash();

  @override
  String toString() {
    return r'studentByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Student?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Student?> create(Ref ref) {
    final argument = this.argument as String;
    return studentById(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StudentByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$studentByIdHash() => r'6fa11f3a209b381f553ffe75ec86836e3907cb04';

final class StudentByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Student?>, String> {
  StudentByIdFamily._()
      : super(
          retry: null,
          name: r'studentByIdProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  StudentByIdProvider call(
    String id,
  ) =>
      StudentByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'studentByIdProvider';
}
