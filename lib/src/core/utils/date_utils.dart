/// Utility extensions and functions for DateTime handling.
///
/// Backend (Supabase/Postgres) stores timestamps in UTC. This module
/// provides consistent conversion between local time (used in the UI)
/// and UTC (stored in DB).

extension AppDateExtensions on DateTime {
  /// Converts to UTC and returns ISO8601 string for storage.
  String toUtcIso8601() => toUtc().toIso8601String();
}

extension AppDateExtensionsNullable on DateTime? {
  /// Converts to UTC ISO8601 string, or returns null if DateTime is null.
  String? toUtcIso8601OrNull() => this?.toUtc().toIso8601String();
}

/// Fallback instant for records that omit created/updated timestamps.
final DateTime timestampFallback =
    DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();

/// Parses a date string from the backend and converts to local time.
///
/// Returns null if the input is null or parsing fails.
DateTime? parseToLocal(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return null;
  final trimmed = dateStr.trim();
  final iso = DateTime.tryParse(trimmed);
  if (iso != null) return iso.toLocal();
  final unixMs = int.tryParse(trimmed);
  if (unixMs != null) {
    return DateTime.fromMillisecondsSinceEpoch(unixMs, isUtc: true).toLocal();
  }
  return null;
}

/// Parses a date string and converts to local, with a fallback default value.
DateTime parseToLocalOrDefault(String? dateStr, DateTime defaultValue) {
  return parseToLocal(dateStr) ?? defaultValue;
}
