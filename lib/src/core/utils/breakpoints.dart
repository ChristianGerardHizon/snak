import 'package:flutter/widgets.dart';

/// Centralized responsive breakpoint definitions.
///
/// Breakpoints follow Material Design 3 guidelines:
/// - Mobile (compact): 0-599px
/// - Tablet medium: 600-899px
/// - Tablet large: 900-1199px
/// - Desktop (expanded): 1200px+
abstract class Breakpoints {
  /// Mobile breakpoint (< 600px).
  static const double mobile = 600;

  /// Tablet breakpoint (600px - 1200px).
  static const double tablet = 900;

  /// Desktop breakpoint (>= 1200px).
  static const double desktop = 1200;

  /// Returns true if the screen width is less than [mobile] breakpoint.
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  /// Returns true if the screen width is at least [mobile] breakpoint.
  static bool isTabletOrLarger(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobile;

  /// Returns true if the screen width is at least [tablet] breakpoint.
  static bool isTabletLargeOrLarger(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;

  /// Returns true if the screen width is at least [desktop] breakpoint.
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;
}
