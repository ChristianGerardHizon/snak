import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../assets/assets.gen.dart';
import 'report_viewer_page.dart';

class SplashPage extends HookWidget {
  const SplashPage({
    super.key,
    required this.canContinue,
    required this.onContinue,
  });

  final bool canContinue;
  final VoidCallback onContinue;

  static const _startPink = Color(0xFFFF007F);
  static const _startButtonWidthFractionOfLogo = 0.45;
  static const _startButtonAspectRatio = 4.25;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    const logoScale = 0.62;
    final logoBox = Size(
      size.width * 0.94 * logoScale,
      size.height * 0.52 * logoScale,
    );
    final horizontalPadding = size.width * 0.06;

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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.08),
                    _AnimatedLogo(
                      animation: logoAnim,
                      size: logoBox,
                    ),
                    const Spacer(),
                    _AnimatedStartButton(
                      animation: buttonAnim,
                      pulse: pulse,
                      width: logoBox.width * _startButtonWidthFractionOfLogo,
                      aspectRatio: _startButtonAspectRatio,
                      enabled: canContinue,
                      onPressed: onContinue,
                      labelColor: _startPink,
                    ),
                    SizedBox(height: size.height * 0.04),
                    const _ReportLookupActions(),
                    SizedBox(height: size.height * 0.04),
                  ],
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
        child: DecoratedBox(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Assets.images.snakLogo.image(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
          ),
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
              color: enabled ? labelColor : labelColor.withValues(alpha: 0.55),
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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: enabled
                    ? Text(
                        'START',
                        key: const ValueKey('label'),
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
                      )
                    : SizedBox(
                        key: const ValueKey('spinner'),
                        width: spinnerSize,
                        height: spinnerSize,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.6,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
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
