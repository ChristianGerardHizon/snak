import 'package:flutter/material.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../widgets/common/mascot.dart';
import '../packages/theme/app_themes.dart';

/// Shown after measurement instructions while the student is being measured.
///
/// When [measurementComplete] is null, completion falls back to a 3 second
/// delay until a real measurement session is integrated.
class StandStillWaitingPage extends StatefulWidget {
  const StandStillWaitingPage({
    super.key,
    required this.onComplete,
    this.measurementComplete,
  });

  final VoidCallback onComplete;

  /// When this future completes, [onComplete] is called.
  final Future<void>? measurementComplete;

  @override
  State<StandStillWaitingPage> createState() => _StandStillWaitingPageState();
}

class _StandStillWaitingPageState extends State<StandStillWaitingPage> {
  @override
  void initState() {
    super.initState();
    final done = widget.measurementComplete ??
        Future<void>.delayed(const Duration(seconds: 6));
    done.then((_) {
      if (!mounted) return;
      widget.onComplete();
    });
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

        final spriteH = (maxH * 0.84).clamp(400.0, 840.0).toDouble();
        final spriteW = spriteH * Mascot.aspect;

        final headlineSize = (maxW * 0.065).clamp(26.0, 44.0).toDouble();

        final headlineStyle = TextStyle(
          fontFamily: AppThemes.fontFamily,
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: headlineSize,
          letterSpacing: 1.2,
          height: 1.1,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        );

        return Material(
          type: MaterialType.transparency,
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Mascot.lay(
                      width: spriteW,
                      height: spriteH,
                    ),
                    SizedBox(height: maxH * 0.005),
                    Text(
                      'STAND STILL AND STAY IN PLACE...',
                      style: headlineStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
