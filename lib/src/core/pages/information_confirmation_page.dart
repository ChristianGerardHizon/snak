import 'package:flutter/material.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../widgets/common/snak_pill_button.dart';
import '../widgets/common/snak_sprite_sheet.dart';

/// Read-only review of student profile before finishing onboarding.
///
/// Layout: logo, centered headline, royal-blue summary panel with mascot
/// overlapping the bottom-right, and two pink actions (confirm / back).
class InformationConfirmationPage extends StatelessWidget {
  const InformationConfirmationPage({
    super.key,
    required this.studentId,
    required this.age,
    required this.sex,
    required this.grade,
    required this.section,
    required this.allergies,
    required this.onConfirm,
    required this.onBack,
  });

  final String studentId;
  final String age;
  final String sex;
  final String grade;
  final String section;
  final String allergies;

  final VoidCallback onConfirm;
  final VoidCallback onBack;

  /// Matches [ProfileSetupPage.fieldBlue].
  static const panelBlue = Color(0xFF4A80F0);

  /// Matches [ProfileSetupPage.actionPink].
  static const pillPink = Color(0xFFE85BB5);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final edgePad = size.width * 0.04;
    final logoWidth = (size.width * 0.22).clamp(120.0, 240.0);
    final logoHeight = logoWidth / SnakLogoRaster.aspect;

    final buttonWidth = (size.width * 0.34).clamp(240.0, 440.0);
    final buttonHeight = (buttonWidth / 3.85).clamp(58.0, 100.0);
    final buttonGap = (size.width * 0.055).clamp(22.0, 48.0);

    final headlineStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: (size.width * 0.052).clamp(30.0, 46.0),
          height: 1.12,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ) ??
        TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: (size.width * 0.052).clamp(30.0, 46.0),
          height: 1.12,
        );

    final bottomPad = edgePad * 2 + MediaQuery.viewInsetsOf(context).bottom;

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
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth;
                  final panelMaxW = (maxW * 0.96).clamp(400.0, 920.0);
                  final labelSize = (maxW * 0.05).clamp(19.0, 28.0);
                  final valueSize = (maxW * 0.055).clamp(21.0, 32.0);
                  final mascotH =
                      (constraints.maxHeight * 0.32).clamp(180.0, 300.0);
                  final cellAspect = SnakSpriteSheet.sheet2CellWidth /
                      SnakSpriteSheet.sheet2CellHeight;
                  final mascotW = mascotH * cellAspect;

                  final labelStyle = TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: labelSize,
                    height: 1.2,
                  );
                  final valueStyle = TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: valueSize,
                    height: 1.2,
                  );

                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      edgePad * 1.0,
                      edgePad * 0.6,
                      edgePad * 1.0,
                      bottomPad,
                    ),
                    clipBehavior: Clip.none,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: logoWidth,
                          height: logoHeight,
                          child: Assets.images.snakLogo.image(
                            fit: BoxFit.contain,
                            alignment: Alignment.centerLeft,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        SizedBox(height: edgePad * 0.85),
                        Text(
                          'IS THIS CORRECT?',
                          textAlign: TextAlign.center,
                          style: headlineStyle,
                        ),
                        SizedBox(height: edgePad * 1.75),
                        Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: panelMaxW),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: mascotH * 0.38,
                                    right: mascotW * 0.18,
                                  ),
                                  child: _StudentInfoPanel(
                                    color: panelBlue,
                                    labelStyle: labelStyle,
                                    valueStyle: valueStyle,
                                    studentId: studentId,
                                    age: age,
                                    sex: sex,
                                    grade: grade,
                                    section: section,
                                    allergies: allergies,
                                  ),
                                ),
                                Positioned(
                                  right: -mascotW * 0.06,
                                  bottom: 0,
                                  child: SnakSpriteSheet.sittingForward(
                                    width: mascotW,
                                    height: mascotH,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: edgePad * 2.75),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SnakPillButton(
                              label: 'CONFIRM',
                              labelColor: pillPink,
                              width: buttonWidth,
                              height: buttonHeight,
                              onPressed: onConfirm,
                            ),
                            SizedBox(width: buttonGap),
                            SnakPillButton(
                              label: 'BACK',
                              labelColor: pillPink,
                              width: buttonWidth,
                              height: buttonHeight,
                              onPressed: onBack,
                            ),
                          ],
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

class _StudentInfoPanel extends StatelessWidget {
  const _StudentInfoPanel({
    required this.color,
    required this.labelStyle,
    required this.valueStyle,
    required this.studentId,
    required this.age,
    required this.sex,
    required this.grade,
    required this.section,
    required this.allergies,
  });

  final Color color;
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final String studentId;
  final String age;
  final String sex;
  final String grade;
  final String section;
  final String allergies;

  @override
  Widget build(BuildContext context) {
    final gap = (labelStyle.fontSize ?? 16) * 0.65;
    final rowGap = gap * 0.85;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 3.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          gap * 1.65,
          gap * 1.35,
          gap * 1.65,
          gap * 1.55,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'STUDENT INFORMATION',
              textAlign: TextAlign.center,
              style: labelStyle.copyWith(
                fontSize: (labelStyle.fontSize ?? 16) * 1.14,
                letterSpacing: 1.35,
              ),
            ),
            SizedBox(height: gap * 1.35),
            LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth >= 560;
                if (wide) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: _InfoLine(
                              label: 'STUDENT ID:',
                              value: studentId,
                              labelStyle: labelStyle,
                              valueStyle: valueStyle,
                            ),
                          ),
                          SizedBox(width: rowGap),
                          Expanded(
                            flex: 2,
                            child: _InfoLine(
                              label: 'AGE:',
                              value: age,
                              labelStyle: labelStyle,
                              valueStyle: valueStyle,
                            ),
                          ),
                          SizedBox(width: rowGap),
                          Expanded(
                            flex: 2,
                            child: _InfoLine(
                              label: 'SEX:',
                              value: sex,
                              labelStyle: labelStyle,
                              valueStyle: valueStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: rowGap),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _InfoLine(
                              label: 'GRADE:',
                              value: grade,
                              labelStyle: labelStyle,
                              valueStyle: valueStyle,
                            ),
                          ),
                          SizedBox(width: rowGap),
                          Expanded(
                            flex: 2,
                            child: _InfoLine(
                              label: 'SECTION:',
                              value: section,
                              labelStyle: labelStyle,
                              valueStyle: valueStyle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _InfoLine(
                      label: 'STUDENT ID:',
                      value: studentId,
                      labelStyle: labelStyle,
                      valueStyle: valueStyle,
                    ),
                    SizedBox(height: rowGap),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _InfoLine(
                            label: 'AGE:',
                            value: age,
                            labelStyle: labelStyle,
                            valueStyle: valueStyle,
                          ),
                        ),
                        SizedBox(width: rowGap),
                        Expanded(
                          child: _InfoLine(
                            label: 'SEX:',
                            value: sex,
                            labelStyle: labelStyle,
                            valueStyle: valueStyle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: rowGap),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _InfoLine(
                            label: 'GRADE:',
                            value: grade,
                            labelStyle: labelStyle,
                            valueStyle: valueStyle,
                          ),
                        ),
                        SizedBox(width: rowGap),
                        Expanded(
                          child: _InfoLine(
                            label: 'SECTION:',
                            value: section,
                            labelStyle: labelStyle,
                            valueStyle: valueStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: rowGap),
            _InfoLine(
              label: 'ALLERGIES:',
              value: allergies,
              labelStyle: labelStyle,
              valueStyle: valueStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: valueStyle,
        children: [
          TextSpan(text: label, style: labelStyle),
          TextSpan(
            text: ' ${value.isEmpty ? '—' : value}',
            style: valueStyle,
          ),
        ],
      ),
    );
  }
}
