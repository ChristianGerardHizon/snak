import 'package:flutter/material.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../widgets/common/snak_sprite_sheet.dart';

/// Shown after stand-still; displays for 8 seconds with a filling progress bar,
/// then calls [onComplete].
class CheckingResultPage extends StatefulWidget {
  const CheckingResultPage({
    super.key,
    required this.onComplete,
  });

  final VoidCallback onComplete;

  @override
  State<CheckingResultPage> createState() => _CheckingResultPageState();
}

class _CheckingResultPageState extends State<CheckingResultPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress;

  static const _fillGreen = Color(0xFF4ADE80);
  static const _fillGreenDeep = Color(0xFF22C55E);

  static const _bgTop = Color(0xFFB8E4FF);
  static const _bgMid = Color(0xFFE8F5FF);
  static const _bgBottom = Color(0xFFFFF6E8);
  static const _ink = Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _progress.forward();
    _progress.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;
        final edgePad = maxW * 0.04;

        final logoWidth = (maxW * 0.19).clamp(108.0, 230.0).toDouble();
        final logoHeight = logoWidth / SnakLogoRaster.aspect;

        final cellAspect =
            SnakSpriteSheet.cellWidth / SnakSpriteSheet.cellHeight;
        final spriteH = (maxH * 0.46).clamp(220.0, 460.0).toDouble();
        final spriteW = spriteH * cellAspect;

        final headlineSize = (maxW * 0.048).clamp(20.0, 36.0).toDouble();
        final barW = (maxW * 0.72).clamp(260.0, 520.0).toDouble();
        final barH = (maxW * 0.028).clamp(22.0, 34.0).toDouble();

        final headlineStyle = TextStyle(
          color: _ink,
          fontWeight: FontWeight.w900,
          fontSize: headlineSize,
          letterSpacing: 0.9,
          height: 1.15,
        );

        return AnimatedBuilder(
          animation: _progress,
          builder: (context, _) {
            final t = _progress.value;
            return Material(
              type: MaterialType.transparency,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.55, 1.0],
                          colors: [_bgTop, _bgMid, _bgBottom],
                        ),
                      ),
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
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: edgePad),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SnakSpriteSheet.jumping(
                            width: spriteW,
                            height: spriteH,
                          ),
                          SizedBox(height: maxH * 0.05),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: edgePad * 1.4,
                              vertical: edgePad * 0.9,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.10),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'CHECKING YOUR RESULT...',
                                  textAlign: TextAlign.center,
                                  style: headlineStyle,
                                ),
                                SizedBox(height: maxH * 0.028),
                                SizedBox(
                                  width: barW,
                                  height: barH,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF4F8),
                                          borderRadius: BorderRadius.circular(
                                              barH * 0.5),
                                          border: Border.all(
                                            color: _ink.withValues(alpha: 0.35),
                                            width: 2,
                                          ),
                                        ),
                                        child: const SizedBox.expand(),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        bottom: 0,
                                        width: (barW * t).clamp(0.0, barW),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              barH * 0.5),
                                          child: CustomPaint(
                                            painter: _StripedFillPainter(
                                              colors: const [
                                                _fillGreen,
                                                _fillGreenDeep,
                                              ],
                                            ),
                                          ),
                                        ),
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _StripedFillPainter extends CustomPainter {
  _StripedFillPainter({required this.colors});

  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    final stripe = Paint()
      ..color = Colors.white.withValues(alpha: 0.38)
      ..strokeWidth = 2.5;
    const step = 10.0;
    for (var x = 0.0; x < size.width + size.height; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height, size.height),
        stripe,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StripedFillPainter oldDelegate) =>
      oldDelegate.colors != colors;
}
