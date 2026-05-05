import 'package:flutter/material.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../widgets/common/snak_pill_button.dart';
import '../widgets/common/mascot.dart';

/// Read-only review of student profile before finishing onboarding.
///
/// Layout: logo, centered headline, royal-blue summary panel with mascot
/// overlapping the bottom-right, and two pink actions (confirm / back).
class InformationConfirmationPage extends StatelessWidget {
  const InformationConfirmationPage({
    super.key,
    required this.studentId,
    required this.name,
    required this.age,
    required this.sex,
    required this.grade,
    required this.section,
    required this.onConfirm,
    required this.onBack,
  });

  final String studentId;
  final String name;
  final String age;
  final String sex;
  final String grade;
  final String section;

  final VoidCallback onConfirm;
  final VoidCallback onBack;

  /// Matches [ProfileSetupPage.fieldBlue].
  static const panelBlue = Color(0xFF4A80F0);

  /// Matches [ProfileSetupPage.actionPink].
  static const pillPink = Color(0xFFE85BB5);

  static const _headlineRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
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
                  final maxH = constraints.maxHeight;

                  final isPortrait = maxW < maxH * 0.95;
                  final cardW =
                      (maxW * 0.94).clamp(320.0, 1100.0).toDouble();
                  final cardH = isPortrait
                      ? (maxH * 0.92).clamp(560.0, 1100.0).toDouble()
                      : (maxH * 0.86).clamp(420.0, 720.0).toDouble();

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
                            child: _ConfirmationCard(
                              cardWidth: cardW,
                              cardHeight: cardH,
                              headlineColor: _headlineRed,
                              labelColor: panelBlue,
                              valueColor: const Color(0xFF1F2937),
                              pillColor: pillPink,
                              studentId: studentId,
                              name: name,
                              age: age,
                              sex: sex,
                              grade: grade,
                              section: section,
                              onConfirm: onConfirm,
                              onBack: onBack,
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

class _ConfirmationCard extends StatelessWidget {
  const _ConfirmationCard({
    required this.cardWidth,
    required this.cardHeight,
    required this.headlineColor,
    required this.labelColor,
    required this.valueColor,
    required this.pillColor,
    required this.studentId,
    required this.name,
    required this.age,
    required this.sex,
    required this.grade,
    required this.section,
    required this.onConfirm,
    required this.onBack,
  });

  final double cardWidth;
  final double cardHeight;
  final Color headlineColor;
  final Color labelColor;
  final Color valueColor;
  final Color pillColor;
  final String studentId;
  final String name;
  final String age;
  final String sex;
  final String grade;
  final String section;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final isPortrait = cardWidth < cardHeight * 0.85;
    if (isPortrait) {
      return _buildPortrait(context);
    }
    final mascotH = cardHeight * 0.62;
    final mascotW = mascotH * Mascot.aspect;
    final mascotColumnW = mascotW.clamp(0.0, cardWidth * 0.34);

    final pillH = (cardHeight * 0.11).clamp(48.0, 72.0).toDouble();
    final confirmW =
        (cardWidth * 0.38).clamp(220.0, 420.0).toDouble();
    final backW = (cardWidth * 0.18).clamp(120.0, 220.0).toDouble();

    final headlineSize = (cardWidth * 0.04).clamp(22.0, 40.0).toDouble();
    final labelSize = (cardWidth * 0.022).clamp(14.0, 24.0).toDouble();
    final valueSize = (cardWidth * 0.028).clamp(16.0, 30.0).toDouble();

    final labelStyle = TextStyle(
      color: labelColor,
      fontWeight: FontWeight.w900,
      fontSize: labelSize,
      letterSpacing: 0.4,
      height: 1.1,
    );
    final valueStyle = TextStyle(
      color: valueColor,
      fontWeight: FontWeight.w800,
      fontSize: valueSize,
      height: 1.15,
    );

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.78),
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
            left: cardWidth * 0.04,
            top: cardHeight * 0.05,
            right: mascotColumnW + cardWidth * 0.06,
            bottom: pillH + cardHeight * 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IS THIS CORRECT?',
                  style: TextStyle(
                    color: headlineColor,
                    fontSize: headlineSize,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: cardHeight * 0.04),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoLine(
                          label: 'ID NO.:',
                          value: studentId,
                          labelStyle: labelStyle,
                          valueStyle: valueStyle,
                        ),
                        SizedBox(height: cardHeight * 0.025),
                        _InfoLine(
                          label: 'NAME:',
                          value: name,
                          labelStyle: labelStyle,
                          valueStyle: valueStyle,
                        ),
                        SizedBox(height: cardHeight * 0.025),
                        _InfoLine(
                          label: 'AGE:',
                          value: age,
                          labelStyle: labelStyle,
                          valueStyle: valueStyle,
                        ),
                        SizedBox(height: cardHeight * 0.025),
                        _InfoLine(
                          label: 'GENDER:',
                          value: sex,
                          labelStyle: labelStyle,
                          valueStyle: valueStyle,
                        ),
                        SizedBox(height: cardHeight * 0.025),
                        _InfoLine(
                          label: 'GRADE:',
                          value: grade,
                          labelStyle: labelStyle,
                          valueStyle: valueStyle,
                        ),
                        SizedBox(height: cardHeight * 0.025),
                        _InfoLine(
                          label: 'SECTION:',
                          value: section,
                          labelStyle: labelStyle,
                          valueStyle: valueStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: cardWidth * 0.02,
            bottom: cardHeight * 0.06,
            width: mascotColumnW,
            height: mascotH,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.bottomRight,
              child: Mascot.sitting(width: mascotW, height: mascotH),
            ),
          ),
          Positioned(
            left: cardWidth * 0.04,
            bottom: cardHeight * 0.05,
            child: Row(
              children: [
                SnakPillButton(
                  label: 'CONFIRM',
                  labelColor: pillColor,
                  width: confirmW,
                  height: pillH,
                  onPressed: onConfirm,
                ),
                SizedBox(width: cardWidth * 0.02),
                SnakPillButton(
                  label: 'BACK',
                  labelColor: pillColor,
                  width: backW,
                  height: pillH,
                  onPressed: onBack,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortrait(BuildContext context) {
    final pad = cardWidth * 0.05;
    final pillH = 60.0;
    final headlineSize = (cardWidth * 0.07).clamp(24.0, 36.0).toDouble();
    final labelSize = (cardWidth * 0.04).clamp(14.0, 20.0).toDouble();
    final valueSize = (cardWidth * 0.05).clamp(18.0, 26.0).toDouble();
    final mascotH = (cardWidth * 0.34).clamp(120.0, 200.0).toDouble();
    final mascotW = mascotH * Mascot.aspect;

    final labelStyle = TextStyle(
      color: labelColor,
      fontWeight: FontWeight.w900,
      fontSize: labelSize,
      letterSpacing: 0.4,
      height: 1.1,
    );
    final valueStyle = TextStyle(
      color: valueColor,
      fontWeight: FontWeight.w800,
      fontSize: valueSize,
      height: 1.2,
    );

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.78),
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
          Padding(
            padding: EdgeInsets.fromLTRB(pad, pad * 1.2, pad, pad * 0.6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'IS THIS CORRECT?',
                  style: TextStyle(
                    color: headlineColor,
                    fontSize: headlineSize,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: pad * 0.8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoLine(
                          label: 'ID NO.:',
                          value: studentId,
                          labelStyle: labelStyle,
                          valueStyle: valueStyle,
                        ),
                        SizedBox(height: pad * 0.5),
                        _InfoLine(
                          label: 'NAME:',
                          value: name,
                          labelStyle: labelStyle,
                          valueStyle: valueStyle,
                        ),
                        SizedBox(height: pad * 0.5),
                        _InfoLine(
                          label: 'AGE:',
                          value: age,
                          labelStyle: labelStyle,
                          valueStyle: valueStyle,
                        ),
                        SizedBox(height: pad * 0.5),
                        _InfoLine(
                          label: 'GENDER:',
                          value: sex,
                          labelStyle: labelStyle,
                          valueStyle: valueStyle,
                        ),
                        SizedBox(height: pad * 0.5),
                        _InfoLine(
                          label: 'GRADE:',
                          value: grade,
                          labelStyle: labelStyle,
                          valueStyle: valueStyle,
                        ),
                        SizedBox(height: pad * 0.5),
                        _InfoLine(
                          label: 'SECTION:',
                          value: section,
                          labelStyle: labelStyle,
                          valueStyle: valueStyle,
                        ),
                        SizedBox(height: pad * 0.6),
                        Center(
                          child: Mascot.sitting(
                            width: mascotW,
                            height: mascotH,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: pad * 0.4),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SnakPillButton(
                        label: 'CONFIRM',
                        labelColor: pillColor,
                        width: double.infinity,
                        height: pillH,
                        onPressed: onConfirm,
                      ),
                    ),
                    SizedBox(width: pad * 0.5),
                    Expanded(
                      flex: 2,
                      child: SnakPillButton(
                        label: 'BACK',
                        labelColor: pillColor,
                        width: double.infinity,
                        height: pillH,
                        onPressed: onBack,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: pad * 0.2),
              ],
            ),
          ),
        ],
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
