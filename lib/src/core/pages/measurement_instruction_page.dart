import 'package:flutter/material.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../widgets/common/snak_pill_button.dart';
import '../widgets/common/snak_sprite_sheet.dart';

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxW = constraints.maxWidth;
          final maxH = constraints.maxHeight;
          final edgePad = maxW * 0.04;

          final logoWidth = (maxW * 0.19).clamp(108.0, 230.0).toDouble();
          final logoHeight = logoWidth / SnakLogoRaster.aspect;

          final cellAspect =
              SnakSpriteSheet.cellWidth / SnakSpriteSheet.cellHeight;
          final mascotH = (maxH * 0.63).clamp(200.0, 420.0).toDouble();
          final mascotW = mascotH * cellAspect;

          final panelW = (maxW * 0.56).clamp(288.0, 640.0).toDouble();
          final panelH = (maxH * 0.48).clamp(184.0, 380.0).toDouble();

          final buttonWidth = (panelW * 0.66).clamp(200.0, 380.0).toDouble();
          final buttonHeight =
              (buttonWidth / 3.45).clamp(60.0, 104.0).toDouble();

          // Button overlaps the bottom of the panel by ~half its height,
          // matching the reference where "GOT IT!" sits across the panel edge.
          final buttonOverlap = buttonHeight * 0.55;
          final groupHeight = panelH + buttonHeight - buttonOverlap;
          final groupTop = ((maxH - groupHeight) / 2).clamp(
            logoHeight + edgePad,
            maxH - groupHeight - edgePad,
          );
          // Center the panel + mascot group horizontally. The mascot extends
          // past the right edge of the panel by `mascotW * 0.75` (since
          // mascotLeft = panelLeft + panelW - mascotW * 0.25).
          final groupVisualWidth = panelW + mascotW * 0.75;
          // Slight nudge right — transparent sprite padding makes pure math
          // centering look a bit left-heavy.
          final nudgeRight = (maxW * 0.032).clamp(14.0, 44.0).toDouble();
          final panelLeft = (((maxW - groupVisualWidth) / 2) + nudgeRight)
              .clamp(edgePad * 0.5, maxW - panelW - 4.0)
              .toDouble();
          final buttonLeft = panelLeft + (panelW - buttonWidth) / 2;

          final instructionTextStyle = TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
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

          // Mascot sits on top of the panel/button group, anchored to the
          // group's right edge and vertically centred against it.
          final groupBottom = groupTop + groupHeight;
          final mascotLeft = panelLeft + panelW - mascotW * 0.25;
          final mascotTop =
              groupBottom - mascotH * 0.92; // ~bottom-aligned to group

          return Material(
            type: MaterialType.transparency,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Image(
                    image: Assets.images.background.provider(),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
                Positioned(
                  left: edgePad * 0.75,
                  top: edgePad * 0.6,
                  width: logoWidth,
                  height: logoHeight,
                  child: Assets.images.snakLogo.image(
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                Positioned(
                  left: panelLeft,
                  top: groupTop,
                  width: panelW,
                  height: panelH,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: panelBlue,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 16,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: (panelW * 0.075).clamp(14.0, 28.0),
                        vertical: (panelH * 0.12).clamp(14.0, 28.0),
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
                Positioned(
                  left: buttonLeft,
                  top: groupTop + panelH - buttonOverlap,
                  width: buttonWidth,
                  height: buttonHeight,
                  child: SnakPillButton(
                    label: 'GOT IT!',
                    labelColor: pillPink,
                    width: buttonWidth,
                    height: buttonHeight,
                    onPressed: onGotIt,
                  ),
                ),
                // Mascot painted last so it sits ON TOP of the panel + button.
                Positioned(
                  left: mascotLeft,
                  top: mascotTop,
                  child: SnakSpriteSheet.thumbsUp(
                    width: mascotW,
                    height: mascotH,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
