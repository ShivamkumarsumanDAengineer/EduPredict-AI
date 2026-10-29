import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../services/ml_prediction_service.dart';

class MlPredictorScreen extends StatefulWidget {
  const MlPredictorScreen({super.key});

  @override
  State<MlPredictorScreen> createState() => _MlPredictorScreenState();
}

class _MlPredictorScreenState extends State<MlPredictorScreen> {
  // Input parameters
  double _attendance = 91.5;
  double _studyHours = 26.5;
  double _internalAssessment = 84.0;
  double _homework = 90.0;
  double _sleepHours = 7.5;

  // Scenario toggles
  bool _scenarioHoursBoost = false;
  bool _scenarioHwBoost = false;

  bool _isRecalculating = false;

  late PredictionResult _result;

  @override
  void initState() {
    super.initState();
    _recompute();
  }

  void _recompute() {
    _result = MlPredictionService.compute(
      attendance: _attendance,
      studyHours: _studyHours,
      internalAssessment: _internalAssessment,
      homeworkPercent: _homework,
      sleepHours: _sleepHours,
      scenarioBoostHours: _scenarioHoursBoost,
      scenarioMaxHw: _scenarioHwBoost,
    );
  }

  void _resetParameters() {
    setState(() {
      _attendance = 91.5;
      _studyHours = 26.5;
      _internalAssessment = 84.0;
      _homework = 90.0;
      _sleepHours = 7.5;
      _scenarioHoursBoost = false;
      _scenarioHwBoost = false;
      _recompute();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Parameters reset to institutional baseline.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _triggerCalculation() {
    setState(() {
      _isRecalculating = true;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _isRecalculating = false;
        _recompute();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.inverseSurface,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: const [
              Icon(Icons.bolt, color: AppColors.primaryFixed),
              SizedBox(width: 8),
              Text('Model re-converged: R² 0.924 (Optimal Fit)'),
            ],
          ),
        ),
      );
    });
  }

  void _showInterventionPlanModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Prescriptive Intervention Plan', style: AppTypography.headlineSm),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Based on your active parameter settings, EduPredict generated 3 high-impact intervention recommendations:',
                style: AppTypography.bodySm,
              ),
              const SizedBox(height: 14),
              _buildPlanStep(
                1,
                'Operating Systems Focus',
                'Allocate +2.5 hours/week to Virtual Memory and Kernel synchronization to shift course grade to A.',
                AppColors.primary,
              ),
              _buildPlanStep(
                2,
                'Maintain Attendance Tier 1',
                'Stay above 90% in Computer Networks to protect internal continuous assessment marks.',
                AppColors.tertiary,
              ),
              _buildPlanStep(
                3,
                'Circadian Sleep Calibration',
                'Keep sleep consistent at 7.5 hours for optimal cognitive consolidation before week 14 finals.',
                AppColors.secondary,
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlanStep(int step, String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLg),
                const SizedBox(height: 2),
                Text(desc, style: AppTypography.bodySm),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header & Live Sync Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.insights, color: AppColors.primary, size: 24),
                    SizedBox(width: 8),
                    Text('ML Predictor & Simulator', style: AppTypography.headlineSm),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Live Sync',
                        style: TextStyle(
                          fontFamily: AppTypography.fontBody,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 2. Model Spec Pill Ribbon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.account_tree_outlined, color: AppColors.tertiary, size: 18),
                      SizedBox(width: 6),
                      Text('Random Forest Regressor', style: AppTypography.labelMd),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('R² 0.924', style: AppTypography.labelSm),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('MAE 2.18', style: AppTypography.labelSm),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 3. Primary Prediction Output Card
            _buildPredictionHeroCard(),
            const SizedBox(height: 14),

            // 4. Quick "What-If" Projections
            _buildWhatIfProjections(),
            const SizedBox(height: 14),

            // 5. Predictive Feature Sliders
            _buildSlidersCard(),
            const SizedBox(height: 14),

            // 6. Action Button: Re-calculate
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isRecalculating ? null : _triggerCalculation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                icon: _isRecalculating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.bolt, size: 20),
                label: Text(
                  _isRecalculating ? 'Re-training Features...' : 'Re-calculate ML Prediction',
                  style: AppTypography.labelLg.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // 7. Coursework Estimates Breakdown
            _buildCourseworkEstimates(),
            const SizedBox(height: 14),

            // 8. Action Deck: Save & Intervention Plan
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Active simulator scenario saved to student timeline!'),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.borderActive),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                    label: const Text('Save Scenario', style: AppTypography.labelMd),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showInterventionPlanModal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tertiaryContainer,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.assignment_turned_in_outlined, size: 18),
                    label: const Text('Intervention Plan', style: AppTypography.labelMd),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 9. Disclaimer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info_outline, color: AppColors.outline, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Predictions are statistical estimates generated by validated regression models; not deterministic guarantees. Intended for timely institutional mentorship and proactive intervention.',
                      style: AppTypography.bodySm,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionHeroCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surfaceContainerLowest,
            AppColors.surfaceContainerLow,
            AppColors.surfaceContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'FORECAST FINAL RESULT',
                    style: TextStyle(
                      fontFamily: AppTypography.fontBody,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '95% Conf. Interval',
                  style: TextStyle(
                    fontFamily: AppTypography.fontBody,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: _result.predictedScore.toStringAsFixed(1),
                      style: AppTypography.metricDisplay.copyWith(
                        fontSize: 42,
                        color: AppColors.onSurface,
                      ),
                      children: const [
                        TextSpan(
                          text: ' / 100',
                          style: TextStyle(
                            fontFamily: AppTypography.fontHeading,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Uncertainty band: [${_result.lowerBand} - ${_result.upperBand}%]',
                    style: AppTypography.bodySm,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _result.grade,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontHeading,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _result.honor,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontBody,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified, color: AppColors.primary, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Pass Probability: ${_result.passProbability}%',
                    style: AppTypography.labelMd,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _result.riskCategory,
                  style: const TextStyle(
                    fontFamily: AppTypography.fontBody,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_result.passProbability / 100).clamp(0.0, 1.0),
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryContainer),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatIfProjections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Row(
              children: [
                Icon(Icons.bolt, color: AppColors.tertiary, size: 18),
                SizedBox(width: 4),
                Text('Quick "What-If" Projections', style: AppTypography.labelMd),
              ],
            ),
            Text('Tap to apply delta', style: AppTypography.labelSm),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _scenarioHoursBoost = !_scenarioHoursBoost;
                    _recompute();
                  });
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _scenarioHoursBoost
                        ? AppColors.primaryFixed
                        : AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _scenarioHoursBoost ? AppColors.primary : AppColors.borderSubtle,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('+5h Study/Week', style: AppTypography.labelSm),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryFixed,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '+3.2%',
                              style: TextStyle(
                                fontFamily: AppTypography.fontBody,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Boost focus in OS & DB',
                        style: AppTypography.bodySm,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _scenarioHwBoost = !_scenarioHwBoost;
                    _recompute();
                  });
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _scenarioHwBoost
                        ? AppColors.tertiaryFixed
                        : AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _scenarioHwBoost ? AppColors.tertiary : AppColors.borderSubtle,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('100% Homework', style: AppTypography.labelSm),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.tertiaryFixed,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '+1.8%',
                              style: TextStyle(
                                fontFamily: AppTypography.fontBody,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.tertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Max continuous score',
                        style: AppTypography.bodySm,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlidersCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Predictive Features', style: AppTypography.titleMd),
              TextButton.icon(
                onPressed: _resetParameters,
                icon: const Icon(Icons.restart_alt, size: 16),
                label: const Text('Reset', style: AppTypography.labelSm),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 1. Attendance Slider
          _buildSliderItem(
            title: 'Attendance Rate',
            valueDisplay: '${_attendance.toStringAsFixed(1)}%',
            value: _attendance,
            min: 60.0,
            max: 100.0,
            subLabel: 'Institutional Threshold: 75%',
            onChanged: (val) {
              setState(() {
                _attendance = val;
                _recompute();
              });
            },
          ),
          const SizedBox(height: 12),

          // 2. Weekly Study Hours (with stepper)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Weekly Dedicated Study', style: AppTypography.labelMd),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: _studyHours > 5
                        ? () {
                            setState(() {
                              _studyHours = (_studyHours - 1).clamp(5.0, 50.0);
                              _recompute();
                            });
                          }
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${_studyHours.toStringAsFixed(1)} hrs',
                    style: AppTypography.labelLg.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    onPressed: _studyHours < 50
                        ? () {
                            setState(() {
                              _studyHours = (_studyHours + 1).clamp(5.0, 50.0);
                              _recompute();
                            });
                          }
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          Slider(
            value: _studyHours,
            min: 5.0,
            max: 50.0,
            divisions: 90,
            onChanged: (val) {
              setState(() {
                _studyHours = val;
                _recompute();
              });
            },
          ),
          const SizedBox(height: 12),

          // 3. Internal Assessment
          _buildSliderItem(
            title: 'Internal Assessment Average',
            valueDisplay: '${_internalAssessment.round()} / 100',
            value: _internalAssessment,
            min: 40.0,
            max: 100.0,
            subLabel: 'Weights: Continuous Mid-evaluations',
            onChanged: (val) {
              setState(() {
                _internalAssessment = val;
                _recompute();
              });
            },
          ),
          const SizedBox(height: 12),

          // 4. Homework Completion
          _buildSliderItem(
            title: 'Homework & Tasks Completion',
            valueDisplay: '${_homework.round()}%',
            value: _homework,
            min: 50.0,
            max: 100.0,
            subLabel: 'LMS Submissions Repository',
            activeColor: AppColors.tertiary,
            onChanged: (val) {
              setState(() {
                _homework = val;
                _recompute();
              });
            },
          ),
          const SizedBox(height: 12),

          // 5. Rest & Sleep
          _buildSliderItem(
            title: 'Rest & Well-being Score',
            valueDisplay: '${_sleepHours.toStringAsFixed(1)} hrs/night',
            value: _sleepHours,
            min: 4.0,
            max: 10.0,
            subLabel: 'Healthy baseline: 7-8 hrs',
            onChanged: (val) {
              setState(() {
                _sleepHours = val;
                _recompute();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSliderItem({
    required String title,
    required String valueDisplay,
    required double value,
    required double min,
    required double max,
    required String subLabel,
    Color? activeColor,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTypography.labelMd),
            Text(
              valueDisplay,
              style: TextStyle(
                fontFamily: AppTypography.fontBody,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: activeColor ?? AppColors.primary,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: activeColor ?? AppColors.primaryContainer,
          onChanged: onChanged,
        ),
        Text(subLabel, style: AppTypography.labelSm),
      ],
    );
  }

  Widget _buildCourseworkEstimates() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Coursework Estimates', style: AppTypography.titleMd),
              Text('4 Active Modules', style: AppTypography.labelSm),
            ],
          ),
          const SizedBox(height: 12),
          ..._result.subjectEstimates.entries.map((entry) {
            final double percent = entry.value;
            String grade = 'A';
            Color tagBg = AppColors.primaryFixed;
            Color tagFg = AppColors.onPrimaryFixed;

            if (percent >= 93) {
              grade = 'Grade A+';
              tagBg = AppColors.tertiaryFixed;
              tagFg = AppColors.onTertiaryFixed;
            } else if (percent >= 85) {
              grade = 'Grade A';
              tagBg = AppColors.primaryFixed;
              tagFg = AppColors.onPrimaryFixed;
            } else {
              grade = 'Grade B+';
              tagBg = AppColors.secondaryContainer;
              tagFg = AppColors.onSecondaryContainer;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: AppTypography.labelLg,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${percent.round()}%',
                            style: AppTypography.labelLg.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: tagBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              grade,
                              style: TextStyle(
                                fontFamily: AppTypography.fontBody,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: tagFg,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (percent / 100).clamp(0.0, 1.0),
                      backgroundColor: AppColors.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        percent >= 90 ? AppColors.primary : AppColors.secondary,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

