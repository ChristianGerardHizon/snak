import 'package:flutter/material.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../widgets/common/snak_pill_button.dart';
import '../widgets/common/mascot.dart';
import '../widgets/looping_video_background.dart';
import '../packages/theme/app_themes.dart';

/// Shown after profile confirmation; reminds the student how to stand for measurement.
///
/// Layout follows the reference: logo top-left, blue instruction panel on the
/// left with the [SnakPillButton] directly underneath (left aligned), and the
/// thumbs-up mascot occupying the right side of the screen. Each element is a
/// [Positioned] child of a single full-screen [Stack] so they overlap freely.
class MeasurementInstructionPage extends StatelessWidget {
  const MeasurementInstructionPage({
    super.key,
    required this.onGotIt,
  });

  final VoidCallback onGotIt;

  /// Matches [ProfileSetupPage.fieldBlue].
  static const panelBlue = Color(0xFF4A80F0);

  /// Matches [ProfileSetupPage.actionPink].
  static const pillPink = Color(0xFFE85BB5);

  /// Exactly three lines; [FittedBox] scales this block to fill the panel.
  static const _instruction = 'NOW, STAND PROPERLY\nFOR ACCURATE\nMEASUREMENT';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Material(
        type: MaterialType.transparency,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const LoopingVideoBackground(
              assetPath: 'assets/videos/background_animated.mp4',
              fit: BoxFit.cover,
              zoom: 1.25,
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth;
                  final maxH = constraints.maxHeight;

                  final isPortrait = maxW < maxH * 0.95;
                  final logoW = (maxW * 0.12).clamp(72.0, 160.0).toDouble();
                  final logoH = logoW / SnakLogoRaster.aspect;

                  final mascotH = isPortrait
                      ? (maxH * 0.32).clamp(180.0, 320.0).toDouble()
                      : (maxH * 0.7).clamp(220.0, 520.0).toDouble();
                  final mascotW = mascotH * Mascot.aspect;

                  final contentW =
                      (maxW * 0.94).clamp(320.0, 1100.0).toDouble();
                  final mascotColumnW =
                      isPortrait ? contentW : mascotW.clamp(0.0, contentW * 0.42);
                  final leftColumnW =
                      isPortrait ? contentW : contentW - mascotColumnW;

                  final panelH = isPortrait
                      ? (maxH * 0.32).clamp(220.0, 380.0).toDouble()
                      : (maxH * 0.42).clamp(180.0, 360.0).toDouble();

                  final buttonW = isPortrait
                      ? leftColumnW
                      : (leftColumnW * 0.78).clamp(220.0, 460.0).toDouble();
                  final buttonH = isPortrait
                      ? 64.0
                      : (buttonW / 3.45).clamp(56.0, 96.0).toDouble();

                  final instructionTextStyle = TextStyle(
                    fontFamily: AppThemes.fontFamily,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 260,
                    height: 1.15,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  );

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: maxW * 0.03,
                      vertical: maxH * 0.03,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              width: contentW,
                              child: isPortrait
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Center(
                                          child: Mascot.thumbsUp(
                                            width: mascotW,
                                            height: mascotH,
                                          ),
                                        ),
                                        SizedBox(height: maxH * 0.02),
                                        SizedBox(
                                          height: panelH,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: panelBlue,
                                              borderRadius:
                                                  BorderRadius.circular(28),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 4,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.18),
                                                  blurRadius: 16,
                                                  offset: const Offset(0, 7),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: (panelH * 0.12)
                                                    .clamp(16.0, 32.0),
                                                vertical: (panelH * 0.12)
                                                    .clamp(16.0, 32.0),
                                              ),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  _instruction,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 3,
                                                  style: instructionTextStyle,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: maxH * 0.03),
                                        SnakPillButton(
                                          label: 'GOT IT!',
                                          labelColor: pillPink,
                                          width: buttonW,
                                          height: buttonH,
                                          onPressed: onGotIt,
                                        ),
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: leftColumnW,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: panelH,
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: panelBlue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 4,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withValues(
                                                                alpha: 0.18),
                                                        blurRadius: 16,
                                                        offset:
                                                            const Offset(0, 7),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          (panelH * 0.12)
                                                              .clamp(16.0, 32.0),
                                                      vertical:
                                                          (panelH * 0.12)
                                                              .clamp(16.0, 32.0),
                                                    ),
                                                    child: FittedBox(
                                                      fit: BoxFit.contain,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        _instruction,
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 3,
                                                        style:
                                                            instructionTextStyle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: maxH * 0.04),
                                              SnakPillButton(
                                                label: 'GOT IT!',
                                                labelColor: pillPink,
                                                width: buttonW,
                                                height: buttonH,
                                                onPressed: onGotIt,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: mascotColumnW,
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            alignment: Alignment.bottomCenter,
                                            child: Mascot.thumbsUp(
                                              width: mascotW,
                                              height: mascotH,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: maxH * 0.01),
                        SizedBox(
                          width: logoW,
                          height: logoH,
                          child: Assets.images.snakLogo.image(
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
