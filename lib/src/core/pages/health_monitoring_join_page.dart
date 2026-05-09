import 'package:flutter/material.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../packages/theme/app_themes.dart';
import '../widgets/common/mascot.dart';
import '../widgets/looping_video_background.dart';
import '../widgets/rise_in_animation.dart';

/// Health-monitoring opt-in step shown after the consent intro.
///
/// Same translucent card + apple mascot layout as the consent page, but with
/// two action pills along the bottom: a wide pink "YES I WANT TO JOIN" and a
/// smaller "NO" to decline.
class HealthMonitoringJoinPage extends StatelessWidget {
  const HealthMonitoringJoinPage({
    super.key,
    required this.onJoin,
    required this.onDecline,
  });

  final VoidCallback onJoin;
  final VoidCallback onDecline;

  static const _bodyBlue = Color(0xFF2575FC);
  static const _pillPink = Color(0xFFE619B0);

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
                  final cardW = (maxW * 0.94).clamp(320.0, 880.0).toDouble();
                  final cardH = isPortrait
                      ? (maxH * 0.86).clamp(480.0, 900.0).toDouble()
                      : (cardW * 0.6).clamp(240.0, 560.0).toDouble();

                  // Constrain mascot by both available height AND width, so it
                  // never grows wider than the reserved right column.
                  final mascotMaxW = cardW * (isPortrait ? 0.42 : 0.26);
                  final rawMascotH = cardH * (isPortrait ? 0.32 : 0.62);
                  final mascotH =
                      rawMascotH.clamp(0.0, mascotMaxW / Mascot.aspect);
                  final mascotW = mascotH * Mascot.aspect;

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
                                bodyColor: _bodyBlue,
                                pillColor: _pillPink,
                                onJoin: onJoin,
                                onDecline: onDecline,
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
    required this.bodyColor,
    required this.pillColor,
    required this.onJoin,
    required this.onDecline,
  });

  final double cardWidth;
  final double cardHeight;
  final double mascotWidth;
  final double mascotHeight;
  final Color bodyColor;
  final Color pillColor;
  final VoidCallback onJoin;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final isPortrait = cardWidth < cardHeight * 0.85;
    if (isPortrait) {
      return _buildPortrait();
    }
    final pillH = (cardHeight * 0.13).clamp(42.0, 70.0).toDouble();
    final joinW = (cardWidth * 0.5).clamp(260.0, 560.0).toDouble();
    final noW = (cardWidth * 0.16).clamp(120.0, 200.0).toDouble();

    final mascotColumnW = mascotWidth.clamp(0.0, cardWidth * 0.42) * 1.4;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: _BodyCard(
              bodyColor: bodyColor,
              rightInset: mascotColumnW + cardWidth * 0.02,
              bottomInset: pillH + cardHeight * 0.06,
            ),
          ),
          Positioned(
            right: cardWidth * 0.02,
            top: 0,
            bottom: pillH + cardHeight * 0.06,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Mascot.shy(width: mascotWidth, height: mascotHeight),
            ),
          ),
          Positioned(
            left: cardWidth * 0.04,
            right: cardWidth * 0.04,
            bottom: cardHeight * 0.06,
            child: Row(
              children: [
                _ActionPill(
                  label: 'YES I WANT TO JOIN',
                  width: joinW,
                  height: pillH,
                  color: pillColor,
                  onPressed: onJoin,
                ),
                const Spacer(),
                _ActionPill(
                  label: 'NO',
                  width: noW,
                  height: pillH,
                  color: pillColor,
                  onPressed: onDecline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortrait() {
    final pad = cardWidth * 0.06;
    final pillH = 56.0;
    final bodySize = (cardWidth * 0.058).clamp(20.0, 30.0).toDouble();

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
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontFamily: AppThemes.fontFamily,
                          color: bodyColor,
                          fontSize: bodySize,
                          fontWeight: FontWeight.w900,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'This will only take a few minutes.',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'You can choose if you want to join.',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "It's okay to say no.",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: pad * 0.6),
                _ActionPill(
                  label: 'YES I WANT TO JOIN',
                  width: double.infinity,
                  height: pillH,
                  color: pillColor,
                  onPressed: onJoin,
                ),
                SizedBox(height: pad * 0.4),
                _ActionPill(
                  label: 'NO',
                  width: double.infinity,
                  height: pillH,
                  color: pillColor,
                  onPressed: onDecline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyCard extends StatelessWidget {
  const _BodyCard({
    required this.bodyColor,
    required this.rightInset,
    required this.bottomInset,
  });

  final Color bodyColor;
  final double rightInset;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;

        final bodySize = (w * 0.058).clamp(22.0, 40.0).toDouble();
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
              padV + bottomInset,
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                fontFamily: AppThemes.fontFamily,
                color: bodyColor,
                fontSize: bodySize,
                fontWeight: FontWeight.w900,
                height: 1.28,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('This will only take a few minutes.'),
                  SizedBox(height: 16),
                  Text('You can choose if you want to join.'),
                  SizedBox(height: 16),
                  Text("It's okay to say no."),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.label,
    required this.width,
    required this.height,
    required this.color,
    required this.onPressed,
  });

  final String label;
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.4),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
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
      ),
    );
  }
}
