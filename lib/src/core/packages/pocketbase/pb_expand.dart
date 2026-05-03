/// Helper class for building PocketBase expand strings.
///
/// Expand strings are used to fetch related records in a single query.
class Expand {
  final List<String> paths;

  const Expand._(this.paths);

  /// Creates an expand with flat paths (no nesting).
  ///
  /// Example:
  /// ```dart
  /// Expand.flat(['branch', 'category'])
  /// // Result: "branch, category"
  /// ```
  factory Expand.flat(List<String> paths) => Expand._(paths);

  /// Creates an expand with nested paths from a root.
  ///
  /// Example:
  /// ```dart
  /// Expand.nested('patient', ['species', 'breed'])
  /// // Result: "patient, patient.species, patient.breed"
  /// ```
  factory Expand.nested(String root, List<String> subPaths) {
    return Expand._([
      root,
      for (var sub in subPaths) '$root.$sub',
    ]);
  }

  /// Combines multiple expands into one.
  factory Expand.combine(List<Expand> expands) {
    return Expand._(expands.expand((e) => e.paths).toList());
  }

  @override
  String toString() => paths.join(', ');
}

/// Pre-defined expand configurations for common queries.
abstract class PBExpand {
  /// Expand for user queries - includes branch relation.
  static final Expand user = Expand.flat(['branch']);

  /// Expand for patient queries - includes species, breed, and branch.
  static final Expand patient = Expand.flat(['species', 'breed', 'branch']);

  /// Expand for product queries - includes category and branch.
  static final Expand product = Expand.flat(['category', 'branch']);

  /// Expand for appointment queries - includes patient (with species/breed), branch, and linked records/treatments.
  static final Expand appointment = Expand.flat([
    'patient',
    'patient.species',
    'patient.breed',
    'branch',
    'patientRecords',
    'patientTreatment',
    'treatmentRecords',
    'treatmentRecords.treatment',
  ]);

  /// Expand for sale queries - includes items and branch.
  static final Expand sale = Expand.flat(['items', 'branch']);

  /// Expand for message queries - includes patient, appointment, and branch.
  static final Expand message =
      Expand.flat(['patient', 'appointment', 'branch']);
}
