import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import 'report_viewer_page.dart';

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

    final entranceController = useAnimationController(
      duration: const Duration(milliseconds: 1100),
    );
    useEffect(() {
      entranceController.forward();
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
                        final reserved = topGap +
                            midGap +
                            bottomGap +
                            buttonHeight +
                            _ReportLookupActions.estimatedHeight;
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
                            const _ReportLookupActions(),
                            SizedBox(height: bottomGap),
                          ],
                        );
                      },
                    ),
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

/// Last path segment of a URL, or the raw input if not a URL.
String? _extractReportId(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return null;
  final uri = Uri.tryParse(value);
  if (uri != null && uri.hasScheme && uri.pathSegments.isNotEmpty) {
    final id = uri.pathSegments.lastWhere(
      (s) => s.isNotEmpty,
      orElse: () => '',
    );
    return id.isEmpty ? null : id;
  }
  return value;
}

void _openReport(BuildContext context, String reportId) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => ReportViewerPage(reportId: reportId),
    ),
  );
}

class _ReportLookupActions extends StatelessWidget {
  const _ReportLookupActions();

  static const double estimatedHeight = 40;

  Future<void> _enterCode(BuildContext context) async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter report code'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Report code'),
          onSubmitted: (v) => Navigator.of(ctx).pop(v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: const Text('View'),
          ),
        ],
      ),
    );
    if (code == null) return;
    final id = _extractReportId(code);
    if (id == null) return;
    if (!context.mounted) return;
    _openReport(context, id);
  }

  Future<void> _scanQr(BuildContext context) async {
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const _QrScannerPage()),
    );
    if (code == null) return;
    final id = _extractReportId(code);
    if (id == null) return;
    if (!context.mounted) return;
    _openReport(context, id);
  }

  @override
  Widget build(BuildContext context) {
    const fg = Colors.white;
    final style = TextButton.styleFrom(
      foregroundColor: fg,
      side: BorderSide(color: fg.withValues(alpha: 0.7), width: 1.4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      minimumSize: const Size(0, 40),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
    );
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          style: style,
          onPressed: () => _enterCode(context),
          icon: const Icon(Icons.keyboard_alt_outlined, size: 18),
          label: const Text('ENTER CODE'),
        ),
        OutlinedButton.icon(
          style: style,
          onPressed: () => _scanQr(context),
          icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
          label: const Text('SCAN QR'),
        ),
      ],
    );
  }
}

class _QrScannerPage extends StatefulWidget {
  const _QrScannerPage();

  @override
  State<_QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<_QrScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final value = capture.barcodes
        .map((b) => b.rawValue)
        .firstWhere((v) => v != null && v.isNotEmpty, orElse: () => null);
    if (value == null) return;
    _handled = true;
    // Defer to next frame so the scanner widget isn't torn down mid-callback,
    // which on desktop trips a mouse-tracker assertion.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _controller.stop();
      if (!mounted) return;
      Navigator.of(context).pop(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan report QR')),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
      ),
    );
  }
}
