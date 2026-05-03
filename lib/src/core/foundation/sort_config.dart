/// Represents a sort configuration with field and direction.
class SortConfig {
  const SortConfig({
    required this.field,
    this.descending = true,
  });

  /// The field to sort by.
  final String field;

  /// Whether to sort in descending order (newest/highest first).
  final bool descending;

  /// Converts to PocketBase sort string format.
  /// Returns `-field` for descending, `field` for ascending.
  String toSortString() => descending ? '-$field' : field;

  /// Creates a copy with optional field overrides.
  SortConfig copyWith({String? field, bool? descending}) {
    return SortConfig(
      field: field ?? this.field,
      descending: descending ?? this.descending,
    );
  }

  /// Toggles the sort direction.
  SortConfig toggleDirection() => copyWith(descending: !descending);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortConfig &&
          runtimeType == other.runtimeType &&
          field == other.field &&
          descending == other.descending;

  @override
  int get hashCode => field.hashCode ^ descending.hashCode;

  @override
  String toString() => 'SortConfig(field: $field, descending: $descending)';
}

/// A sortable field definition with key and label.
typedef SortableField = ({String key, String label});
