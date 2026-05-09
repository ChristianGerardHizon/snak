import 'package:flutter/material.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../widgets/common/mascot.dart';
import '../widgets/looping_video_background.dart';
import '../widgets/rise_in_animation.dart';
import '../packages/theme/app_themes.dart';

/// School health-monitoring consent step.
///
/// Translucent white card on the left with a red title and a blue body that
/// highlights "height" and "weight" in pink. The apple mascot stands on the
/// right, partially overlapping the card. A pink NEXT pill sits in the
/// bottom-right of the card and the SNAK logo is centered at the bottom.
class HealthMonitoringConsentPage extends StatelessWidget {
  const HealthMonitoringConsentPage({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  final VoidCallback onContinue;
  final VoidCallback onBack;

  static const _titleRed = Color(0xFFE53935);
  static const _bodyBlue = Color(0xFF2575FC);
  static const _highlightPink = Color(0xFFE619B0);
  static const _nextPink = Color(0xFFE619B0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  final cardW = (maxW * 0.94).clamp(320.0, 1200.0).toDouble();
                  final cardH = isPortrait
                      ? (maxH * 0.86).clamp(480.0, 900.0).toDouble()
                      : (cardW * 0.55).clamp(240.0, 520.0).toDouble();

                  final mascotMaxW = cardW * (isPortrait ? 0.42 : 0.26);
                  final rawMascotH = cardH * (isPortrait ? 0.32 : 0.62);
                  final mascotH =
                      rawMascotH.clamp(0.0, mascotMaxW / Mascot.aspect);
                  final mascotW = mascotH * Mascot.aspect;

                  // Logo at bottom center.
                  final logoW = (maxW * 0.12).clamp(72.0, 160.0).toDouble();
                  final logoH = logoW / SnakLogoRaster.aspect;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: maxW * 0.03,
                      vertical: maxH * 0.03,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: RiseInAnimation(
                              child: _CardWithMascot(
                                cardWidth: cardW,
                                cardHeight: cardH,
                                mascotWidth: mascotW,
                                mascotHeight: mascotH,
                                titleColor: _titleRed,
                                bodyColor: _bodyBlue,
                                highlightColor: _highlightPink,
                                nextColor: _nextPink,
                                onNext: onContinue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: maxH * 0.01),
                        RiseInAnimation(
                          index: 1,
                          child: SizedBox(
                            width: logoW,
                            height: logoH,
                            child: Assets.images.snakLogo.image(
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                            ),
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

class _CardWithMascot extends StatelessWidget {
  const _CardWithMascot({
    required this.cardWidth,
    required this.cardHeight,
    required this.mascotWidth,
    required this.mascotHeight,
    required this.titleColor,
    required this.bodyColor,
    required this.highlightColor,
    required this.nextColor,
    required this.onNext,
  });

  final double cardWidth;
  final double cardHeight;
  final double mascotWidth;
  final double mascotHeight;
  final Color titleColor;
  final Color bodyColor;
  final Color highlightColor;
  final Color nextColor;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isPortrait = cardWidth < cardHeight * 0.85;
    if (isPortrait) {
      return _buildPortrait();
    }
    final btnW = (cardWidth * 0.18).clamp(120.0, 200.0).toDouble();
    final btnH = (btnW / 3.2).clamp(42.0, 70.0).toDouble();

    // Reserve a column on the right of the card for the mascot. The card
    // text is inset by this amount so it never runs under the mascot.
    final mascotColumnW = mascotWidth.clamp(0.0, cardWidth * 0.42) * 1.4;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: _ConsentCard(
              titleColor: titleColor,
              bodyColor: bodyColor,
              highlightColor: highlightColor,
              rightInset: mascotColumnW + cardWidth * 0.02,
            ),
          ),
          Positioned(
            right: cardWidth * 0.02,
            top: 0,
            bottom: btnH + cardHeight * 0.06,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Mascot.shy(width: mascotWidth, height: mascotHeight),
            ),
          ),
          Positioned(
            right: cardWidth * 0.04,
            bottom: cardHeight * 0.06,
            child: _NextPill(
              width: btnW,
              height: btnH,
              color: nextColor,
              onPressed: onNext,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortrait() {
    final pad = cardWidth * 0.06;
    final pillH = 56.0;
    final titleSize = (cardWidth * 0.075).clamp(26.0, 38.0).toDouble();
    final bodySize = (cardWidth * 0.052).clamp(18.0, 26.0).toDouble();

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.9),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(pad, pad, pad, pad * 0.6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Mascot.shy(
                    width: mascotWidth,
                    height: mascotHeight,
                  ),
                ),
                SizedBox(height: pad * 0.6),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Hello Healthy Human!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppThemes.fontFamily,
                              color: titleColor,
                              fontSize: titleSize,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: pad * 0.5),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: AppThemes.fontFamily,
                                color: bodyColor,
                                fontSize: bodySize,
                                fontWeight: FontWeight.w800,
                                height: 1.3,
                              ),
                              children: [
                                const TextSpan(text: 'We will measure your '),
                                TextSpan(
                                  text: 'height',
                                  style: TextStyle(
                                      fontFamily: AppThemes.fontFamily,
                                      color: highlightColor),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'weight',
                                  style: TextStyle(
                                      fontFamily: AppThemes.fontFamily,
                                      color: highlightColor),
                                ),
                                const TextSpan(
                                  text:
                                      ' to check your health. This will only take a few minutes.\n\n',
                                ),
                                const TextSpan(
                                  text:
                                      'Your information will only be used by the school for health monitoring and will be kept private.',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: pad * 0.6),
                _NextPill(
                  width: double.infinity,
                  height: pillH,
                  color: nextColor,
                  onPressed: onNext,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsentCard extends StatelessWidget {
  const _ConsentCard({
    required this.titleColor,
    required this.bodyColor,
    required this.highlightColor,
    required this.rightInset,
  });

  final Color titleColor;
  final Color bodyColor;
  final Color highlightColor;
  final double rightInset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;

        final titleSize = (w * 0.045).clamp(22.0, 40.0).toDouble();
        final bodySize = (w * 0.038).clamp(18.0, 32.0).toDouble();
        final padH = (w * 0.045).clamp(18.0, 40.0).toDouble();
        final padV = (h * 0.07).clamp(18.0, 40.0).toDouble();

        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              padH,
              padV,
              padH + rightInset,
              padV,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hello Healthy Human!',
                  style: TextStyle(
                    fontFamily: AppThemes.fontFamily,
                    color: titleColor,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    letterSpacing: 0.1,
                  ),
                ),
                SizedBox(height: padV * 0.45),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: AppThemes.fontFamily,
                      color: bodyColor,
                      fontSize: bodySize,
                      fontWeight: FontWeight.w800,
                      height: 1.28,
                    ),
                    children: [
                      const TextSpan(text: 'We will measure your '),
                      TextSpan(
                        text: 'height',
                        style: TextStyle(
                            fontFamily: AppThemes.fontFamily,
                            color: highlightColor),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'weight',
                        style: TextStyle(
                            fontFamily: AppThemes.fontFamily,
                            color: highlightColor),
                      ),
                      const TextSpan(
                        text:
                            ' to check your health. This will only take a few minutes.\n',
                      ),
                      const TextSpan(
                        text:
                            'Your information will only be used by the school for health monitoring and will be kept private.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NextPill extends StatelessWidget {
  const _NextPill({
    required this.width,
    required this.height,
    required this.color,
    required this.onPressed,
  });

  final double width;
  final double height;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cornerRadius = height * 0.5;
    final fontSize = (height * 0.42).clamp(16.0, 28.0).toDouble();
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(cornerRadius),
    );

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: shape,
          child: Ink(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(cornerRadius),
              border: Border.all(color: const Color(0xFFFFE45C), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'NEXT',
                style: TextStyle(
                  fontFamily: AppThemes.fontFamily,
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: fontSize * 0.1,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
