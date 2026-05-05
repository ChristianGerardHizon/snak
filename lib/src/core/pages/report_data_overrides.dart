import 'package:flutter/foundation.dart';

/// Manually entered vitals used in place of the randomly generated demo
/// height/weight in [ProfileSetupPage._persistAndAdvance].
///
/// Set from a hidden cog button on the splash page so a presenter can drive
/// the printed health report with chosen numbers (or one of the BMI-category
/// presets) instead of the random fakes. Null fields fall back to the
/// auto-rolled value.
@immutable
class ReportDataOverrides {
  const ReportDataOverrides({
    this.heightCm,
    this.weightKg,
  });

  final double? heightCm;
  final double? weightKg;
}

/// In-memory holder updated from the splash override sheet and consumed by
/// the profile-setup flow.
final ValueNotifier<ReportDataOverrides> reportDataOverrides =
    ValueNotifier(const ReportDataOverrides());
