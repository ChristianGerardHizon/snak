import 'package:flutter/material.dart';

import '../assets/assets.gen.dart';

/// Full-screen Snak branding with a Start control while the app finishes
/// initialization before [MaterialApp.router] mounts.
class SplashPage extends StatelessWidget {
  const SplashPage({
    super.key,
    required this.canContinue,
    required this.onContinue,
  });

  final bool canContinue;
  final VoidCallback onContinue;

  static const _startPink = Color(0xFFFF007F);

  /// Pill width as a fraction of the logo width; height = width / [_startButtonAspectRatio].
  static const _startButtonWidthFractionOfLogo = 0.4;
  static const _startButtonAspectRatio = 4.25;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    const logoScale = 0.6;
    final logoBox = Size(
      size.width * 0.94 * logoScale,
      size.height * 0.52 * logoScale,
    );
    final horizontalPadding = size.width * 0.06;

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
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: logoBox.width,
                        height: logoBox.height,
                        child: Assets.images.snakLogo.image(
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      SizedBox(height: size.height * 0.042),
                      _StartButton(
                        width: logoBox.width * _startButtonWidthFractionOfLogo,
                        aspectRatio: _startButtonAspectRatio,
                        enabled: canContinue,
                        onPressed: onContinue,
                        labelColor: _startPink,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({
    required this.width,
    required this.aspectRatio,
    required this.enabled,
    required this.onPressed,
    required this.labelColor,
  });

  final double width;
  final double aspectRatio;
  final bool enabled;
  final VoidCallback onPressed;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = width / aspectRatio;
    // Stadium / pill: semicircular ends like the reference (radius = half height).
    final cornerRadius = height * 0.5;
    final pillShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(cornerRadius),
    );
    final fontSize = (height * 0.46).clamp(18.0, 34.0);
    final letterSpacing = fontSize * 0.11;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          color: Colors.transparent,
          shape: pillShape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            customBorder: pillShape,
            child: Ink(
              decoration: BoxDecoration(
                color: labelColor,
                borderRadius: BorderRadius.circular(cornerRadius),
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: enabled
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.22),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  'START',
                  style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: letterSpacing,
                        fontSize: fontSize,
                        height: 1.0,
                      ) ??
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: letterSpacing,
                        fontSize: fontSize,
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
