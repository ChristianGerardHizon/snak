import 'package:flutter/material.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../widgets/common/snak_pill_button.dart';
import '../widgets/common/snak_sprite_sheet.dart';

/// School health-monitoring consent step.
///
/// Layout matches the reference design:
/// - SNAK logo anchored to the top-left corner.
/// - Large apple sprite on the left, royal-blue consent panel on the right
///   (panel sized to wrap the message across ~4 lines).
/// - Two pink pill buttons at the bottom: CONTINUE (left) and BACK (right),
///   centered as a pair rather than stretched to the screen edges.
class HealthMonitoringConsentPage extends StatelessWidget {
  const HealthMonitoringConsentPage({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  final VoidCallback onContinue;
  final VoidCallback onBack;

  /// Vibrant pink for pill buttons (matches design reference).
  static const _pillPink = Color(0xFFE619B0);

  /// Royal blue consent panel.
  static const _panelBlue = Color(0xFF2575FC);

  static const _consentMessage =
      'I agree that my information will be used by the school for health monitoring.';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final edgePad = size.width * 0.04;
    final logoWidth = (size.width * 0.16).clamp(96.0, 180.0);
    final logoHeight = logoWidth / SnakLogoRaster.aspect;

    final buttonWidth = (size.width * 0.26).clamp(180.0, 320.0);
    final buttonHeight = (buttonWidth / 4.2).clamp(48.0, 78.0);
    final buttonGap = size.width * 0.18;

    return Scaffold(
      body: Material(
        type: MaterialType.transparency,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(
              image: Assets.images.background.provider(),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
            SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: edgePad * 0.4,
                    left: edgePad * 0.6,
                    child: SizedBox(
                      width: logoWidth,
                      height: logoHeight,
                      child: Assets.images.snakLogo.image(
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                  Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final availableW = constraints.maxWidth;
                        final availableH = constraints.maxHeight;
                        final spriteH =
                            (availableH * 0.55).clamp(220.0, 460.0).toDouble();
                        final cellAspect = SnakSpriteSheet.cellWidth /
                            SnakSpriteSheet.cellHeight;
                        final spriteW = spriteH * cellAspect;
                        final panelW =
                            (availableW * 0.46).clamp(280.0, 520.0).toDouble();

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: edgePad * 1.2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SnakSpriteSheet.happy(
                                width: spriteW,
                                height: spriteH,
                              ),
                              SizedBox(width: edgePad * 0.6),
                              SizedBox(
                                width: panelW,
                                child: _ConsentPanel(
                                  color: _panelBlue,
                                  message: _consentMessage,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: size.height * 0.04,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SnakPillButton(
                          label: 'CONTINUE',
                          labelColor: _pillPink,
                          width: buttonWidth,
                          height: buttonHeight,
                          onPressed: onContinue,
                        ),
                        SizedBox(width: buttonGap),
                        SnakPillButton(
                          label: 'BACK',
                          labelColor: _pillPink,
                          width: buttonWidth,
                          height: buttonHeight,
                          onPressed: onBack,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsentPanel extends StatelessWidget {
  const _ConsentPanel({
    required this.color,
    required this.message,
  });

  final Color color;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseSize = theme.textTheme.headlineSmall?.fontSize ?? 24;
    final textStyle =
        (theme.textTheme.headlineSmall ?? const TextStyle()).copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      height: 1.28,
      fontSize: baseSize.clamp(20.0, 28.0),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }
}
