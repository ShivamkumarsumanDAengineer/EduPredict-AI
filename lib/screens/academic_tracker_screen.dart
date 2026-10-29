import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../widgets/custom_charts.dart';

class AcademicTrackerScreen extends StatefulWidget {
  const AcademicTrackerScreen({super.key});

  @override
  State<AcademicTrackerScreen> createState() => _AcademicTrackerScreenState();
}

class _AcademicTrackerScreenState extends State<AcademicTrackerScreen> {
  int _selectedTabIndex = 0; // 0: Attendance, 1: Assignments, 2: Quizzes, 3: Timetable

  final List<double> _weeklyHours = [4.0, 3.5, 5.0, 4.0, 4.5, 3.0, 2.5];

  bool _isSubmittingAssignment = false;
  bool _assignmentSubmitted = false;

  void _submitAssignment() {
    setState(() {
      _isSubmittingAssignment = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _isSubmittingAssignment = false;
        _assignmentSubmitted = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.inverseSurface,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Icon(Icons.task_alt, color: AppColors.primaryFixed),
              SizedBox(width: 8),
              Text('Machine Learning Mini Project submitted to LMS!'),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header & Sync Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Academic Diagnostics', style: AppTypography.headlineSm),
                    Text(
                      'Semester 6 • Fall Cohort Analytics',
                      style: AppTypography.bodySm,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.auto_awesome, color: AppColors.primary, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'SYNC ACTIVE',
                        style: TextStyle(
                          fontFamily: AppTypography.fontBody,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. Segmented Tab Navigation
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  _buildSegmentedTab('Attendance', 0),
                  _buildSegmentedTab('Assignments', 1),
                  _buildSegmentedTab('Quizzes', 2),
                  _buildSegmentedTab('Timetable', 3),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Tab Body
            if (_selectedTabIndex == 0) _buildAttendanceView(),
            if (_selectedTabIndex == 1) _buildAssignmentsView(),
            if (_selectedTabIndex == 2) _buildQuizzesView(),
            if (_selectedTabIndex == 3) _buildTimetableView(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedTab(String label, int index) {
    final bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTypography.fontBody,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Attendance Radial Gauge Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.how_to_reg, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text('Aggregate Presence', style: AppTypography.titleMd),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Week 12 of 16', style: AppTypography.labelSm),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const AttendanceRadialGauge(percentage: 91.5, size: 105),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.verified, color: AppColors.primary, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Tier 1 Standing',
                                style: TextStyle(
                                  fontFamily: AppTypography.fontBody,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Comfortably +16.5% above mandatory institutional threshold (75%).',
                          style: AppTypography.bodySm,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: const [
                            Icon(Icons.event_available,
                                color: AppColors.onSecondaryContainer, size: 15),
                            SizedBox(width: 4),
                            Text('89 of 97 logged sessions', style: AppTypography.labelSm),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Subject-wise Roll Call
        Container(
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
                  Text('Subject-wise Roll Call', style: AppTypography.titleMd),
                  Text('4 Active Streams', style: AppTypography.labelSm),
                ],
              ),
              const SizedBox(height: 12),
              _buildSubjectAttendanceCard(
                'Operating Systems',
                'terminal',
                22,
                25,
                88,
                'Good',
                AppColors.primary,
                AppColors.surfaceContainerHighest,
              ),
              _buildSubjectAttendanceCard(
                'Machine Learning',
                'psychology',
                24,
                25,
                96,
                'Excellent',
                AppColors.tertiary,
                AppColors.tertiaryFixed,
              ),
              _buildSubjectAttendanceCard(
                'Computer Networks',
                'hub',
                20,
                25,
                80,
                'Warning',
                AppColors.error,
                AppColors.errorContainer,
                warningNote: 'Requires 2 more consecutive classes to touch 85% tier',
              ),
              _buildSubjectAttendanceCard(
                'Cloud Computing',
                'cloud',
                23,
                25,
                92,
                'Very Good',
                AppColors.primary,
                AppColors.surfaceContainerHighest,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Weekly Study Hours Bar Chart
        Container(
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
                  Text('Weekly Study Hours', style: AppTypography.titleMd),
                  Text('26.5h Total', style: AppTypography.labelSm),
                ],
              ),
              const SizedBox(height: 16),
              WeeklyStudyBarChart(dailyHours: _weeklyHours),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Quick Log CTA
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('+1.5 hours added to today\'s learning session!'),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.borderActive),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.timer_outlined, size: 20),
            label: const Text('Quick Log Today\'s Study Session', style: AppTypography.labelMd),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectAttendanceCard(
    String subject,
    String iconName,
    int attended,
    int total,
    int percent,
    String status,
    Color color,
    Color badgeBg, {
    String? warningNote,
  }) {
    IconData icon = Icons.book_outlined;
    if (iconName == 'terminal') icon = Icons.terminal;
    if (iconName == 'psychology') icon = Icons.psychology;
    if (iconName == 'hub') icon = Icons.hub;
    if (iconName == 'cloud') icon = Icons.cloud_outlined;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subject, style: AppTypography.labelLg),
                      Text('$attended/$total classes attended', style: AppTypography.bodySm),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '$percent%',
                    style: AppTypography.labelLg.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontFamily: AppTypography.fontBody,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (percent / 100).clamp(0.0, 1.0),
              backgroundColor: AppColors.surfaceContainer,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
          if (warningNote != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.error, size: 14),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    warningNote,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontBody,
                      fontSize: 11,
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAssignmentsView() {
    return Column(
      children: [
        _buildAssignmentCard(
          title: 'OS Kernel Memory Manager',
          course: 'CS-401 • Operating Systems',
          due: 'Submitted yesterday',
          isSubmitted: true,
          grade: '94 / 100 (A)',
        ),
        _buildAssignmentCard(
          title: 'Neural Style Transfer Notebook',
          course: 'AI-503 • Machine Learning',
          due: 'Due in 3 days',
          isSubmitted: _assignmentSubmitted,
          isActionable: true,
        ),
        _buildAssignmentCard(
          title: 'Distributed Transaction Protocol',
          course: 'CS-408 • Cloud Computing',
          due: 'Due in 8 days',
          isSubmitted: false,
        ),
      ],
    );
  }

  Widget _buildAssignmentCard({
    required String title,
    required String course,
    required String due,
    required bool isSubmitted,
    String? grade,
    bool isActionable = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.titleMd),
                    Text(course, style: AppTypography.bodySm),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isSubmitted ? AppColors.successContainer : AppColors.warningContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isSubmitted ? 'Submitted' : 'Pending',
                  style: TextStyle(
                    fontFamily: AppTypography.fontBody,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSubmitted ? AppColors.onSuccess : AppColors.onWarning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(due, style: AppTypography.bodySm),
              if (grade != null)
                Text(
                  grade,
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (isActionable && !isSubmitted)
                ElevatedButton.icon(
                  onPressed: _isSubmittingAssignment ? null : _submitAssignment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  icon: _isSubmittingAssignment
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.upload_file, size: 16),
                  label: Text(
                    _isSubmittingAssignment ? 'Submitting...' : 'Upload Report',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizzesView() {
    final quizzes = [
      {'title': 'Quiz 1: Tree Traversal & Heaps', 'score': '92%', 'status': 'Mastered', 'color': AppColors.primary},
      {'title': 'Quiz 2: CPU Scheduling & Deadlocks', 'score': '85%', 'status': 'Proficient', 'color': AppColors.primary},
      {'title': 'Quiz 3: Virtual Memory & Paging', 'score': '62%', 'status': 'Vulnerability Alert', 'color': AppColors.error},
      {'title': 'Quiz 4: Gradient Descent & Loss', 'score': '96%', 'status': 'Top Percentile', 'color': AppColors.tertiary},
    ];

    return Column(
      children: quizzes.map((q) {
        final Color col = q['color'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(q['title'] as String, style: AppTypography.labelLg),
                    Text(q['status'] as String,
                        style: TextStyle(
                          fontFamily: AppTypography.fontBody,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: col,
                        )),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: col.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  q['score'] as String,
                  style: TextStyle(
                    fontFamily: AppTypography.fontHeading,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: col,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimetableView() {
    return Column(
      children: [
        _buildTimetableItem(
          '10:00 AM - 11:30 AM',
          'Data Structures & Algorithms',
          'Hall 3 • Prof. A. Mehta',
          AppColors.primary,
        ),
        _buildTimetableItem(
          '02:00 PM - 04:00 PM',
          'Operating Systems Kernel Lab',
          'Systems Lab 2 • Prof. V. Kulkarni',
          AppColors.tertiary,
        ),
        _buildTimetableItem(
          '04:30 PM - 05:30 PM',
          'Machine Learning Seminar',
          'Seminar Hall A • Dr. R. Narayan',
          AppColors.secondary,
        ),
      ],
    );
  }

  Widget _buildTimetableItem(String time, String subject, String room, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 44,
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
}

