import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../widgets/common/snak_pill_button.dart';

/// Base URL for hosted health reports. Override via:
/// `--dart-define=SNAK_REPORT_BASE_URL=https://your.host/r`
const String _reportBaseUrl = String.fromEnvironment(
  'SNAK_REPORT_BASE_URL',
  defaultValue: 'https://snak.app/r',
);

String _reportUrl(String reportId) => '$_reportBaseUrl/$reportId';

/// BMI-style result for [MeasurementResultPage] (Health Findings).
enum MeasurementResultOutcome {
  underweight,
  normal,
  overweight,
}

/// Health Findings report: measurements, BMI category, tips, footer.
class MeasurementResultPage extends StatelessWidget {
  const MeasurementResultPage({
    super.key,
    required this.outcome,
    required this.onDone,
    this.reportId,
  });

  final MeasurementResultOutcome outcome;
  final VoidCallback onDone;
  final String? reportId;

  static const _ink = Color(0xFF1A1A1A);
  static const _cream = Color(0xFFFFF6E8);
  static const _skyTop = Color(0xFFB8E4FF);
  static const _skyBottom = Color(0xFFE8F5FF);
  static const _panelTop = Color(0xFFFFF6E8);
  static const _panelBottom = Color(0xFFFFE9C7);
  static const _doneGreen = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    final spec = _spec(outcome);
    final now = DateTime.now();
    final stamp = DateFormat('MMM d, yyyy | h:mm a').format(now).toUpperCase();

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final edge = maxW * 0.055;

        final logoW = (maxW * 0.52).clamp(200.0, 340.0).toDouble();
        final logoH = logoW / SnakLogoRaster.aspect;
        final skyH = (maxW * 0.52).clamp(200.0, 280.0);

        final titleSize = (maxW * 0.05).clamp(17.0, 30.0).toDouble();
        final bodySize = (maxW * 0.038).clamp(14.0, 22.0).toDouble();
        final bmiLabelSize = (maxW * 0.032).clamp(12.0, 18.0).toDouble();
        final bmiMainSize = (maxW * 0.065).clamp(22.0, 42.0).toDouble();
        final bmiSubSize = (maxW * 0.036).clamp(13.0, 21.0).toDouble();

        final buttonW = (maxW * 0.82).clamp(260.0, 560.0).toDouble();
        final buttonH = (buttonW / 4.4).clamp(50.0, 90.0).toDouble();

        return ColoredBox(
          color: _cream,
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: skyH,
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [_skyTop, _skyBottom],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: edge * 0.4,
                              top: edge * 0.35,
                              child: Icon(
                                Icons.wb_sunny_rounded,
                                size: (maxW * 0.12).clamp(40.0, 56.0),
                                color: const Color(0xFFFFD54F),
                                shadows: const [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: edge * 0.8,
                              top: edge * 0.5,
                              child: _Cloud(w: maxW * 0.14, h: maxW * 0.07),
                            ),
                            Positioned(
                              left: edge * 1.2,
                              top: edge * 1.1,
                              child: _Cloud(w: maxW * 0.1, h: maxW * 0.05),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: edge * 0.3),
                                child: SizedBox(
                                  width: logoW,
                                  height: logoH,
                                  child: Assets.images.snakLogo.image(
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [_panelTop, _panelBottom],
                          ),
                        ),
                        child: SizedBox.expand(),
                      ),
                    ),
                  ],
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(edge, 8, edge, edge * 1.4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: skyH - 4),
                        Text(
                          'HEALTH FINDINGS:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w900,
                            color: _ink,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          stamp,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: bodySize * 0.88,
                            fontWeight: FontWeight.w700,
                            color: _ink.withValues(alpha: 0.78),
                          ),
                        ),
                        SizedBox(height: edge * 0.9),
                        _DottedLine(width: maxW - edge * 2),
                        SizedBox(height: edge * 0.75),
                        Text(
                          'MEASUREMENTS:',
                          style: TextStyle(
                            fontSize: titleSize * 0.92,
                            fontWeight: FontWeight.w900,
                            color: _ink,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: edge * 0.55),
                        _MeasureRow(
                          icon: Icons.straighten_rounded,
                          iconColor: const Color(0xFFE65100),
                          label: 'HEIGHT:',
                          value: '${spec.heightCm} cm',
                          fontSize: bodySize,
                        ),
                        SizedBox(height: edge * 0.45),
                        _MeasureRow(
                          icon: Icons.monitor_weight_outlined,
                          iconColor: const Color(0xFFC62828),
                          label: 'WEIGHT:',
                          value: '${spec.weightKg} kg',
                          fontSize: bodySize,
                        ),
                        SizedBox(height: edge * 0.75),
                        _DottedLine(width: maxW - edge * 2),
                        SizedBox(height: edge * 0.85),
                        _BmiCard(
                          spec: spec,
                          bmiLabelSize: bmiLabelSize,
                          bmiMainSize: bmiMainSize,
                          bmiSubSize: bmiSubSize,
                        ),
                        SizedBox(height: edge * 0.95),
                        _TipsPanel(
                          outcome: outcome,
                          tips: spec.tips,
                          bodySize: bodySize,
                        ),
                        SizedBox(height: edge * 1.1),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _ink.withValues(alpha: 0.08),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.10),
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Text(
                            spec.footer,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: (maxW * 0.038).clamp(14.0, 20.0),
                              fontWeight: FontWeight.w900,
                              color: _ink,
                              letterSpacing: 0.4,
                              height: 1.25,
                            ),
                          ),
                        ),
                        SizedBox(height: edge * 1.0),
                        if (reportId != null) ...[
                          _ReportActions(
                            reportId: reportId!,
                            outcome: outcome,
                            spec: spec,
                            stamp: stamp,
                            buttonW: buttonW,
                          ),
                          SizedBox(height: edge * 0.8),
                        ],
                        Center(
                          child: SnakPillButton(
                            label: 'DONE',
                            labelColor: _doneGreen,
                            width: buttonW,
                            height: buttonH,
                            onPressed: onDone,
                          ),
                        ),
                      ],
                    ),
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

class _HealthSpec {
  const _HealthSpec({
    required this.heightCm,
    required this.weightKg,
    required this.categoryTitle,
    required this.categorySubtitle,
    required this.tips,
    required this.footer,
    required this.bmiGradient,
    required this.bmiBorder,
    required this.faceBg,
    required this.faceIcon,
    required this.faceColor,
  });

  final int heightCm;
  final int weightKg;
  final String categoryTitle;
  final String categorySubtitle;
  final List<String> tips;
  final String footer;
  final List<Color> bmiGradient;
  final Color bmiBorder;
  final Color faceBg;
  final IconData faceIcon;
  final Color faceColor;
}

_HealthSpec _spec(MeasurementResultOutcome o) {
  return switch (o) {
    MeasurementResultOutcome.underweight => const _HealthSpec(
        heightCm: 120,
        weightKg: 18,
        categoryTitle: 'UNDERWEIGHT',
        categorySubtitle: '(LOWER THAN NORMAL)',
        tips: [
          'If you are underweight, your body needs more food.',
          'Eat three full meals every day with complete GO, GROW, and GLOW foods.',
          'Add healthy snacks like fruits, eggs, or milk.',
          'Do not skip meals even when you are busy.',
          'Wash your hands and sleep early',
        ],
        footer: 'A HEALTHY LIFE, A HAPPY LIFE!',
        bmiGradient: [Color(0xFFFFF9C4), Color(0xFFFFECB3)],
        bmiBorder: Color(0xFFFFB74D),
        faceBg: Color(0xFFFFD54F),
        faceIcon: Icons.sentiment_dissatisfied_rounded,
        faceColor: Color(0xFF5D4037),
      ),
    MeasurementResultOutcome.normal => const _HealthSpec(
        heightCm: 135,
        weightKg: 30,
        categoryTitle: 'NORMAL',
        categorySubtitle: '(WAY TO GO!)',
        tips: [
          'Eat balanced meals with vegetables, fruits, rice, and protein.',
          'Stay active every day by playing or exercising.',
          'Drink plenty of water.',
          'Avoid too much sugary drinks, junk food, and screen time.',
          'Practice good hygiene and healthy habits every day.',
        ],
        footer: 'KEEP UP THE GOOD WORK!',
        bmiGradient: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
        bmiBorder: Color(0xFF43A047),
        faceBg: Color(0xFF66BB6A),
        faceIcon: Icons.sentiment_satisfied_alt_rounded,
        faceColor: Colors.white,
      ),
    MeasurementResultOutcome.overweight => const _HealthSpec(
        heightCm: 128,
        weightKg: 32,
        categoryTitle: 'OVERWEIGHT',
        categorySubtitle: '(HIGHER THAN NORMAL)',
        tips: [
          'Eat more healthy foods that fill you up, like vegetables and clear soup.',
          'Choose energy-giving foods.',
          'Do not skip meals to avoid overeating later.',
          'Avoid too much sweet, salty, and processed foods like chips and fast food.',
          'Drink plenty of water and limit sugary drinks like soda, milk tea, and juice.',
        ],
        footer: 'YOU CAN DO IT!',
        bmiGradient: [Color(0xFFFFEBEE), Color(0xFFFFCDD2)],
        bmiBorder: Color(0xFFE57373),
        faceBg: Color(0xFFEF5350),
        faceIcon: Icons.sentiment_dissatisfied_rounded,
        faceColor: Colors.white,
      ),
  };
}

class _Cloud extends StatelessWidget {
  const _Cloud({required this.w, required this.h});

  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(h * 0.5),
        border: Border.all(
          color: const Color(0xFFFFCDD2).withValues(alpha: 0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

class _DottedLine extends StatelessWidget {
  const _DottedLine({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedLinePainter(),
      size: Size(width, 6),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dash = 5.0;
    const gap = 4.0;
    final paint = Paint()
      ..color = MeasurementResultPage._ink
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    var x = 0.0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(
          Offset(x, y), Offset((x + dash).clamp(0, size.width), y), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MeasureRow extends StatelessWidget {
  const _MeasureRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.fontSize,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: fontSize * 1.35, color: iconColor),
        SizedBox(width: fontSize * 0.55),
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: MeasurementResultPage._ink,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: MeasurementResultPage._ink,
          ),
        ),
      ],
    );
  }
}

class _BmiCard extends StatelessWidget {
  const _BmiCard({
    required this.spec,
    required this.bmiLabelSize,
    required this.bmiMainSize,
    required this.bmiSubSize,
  });

  final _HealthSpec spec;
  final double bmiLabelSize;
  final double bmiMainSize;
  final double bmiSubSize;

  @override
  Widget build(BuildContext context) {
    final faceD = (bmiMainSize * 2.1).clamp(72.0, 108.0);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: spec.bmiGradient,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: spec.bmiBorder, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 18, 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: faceD,
              height: faceD,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: spec.faceBg,
                boxShadow: [
                  BoxShadow(
                    color: spec.faceBg.withValues(alpha: 0.45),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                spec.faceIcon,
                size: faceD * 0.52,
                color: spec.faceColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR BMI CATEGORY IS:',
                    style: TextStyle(
                      fontSize: bmiLabelSize,
                      fontWeight: FontWeight.w800,
                      color: MeasurementResultPage._ink,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    spec.categoryTitle,
                    style: TextStyle(
                      fontSize: bmiMainSize,
                      fontWeight: FontWeight.w900,
                      color: MeasurementResultPage._ink,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    spec.categorySubtitle,
                    style: TextStyle(
                      fontSize: bmiSubSize,
                      fontWeight: FontWeight.w800,
                      color: MeasurementResultPage._ink.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipsPanel extends StatelessWidget {
  const _TipsPanel({
    required this.outcome,
    required this.tips,
    required this.bodySize,
  });

  final MeasurementResultOutcome outcome;
  final List<String> tips;
  final double bodySize;

  (IconData, Color, IconData, Color) _sideIcons() {
    return switch (outcome) {
      MeasurementResultOutcome.underweight => (
          Icons.restaurant_rounded,
          const Color(0xFF2E7D32),
          Icons.wash_rounded,
          const Color(0xFF0277BD),
        ),
      MeasurementResultOutcome.normal => (
          Icons.restaurant_menu_rounded,
          const Color(0xFF2E7D32),
          Icons.directions_run_rounded,
          const Color(0xFFE65100),
        ),
      MeasurementResultOutcome.overweight => (
          Icons.eco_rounded,
          const Color(0xFF2E7D32),
          Icons.local_drink_rounded,
          const Color(0xFF0277BD),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final ic = _sideIcons();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MeasurementResultPage._ink.withValues(alpha: 0.08),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TIPS:',
              style: TextStyle(
                fontSize: bodySize * 0.95,
                fontWeight: FontWeight.w900,
                color: MeasurementResultPage._ink,
              ),
            ),
            SizedBox(height: bodySize * 0.55),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(
                      ic.$1,
                      size: bodySize * 1.5,
                      color: ic.$2,
                    ),
                    SizedBox(height: bodySize * 0.9),
                    Icon(
                      ic.$3,
                      size: bodySize * 1.5,
                      color: ic.$4,
                    ),
                  ],
                ),
                SizedBox(width: bodySize * 0.65),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < tips.length; i++) ...[
                        if (i > 0) SizedBox(height: bodySize * 0.55),
                        Text(
                          '• ${tips[i]}',
                          style: TextStyle(
                            fontSize: bodySize * 0.92,
                            fontWeight: FontWeight.w600,
                            color: MeasurementResultPage._ink,
                            height: 1.38,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportActions extends StatelessWidget {
  const _ReportActions({
    required this.reportId,
    required this.outcome,
    required this.spec,
    required this.stamp,
    required this.buttonW,
  });

  final String reportId;
  final MeasurementResultOutcome outcome;
  final _HealthSpec spec;
  final String stamp;
  final double buttonW;

  Future<void> _showQr(BuildContext context) async {
    final url = _reportUrl(reportId);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Scan to view report'),
        content: SizedBox(
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 240,
                height: 240,
                child: QrImageView(
                  data: url,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Scan this QR code on the Snak app to view the report.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadPdf() async {
    final url = _reportUrl(reportId);
    final doc = pw.Document();

    PdfColor c(Color v) => PdfColor.fromInt(v.toARGB32());
    final ink = c(MeasurementResultPage._ink);
    final cream = c(MeasurementResultPage._cream);
    final panelTop = c(MeasurementResultPage._panelTop);
    final panelBottom = c(MeasurementResultPage._panelBottom);
    final bmiTop = c(spec.bmiGradient.first);
    final bmiBottom = c(spec.bmiGradient.last);
    final bmiBorder = c(spec.bmiBorder);

    pw.Widget measureRow(String label, String value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Row(
          children: [
            pw.Text(label,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 13, color: ink)),
            pw.Spacer(),
            pw.Text(value,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 13, color: ink)),
          ],
        ),
      );
    }

    pw.Widget dottedDivider() => pw.Container(
          height: 1,
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: ink, width: 1, style: pw.BorderStyle.dashed),
            ),
          ),
        );

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (ctx) => pw.Container(
          decoration: pw.BoxDecoration(
            gradient: pw.LinearGradient(
              begin: pw.Alignment.topCenter,
              end: pw.Alignment.bottomCenter,
              colors: [cream, panelTop, panelBottom],
              stops: const [0.0, 0.15, 1.0],
            ),
          ),
          padding: const pw.EdgeInsets.all(28),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Center(
                child: pw.Text(
                  'HEALTH FINDINGS:',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: ink,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  stamp,
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(0xFF555555),
                  ),
                ),
              ),
              pw.SizedBox(height: 16),
              dottedDivider(),
              pw.SizedBox(height: 14),
              pw.Text('MEASUREMENTS:',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold, color: ink)),
              pw.SizedBox(height: 6),
              measureRow('HEIGHT:', '${spec.heightCm} cm'),
              measureRow('WEIGHT:', '${spec.weightKg} kg'),
              pw.SizedBox(height: 14),
              dottedDivider(),
              pw.SizedBox(height: 14),
              pw.Container(
                decoration: pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    begin: pw.Alignment.topLeft,
                    end: pw.Alignment.bottomRight,
                    colors: [bmiTop, bmiBottom],
                  ),
                  borderRadius: pw.BorderRadius.circular(16),
                  border: pw.Border.all(color: bmiBorder, width: 2),
                ),
                padding: const pw.EdgeInsets.all(16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('YOUR BMI CATEGORY IS:',
                        style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            color: ink)),
                    pw.SizedBox(height: 4),
                    pw.Text(spec.categoryTitle,
                        style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: ink)),
                    pw.SizedBox(height: 2),
                    pw.Text(spec.categorySubtitle,
                        style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            color: ink)),
                  ],
                ),
              ),
              pw.SizedBox(height: 14),
              pw.Container(
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(14),
                  border: pw.Border.all(
                      color: PdfColor.fromInt(0x14000000), width: 1),
                ),
                padding: const pw.EdgeInsets.all(14),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('TIPS:',
                        style: pw.TextStyle(
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                            color: ink)),
                    pw.SizedBox(height: 6),
                    for (final t in spec.tips)
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 2),
                        child: pw.Text('• $t',
                            style: pw.TextStyle(
                              fontSize: 11,
                              color: ink,
                              lineSpacing: 2,
                            )),
                      ),
                  ],
                ),
              ),
              pw.SizedBox(height: 14),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 12, horizontal: 12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(12),
                  border: pw.Border.all(
                      color: PdfColor.fromInt(0x14000000), width: 1),
                ),
                child: pw.Center(
                  child: pw.Text(
                    spec.footer,
                    style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: ink,
                        letterSpacing: 0.4),
                  ),
                ),
              ),
              pw.Spacer(),
              pw.Center(
                child: pw.Column(children: [
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: url,
                    width: 110,
                    height: 110,
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text('Scan this QR code on the Snak app to view the report.',
                      style: pw.TextStyle(
                          fontSize: 10, color: PdfColor.fromInt(0xFF555555))),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'snak-report-$reportId.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final btnH = (buttonW / 5.5).clamp(40.0, 64.0).toDouble();
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: buttonW),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: btnH,
                child: OutlinedButton.icon(
                  onPressed: () => _showQr(context),
                  icon: const Icon(Icons.qr_code_2_rounded),
                  label: const Text('VIEW QR'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: btnH,
                child: OutlinedButton.icon(
                  onPressed: _downloadPdf,
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  label: const Text('DOWNLOAD PDF'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
