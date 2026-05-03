import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../assets/assets.gen.dart';
import '../constants/constants.dart';
import '../routing/router.dart';
import '../../features/health/data/health_records_repository.dart';
import '../../features/health/data/health_reports_repository.dart';
import '../../features/health/models/health_record.dart';
import '../../features/health/models/health_report.dart';
import '../../features/students/data/students_repository.dart';
import '../../features/students/models/student.dart';
import '../widgets/form_feedback.dart';
import 'information_confirmation_page.dart';
import 'measurement_instruction_page.dart';
import 'checking_result_page.dart';
import 'measurement_result_page.dart';
import 'stand_still_waiting_page.dart';
import '../widgets/common/snak_pill_button.dart';
import '../widgets/common/snak_sprite_sheet.dart';

/// Student profile capture after health monitoring consent.
///
/// Matches reference layout: logo, mascot + headline left, form grid right,
/// primary action directly under the allergies field.
class ProfileSetupPage extends ConsumerStatefulWidget {
  const ProfileSetupPage({
    super.key,
    required this.onComplete,
    required this.onBack,
    required this.onReturnToStart,
    this.measurementResultOutcome = MeasurementResultOutcome.normal,
  });

  final VoidCallback onComplete;
  final VoidCallback onBack;
  final VoidCallback onReturnToStart;

  /// Fallback if no random draw is stored. For now the flow picks a random
  /// [MeasurementResultOutcome] (underweight / normal / overweight) when
  /// leaving the checking screen; pass a fixed value when wiring real data.
  final MeasurementResultOutcome measurementResultOutcome;

  /// Field panels (royal blue).
  static const fieldBlue = Color(0xFF4A80F0);

  /// Primary action (vibrant pink).
  static const actionPink = Color(0xFFE85BB5);

  @override
  ConsumerState<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends ConsumerState<ProfileSetupPage> {
  final _studentIdController = TextEditingController();
  final _ageController = TextEditingController();
  final _sectionController = TextEditingController();
  final _allergiesController = TextEditingController();

  _ProfileSex? _sex;
  String? _selectedGrade;
  bool _showConfirmation = false;
  bool _showMeasurementInstruction = false;
  bool _showStandStillWaiting = false;
  bool _showCheckingResult = false;
  bool _showMeasurementResult = false;
  MeasurementResultOutcome? _rolledMeasurementOutcome;
  String? _rolledReportId;
  bool _persisting = false;

  @override
  void dispose() {
    _studentIdController.dispose();
    _ageController.dispose();
    _sectionController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  String _sexLabel(_ProfileSex? sex) {
    return switch (sex) {
      _ProfileSex.boy => 'Boy',
      _ProfileSex.girl => 'Girl',
      null => '—',
    };
  }

  String _allergiesDisplay() {
    final t = _allergiesController.text.trim();
    return t.isEmpty ? 'None' : t;
  }

  /// Return to the profile form so another student can be entered.
  void _restartForNextStudent() {
    setState(() {
      _studentIdController.clear();
      _ageController.clear();
      _sectionController.clear();
      _allergiesController.clear();
      _selectedGrade = null;
      _sex = null;
      _showConfirmation = false;
      _showMeasurementInstruction = false;
      _showStandStillWaiting = false;
      _showCheckingResult = false;
      _showMeasurementResult = false;
      _rolledMeasurementOutcome = null;
      _rolledReportId = null;
      _persisting = false;
    });
  }

  StudentSex? _mapSex(_ProfileSex? s) => switch (s) {
        _ProfileSex.boy => StudentSex.male,
        _ProfileSex.girl => StudentSex.female,
        null => null,
      };

  /// Generate fake "machine reading" vitals matching the rolled outcome's spec.
  ({double heightCm, double weightKg, double tempC, int hr, String bp})
      _fakeVitals(MeasurementResultOutcome outcome) {
    final r = Random();
    final (baseHeight, baseWeight) = switch (outcome) {
      MeasurementResultOutcome.underweight => (120, 18),
      MeasurementResultOutcome.normal => (130, 28),
      MeasurementResultOutcome.overweight => (135, 40),
    };
    final heightCm = baseHeight + r.nextDouble() * 4 - 2;
    final weightKg = baseWeight + r.nextDouble() * 4 - 2;
    final tempC = 36.4 + r.nextDouble() * 0.8;
    final hr = 78 + r.nextInt(20);
    final systolic = 100 + r.nextInt(20);
    final diastolic = 65 + r.nextInt(15);
    return (
      heightCm: double.parse(heightCm.toStringAsFixed(1)),
      weightKg: double.parse(weightKg.toStringAsFixed(1)),
      tempC: double.parse(tempC.toStringAsFixed(1)),
      hr: hr,
      bp: '$systolic/$diastolic',
    );
  }

  Future<void> _persistAndAdvance() async {
    debugPrint('[ProfileSetup] CONFIRM tapped (persisting=$_persisting)');
    if (_persisting) return;
    setState(() => _persisting = true);

    // Roll the outcome now so the persisted vitals match what's displayed.
    final outcome = MeasurementResultOutcome
        .values[Random().nextInt(MeasurementResultOutcome.values.length)];
    final v = _fakeVitals(outcome);

    try {
      final ageText = _ageController.text.trim();
      final age = int.tryParse(ageText);
      // Approximate DOB from age (Jan 1 of birth year) — schema needs `date`.
      final dob = age == null
          ? null
          : DateTime(DateTime.now().year - age, 1, 1);

      final studentId = _studentIdController.text.trim();
      final allergies = _allergiesController.text.trim();

      final draft = Student(
        id: '',
        firstName: studentId.isEmpty ? 'Student' : studentId,
        lastName: '',
        dateOfBirth: dob,
        sex: _mapSex(_sex),
        gradeLevel: _selectedGrade,
        section: _sectionController.text.trim().isEmpty
            ? null
            : _sectionController.text.trim(),
        studentNumber: studentId.isEmpty ? null : studentId,
        notes: allergies.isEmpty ? null : 'Allergies: $allergies',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final repo = ref.read(studentsRepositoryProvider);
      Student? saved;
      if (studentId.isNotEmpty) {
        saved = await repo.getByStudentNumber(studentId);
        if (saved != null) {
          debugPrint('[ProfileSetup] reusing existing student id=${saved.id}');
        }
      }
      if (saved == null) {
        debugPrint('[ProfileSetup] inserting student...');
        saved = await repo.create(draft);
        debugPrint('[ProfileSetup] student inserted id=${saved.id}');
      }
      final studentDbId = saved.id;

      await ref.read(healthRecordsRepositoryProvider).create(
            HealthRecord(
              id: '',
              studentId: studentDbId,
              heightCm: v.heightCm,
              weightKg: v.weightKg,
              allergies: allergies.isEmpty ? null : allergies,
              recordedAt: DateTime.now(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

      final savedReport = await ref.read(healthReportsRepositoryProvider).create(
            HealthReport(
              id: '',
              studentId: studentDbId,
              visitDate: DateTime.now(),
              vitalsTempC: v.tempC,
              vitalsBp: v.bp,
              vitalsHr: v.hr,
              diagnosis: outcome.name,
              reportedBy: 'snak-machine',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

      debugPrint('[ProfileSetup] all writes ok, advancing');
      if (!mounted) return;
      setState(() {
        _rolledMeasurementOutcome = outcome;
        _rolledReportId = savedReport.id;
        _persisting = false;
        _showConfirmation = false;
        _showMeasurementInstruction = true;
      });
    } catch (e, st) {
      debugPrint('[ProfileSetup] persist failed: $e\n$st');
      if (!mounted) return;
      setState(() => _persisting = false);
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showMeasurementResult) {
      return MeasurementResultPage(
        outcome: _rolledMeasurementOutcome ?? widget.measurementResultOutcome,
        reportId: _rolledReportId,
        onDone: () {
          _restartForNextStudent();
          widget.onReturnToStart();
        },
      );
    }

    if (_showCheckingResult) {
      return CheckingResultPage(
        onComplete: () => setState(() {
          _showCheckingResult = false;
          _showMeasurementResult = true;
        }),
      );
    }

    if (_showStandStillWaiting) {
      return StandStillWaitingPage(
        onComplete: () => setState(() {
          _showStandStillWaiting = false;
          _showCheckingResult = true;
        }),
      );
    }

    if (_showMeasurementInstruction) {
      return MeasurementInstructionPage(
        onGotIt: () => setState(() {
          _showMeasurementInstruction = false;
          _showStandStillWaiting = true;
        }),
      );
    }

    if (_showConfirmation) {
      return InformationConfirmationPage(
        studentId: _studentIdController.text.trim(),
        age: _ageController.text.trim(),
        sex: _sexLabel(_sex),
        grade: _selectedGrade ?? '',
        section: _sectionController.text.trim(),
        allergies: _allergiesDisplay(),
        onConfirm: _persisting ? () {} : _persistAndAdvance,
        onBack: () => setState(() => _showConfirmation = false),
      );
    }

    final size = MediaQuery.sizeOf(context);
    final edgePad = size.width * 0.04;
    final logoWidth = (size.width * 0.16).clamp(96.0, 180.0);
    final logoHeight = logoWidth / SnakLogoRaster.aspect;

    final buttonWidth = (size.width * 0.36).clamp(220.0, 420.0);
    final buttonHeight = (buttonWidth / 4.8).clamp(52.0, 84.0);

    final headlineStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: (size.width * 0.028).clamp(18.0, 26.0),
          height: 1.2,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ) ??
        TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: (size.width * 0.028).clamp(18.0, 26.0),
          height: 1.2,
        );

    final bottomClearance =
        edgePad * 2 + MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              child: Stack(
                children: [
                  Positioned(
                    top: edgePad * 0.35,
                    left: edgePad * 0.5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          onPressed: widget.onBack,
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: Colors.white,
                          tooltip: MaterialLocalizations.of(context)
                              .backButtonTooltip,
                        ),
                        SizedBox(width: edgePad * 0.25),
                        SizedBox(
                          width: logoWidth,
                          height: logoHeight,
                          child: Assets.images.snakLogo.image(
                            fit: BoxFit.contain,
                            alignment: Alignment.centerLeft,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final availableW = constraints.maxWidth;
                        final availableH = constraints.maxHeight;
                        // Cap mascot height so Row + form fits typical viewports; scroll handles the rest.
                        final wideLayout = availableW >= 720;
                        final spriteH = (availableH * (wideLayout ? 0.42 : 0.34))
                            .clamp(160.0, 360.0)
                            .toDouble();
                        final cellAspect = SnakSpriteSheet.cellWidth /
                            SnakSpriteSheet.cellHeight;
                        final spriteW = spriteH * cellAspect;
                        final scrollHorizontalPadding = edgePad * 2.8;
                        final rowGap = edgePad * 1.0;
                        final remainingForForm = availableW -
                            scrollHorizontalPadding -
                            spriteW -
                            rowGap;
                        final formW = wideLayout
                            ? remainingForForm.clamp(420.0, 1400.0).toDouble()
                            : (availableW * 0.55).clamp(340.0, 760.0).toDouble();

                        final actionGap =
                            (size.width * 0.03).clamp(16.0, 28.0).toDouble();
                        final form = ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: wideLayout ? formW : double.infinity,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _ProfileForm(
                                fieldColor: ProfileSetupPage.fieldBlue,
                                studentIdController: _studentIdController,
                                ageController: _ageController,
                                selectedGrade: _selectedGrade,
                                onGradeChanged: (v) =>
                                    setState(() => _selectedGrade = v),
                                sectionController: _sectionController,
                                allergiesController: _allergiesController,
                                sex: _sex,
                                onSexChanged: (v) => setState(() => _sex = v),
                              ),
                              SizedBox(height: actionGap),
                              Align(
                                alignment: Alignment.centerRight,
                                child: SnakPillButton(
                                  label: "GOT IT! LET'S START",
                                  labelColor: ProfileSetupPage.actionPink,
                                  width: buttonWidth,
                                  height: buttonHeight,
                                  onPressed: () {
                                    final missing = <String>[
                                      if (_studentIdController.text
                                          .trim()
                                          .isEmpty)
                                        'Student ID',
                                      if (_ageController.text.trim().isEmpty)
                                        'Age',
                                      if (_sex == null) 'Sex',
                                      if (_selectedGrade == null) 'Grade',
                                      if (_sectionController.text
                                          .trim()
                                          .isEmpty)
                                        'Section',
                                    ];
                                    if (missing.isNotEmpty) {
                                      showErrorSnackBar(
                                        context,
                                        message:
                                            'Please fill in: ${missing.join(', ')}',
                                      );
                                      return;
                                    }
                                    setState(() => _showConfirmation = true);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );

                        final mascotCol = Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Tell me about yourself!',
                              textAlign: TextAlign.center,
                              style: headlineStyle,
                            ),
                            SizedBox(height: edgePad * 0.8),
                            SnakSpriteSheet.waving(
                              width: spriteW,
                              height: spriteH,
                            ),
                          ],
                        );

                        final scrollPadding = EdgeInsets.fromLTRB(
                          edgePad * 1.4,
                          edgePad * 3.2,
                          edgePad * 1.4,
                          edgePad * 2 + bottomClearance,
                        );

                        return SingleChildScrollView(
                          padding: scrollPadding,
                          clipBehavior: Clip.none,
                          child: wideLayout
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: spriteW,
                                      child: mascotCol,
                                    ),
                                    SizedBox(width: edgePad * 1.0),
                                    Expanded(child: form),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    mascotCol,
                                    SizedBox(height: edgePad * 1.2),
                                    form,
                                  ],
                                ),
                        );
                      },
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

enum _ProfileSex { boy, girl }

class _ProfileForm extends StatelessWidget {
  const _ProfileForm({
    required this.fieldColor,
    required this.studentIdController,
    required this.ageController,
    required this.selectedGrade,
    required this.onGradeChanged,
    required this.sectionController,
    required this.allergiesController,
    required this.sex,
    required this.onSexChanged,
  });

  final Color fieldColor;
  final TextEditingController studentIdController;
  final TextEditingController ageController;
  final String? selectedGrade;
  final ValueChanged<String?> onGradeChanged;
  final TextEditingController sectionController;
  final TextEditingController allergiesController;
  final _ProfileSex? sex;
  final ValueChanged<_ProfileSex?> onSexChanged;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final labelFontSize = (w * 0.044).clamp(17.0, 27.0);
    final inputFontSize = (w * 0.052).clamp(20.0, 34.0);
    final fieldPadH = (w * 0.05).clamp(20.0, 32.0);
    final fieldPadV = (w * 0.04).clamp(18.0, 28.0);
    final rowGap = (w * 0.036).clamp(14.0, 22.0);
    final inputPadV = (inputFontSize * 0.48).clamp(12.0, 20.0);
    final minInputRow = (inputFontSize * 2.55).clamp(56.0, 76.0).toDouble();
    final sexCircle = (w * 0.12).clamp(56.0, 78.0).toDouble();

    final labelStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.7,
      fontSize: labelFontSize,
      height: 1.1,
    );
    final inputStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: inputFontSize,
      height: 1.15,
      decoration: TextDecoration.none,
    );
    final fieldInsets =
        EdgeInsets.symmetric(horizontal: fieldPadH, vertical: fieldPadV);

    InputDecoration deco({String? hint}) {
      return InputDecoration(
        hintText: hint,
        hintMaxLines: 1,
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.5),
          fontWeight: FontWeight.w600,
          fontSize: inputFontSize * 0.92,
          overflow: TextOverflow.ellipsis,
        ),
        isDense: false,
        contentPadding: EdgeInsets.only(
          top: inputPadV,
          bottom: inputPadV + 4,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.88),
            width: 3,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.88),
            width: 3,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 3.5),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LabeledField(
          color: fieldColor,
          label: 'STUDENT ID:',
          labelStyle: labelStyle,
          fieldInsets: fieldInsets,
          minInputRowHeight: minInputRow,
          field: TextField(
            controller: studentIdController,
            style: inputStyle,
            cursorColor: Colors.white,
            textCapitalization: TextCapitalization.none,
            decoration: deco(),
          ),
        ),
        SizedBox(height: rowGap),
        LayoutBuilder(
          builder: (context, constraints) {
            final ageField = _LabeledField(
              color: fieldColor,
              label: 'AGE:',
              labelStyle: labelStyle,
              fieldInsets: fieldInsets,
              minInputRowHeight: minInputRow,
              field: TextField(
                controller: ageController,
                style: inputStyle,
                cursorColor: Colors.white,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                decoration: deco(),
              ),
            );
            final sexField = _SexField(
              color: fieldColor,
              labelStyle: labelStyle,
              fieldInsets: fieldInsets,
              minInputRowHeight: minInputRow,
              sexCircleSize: sexCircle,
              sex: sex,
              onSexChanged: onSexChanged,
            );
            if (constraints.maxWidth < 460) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ageField,
                  SizedBox(height: rowGap),
                  sexField,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: ageField),
                SizedBox(width: rowGap),
                Expanded(flex: 6, child: sexField),
              ],
            );
          },
        ),
        SizedBox(height: rowGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: _LabeledField(
                color: fieldColor,
                label: 'GRADE:',
                labelStyle: labelStyle,
                fieldInsets: fieldInsets,
                minInputRowHeight: minInputRow,
                field: InputDecorator(
                  decoration: deco(hint: 'Select'),
                  isEmpty: selectedGrade == null,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedGrade,
                      isExpanded: true,
                      isDense: true,
                      style: inputStyle,
                      iconEnabledColor: Colors.white,
                      iconDisabledColor:
                          Colors.white.withValues(alpha: 0.5),
                      dropdownColor: fieldColor,
                      items: [
                        for (var g = 1; g <= 6; g++)
                          DropdownMenuItem(
                            value: 'Grade $g',
                            child: Text(
                              'Grade $g',
                              style: inputStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: onGradeChanged,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: rowGap),
            Expanded(
              flex: 6,
              child: _LabeledField(
                color: fieldColor,
                label: 'SECTION:',
                labelStyle: labelStyle,
                fieldInsets: fieldInsets,
                minInputRowHeight: minInputRow,
                field: TextField(
                  controller: sectionController,
                  style: inputStyle,
                  cursorColor: Colors.white,
                  decoration: deco(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: rowGap),
        _LabeledField(
          color: fieldColor,
          label: 'ALLERGIES:',
          labelStyle: labelStyle,
          fieldInsets: fieldInsets,
          minInputRowHeight: minInputRow,
          field: TextField(
            controller: allergiesController,
            style: inputStyle,
            cursorColor: Colors.white,
            textCapitalization: TextCapitalization.sentences,
            decoration: deco(hint: 'None'),
          ),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.color,
    required this.label,
    required this.labelStyle,
    required this.fieldInsets,
    required this.minInputRowHeight,
    required this.field,
  });

  final Color color;
  final String label;
  final TextStyle labelStyle;
  final EdgeInsets fieldInsets;
  final double minInputRowHeight;
  final Widget field;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: fieldInsets,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minInputRowHeight),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(label, style: labelStyle),
              SizedBox(width: (labelStyle.fontSize ?? 16) * 0.55),
              Expanded(child: field),
            ],
          ),
        ),
      ),
    );
  }
}

class _SexField extends StatelessWidget {
  const _SexField({
    required this.color,
    required this.labelStyle,
    required this.fieldInsets,
    required this.minInputRowHeight,
    required this.sexCircleSize,
    required this.sex,
    required this.onSexChanged,
  });

  final Color color;
  final TextStyle labelStyle;
  final EdgeInsets fieldInsets;
  final double minInputRowHeight;
  final double sexCircleSize;
  final _ProfileSex? sex;
  final ValueChanged<_ProfileSex?> onSexChanged;

  @override
  Widget build(BuildContext context) {
    final iconSize = sexCircleSize * 0.48;

    Widget genderCircle({
      required _ProfileSex value,
      required IconData icon,
      required Color fillColor,
    }) {
      final selected = sex == value;
      final hasSelection = sex != null;
      final dimmed = hasSelection && !selected;

      return AnimatedScale(
        scale: selected ? 1.12 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: sexCircleSize,
          height: sexCircleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: fillColor.withValues(alpha: 0.55),
                      blurRadius: 18,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.45),
                      blurRadius: 10,
                      spreadRadius: -2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Material(
            color: fillColor.withValues(
              alpha: selected ? 1.0 : (dimmed ? 0.55 : 0.85),
            ),
            shape: CircleBorder(
              side: BorderSide(
                color: Colors.white,
                width: selected ? 4.0 : 2.5,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => onSexChanged(selected ? null : value),
              customBorder: const CircleBorder(),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: fieldInsets,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minInputRowHeight),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('SEX:', style: labelStyle),
                SizedBox(width: (labelStyle.fontSize ?? 16) * 0.45),
                genderCircle(
                  value: _ProfileSex.boy,
                  icon: Icons.male,
                  fillColor: const Color(0xFF3B7DD8),
                ),
                SizedBox(width: sexCircleSize * 0.2),
                genderCircle(
                  value: _ProfileSex.girl,
                  icon: Icons.female,
                  fillColor: const Color(0xFFE85BB5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
