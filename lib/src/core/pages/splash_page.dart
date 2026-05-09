import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:window_manager/window_manager.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../utils/web_fullscreen.dart';
import 'measurement_result_page.dart';
import 'report_data_overrides.dart';

/// True once [SplashPage] has been shown at least once this session. Used to
/// skip the first-launch intro delay when the user returns to the splash
/// (e.g. after finishing a measurement) so the screen isn't blank for 3s.
bool _splashHasBeenShown = false;

class SplashPage extends HookWidget {
  const SplashPage({
    super.key,
    required this.canContinue,
    required this.onContinue,
  });

  final bool canContinue;
  final VoidCallback onContinue;

  static const _startRed = Color(0xFFE53935);
  static const _startButtonWidthFractionOfLogo = 0.55;
  static const _startButtonAspectRatio = 3.6;
  static const _maxLogoWidth = 1200.0;
  static const _maxButtonContentWidth = 700.0;
  static const _maxContentHeight = 900.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final contentWidth =
        size.width < _maxLogoWidth ? size.width : _maxLogoWidth;
    final horizontalPadding = contentWidth * 0.02;
    final logoWidth = contentWidth - horizontalPadding * 2;
    final buttonContentWidth = logoWidth < _maxButtonContentWidth
        ? logoWidth
        : _maxButtonContentWidth;
    final logoBox = Size(
      logoWidth,
      logoWidth / SnakLogoRaster.aspect,
    );

    // The logo and START button fade in shortly after mount. On first launch
    // we wait a beat for the background video to settle; on subsequent visits
    // (e.g. returning from results) the entrance plays immediately so the
    // user isn't staring at an empty/black screen.
    final introDelay = _splashHasBeenShown
        ? Duration.zero
        : const Duration(milliseconds: 3000);

    final entranceController = useAnimationController(
      duration: const Duration(milliseconds: 1100),
    );
    useEffect(() {
      _splashHasBeenShown = true;
      if (introDelay == Duration.zero) {
        entranceController.forward();
        return null;
      }
      final timer = Future.delayed(introDelay, () {
        if (entranceController.isDismissed) {
          entranceController.forward();
        }
      });
      return timer.ignore;
    }, const []);

    // Warm the static background used by the screens after splash so the
    // handoff doesn't flash black while the asset decodes.
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          precacheImage(Assets.images.background.provider(), context);
        }
      });
      return null;
    }, const []);

    final logoAnim = CurvedAnimation(
      parent: entranceController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
    );
    final buttonAnim = CurvedAnimation(
      parent: entranceController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
    );

    final pulse = useAnimationController(
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Material(
        type: MaterialType.transparency,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Soft scrim for legibility behind the logo & button.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0x14000000),
                    Color(0x33000000),
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
              child: SizedBox.expand(),
            ),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: _maxLogoWidth,
                    maxHeight: _maxContentHeight,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final buttonWidth =
                            buttonContentWidth * _startButtonWidthFractionOfLogo;
                        final buttonHeight =
                            buttonWidth / _startButtonAspectRatio;
                        final topGap = size.height * 0.08;
                        final midGap = size.height * 0.04;
                        final bottomGap = size.height * 0.04;
                        // Reserve space for fixed elements; whatever's left goes to the logo.
                        final reserved =
                            topGap + midGap + bottomGap + buttonHeight;
                        final maxLogoHeight = (constraints.maxHeight - reserved)
                            .clamp(0.0, logoBox.height);
                        final logoHeight = maxLogoHeight < logoBox.height
                            ? maxLogoHeight
                            : logoBox.height;
                        final logoSize = Size(
                          logoHeight * SnakLogoRaster.aspect,
                          logoHeight,
                        );
                        return Column(
                          children: [
                            SizedBox(height: topGap),
                            _AnimatedLogo(
                              animation: logoAnim,
                              size: logoSize,
                            ),
                            const Spacer(),
                            _AnimatedStartButton(
                              animation: buttonAnim,
                              pulse: pulse,
                              width: buttonWidth,
                              aspectRatio: _startButtonAspectRatio,
                              enabled: canContinue,
                              onPressed: onContinue,
                              labelColor: _startRed,
                            ),
                            SizedBox(height: midGap),
                            SizedBox(height: bottomGap),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            // Barely visible top-right buttons: fullscreen toggle + cog.
            // Last in the Stack so they always paint on top of the splash UI.
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _FullscreenToggleButton(),
                      IconButton(
                        tooltip: 'Set report data',
                        icon: const Icon(Icons.settings, size: 24),
                        color: Colors.white,
                        onPressed: () => _showOverrideDialog(context),
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

class _AnimatedLogo extends StatelessWidget {
  const _AnimatedLogo({required this.animation, required this.size});

  final Animation<double> animation;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value.clamp(0.0, 1.0);
        return Opacity(
          opacity: t,
          child: Transform.scale(
            scale: 0.6 + 0.4 * t,
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Assets.images.snakLogo.image(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

class _AnimatedStartButton extends StatelessWidget {
  const _AnimatedStartButton({
    required this.animation,
    required this.pulse,
    required this.width,
    required this.aspectRatio,
    required this.enabled,
    required this.onPressed,
    required this.labelColor,
  });

  final Animation<double> animation;
  final Animation<double> pulse;
  final double width;
  final double aspectRatio;
  final bool enabled;
  final VoidCallback onPressed;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value.clamp(0.0, 1.0);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 24),
            child: child,
          ),
        );
      },
      child: AnimatedBuilder(
        animation: pulse,
        builder: (context, child) {
          final scale = enabled ? 1.0 + pulse.value * 0.035 : 1.0;
          return Transform.scale(scale: scale, child: child);
        },
        child: _StartPill(
          width: width,
          aspectRatio: aspectRatio,
          enabled: enabled,
          onPressed: onPressed,
          labelColor: labelColor,
        ),
      ),
    );
  }
}

class _StartPill extends StatelessWidget {
  const _StartPill({
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
    final cornerRadius = height * 0.5;
    final pillShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(cornerRadius),
    );
    final fontSize = (height * 0.46).clamp(18.0, 34.0);
    final letterSpacing = fontSize * 0.11;
    final spinnerSize = (height * 0.5).clamp(16.0, 28.0);

    return SizedBox(
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
              color:
                  enabled ? Colors.white : Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(cornerRadius),
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.28),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: enabled
                    ? Text(
                        'START',
                        key: const ValueKey('label'),
                        style: theme.textTheme.titleLarge?.copyWith(
                              color: labelColor,
                              fontWeight: FontWeight.w900,
                              letterSpacing: letterSpacing,
                              fontSize: fontSize,
                              height: 1.0,
                            ) ??
                            TextStyle(
                              color: labelColor,
                              fontWeight: FontWeight.w900,
                              letterSpacing: letterSpacing,
                              fontSize: fontSize,
                              height: 1.0,
                            ),
                      )
                    : SizedBox(
                        key: const ValueKey('spinner'),
                        width: spinnerSize,
                        height: spinnerSize,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.6,
                          valueColor: AlwaysStoppedAnimation<Color>(labelColor),
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

Future<void> _showOverrideDialog(BuildContext context) async {
  final result = await showDialog<ReportDataOverrides>(
    context: context,
    builder: (_) => _ReportOverrideDialog(current: reportDataOverrides.value),
  );
  if (result != null) {
    reportDataOverrides.value = result;
  }
}

/// Preset height/weight pairs that land squarely in each BMI category for a
/// typical school-age learner.
const _presets = <MeasurementResultOutcome, ({double heightCm, double weightKg})>{
  MeasurementResultOutcome.underweight: (heightCm: 130, weightKg: 22),
  MeasurementResultOutcome.normal: (heightCm: 130, weightKg: 30),
  MeasurementResultOutcome.overweight: (heightCm: 130, weightKg: 42),
};

class _ReportOverrideDialog extends HookWidget {
  const _ReportOverrideDialog({required this.current});

  final ReportDataOverrides current;

  @override
  Widget build(BuildContext context) {
    final heightCtl = useTextEditingController(
      text: current.heightCm?.toString() ?? '',
    );
    final weightCtl = useTextEditingController(
      text: current.weightKg?.toString() ?? '',
    );

    void applyPreset(MeasurementResultOutcome o) {
      final p = _presets[o]!;
      heightCtl.text = p.heightCm.toString();
      weightCtl.text = p.weightKg.toString();
    }

    return AlertDialog(
      title: const Text('Set measured vitals'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Leave blank to keep the auto-generated random value.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: heightCtl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Height (cm)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: weightCtl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Presets',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final o in MeasurementResultOutcome.values)
                  OutlinedButton(
                    onPressed: () => applyPreset(o),
                    child: Text(_presetLabel(o)),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(const ReportDataOverrides());
          },
          child: const Text('Clear'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(
              ReportDataOverrides(
                heightCm: double.tryParse(heightCtl.text.trim()),
                weightKg: double.tryParse(weightCtl.text.trim()),
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  static String _presetLabel(MeasurementResultOutcome o) => switch (o) {
        MeasurementResultOutcome.underweight => 'Underweight',
        MeasurementResultOutcome.normal => 'Normal',
        MeasurementResultOutcome.overweight => 'Overweight',
      };
}

class _FullscreenToggleButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isFullscreen = useState(false);

    Future<void> toggle() async {
      final next = !isFullscreen.value;

      if (kIsWeb) {
        await setWebFullscreen(next);
      } else if (Platform.isAndroid || Platform.isIOS) {
        await SystemChrome.setEnabledSystemUIMode(
          next ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
        );
      } else {
        await windowManager.setFullScreen(next);
      }

      isFullscreen.value = next;
    }

    return IconButton(
      tooltip:
          isFullscreen.value ? 'Exit fullscreen' : 'Open fullscreen',
      icon: Icon(
        isFullscreen.value ? Icons.fullscreen_exit : Icons.fullscreen,
        size: 24,
      ),
      color: Colors.white,
      onPressed: toggle,
    );
  }
}
