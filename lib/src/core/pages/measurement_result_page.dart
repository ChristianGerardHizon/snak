import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../widgets/common/snak_pill_button.dart';
import '../packages/theme/app_themes.dart';

/// BMI-style result for [MeasurementResultPage] (Health Findings).
enum MeasurementResultOutcome {
  underweight,
  normal,
  overweight,
}

/// Health Findings report card.
class MeasurementResultPage extends StatelessWidget {
  const MeasurementResultPage({
    super.key,
    required this.outcome,
    required this.onDone,
    this.reportId,
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
  final VoidCallback onDone;
  final String? reportId;
  final String? studentName;
  final String? schoolId;
  final int? age;
  final String? sex;
  final double? heightMeters;
  final double? weightKg;
  final double? bmi;
  final DateTime? visitDate;

  static const _ink = Color(0xFF3E2A18);
  static const _doneGreen = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    final spec = _spec(outcome);
    final stamp = DateFormat('MMM d, yyyy | h:mm a')
        .format(visitDate ?? DateTime.now())
        .toUpperCase();

    final displayHeight = heightMeters ?? spec.fallbackHeightM;
    final displayWeight = weightKg ?? spec.fallbackWeightKg.toDouble();
    final displayBmi = bmi ?? spec.fallbackBmi;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Material(
        type: MaterialType.transparency,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth;
                  final maxH = constraints.maxHeight;

                  // On wider landscape viewports (iPad 10 landscape ≈
                  // 1180×~760 safe) widen the card so the report content fits
                  // without scrolling, and let the height clamp follow the
                  // viewport instead of capping at 880.
                  final isWideLandscape = maxW > maxH * 1.2;
                  final cardW = isWideLandscape
                      ? (maxW * 0.62).clamp(360.0, 880.0).toDouble()
                      : (maxW * 0.7).clamp(360.0, 720.0).toDouble();
                  final cardH =
                      (maxH * 0.96).clamp(520.0, 1040.0).toDouble();

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: maxW * 0.03,
                      vertical: maxH * 0.02,
                    ),
                    child: Center(
                      child: _ResultCard(
                        width: cardW,
                        height: cardH,
                        spec: spec,
                        stamp: stamp,
                        studentName: studentName,
                        schoolId: schoolId,
                        age: age,
                        sex: sex,
                        heightMeters: displayHeight,
                        weightKg: displayWeight,
                        bmi: displayBmi,
                        doneColor: _doneGreen,
                        onDone: onDone,
                      ),
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

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.width,
    required this.height,
    required this.spec,
    required this.stamp,
    required this.studentName,
    required this.schoolId,
    required this.age,
    required this.sex,
    required this.heightMeters,
    required this.weightKg,
    required this.bmi,
    required this.doneColor,
    required this.onDone,
  });

  final double width;
  final double height;
  final HealthOutcomeSpec spec;
  final String stamp;
  final String? studentName;
  final String? schoolId;
  final int? age;
  final String? sex;
  final double heightMeters;
  final double weightKg;
  final double bmi;
  final Color doneColor;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final pad = width * 0.04;
    final logoW = (width * 0.22).clamp(120.0, 220.0).toDouble();
    final logoH = logoW / SnakLogoRaster.aspect;

    final labelSize = (width * 0.028).clamp(13.0, 22.0).toDouble();
    final valueSize = (width * 0.032).clamp(14.0, 24.0).toDouble();
    final headerSize = (width * 0.05).clamp(22.0, 38.0).toDouble();
    final measureSize = (width * 0.046).clamp(20.0, 36.0).toDouble();
    final footerSize = (width * 0.05).clamp(20.0, 38.0).toDouble();

    final labelStyle = TextStyle(
      fontFamily: AppThemes.fontFamily,
      color: MeasurementResultPage._ink,
      fontWeight: FontWeight.w900,
      fontSize: labelSize,
      letterSpacing: 0.4,
      height: 1.1,
    );
    final valueStyle = TextStyle(
      fontFamily: AppThemes.fontFamily,
      color: MeasurementResultPage._ink,
      fontWeight: FontWeight.w800,
      fontSize: valueSize,
      height: 1.1,
    );

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFFE7C97A),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(pad * 1.2, pad, pad * 1.2, pad * 0.6),
          child: LayoutBuilder(
            builder: (context, c) => FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: c.maxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                Center(
                  child: SizedBox(
                    width: logoW,
                    height: logoH,
                    child: Assets.images.snakLogo.image(
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
                SizedBox(height: pad * 0.5),
                _BmiBanner(
                  spec: spec,
                  bmi: bmi,
                  headerSize: headerSize,
                ),
                SizedBox(height: pad * 0.8),
                Center(
                  child: Text(
                    stamp,
                    style: TextStyle(
                      fontFamily: AppThemes.fontFamily,
                      color: MeasurementResultPage._ink,
                      fontWeight: FontWeight.w900,
                      fontSize: labelSize,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(height: pad * 0.4),
                _DottedDivider(color: MeasurementResultPage._ink),
                SizedBox(height: pad * 0.6),
                _StudentInfoRows(
                  name: studentName ?? '—',
                  schoolId: schoolId ?? '—',
                  age: age?.toString() ?? '—',
                  sex: sex ?? '—',
                  labelStyle: labelStyle,
                  valueStyle: valueStyle,
                ),
                SizedBox(height: pad * 0.6),
                _DottedDivider(color: MeasurementResultPage._ink),
                SizedBox(height: pad * 0.7),
                _MeasureLine(
                  label: 'HEIGHT:',
                  value: '${heightMeters.toStringAsFixed(2)} meter',
                  fontSize: measureSize,
                ),
                SizedBox(height: pad * 0.3),
                _MeasureLine(
                  label: 'WEIGHT:',
                  value:
                      '${weightKg.toStringAsFixed(weightKg.truncateToDouble() == weightKg ? 0 : 1)} kilograms',
                  fontSize: measureSize,
                ),
                SizedBox(height: pad * 0.7),
                _TipsBox(
                  tips: spec.shortTips,
                  fontSize: labelSize,
                ),
                SizedBox(height: pad * 0.7),
                Center(
                  child: Text(
                    spec.footer,
                    style: TextStyle(
                      fontFamily: AppThemes.fontFamily,
                      color: spec.footerColor,
                      fontWeight: FontWeight.w900,
                      fontSize: footerSize,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                SizedBox(height: pad * 0.9),
                Center(
                  child: SnakPillButton(
                    label: 'DONE',
                    labelColor: doneColor,
                    width: (width * 0.4).clamp(160.0, 260.0).toDouble(),
                    height: (width * 0.1).clamp(48.0, 76.0).toDouble(),
                    onPressed: onDone,
                  ),
                ),
                SizedBox(height: pad * 0.6),
              ],
            ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BmiBanner extends StatelessWidget {
  const _BmiBanner({
    required this.spec,
    required this.bmi,
    required this.headerSize,
  });

  final HealthOutcomeSpec spec;
  final double bmi;
  final double headerSize;

  @override
  Widget build(BuildContext context) {
    final faceSize = headerSize * 3.0;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: spec.bannerBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: spec.bannerBorder, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: headerSize * 0.8,
          vertical: headerSize * 0.7,
        ),
        child: Row(
          children: [
            SizedBox(
              width: faceSize,
              height: faceSize,
              child: CustomPaint(
                painter: _FacePainter(
                  color: spec.faceColor,
                  smile: spec.smiling,
                ),
              ),
            ),
            SizedBox(width: headerSize * 0.6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'YOUR BMI RESULT IS: ${bmi.toStringAsFixed(1)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppThemes.fontFamily,
                      color: MeasurementResultPage._ink,
                      fontWeight: FontWeight.w900,
                      fontSize: headerSize * 0.95,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: headerSize * 0.2),
                  Text(
                    spec.categoryTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppThemes.fontFamily,
                      color: MeasurementResultPage._ink,
                      fontWeight: FontWeight.w900,
                      fontSize: headerSize * 1.55,
                      letterSpacing: 0.6,
                      height: 1.05,
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

class _FacePainter extends CustomPainter {
  _FacePainter({required this.color, required this.smile});

  final Color color;
  final bool smile;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * 0.06;
    final fill = Paint()..color = color;

    final r = size.width * 0.5 - stroke.strokeWidth / 2;
    final c = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(c, r, stroke);

    final eyeR = size.width * 0.05;
    final eyeY = c.dy - r * 0.28;
    canvas.drawCircle(Offset(c.dx - r * 0.32, eyeY), eyeR, fill);
    canvas.drawCircle(Offset(c.dx + r * 0.32, eyeY), eyeR, fill);

    final mouthRect = Rect.fromCenter(
      center: Offset(c.dx, c.dy + r * (smile ? 0.18 : 0.42)),
      width: r * 0.9,
      height: r * 0.6,
    );
    canvas.drawArc(
      mouthRect,
      smile ? 0.2 : 3.34,
      smile ? 2.74 : 2.74,
      false,
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _FacePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.smile != smile;
}

class _StudentInfoRows extends StatelessWidget {
  const _StudentInfoRows({
    required this.name,
    required this.schoolId,
    required this.age,
    required this.sex,
    required this.labelStyle,
    required this.valueStyle,
  });

  final String name;
  final String schoolId;
  final String age;
  final String sex;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    Widget cell(String label, String value) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: label, style: labelStyle),
            const TextSpan(text: '  '),
            TextSpan(text: value, style: valueStyle),
          ],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cell('NAME:', name),
              SizedBox(height: (labelStyle.fontSize ?? 14) * 0.4),
              cell('SCHOOL ID:', schoolId),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cell('AGE:', age),
              SizedBox(height: (labelStyle.fontSize ?? 14) * 0.4),
              cell('GENDER:', sex),
            ],
          ),
        ),
      ],
    );
  }
}

class _MeasureLine extends StatelessWidget {
  const _MeasureLine({
    required this.label,
    required this.value,
    required this.fontSize,
  });

  final String label;
  final String value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: fontSize * 5.4,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppThemes.fontFamily,
              color: MeasurementResultPage._ink,
              fontWeight: FontWeight.w900,
              fontSize: fontSize,
              letterSpacing: 0.3,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: AppThemes.fontFamily,
              color: MeasurementResultPage._ink,
              fontWeight: FontWeight.w900,
              fontSize: fontSize,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _TipsBox extends StatelessWidget {
  const _TipsBox({required this.tips, required this.fontSize});

  final List<String> tips;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: MeasurementResultPage._ink.withValues(alpha: 0.45),
          width: 1.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: fontSize * 0.9,
          vertical: fontSize * 0.7,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  'TIPS:',
                  style: TextStyle(
                    fontFamily: AppThemes.fontFamily,
                    color: MeasurementResultPage._ink,
                    fontWeight: FontWeight.w900,
                    fontSize: fontSize * 1.15,
                  ),
                ),
                SizedBox(height: fontSize * 0.35),
                Row(
                  children: [
                    Icon(
                      Icons.rice_bowl_rounded,
                      size: fontSize * 1.6,
                      color: const Color(0xFF2E7D32),
                    ),
                    SizedBox(width: fontSize * 0.2),
                    Icon(
                      Icons.directions_run_rounded,
                      size: fontSize * 1.6,
                      color: const Color(0xFFE65100),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: fontSize * 0.8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < tips.length; i++) ...[
                    if (i > 0) SizedBox(height: fontSize * 0.2),
                    Text(
                      tips[i],
                      style: TextStyle(
                        fontFamily: AppThemes.fontFamily,
                        color: MeasurementResultPage._ink,
                        fontWeight: FontWeight.w800,
                        fontSize: fontSize,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DottedDivider extends StatelessWidget {
  const _DottedDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6,
      child: CustomPaint(
        painter: _DottedLinePainter(color: color),
        size: const Size(double.infinity, 6),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  _DottedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const dash = 4.0;
    const gap = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    var x = 0.0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, y),
        Offset((x + dash).clamp(0, size.width), y),
        paint,
      );
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Public accessor for the health spec, used by the PDF export to mirror the
/// in-app report card layout.
HealthOutcomeSpec healthOutcomeSpec(MeasurementResultOutcome o) => _spec(o);

class HealthOutcomeSpec {
  const HealthOutcomeSpec({
    required this.fallbackHeightM,
    required this.fallbackWeightKg,
    required this.fallbackBmi,
    required this.categoryTitle,
    required this.shortTips,
    required this.tips,
    required this.footer,
    required this.footerColor,
    required this.bannerBg,
    required this.bannerBorder,
    required this.faceColor,
    required this.smiling,
  });

  final double fallbackHeightM;
  final int fallbackWeightKg;
  final double fallbackBmi;
  final String categoryTitle;

  /// Short bullet lines used in the new card layout.
  final List<String> shortTips;

  /// Long-form tips kept for the PDF export.
  final List<String> tips;

  final String footer;
  final Color footerColor;
  final Color bannerBg;
  final Color bannerBorder;
  final Color faceColor;
  final bool smiling;
}

HealthOutcomeSpec _spec(MeasurementResultOutcome o) {
  return switch (o) {
    MeasurementResultOutcome.underweight => const HealthOutcomeSpec(
        fallbackHeightM: 1.20,
        fallbackWeightKg: 18,
        fallbackBmi: 12.5,
        categoryTitle: 'UNDERWEIGHT',
        shortTips: [
          'Eat three balanced meals with GO,',
          'GROW, and GLOW foods;',
          "Add healthy snacks, don't skip meals;",
          'Keep good habits like handwashing',
          'and sleeping early',
        ],
        tips: [
          'If you are underweight, your body needs more food.',
          'Eat three full meals every day with complete GO, GROW, and GLOW foods.',
          'Add healthy snacks like fruits, eggs, or milk.',
          'Do not skip meals even when you are busy.',
          'Wash your hands and sleep early',
        ],
        footer: 'YOU CAN DO IT!',
        footerColor: Color(0xFFE6B800),
        bannerBg: Color(0xFFFFF1C2),
        bannerBorder: Color(0xFFE7C97A),
        faceColor: Color(0xFFE6B800),
        smiling: false,
      ),
    MeasurementResultOutcome.normal => const HealthOutcomeSpec(
        fallbackHeightM: 1.35,
        fallbackWeightKg: 30,
        fallbackBmi: 16.5,
        categoryTitle: 'NORMAL',
        shortTips: [
          'Eat balanced meals, stay active.',
          'Drink plenty of water.',
          'Limit sugary foods and screen time.',
          'Practice good hygiene.',
        ],
        tips: [
          'Eat balanced meals with vegetables, fruits, rice, and protein.',
          'Stay active every day by playing or exercising.',
          'Drink plenty of water.',
          'Avoid too much sugary drinks, junk food, and screen time.',
          'Practice good hygiene and healthy habits every day.',
        ],
        footer: 'KEEP UP THE GOOD WORK!',
        footerColor: Color(0xFF22C55E),
        bannerBg: Color(0xFFD9F2C2),
        bannerBorder: Color(0xFF8BC07A),
        faceColor: Color(0xFF22C55E),
        smiling: true,
      ),
    MeasurementResultOutcome.overweight => const HealthOutcomeSpec(
        fallbackHeightM: 1.28,
        fallbackWeightKg: 32,
        fallbackBmi: 19.5,
        categoryTitle: 'OVERWEIGHT',
        shortTips: [
          'Eat filling, healthy foods like vegetables',
          'and soup;',
          "Choose energy-boosting options, don't",
          'skip meals;',
          'Limit sugary/salty processed foods;',
          'Drink more water instead of sugary drinks.',
        ],
        tips: [
          'Eat more healthy foods that fill you up, like vegetables and clear soup.',
          'Choose energy-giving foods.',
          'Do not skip meals to avoid overeating later.',
          'Avoid too much sweet, salty, and processed foods like chips and fast food.',
          'Drink plenty of water and limit sugary drinks like soda, milk tea, and juice.',
        ],
        footer: 'YOU CAN DO IT!',
        footerColor: Color(0xFFE53935),
        bannerBg: Color(0xFFFFD3D0),
        bannerBorder: Color(0xFFE57373),
        faceColor: Color(0xFFE53935),
        smiling: false,
      ),
  };
}

