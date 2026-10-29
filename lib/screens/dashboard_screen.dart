import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../widgets/custom_charts.dart';
import '../models/assessment_item.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int tabIndex)? onNavigateToTab;

  const DashboardScreen({super.key, this.onNavigateToTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isGeneratingPlan = false;
  bool _planReady = false;
  bool _insightDismissed = false;

  final List<AssessmentItem> _assessments = const [
    AssessmentItem(
      title: 'Operating Systems Final',
      courseCode: 'CS-401',
      instructor: 'Prof. V. Kulkarni',
      daysLeft: 9,
      predictedGrade: 'A-',
      expectedScore: 86.2,
      actionLabel: 'Review Syllabus',
    ),
    AssessmentItem(
      title: 'Data Mining & Business Intelligence',
      courseCode: 'AI-503',
      instructor: 'Dr. R. Narayan',
      daysLeft: 16,
      predictedGrade: 'A',
      expectedScore: 91.8,
      actionLabel: 'Mock Test',
    ),
  ];

  void _triggerPlanGeneration() {
    setState(() {
      _isGeneratingPlan = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isGeneratingPlan = false;
        _planReady = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.inverseSurface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: AppColors.primaryFixed, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Personalized 3-Day Recovery Plan generated in Study Buddy!',
                  style: TextStyle(color: AppColors.inverseOnSurface),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'View',
            textColor: AppColors.primaryFixed,
            onPressed: () {
              widget.onNavigateToTab?.call(3); // Navigate to Study Buddy
            },
          ),
        ),
      );
    });
  }

  void _showTimetableModal() {
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
                  const Text('Today\'s Academic Schedule', style: AppTypography.headlineSm),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTimetableItem(
                '10:00 AM - 11:30 AM',
                'Data Structures & Algorithms',
                'Room 304 • Lecture',
                AppColors.primary,
              ),
              _buildTimetableItem(
                '02:00 PM - 04:00 PM',
                'Operating Systems Kernel Lab',
                'Lab 2 • Systems Lab',
                AppColors.tertiary,
              ),
              _buildTimetableItem(
                '04:30 PM - 05:30 PM',
                'Machine Learning Group Mentorship',
                'Seminar Hall A',
                AppColors.secondary,
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimetableItem(String time, String subject, String room, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: AppTypography.labelLg),
                Text('$time • $room', style: AppTypography.bodySm),
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
            // 1. Student Welcome Profile Banner
            _buildProfileBanner(),
            const SizedBox(height: 14),

            // 2. Key Metrics 2x2 Grid
            _buildMetricsGrid(),
            const SizedBox(height: 14),

            // 3. Smart Early-Warning & Recommendation Banner
            if (!_insightDismissed) ...[
              _buildInsightBanner(),
              const SizedBox(height: 14),
            ],

            // 4. ML Performance Trajectory Graph Widget
            _buildTrajectoryCard(),
            const SizedBox(height: 14),

            // 5. Upcoming Assessments
            _buildAssessmentsSection(),
            const SizedBox(height: 14),

            // 6. Quick Interventions
            _buildQuickInterventions(),
            const SizedBox(height: 14),

            // 7. Autonomous Coach Banner
            _buildCoachSnippet(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryContainer.withOpacity(0.15),
                          border: Border.all(color: AppColors.primaryContainer, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            'SK',
                            style: TextStyle(
                              fontFamily: AppTypography.fontHeading,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Welcome back, Shivam!',
                        style: AppTypography.headlineSm,
                      ),
                      Text(
                        'B.Tech CS & AI • Sem 6',
                        style: AppTypography.bodySm,
                      ),
                    ],
                  ),
                ],
              ),
              // Live Model Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Live Model',
                      style: TextStyle(
                        fontFamily: AppTypography.fontBody,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Academic Health Status Pill Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.verified, color: AppColors.primary, size: 18),
                    SizedBox(width: 6),
                    Text('Academic Health', style: AppTypography.labelMd),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'On Track • 88.4% Confidence',
                        style: TextStyle(
                          fontFamily: AppTypography.fontBody,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.35,
      children: [
        // Metric 1: Predicted GPA
        _buildMetricCard(
          title: 'Pred. GPA',
          icon: Icons.school_outlined,
          iconColor: AppColors.primaryContainer,
          value: '3.84',
          unit: '/4.0',
          footer: Row(
            children: const [
              Icon(Icons.trending_up, color: AppColors.primary, size: 14),
              SizedBox(width: 4),
              Text(
                '+0.18 vs midterm',
                style: TextStyle(
                  fontFamily: AppTypography.fontBody,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),

        // Metric 2: Attendance Rate
        _buildMetricCard(
          title: 'Attendance',
          icon: Icons.calendar_today_outlined,
          iconColor: AppColors.primaryContainer,
          value: '91.5',
          unit: '%',
          footer: Row(
            children: const [
              Icon(Icons.check_circle_outline, color: AppColors.primary, size: 14),
              SizedBox(width: 4),
              Text(
                '>75% required',
                style: AppTypography.bodySm,
              ),
            ],
          ),
        ),

        // Metric 3: Assignments
        _buildMetricCard(
          title: 'Assignments',
          icon: Icons.task_alt,
          iconColor: AppColors.tertiary,
          value: '18',
          unit: '/20',
          footer: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.90,
              backgroundColor: AppColors.surfaceContainer,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.tertiaryContainer),
              minHeight: 6,
            ),
          ),
        ),

        // Metric 4: Study Hours
        _buildMetricCard(
          title: 'Study Hours',
          icon: Icons.timer_outlined,
          iconColor: AppColors.primaryContainer,
          value: '26.5',
          unit: 'h',
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Target: 28 hrs', style: AppTypography.bodySm),
              Text(
                '94%',
                style: TextStyle(
                  fontFamily: AppTypography.fontBody,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String unit,
    required Widget footer,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.labelSm),
              Icon(icon, color: iconColor, size: 18),
            ],
          ),
          RichText(
            text: TextSpan(
              text: value,
              style: AppTypography.metricDisplay,
              children: [
                TextSpan(
                  text: unit,
                  style: const TextStyle(
                    fontFamily: AppTypography.fontHeading,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          footer,
        ],
      ),
    );
  }

  Widget _buildInsightBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tertiaryFixed,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.tertiaryFixedDim),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.tertiary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.psychology, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'ADAPTIVE INTERVENTION',
                    style: TextStyle(
                      fontFamily: AppTypography.fontBody,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.onTertiaryFixedVariant,
                    ),
                  ),
                  Text(
                    'Smart AI Insight',
                    style: TextStyle(
                      fontFamily: AppTypography.fontHeading,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onTertiaryFixed,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Operating Systems Midterm in 9 days. Dedicate +2.5 hours to Memory Management to push your predicted score from 78% to 87%.',
            style: TextStyle(
              fontFamily: AppTypography.fontBody,
              fontSize: 13,
              height: 1.45,
              color: AppColors.onTertiaryFixed,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isGeneratingPlan ? null : _triggerPlanGeneration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tertiary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                  icon: _isGeneratingPlan
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(
                          _planReady ? Icons.done : Icons.calendar_view_week,
                          size: 18,
                        ),
                  label: Text(
                    _isGeneratingPlan
                        ? 'Generating Schedule...'
                        : (_planReady ? 'Plan Ready (3 Blocks)' : 'View Study Plan'),
                    style: AppTypography.labelLg.copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  setState(() {
                    _insightDismissed = true;
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryFixedDim.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.snooze,
                    color: AppColors.onTertiaryFixed,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrajectoryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('GPA Trajectory & Forecast', style: AppTypography.titleMd),
                  Text(
                    'Sem 1 to Sem 6 Machine Learning Projection',
                    style: AppTypography.bodySm,
                  ),
                ],
              ),
              const Icon(Icons.insights, color: AppColors.primaryContainer, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          const GpaTrajectoryChart(currentGpa: 3.84),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.tertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text('Historical', style: AppTypography.labelSm),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'ML Forecast',
                        style: TextStyle(
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
              const Text('R² = 0.94 Fit', style: AppTypography.labelSm),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.event_available, color: AppColors.primary, size: 18),
                SizedBox(width: 6),
                Text('Upcoming Assessments', style: AppTypography.titleMd),
              ],
            ),
            const Text(
              '2 Active Exams',
              style: TextStyle(
                fontFamily: AppTypography.fontBody,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._assessments.map((exam) {
          final bool isUrgent = exam.daysLeft <= 10;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exam.title, style: AppTypography.titleMd),
                        Text('${exam.courseCode} • ${exam.instructor}',
                            style: AppTypography.bodySm),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isUrgent ? AppColors.errorContainer : AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isUrgent ? Icons.timer : Icons.calendar_month,
                            color: isUrgent ? AppColors.onErrorContainer : AppColors.onSurface,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${exam.daysLeft} Days Left',
                            style: TextStyle(
                              fontFamily: AppTypography.fontBody,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isUrgent ? AppColors.onErrorContainer : AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isUrgent
                                  ? AppColors.primaryContainer
                                  : AppColors.tertiaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                exam.predictedGrade,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Predicted Outcome', style: AppTypography.labelSm),
                              Text(
                                '${exam.expectedScore}% Expected Score',
                                style: AppTypography.labelMd,
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Opening syllabus modules for ${exam.courseCode}...'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainerHighest,
                          foregroundColor: AppColors.onPrimaryFixedVariant,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          exam.actionLabel,
                          style: const TextStyle(
                            fontFamily: AppTypography.fontBody,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildQuickInterventions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Interventions', style: AppTypography.titleMd),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.55,
          children: [
            _buildActionCard(
              title: 'What-If Simulator',
              subtitle: 'Test grade scenarios',
              icon: Icons.batch_prediction,
              iconBg: AppColors.surfaceContainerHigh,
              iconColor: AppColors.primary,
              onTap: () => widget.onNavigateToTab?.call(1), // Predict tab
            ),
            _buildActionCard(
              title: 'Log Study Hours',
              subtitle: '+2.5h tracked today',
              icon: Icons.add_circle_outline,
              iconBg: AppColors.secondaryContainer,
              iconColor: AppColors.onSecondaryContainer,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.inverseSurface,
                    behavior: SnackBarBehavior.floating,
                    content: Row(
                      children: const [
                        Icon(Icons.check_circle, color: AppColors.primaryFixed),
                        SizedBox(width: 8),
                        Text('+1.5 Study Hours logged for Operating Systems!'),
                      ],
                    ),
                  ),
                );
              },
            ),
            _buildActionCard(
              title: 'View Timetable',
              subtitle: 'Next: Lab at 2:00 PM',
              icon: Icons.table_rows_outlined,
              iconBg: AppColors.tertiaryFixed,
              iconColor: AppColors.tertiary,
              onTap: _showTimetableModal,
            ),
            _buildActionCard(
              title: 'Download PDF',
              subtitle: 'Full Sem 6 Analytics',
              icon: Icons.download_outlined,
              iconBg: AppColors.surfaceContainerHigh,
              iconColor: AppColors.primary,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Generating official institutional analytics report...'),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(height: 8),
            Text(title, style: AppTypography.labelLg, maxLines: 1),
            Text(subtitle, style: AppTypography.bodySm, maxLines: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachSnippet() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'EduPredict Autonomous Coach',
                  style: TextStyle(
                    fontFamily: AppTypography.fontHeading,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Your current performance probability puts you in the top 8% of your batch.',
                  style: AppTypography.bodySm,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => widget.onNavigateToTab?.call(3), // Buddy tab
            child: const Text(
              'Chat',
              style: TextStyle(
                fontFamily: AppTypography.fontBody,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


