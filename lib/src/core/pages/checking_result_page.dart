import 'package:flutter/material.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../widgets/common/mascot.dart';
import '../widgets/looping_video_background.dart';
import '../packages/theme/app_themes.dart';

/// Shown after stand-still; displays for 8 seconds with a filling progress bar,
/// while [onSave] persists the visit to the server in the background. Calls
/// [onComplete] only once both the animation and the save have succeeded. If
/// the save throws, [onSaveError] is called instead and [onComplete] never
/// fires.
class CheckingResultPage extends StatefulWidget {
  const CheckingResultPage({
    super.key,
    required this.onComplete,
    this.onSave,
    this.onSaveError,
  });

  final VoidCallback onComplete;
  final Future<void> Function()? onSave;
  final void Function(Object error, StackTrace stackTrace)? onSaveError;

  @override
  State<CheckingResultPage> createState() => _CheckingResultPageState();
}

class _CheckingResultPageState extends State<CheckingResultPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress;
  bool _animationDone = false;
  bool _saveDone = false;
  bool _saveFailed = false;
  bool _completed = false;

  static const _fillGreen = Color(0xFF4ADE80);
  static const _fillGreenDeep = Color(0xFF22C55E);

  static const _ink = Color(0xFF1A1A1A);
  static const _headlineRed = Color(0xFFE53935);

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
        _animationDone = true;
        _maybeComplete();
      }
    });

    final save = widget.onSave;
    if (save == null) {
      _saveDone = true;
    } else {
      save().then(
        (_) {
          if (!mounted) return;
          _saveDone = true;
          _maybeComplete();
        },
        onError: (Object error, StackTrace stackTrace) {
          if (!mounted) return;
          _saveFailed = true;
          _completed = true;
          widget.onSaveError?.call(error, stackTrace);
        },
      );
    }
  }

  void _maybeComplete() {
    if (_completed || _saveFailed) return;
    if (_animationDone && _saveDone) {
      _completed = true;
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

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

                  final spriteH =
                      (maxH * 0.5).clamp(220.0, 460.0).toDouble();
                  final spriteW = spriteH * Mascot.aspect;

                  final headlineSize =
                      (maxW * 0.052).clamp(24.0, 48.0).toDouble();
                  final barW =
                      (maxW * 0.62).clamp(260.0, 640.0).toDouble();
                  final barH =
                      (maxW * 0.03).clamp(22.0, 38.0).toDouble();

                  final logoW = (maxW * 0.12).clamp(72.0, 160.0).toDouble();
                  final logoH = logoW / SnakLogoRaster.aspect;

                  final headlineStyle = TextStyle(
                    fontFamily: AppThemes.fontFamily,
                    color: _headlineRed,
                    fontWeight: FontWeight.w900,
                    fontSize: headlineSize,
                    letterSpacing: 0.9,
                    height: 1.15,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  );

                  return AnimatedBuilder(
                    animation: _progress,
                    builder: (context, _) {
                      final t = _progress.value;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: maxW * 0.03,
                          vertical: maxH * 0.03,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Mascot.running(
                                      width: spriteW,
                                      height: spriteH,
                                    ),
                                    SizedBox(height: maxH * 0.03),
                                    Text(
                                      'CHECKING YOUR RESULT...',
                                      textAlign: TextAlign.center,
                                      style: headlineStyle,
                                    ),
                                    SizedBox(height: maxH * 0.025),
                                    SizedBox(
                                      width: barW,
                                      height: barH,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withValues(alpha: 0.85),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      barH * 0.5),
                                              border: Border.all(
                                                color: _ink
                                                    .withValues(alpha: 0.45),
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.12),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: const SizedBox.expand(),
                                          ),
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            bottom: 0,
                                            width: (barW * t).clamp(0.0, barW),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
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
