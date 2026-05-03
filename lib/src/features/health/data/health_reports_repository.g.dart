// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_reports_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(healthReportsRepository)
final healthReportsRepositoryProvider = HealthReportsRepositoryProvider._();

final class HealthReportsRepositoryProvider extends $FunctionalProvider<
    HealthReportsRepository,
    HealthReportsRepository,
    HealthReportsRepository> with $Provider<HealthReportsRepository> {
  HealthReportsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'healthReportsRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$healthReportsRepositoryHash();

  @$internal
  @override
  $ProviderElement<HealthReportsRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HealthReportsRepository create(Ref ref) {
    return healthReportsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HealthReportsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HealthReportsRepository>(value),
    );
  }
}

String _$healthReportsRepositoryHash() =>
    r'4df1b2635416473047c8029b6f7f3a2559b7387f';

@ProviderFor(healthReportsForStudent)
final healthReportsForStudentProvider = HealthReportsForStudentFamily._();

final class HealthReportsForStudentProvider extends $FunctionalProvider<
        AsyncValue<List<HealthReport>>,
        List<HealthReport>,
        FutureOr<List<HealthReport>>>
    with
        $FutureModifier<List<HealthReport>>,
        $FutureProvider<List<HealthReport>> {
  HealthReportsForStudentProvider._(
      {required HealthReportsForStudentFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'healthReportsForStudentProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$healthReportsForStudentHash();

  @override
  String toString() {
    return r'healthReportsForStudentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<HealthReport>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<HealthReport>> create(Ref ref) {
    final argument = this.argument as String;
    return healthReportsForStudent(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HealthReportsForStudentProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$healthReportsForStudentHash() =>
    r'3e923a290f9a36a96195b77afb7f3083b5f8b46f';

final class HealthReportsForStudentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<HealthReport>>, String> {
  HealthReportsForStudentFamily._()
      : super(
          retry: null,
          name: r'healthReportsForStudentProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  HealthReportsForStudentProvider call(
    String studentId,
  ) =>
      HealthReportsForStudentProvider._(argument: studentId, from: this);

  @override
  String toString() => r'healthReportsForStudentProvider';
}

@ProviderFor(healthReportById)
final healthReportByIdProvider = HealthReportByIdFamily._();

final class HealthReportByIdProvider extends $FunctionalProvider<
        AsyncValue<HealthReport?>, HealthReport?, FutureOr<HealthReport?>>
    with $FutureModifier<HealthReport?>, $FutureProvider<HealthReport?> {
  HealthReportByIdProvider._(
      {required HealthReportByIdFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'healthReportByIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$healthReportByIdHash();

  @override
  String toString() {
    return r'healthReportByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<HealthReport?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<HealthReport?> create(Ref ref) {
    final argument = this.argument as String;
    return healthReportById(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HealthReportByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$healthReportByIdHash() => r'501bacc5c8b4ce16d2fdde6086e2621247af66b6';

final class HealthReportByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<HealthReport?>, String> {
  HealthReportByIdFamily._()
      : super(
          retry: null,
          name: r'healthReportByIdProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  HealthReportByIdProvider call(
    String id,
  ) =>
      HealthReportByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'healthReportByIdProvider';
}
