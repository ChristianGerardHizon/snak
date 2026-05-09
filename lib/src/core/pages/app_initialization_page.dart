import 'package:flutter/material.dart';

import '../widgets/looping_video_background.dart';
import 'health_monitoring_consent_page.dart';
import 'health_monitoring_join_page.dart';
import 'measurement_result_page.dart';
import 'profile_setup_page.dart';
import 'splash_page.dart';

/// Bootstrap screens before router-based pages mount: splash, consent, profile.
class AppInitializationPage extends StatelessWidget {
  const AppInitializationPage({
    super.key,
    required this.canContinue,
    required this.showConsent,
    required this.showJoin,
    required this.showProfileSetup,
    required this.onSplashContinue,
    required this.onConsentContinue,
    required this.onConsentBack,
    required this.onJoinAccept,
    required this.onJoinDecline,
    required this.onProfileComplete,
    required this.onProfileBack,
    required this.onReturnToStart,
    this.measurementResultOutcome = MeasurementResultOutcome.normal,
  });

  final bool canContinue;
  final bool showConsent;
  final bool showJoin;
  final bool showProfileSetup;
  final VoidCallback onSplashContinue;
  final VoidCallback onConsentContinue;
  final VoidCallback onConsentBack;
  final VoidCallback onJoinAccept;
  final VoidCallback onJoinDecline;
  final VoidCallback onProfileComplete;
  final VoidCallback onProfileBack;
  final VoidCallback onReturnToStart;

  /// Shown after the checking screen; swap when measurement is wired.
  final MeasurementResultOutcome measurementResultOutcome;

  @override
  Widget build(BuildContext context) {
    final Widget current;
    if (showProfileSetup) {
      current = ProfileSetupPage(
        key: const ValueKey('profile'),
        onComplete: onProfileComplete,
        onBack: onProfileBack,
        onReturnToStart: onReturnToStart,
        measurementResultOutcome: measurementResultOutcome,
      );
    } else if (showJoin) {
      current = HealthMonitoringJoinPage(
        key: const ValueKey('join'),
        onJoin: onJoinAccept,
        onDecline: onJoinDecline,
      );
    } else if (showConsent) {
      current = HealthMonitoringConsentPage(
        key: const ValueKey('consent'),
        onContinue: onConsentContinue,
        onBack: onConsentBack,
      );
    } else {
      current = SplashPage(
        key: const ValueKey('splash'),
        canContinue: canContinue,
        onContinue: onSplashContinue,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        const LoopingVideoBackground(
          assetPath: 'assets/videos/background_animated.mp4',
          fit: BoxFit.cover,
          zoom: 1.25,
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: current,
        ),
      ],
    );
  }
}
