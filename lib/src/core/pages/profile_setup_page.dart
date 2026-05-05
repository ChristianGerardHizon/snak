import 'dart:math' show Random;

import 'package:flutter/material.dart';
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
import 'report_data_overrides.dart';
import 'results_gateway_page.dart';
import 'stand_still_waiting_page.dart';
import '../widgets/common/snak_pill_button.dart';
import '../widgets/common/mascot.dart';

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
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _sectionController = TextEditingController();

  _ProfileSex? _sex;
  String? _selectedGrade;
  bool _showConfirmation = false;
  bool _showMeasurementInstruction = false;
  bool _showStandStillWaiting = false;
  bool _showCheckingResult = false;
  bool _showMeasurementResult = false;
  bool _showResultsGateway = false;
  MeasurementResultOutcome? _rolledMeasurementOutcome;
  String? _rolledReportId;
  double? _rolledHeightCm;
  double? _rolledWeightKg;
  DateTime? _rolledVisitDate;
  bool _persisting = false;

  @override
  void dispose() {
    _studentIdController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _sectionController.dispose();
    super.dispose();
  }

  String _sexLabel(_ProfileSex? sex) {
    return switch (sex) {
      _ProfileSex.boy => 'Boy',
      _ProfileSex.girl => 'Girl',
      null => '—',
    };
  }

  /// Return to the profile form so another student can be entered.
  void _restartForNextStudent() {
    setState(() {
      _studentIdController.clear();
      _nameController.clear();
      _ageController.clear();
      _sectionController.clear();
      _selectedGrade = null;
      _sex = null;
      _showConfirmation = false;
      _showMeasurementInstruction = false;
      _showStandStillWaiting = false;
      _showCheckingResult = false;
      _showMeasurementResult = false;
      _showResultsGateway = false;
      _rolledMeasurementOutcome = null;
      _rolledReportId = null;
      _rolledHeightCm = null;
      _rolledWeightKg = null;
      _rolledVisitDate = null;
      _persisting = false;
    });
  }

  StudentSex? _mapSex(_ProfileSex? s) => switch (s) {
        _ProfileSex.boy => StudentSex.male,
        _ProfileSex.girl => StudentSex.female,
        null => null,
      };

  /// WHO BMI-for-age cutoffs (5–19 years), ages 6–12.
  /// Source: WHO Growth reference data for 5-19 years, BMI-for-age.
  /// https://www.who.int/tools/growth-reference-data-for-5to19-years/indicators/bmi-for-age
  ///
  /// Each entry is (underweight cutoff, overweight cutoff):
  /// - bmi < underweight  → underweight  (Below -2 SD)
  /// - bmi > overweight   → overweight   (Above +1 SD)
  /// - otherwise          → normal
  static const Map<int, ({double underweight, double overweight})>
      _boysBmiCutoffs = {
    6: (underweight: 13.0, overweight: 17.0),
    7: (underweight: 13.1, overweight: 17.3),
    8: (underweight: 13.3, overweight: 17.7),
    9: (underweight: 13.5, overweight: 18.3),
    10: (underweight: 13.7, overweight: 19.0),
    11: (underweight: 14.1, overweight: 19.9),
    12: (underweight: 14.5, overweight: 20.8),
  };

  static const Map<int, ({double underweight, double overweight})>
      _girlsBmiCutoffs = {
    6: (underweight: 12.7, overweight: 16.8),
    7: (underweight: 12.7, overweight: 17.3),
    8: (underweight: 12.9, overweight: 18.0),
    9: (underweight: 13.1, overweight: 18.8),
    10: (underweight: 13.5, overweight: 19.6),
    11: (underweight: 13.9, overweight: 20.4),
    12: (underweight: 14.4, overweight: 21.3),
  };

  /// Map a manually-entered height/weight to a BMI category using
  /// age- and sex-specific WHO cutoffs.
  MeasurementResultOutcome _outcomeFromBmi(
    double heightCm,
    double weightKg, {
    required int age,
    required _ProfileSex sex,
  }) {
    final m = heightCm / 100.0;
    if (m <= 0) return MeasurementResultOutcome.normal;
    final bmi = weightKg / (m * m);
    final table = sex == _ProfileSex.boy ? _boysBmiCutoffs : _girlsBmiCutoffs;
    final cutoff = table[age];
    if (cutoff == null) return MeasurementResultOutcome.normal;
    if (bmi < cutoff.underweight) return MeasurementResultOutcome.underweight;
    if (bmi > cutoff.overweight) return MeasurementResultOutcome.overweight;
    return MeasurementResultOutcome.normal;
  }

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

    final overrides = reportDataOverrides.value;

    // If the user manually set vitals, derive the outcome from the resulting
    // BMI so the printed report's category matches what they entered.
    // Otherwise roll a random outcome and let _fakeVitals fill the rest.
    final hasManualVitals =
        overrides.heightCm != null && overrides.weightKg != null;
    final manualAge = int.tryParse(_ageController.text.trim());
    final canClassifyByBmi =
        hasManualVitals && manualAge != null && _sex != null;
    final outcome = canClassifyByBmi
        ? _outcomeFromBmi(
            overrides.heightCm!,
            overrides.weightKg!,
            age: manualAge,
            sex: _sex!,
          )
        : MeasurementResultOutcome
            .values[Random().nextInt(MeasurementResultOutcome.values.length)];
    final rolled = _fakeVitals(outcome);
    final v = (
      heightCm: overrides.heightCm ?? rolled.heightCm,
      weightKg: overrides.weightKg ?? rolled.weightKg,
      tempC: rolled.tempC,
      hr: rolled.hr,
      bp: rolled.bp,
    );

    try {
      final ageText = _ageController.text.trim();
      final age = int.tryParse(ageText);
      // Approximate DOB from age (Jan 1 of birth year) — schema needs `date`.
      final dob = age == null
          ? null
          : DateTime(DateTime.now().year - age, 1, 1);

      final studentId = _studentIdController.text.trim();
      final fullName = _nameController.text.trim();
      final nameParts = fullName.split(RegExp(r'\s+'));
      final firstName = nameParts.isEmpty
          ? (studentId.isEmpty ? 'Student' : studentId)
          : nameParts.first;
      final lastName = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';

      final draft = Student(
        id: '',
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dob,
        sex: _mapSex(_sex),
        gradeLevel: _selectedGrade,
        section: _sectionController.text.trim().isEmpty
            ? null
            : _sectionController.text.trim(),
        studentNumber: studentId.isEmpty ? null : studentId,
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
              allergies: null,
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
        _rolledHeightCm = v.heightCm;
        _rolledWeightKg = v.weightKg;
        _rolledVisitDate = DateTime.now();
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
    if (_showResultsGateway) {
      final heightM =
          _rolledHeightCm == null ? null : _rolledHeightCm! / 100.0;
      final ageInt = int.tryParse(_ageController.text.trim());
      final bmi = (heightM != null && _rolledWeightKg != null && heightM > 0)
          ? _rolledWeightKg! / (heightM * heightM)
          : null;
      return ResultsGatewayPage(
        outcome: _rolledMeasurementOutcome ?? widget.measurementResultOutcome,
        reportId: _rolledReportId,
        studentName: _nameController.text.trim().isEmpty
            ? null
            : _nameController.text.trim(),
        schoolId: _studentIdController.text.trim().isEmpty
            ? null
            : _studentIdController.text.trim(),
        age: ageInt,
        sex: _sexLabel(_sex),
        heightMeters: heightM,
        weightKg: _rolledWeightKg,
        bmi: bmi,
        visitDate: _rolledVisitDate,
        onDone: () {
          _restartForNextStudent();
          widget.onReturnToStart();
        },
      );
    }

    if (_showMeasurementResult) {
      final heightM =
          _rolledHeightCm == null ? null : _rolledHeightCm! / 100.0;
      final ageInt = int.tryParse(_ageController.text.trim());
      final bmi = (heightM != null && _rolledWeightKg != null && heightM > 0)
          ? _rolledWeightKg! / (heightM * heightM)
          : null;
      return MeasurementResultPage(
        outcome: _rolledMeasurementOutcome ?? widget.measurementResultOutcome,
        reportId: _rolledReportId,
        studentName: _nameController.text.trim().isEmpty
            ? null
            : _nameController.text.trim(),
        schoolId: _studentIdController.text.trim().isEmpty
            ? null
            : _studentIdController.text.trim(),
        age: ageInt,
        sex: _sexLabel(_sex),
        heightMeters: heightM,
        weightKg: _rolledWeightKg,
        bmi: bmi,
        visitDate: _rolledVisitDate,
        onDone: () => setState(() {
          _showMeasurementResult = false;
          _showResultsGateway = true;
        }),
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
        name: _nameController.text.trim(),
        age: _ageController.text.trim(),
        sex: _sexLabel(_sex),
        grade: _selectedGrade ?? '',
        section: _sectionController.text.trim(),
        onConfirm: _persisting ? () {} : _persistAndAdvance,
        onBack: () => setState(() => _showConfirmation = false),
      );
    }

    final size = MediaQuery.sizeOf(context);
    final edgePad = size.width * 0.04;

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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth;
                  final maxH = constraints.maxHeight;

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
                            child: _ProfileCard(
                              cardWidth: cardW,
                              cardHeight: cardH,
                              fieldColor: ProfileSetupPage.fieldBlue,
                              actionColor: ProfileSetupPage.actionPink,
                              studentIdController: _studentIdController,
                              nameController: _nameController,
                              ageController: _ageController,
                              onAgeChanged: (v) =>
                                  setState(() => _ageController.text = v ?? ''),
                              sectionController: _sectionController,
                              selectedGrade: _selectedGrade,
                              onGradeChanged: (v) =>
                                  setState(() => _selectedGrade = v),
                              sex: _sex,
                              onSexChanged: (v) => setState(() => _sex = v),
                              onSubmit: () {
                                final missing = <String>[
                                  if (_studentIdController.text.trim().isEmpty)
                                    'ID No.',
                                  if (_nameController.text.trim().isEmpty)
                                    'Name',
                                  if (_ageController.text.trim().isEmpty)
                                    'Age',
                                  if (_sex == null) 'Gender',
                                  if (_selectedGrade == null) 'Grade',
                                  if (_sectionController.text.trim().isEmpty)
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
                              onBack: widget.onBack,
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
                        SizedBox(height: edgePad * 0.4),
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

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.cardWidth,
    required this.cardHeight,
    required this.fieldColor,
    required this.actionColor,
    required this.studentIdController,
    required this.nameController,
    required this.ageController,
    required this.onAgeChanged,
    required this.sectionController,
    required this.selectedGrade,
    required this.onGradeChanged,
    required this.sex,
    required this.onSexChanged,
    required this.onSubmit,
    required this.onBack,
  });

  final double cardWidth;
  final double cardHeight;
  final Color fieldColor;
  final Color actionColor;
  final TextEditingController studentIdController;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final ValueChanged<String?> onAgeChanged;
  final TextEditingController sectionController;
  final String? selectedGrade;
  final ValueChanged<String?> onGradeChanged;
  final _ProfileSex? sex;
  final ValueChanged<_ProfileSex?> onSexChanged;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  static const _headlineRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final mascotColumnW = cardWidth * 0.42;
    final mascotH = (cardHeight * 0.78).clamp(0.0, cardHeight - 24).toDouble();
    final mascotW = mascotH * Mascot.aspect;

    final pillH = (cardHeight * 0.11).clamp(48.0, 72.0).toDouble();
    final pillW = (cardWidth * 0.5).clamp(280.0, 560.0).toDouble();

    final headlineSize = (cardWidth * 0.05).clamp(28.0, 56.0).toDouble();

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
            top: cardHeight * 0.05,
            right: cardWidth * 0.04,
            width: mascotColumnW,
            child: Text(
              'Tell me\nabout\nyourself!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _headlineRed,
                fontSize: headlineSize,
                fontWeight: FontWeight.w900,
                height: 1.0,
                letterSpacing: 0.4,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    offset: const Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: cardWidth * 0.02,
            bottom: cardHeight * 0.04,
            width: mascotColumnW,
            height: mascotH,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.bottomRight,
              child: Mascot.winking(width: mascotW, height: mascotH),
            ),
          ),
          Positioned(
            left: cardWidth * 0.04,
            top: cardHeight * 0.05,
            right: mascotColumnW + cardWidth * 0.06,
            bottom: pillH + cardHeight * 0.1,
            child: _ProfileForm(
              fieldColor: fieldColor,
              studentIdController: studentIdController,
              nameController: nameController,
              ageController: ageController,
              onAgeChanged: onAgeChanged,
              selectedGrade: selectedGrade,
              onGradeChanged: onGradeChanged,
              sectionController: sectionController,
              sex: sex,
              onSexChanged: onSexChanged,
            ),
          ),
          Positioned(
            left: cardWidth * 0.04,
            bottom: cardHeight * 0.05,
            child: SnakPillButton(
              label: "GOT IT! LET'S START",
              labelColor: actionColor,
              width: pillW,
              height: pillH,
              onPressed: onSubmit,
            ),
          ),
          Positioned(
            top: 4,
            left: 4,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: Colors.black54,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            ),
          ),
        ],
      ),
    );
  }
}

enum _ProfileSex { boy, girl }

class _ProfileForm extends StatelessWidget {
  const _ProfileForm({
    required this.fieldColor,
    required this.studentIdController,
    required this.nameController,
    required this.ageController,
    required this.onAgeChanged,
    required this.selectedGrade,
    required this.onGradeChanged,
    required this.sectionController,
    required this.sex,
    required this.onSexChanged,
  });

  final Color fieldColor;
  final TextEditingController studentIdController;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final ValueChanged<String?> onAgeChanged;
  final String? selectedGrade;
  final ValueChanged<String?> onGradeChanged;
  final TextEditingController sectionController;
  final _ProfileSex? sex;
  final ValueChanged<_ProfileSex?> onSexChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
    final w = c.maxWidth;
    final labelFontSize = (w * 0.05).clamp(13.0, 20.0);
    final inputFontSize = (w * 0.058).clamp(15.0, 24.0);
    final fieldPadH = (w * 0.045).clamp(14.0, 22.0);
    final fieldPadV = (w * 0.022).clamp(8.0, 14.0);
    final rowGap = (w * 0.022).clamp(8.0, 14.0);
    final inputPadV = (inputFontSize * 0.36).clamp(6.0, 12.0);
    final minInputRow = (inputFontSize * 2.1).clamp(40.0, 56.0).toDouble();
    final sexCircle = (w * 0.11).clamp(36.0, 54.0).toDouble();

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

    return SingleChildScrollView(
      child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LabeledField(
          color: fieldColor,
          label: 'ID No.:',
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
        _LabeledField(
          color: fieldColor,
          label: 'Name:',
          labelStyle: labelStyle,
          fieldInsets: fieldInsets,
          minInputRowHeight: minInputRow,
          field: TextField(
            controller: nameController,
            style: inputStyle,
            cursorColor: Colors.white,
            textCapitalization: TextCapitalization.words,
            decoration: deco(),
          ),
        ),
        SizedBox(height: rowGap),
        LayoutBuilder(
          builder: (context, constraints) {
            final ageValue = ageController.text.trim().isEmpty
                ? null
                : ageController.text.trim();
            final ageField = _LabeledField(
              color: fieldColor,
              label: 'AGE:',
              labelStyle: labelStyle,
              fieldInsets: fieldInsets,
              minInputRowHeight: minInputRow,
              field: InputDecorator(
                decoration: deco(hint: 'Select'),
                isEmpty: ageValue == null,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: ageValue,
                    isExpanded: true,
                    isDense: true,
                    style: inputStyle,
                    iconEnabledColor: Colors.white,
                    iconDisabledColor: Colors.white.withValues(alpha: 0.5),
                    dropdownColor: fieldColor,
                    items: [
                      for (var a = 6; a <= 12; a++)
                        DropdownMenuItem(
                          value: '$a',
                          child: Text(
                            '$a',
                            style: inputStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: onAgeChanged,
                  ),
                ),
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
                Expanded(flex: 6, child: ageField),
                SizedBox(width: rowGap),
                Expanded(flex: 5, child: sexField),
              ],
            );
          },
        ),
        SizedBox(height: rowGap),
        _LabeledField(
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
                iconDisabledColor: Colors.white.withValues(alpha: 0.5),
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
        SizedBox(height: rowGap),
        _LabeledField(
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
      ],
      ),
    );
    });
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
              Flexible(
                child: Text(
                  label,
                  style: labelStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
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
                Text('GENDER:', style: labelStyle),
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
