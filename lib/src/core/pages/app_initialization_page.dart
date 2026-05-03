import 'package:flutter/material.dart';

import 'health_monitoring_consent_page.dart';
import 'measurement_result_page.dart';
import 'profile_setup_page.dart';
import 'splash_page.dart';

/// Bootstrap screens before router-based pages mount: splash, consent, profile.
class AppInitializationPage extends StatelessWidget {
  const AppInitializationPage({
    super.key,
    required this.canContinue,
    required this.showConsent,
    required this.showProfileSetup,
    required this.onSplashContinue,
    required this.onConsentContinue,
    required this.onConsentBack,
    required this.onProfileComplete,
    required this.onProfileBack,
    required this.onReturnToStart,
    this.measurementResultOutcome = MeasurementResultOutcome.normal,
  });

  final bool canContinue;
  final bool showConsent;
  final bool showProfileSetup;
  final VoidCallback onSplashContinue;
  final VoidCallback onConsentContinue;
  final VoidCallback onConsentBack;
  final VoidCallback onProfileComplete;
  final VoidCallback onProfileBack;
  final VoidCallback onReturnToStart;

  /// Shown after the checking screen; swap when measurement is wired.
  final MeasurementResultOutcome measurementResultOutcome;

  @override
  Widget build(BuildContext context) {
    if (showProfileSetup) {
      return ProfileSetupPage(
        onComplete: onProfileComplete,
        onBack: onProfileBack,
        onReturnToStart: onReturnToStart,
        measurementResultOutcome: measurementResultOutcome,
      );
    }
    if (showConsent) {
      return HealthMonitoringConsentPage(
        onContinue: onConsentContinue,
        onBack: onConsentBack,
      );
    }
    return SplashPage(
      canContinue: canContinue,
      onContinue: onSplashContinue,
    );
  }
}
