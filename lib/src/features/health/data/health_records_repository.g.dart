// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_records_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(healthRecordsRepository)
final healthRecordsRepositoryProvider = HealthRecordsRepositoryProvider._();

final class HealthRecordsRepositoryProvider extends $FunctionalProvider<
    HealthRecordsRepository,
    HealthRecordsRepository,
    HealthRecordsRepository> with $Provider<HealthRecordsRepository> {
  HealthRecordsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'healthRecordsRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$healthRecordsRepositoryHash();

  @$internal
  @override
  $ProviderElement<HealthRecordsRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HealthRecordsRepository create(Ref ref) {
    return healthRecordsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HealthRecordsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HealthRecordsRepository>(value),
    );
  }
}

String _$healthRecordsRepositoryHash() =>
    r'fe956758bdc9c5b3320f79196b70cf8bc2f15811';

@ProviderFor(healthRecordsForStudent)
final healthRecordsForStudentProvider = HealthRecordsForStudentFamily._();

final class HealthRecordsForStudentProvider extends $FunctionalProvider<
        AsyncValue<List<HealthRecord>>,
        List<HealthRecord>,
        FutureOr<List<HealthRecord>>>
    with
        $FutureModifier<List<HealthRecord>>,
        $FutureProvider<List<HealthRecord>> {
  HealthRecordsForStudentProvider._(
      {required HealthRecordsForStudentFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'healthRecordsForStudentProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$healthRecordsForStudentHash();

  @override
  String toString() {
    return r'healthRecordsForStudentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<HealthRecord>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<HealthRecord>> create(Ref ref) {
    final argument = this.argument as String;
    return healthRecordsForStudent(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HealthRecordsForStudentProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$healthRecordsForStudentHash() =>
    r'73b0622e16fa58021538c84e786962f5579b9dc1';

final class HealthRecordsForStudentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<HealthRecord>>, String> {
  HealthRecordsForStudentFamily._()
      : super(
          retry: null,
          name: r'healthRecordsForStudentProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  HealthRecordsForStudentProvider call(
    String studentId,
  ) =>
      HealthRecordsForStudentProvider._(argument: studentId, from: this);

  @override
  String toString() => r'healthRecordsForStudentProvider';
}

@ProviderFor(latestHealthRecord)
final latestHealthRecordProvider = LatestHealthRecordFamily._();

final class LatestHealthRecordProvider extends $FunctionalProvider<
        AsyncValue<HealthRecord?>, HealthRecord?, FutureOr<HealthRecord?>>
    with $FutureModifier<HealthRecord?>, $FutureProvider<HealthRecord?> {
  LatestHealthRecordProvider._(
      {required LatestHealthRecordFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'latestHealthRecordProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$latestHealthRecordHash();

  @override
  String toString() {
    return r'latestHealthRecordProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<HealthRecord?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<HealthRecord?> create(Ref ref) {
    final argument = this.argument as String;
    return latestHealthRecord(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LatestHealthRecordProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$latestHealthRecordHash() =>
    r'0c6d892c4021a25fef848d09b7fac43fa3cf9d96';

final class LatestHealthRecordFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<HealthRecord?>, String> {
  LatestHealthRecordFamily._()
      : super(
          retry: null,
          name: r'latestHealthRecordProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  LatestHealthRecordProvider call(
    String studentId,
  ) =>
      LatestHealthRecordProvider._(argument: studentId, from: this);

  @override
  String toString() => r'latestHealthRecordProvider';
}
