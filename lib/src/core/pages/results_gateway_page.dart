import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../widgets/common/mascot.dart';
import '../widgets/common/snak_pill_button.dart';
import 'measurement_result_page.dart';

const String _reportBaseUrlOverride =
    String.fromEnvironment('SNAK_REPORT_BASE_URL');

const String _prodReportBaseUrl =
    'https://christiangerardhizon.github.io/snak/#/reports';
const String _localReportBaseUrl = 'http://localhost:8000/#/reports';

String get _reportBaseUrl {
  if (_reportBaseUrlOverride.isNotEmpty) return _reportBaseUrlOverride;
  return kReleaseMode ? _prodReportBaseUrl : _localReportBaseUrl;
}

String _reportUrl(String reportId) => '$_reportBaseUrl/$reportId';

/// Post-result step. Shows a phone mockup with a "Great Job!" / similar
/// summary, plus a giant QR code so the user can scan or print their report.
class ResultsGatewayPage extends StatelessWidget {
  const ResultsGatewayPage({
    super.key,
    required this.outcome,
    required this.reportId,
    required this.onDone,
    this.studentName,
    this.schoolId,
    this.age,
    this.sex,
    this.heightMeters,
    this.weightKg,
    this.bmi,
    this.visitDate,
  });

  final MeasurementResultOutcome outcome;
  final String? reportId;
  final VoidCallback onDone;
  final String? studentName;
  final String? schoolId;
  final int? age;
  final String? sex;
  final double? heightMeters;
  final double? weightKg;
  final double? bmi;
  final DateTime? visitDate;

  @override
  Widget build(BuildContext context) {
    final spec = _summaryFor(outcome);

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
              child: LayoutBuilder(
                builder: (context, c) {
                  final maxW = c.maxWidth;
                  final maxH = c.maxHeight;

                  final cardW = (maxW * 0.94).clamp(360.0, 1100.0).toDouble();
                  final cardH = (maxH * 0.86).clamp(420.0, 720.0).toDouble();

                  final logoW = (maxW * 0.12).clamp(72.0, 160.0).toDouble();
                  final logoH = logoW / SnakLogoRaster.aspect;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: maxW * 0.03,
                      vertical: maxH * 0.02,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: _GatewayCard(
                              cardWidth: cardW,
                              cardHeight: cardH,
                              spec: spec,
                              outcome: outcome,
                              reportId: reportId,
                              studentName: studentName,
                              schoolId: schoolId,
                              age: age,
                              sex: sex,
                              heightMeters: heightMeters,
                              weightKg: weightKg,
                              bmi: bmi,
                              visitDate: visitDate,
                              onDone: onDone,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GatewayCard extends StatelessWidget {
  const _GatewayCard({
    required this.cardWidth,
    required this.cardHeight,
    required this.spec,
    required this.outcome,
    required this.reportId,
    required this.studentName,
    required this.schoolId,
    required this.age,
    required this.sex,
    required this.heightMeters,
    required this.weightKg,
    required this.bmi,
    required this.visitDate,
    required this.onDone,
  });

  final double cardWidth;
  final double cardHeight;
  final _SummarySpec spec;
  final MeasurementResultOutcome outcome;
  final String? reportId;
  final String? studentName;
  final String? schoolId;
  final int? age;
  final String? sex;
  final double? heightMeters;
  final double? weightKg;
  final double? bmi;
  final DateTime? visitDate;
  final VoidCallback onDone;

  static const _bodyBlue = Color(0xFF2575FC);
  static const _doneGreen = Color(0xFF22C55E);
  static const _printGreen = Color(0xFF6CC04A);

  @override
  Widget build(BuildContext context) {
    final phoneColW = cardWidth * 0.42;
    final rightColW = cardWidth - phoneColW;

    final qrSide = (rightColW * 0.55).clamp(180.0, 340.0).toDouble();
    final pillH = (cardHeight * 0.11).clamp(48.0, 72.0).toDouble();
    final pillW = (cardWidth * 0.32).clamp(180.0, 280.0).toDouble();

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
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
          Positioned(
            left: cardWidth * 0.02,
            top: cardHeight * 0.04,
            bottom: cardHeight * 0.04,
            width: phoneColW,
            child: _PhoneMock(
              spec: spec,
              printColor: _printGreen,
              onPrint: reportId == null
                  ? null
                  : () => _downloadPdf(
                        reportId: reportId!,
                        outcome: outcome,
                        studentName: studentName,
                        schoolId: schoolId,
                        age: age,
                        sex: sex,
                        heightMeters: heightMeters,
                        weightKg: weightKg,
                        bmi: bmi,
                        visitDate: visitDate,
                      ),
            ),
          ),
          Positioned(
            left: phoneColW + cardWidth * 0.02,
            top: cardHeight * 0.05,
            right: cardWidth * 0.04,
            bottom: pillH + cardHeight * 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ResultsHereBanner(
                  width: rightColW * 0.92,
                  height: cardHeight * 0.16,
                ),
                SizedBox(height: cardHeight * 0.03),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: qrSide,
                        height: qrSide,
                        padding: EdgeInsets.all(qrSide * 0.06),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(qrSide * 0.08),
                          border: Border.all(
                            color: const Color(0xFFB8CDEB),
                            width: 3,
                          ),
                        ),
                        child: reportId == null
                            ? const Center(
                                child: Icon(Icons.qr_code_2_rounded,
                                    size: 100, color: Colors.black26),
                              )
                            : QrImageView(
                                data: _reportUrl(reportId!),
                                backgroundColor: Colors.white,
                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: Color(0xFF2C4A8C),
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: Color(0xFF2C4A8C),
                                ),
                              ),
                      ),
                      SizedBox(width: rightColW * 0.04),
                      Expanded(
                        child: Mascot.sitting(
                          width: qrSide * 0.85,
                          height: qrSide * 0.85,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: cardHeight * 0.02),
                Text(
                  'Click ',
                  style: TextStyle(
                    color: _bodyBlue,
                    fontSize: (cardWidth * 0.022).clamp(14.0, 24.0),
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                  ),
                ),
                _ClickPrintLine(
                  baseColor: _bodyBlue,
                  highlightColor: _printGreen,
                  fontSize: (cardWidth * 0.022).clamp(14.0, 24.0).toDouble(),
                ),
              ],
            ),
          ),
          Positioned(
            right: cardWidth * 0.04,
            bottom: cardHeight * 0.05,
            child: SnakPillButton(
              label: 'DONE',
              labelColor: _doneGreen,
              width: pillW,
              height: pillH,
              onPressed: onDone,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsHereBanner extends StatelessWidget {
  const _ResultsHereBanner({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: height * 0.05,
            top: height * 0.1,
            child: Icon(
              Icons.mark_email_unread_rounded,
              size: height * 0.85,
              color: const Color(0xFFB8CDEB),
            ),
          ),
          Positioned(
            left: height * 0.95,
            right: 0,
            top: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF6CC04A),
                borderRadius: BorderRadius.circular(height * 0.4),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.4),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Get your\nResults here!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: height * 0.32,
                        height: 1.05,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClickPrintLine extends StatelessWidget {
  const _ClickPrintLine({
    required this.baseColor,
    required this.highlightColor,
    required this.fontSize,
  });

  final Color baseColor;
  final Color highlightColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: baseColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          height: 1.25,
        ),
        children: [
          const TextSpan(text: 'Click '),
          TextSpan(
            text: 'PRINT',
            style: TextStyle(color: highlightColor),
          ),
          const TextSpan(
            text:
                ' or scan the QR code to view your\nhealth results and discover more tips!',
          ),
        ],
      ),
    );
  }
}

class _PhoneMock extends StatelessWidget {
  const _PhoneMock({
    required this.spec,
    required this.printColor,
    required this.onPrint,
  });

  final _SummarySpec spec;
  final Color printColor;
  final VoidCallback? onPrint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final h = c.maxHeight;
      final phoneW = (h * 0.5).clamp(160.0, w);
      final phoneH = h * 0.95;

      return Center(
        child: SizedBox(
          width: phoneW,
          height: phoneH,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(phoneW * 0.1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                phoneW * 0.04,
                phoneW * 0.1,
                phoneW * 0.04,
                phoneW * 0.06,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(phoneW * 0.05),
                ),
                child: Padding(
                  padding: EdgeInsets.all(phoneW * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        spec.title,
                        style: TextStyle(
                          color: const Color(0xFF5A3A1F),
                          fontWeight: FontWeight.w900,
                          fontSize: phoneW * 0.085,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: phoneW * 0.02),
                      Text(
                        spec.subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF5A3A1F),
                          fontWeight: FontWeight.w800,
                          fontSize: phoneW * 0.05,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: phoneW * 0.06),
                      Container(
                        width: phoneW * 0.42,
                        height: phoneW * 0.42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: spec.faceColor,
                          boxShadow: [
                            BoxShadow(
                              color: spec.faceColor.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          spec.faceIcon,
                          color: Colors.white,
                          size: phoneW * 0.28,
                        ),
                      ),
                      const Spacer(),
                      _ColorLegend(fontSize: phoneW * 0.045),
                      SizedBox(height: phoneW * 0.05),
                      SizedBox(
                        width: double.infinity,
                        height: phoneW * 0.16,
                        child: SnakPillButton(
                          label: 'PRINT',
                          labelColor: printColor,
                          width: phoneW * 0.7,
                          height: phoneW * 0.16,
                          onPressed: onPrint ?? () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _ColorLegend extends StatelessWidget {
  const _ColorLegend({required this.fontSize});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    Widget row(Color dot, String label) => Padding(
          padding: EdgeInsets.symmetric(vertical: fontSize * 0.1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: fontSize * 0.7,
                height: fontSize * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dot,
                ),
              ),
              SizedBox(width: fontSize * 0.4),
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF5A3A1F),
                  fontWeight: FontWeight.w800,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F1E5),
        borderRadius: BorderRadius.circular(fontSize),
        border: Border.all(color: const Color(0xFFD9CFB8), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: fontSize * 0.7,
          vertical: fontSize * 0.4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Color-coded\nresult:',
              style: TextStyle(
                color: const Color(0xFF5A3A1F),
                fontWeight: FontWeight.w900,
                fontSize: fontSize * 0.95,
                height: 1.05,
              ),
            ),
            SizedBox(height: fontSize * 0.2),
            row(const Color(0xFF22C55E), 'Healthy'),
            row(const Color(0xFFE6B800), 'Improve'),
            row(const Color(0xFFE53935), 'Needs attention'),
          ],
        ),
      ),
    );
  }
}

class _SummarySpec {
  const _SummarySpec({
    required this.title,
    required this.subtitle,
    required this.faceColor,
    required this.faceIcon,
  });

  final String title;
  final String subtitle;
  final Color faceColor;
  final IconData faceIcon;
}

_SummarySpec _summaryFor(MeasurementResultOutcome o) {
  return switch (o) {
    MeasurementResultOutcome.normal => const _SummarySpec(
        title: 'Great Job!',
        subtitle: 'You are healthy! Keep it up!',
        faceColor: Color(0xFF22C55E),
        faceIcon: Icons.sentiment_very_satisfied_rounded,
      ),
    MeasurementResultOutcome.underweight => const _SummarySpec(
        title: 'Keep Going!',
        subtitle: 'Eat well and stay strong!',
        faceColor: Color(0xFFE6B800),
        faceIcon: Icons.sentiment_neutral_rounded,
      ),
    MeasurementResultOutcome.overweight => const _SummarySpec(
        title: "Let's Improve!",
        subtitle: 'Small changes make a big difference!',
        faceColor: Color(0xFFE53935),
        faceIcon: Icons.sentiment_dissatisfied_rounded,
      ),
  };
}

Future<void> _downloadPdf({
  required String reportId,
  required MeasurementResultOutcome outcome,
  String? studentName,
  String? schoolId,
  int? age,
  String? sex,
  double? heightMeters,
  double? weightKg,
  double? bmi,
  DateTime? visitDate,
}) async {
  final hSpec = healthOutcomeSpec(outcome);
  final url = _reportUrl(reportId);
  final stamp = DateFormat('MMM d, yyyy | h:mm a')
      .format(visitDate ?? DateTime.now())
      .toUpperCase();

  final displayHeight = heightMeters ?? hSpec.fallbackHeightM;
  final displayWeight = weightKg ?? hSpec.fallbackWeightKg.toDouble();
  final displayBmi = bmi ?? hSpec.fallbackBmi;

  final logoBytes = (await rootBundle.load(Assets.images.snakLogo.path))
      .buffer
      .asUint8List();
  final logoImg = pw.MemoryImage(logoBytes);

  const ink = PdfColor.fromInt(0xFF3E2A18);
  final cardBorder = PdfColor.fromInt(0xFFE7C97A);
  final bannerBg = _toPdfColor(hSpec.bannerBg);
  final bannerBorder = _toPdfColor(hSpec.bannerBorder);
  final faceColor = _toPdfColor(hSpec.faceColor);
  final footerColor = _toPdfColor(hSpec.footerColor);

  final labelStyle = pw.TextStyle(
    color: ink,
    fontWeight: pw.FontWeight.bold,
    fontSize: 11,
    letterSpacing: 0.4,
  );
  final valueStyle = pw.TextStyle(
    color: ink,
    fontWeight: pw.FontWeight.bold,
    fontSize: 11,
    decoration: pw.TextDecoration.underline,
  );

  pw.Widget infoCell(String label, String value) => pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(text: label, style: labelStyle),
            const pw.TextSpan(text: '  '),
            pw.TextSpan(text: value, style: valueStyle),
          ],
        ),
      );

  pw.Widget measureLine(String label, String value) => pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 90,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                color: ink,
                fontWeight: pw.FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                color: ink,
                fontWeight: pw.FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      );

  final doc = pw.Document();
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (ctx) => pw.Container(
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          borderRadius: pw.BorderRadius.circular(20),
          border: pw.Border.all(color: cardBorder, width: 2),
        ),
        padding: const pw.EdgeInsets.fromLTRB(28, 24, 28, 20),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Center(
              child: pw.SizedBox(
                width: 140,
                child: pw.Image(logoImg, fit: pw.BoxFit.contain),
              ),
            ),
            pw.SizedBox(height: 14),
            // BMI banner
            pw.Container(
              decoration: pw.BoxDecoration(
                color: bannerBg,
                borderRadius: pw.BorderRadius.circular(10),
                border: pw.Border.all(color: bannerBorder, width: 1.5),
              ),
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  _PdfFace(color: faceColor, smile: hSpec.smiling, size: 56),
                  pw.SizedBox(width: 14),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          'YOUR BMI RESULT IS: ${displayBmi.toStringAsFixed(1)}',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            color: ink,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 0.3,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          hSpec.categoryTitle,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            color: ink,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 22,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 14),
            pw.Center(
              child: pw.Text(
                stamp,
                style: pw.TextStyle(
                  color: ink,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            _PdfDottedDivider(color: ink),
            pw.SizedBox(height: 12),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 6,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      infoCell('NAME:', studentName ?? '—'),
                      pw.SizedBox(height: 6),
                      infoCell('SCHOOL ID:', schoolId ?? '—'),
                    ],
                  ),
                ),
                pw.Expanded(
                  flex: 4,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      infoCell('AGE:', age?.toString() ?? '—'),
                      pw.SizedBox(height: 6),
                      infoCell('SEX:', sex ?? '—'),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 12),
            _PdfDottedDivider(color: ink),
            pw.SizedBox(height: 14),
            measureLine(
              'HEIGHT:',
              '${displayHeight.toStringAsFixed(2)} meter',
            ),
            pw.SizedBox(height: 6),
            measureLine(
              'WEIGHT:',
              '${displayWeight.toStringAsFixed(displayWeight.truncateToDouble() == displayWeight ? 0 : 1)} kilograms',
            ),
            pw.SizedBox(height: 14),
            // Tips box
            pw.Container(
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(10),
                border: pw.Border.all(
                  color: PdfColor.fromInt(0x733E2A18),
                  width: 1,
                ),
              ),
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 70,
                    child: pw.Text(
                      'TIPS:',
                      style: pw.TextStyle(
                        color: ink,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        for (final tip in hSpec.tips) ...[
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(vertical: 1.5),
                            child: pw.Text(
                              '• $tip',
                              style: pw.TextStyle(
                                color: ink,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 11,
                                lineSpacing: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Center(
              child: pw.Text(
                hSpec.footer,
                style: pw.TextStyle(
                  color: footerColor,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            pw.Spacer(),
            pw.Center(
              child: pw.Column(
                children: [
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: url,
                    width: 110,
                    height: 110,
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    'Scan to view your full report.',
                    style: pw.TextStyle(
                      color: ink,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  await Printing.sharePdf(
    bytes: await doc.save(),
    filename: 'snak-results-$reportId.pdf',
  );
}

PdfColor _toPdfColor(Color c) => PdfColor.fromInt(c.toARGB32());

class _PdfDottedDivider extends pw.StatelessWidget {
  _PdfDottedDivider({required this.color});

  final PdfColor color;

  @override
  pw.Widget build(pw.Context context) {
    return pw.LayoutBuilder(builder: (ctx, constraints) {
      final w = constraints?.maxWidth ?? 0;
      const dash = 4.0;
      const gap = 4.0;
      final count = (w / (dash + gap)).floor();
      return pw.Row(
        children: [
          for (var i = 0; i < count; i++) ...[
            pw.Container(width: dash, height: 1.5, color: color),
            pw.SizedBox(width: gap),
          ],
        ],
      );
    });
  }
}

class _PdfFace extends pw.StatelessWidget {
  _PdfFace({required this.color, required this.smile, required this.size});

  final PdfColor color;
  final bool smile;
  final double size;

  @override
  pw.Widget build(pw.Context context) {
    return pw.SizedBox(
      width: size,
      height: size,
      child: pw.CustomPaint(
        size: PdfPoint(size, size),
        painter: (canvas, sz) {
          final stroke = size * 0.06;
          final r = size * 0.5 - stroke / 2;
          final cx = size / 2;
          final cy = size / 2;
          canvas
            ..setStrokeColor(color)
            ..setLineWidth(stroke)
            ..setLineCap(PdfLineCap.round)
            ..drawEllipse(cx, cy, r, r)
            ..strokePath();
          // eyes
          canvas
            ..setFillColor(color)
            ..drawEllipse(cx - r * 0.32, cy + r * 0.28, size * 0.05,
                size * 0.05)
            ..drawEllipse(cx + r * 0.32, cy + r * 0.28, size * 0.05,
                size * 0.05)
            ..fillPath();
          // mouth: simple line/curve approximation
          canvas
            ..setStrokeColor(color)
            ..setLineWidth(stroke);
          if (smile) {
            // arc downward (PDF y is up): smile = lower curve
            final mY = cy - r * 0.18;
            canvas
              ..moveTo(cx - r * 0.45, mY)
              ..curveTo(
                cx - r * 0.2, mY - r * 0.45,
                cx + r * 0.2, mY - r * 0.45,
                cx + r * 0.45, mY,
              )
              ..strokePath();
          } else {
            final mY = cy - r * 0.42;
            canvas
              ..moveTo(cx - r * 0.45, mY)
              ..curveTo(
                cx - r * 0.2, mY + r * 0.35,
                cx + r * 0.2, mY + r * 0.35,
                cx + r * 0.45, mY,
              )
              ..strokePath();
          }
        },
      ),
    );
  }
}
