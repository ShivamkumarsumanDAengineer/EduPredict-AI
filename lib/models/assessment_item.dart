class AssessmentItem {
  final String title;
  final String courseCode;
  final String instructor;
  final int daysLeft;
  final String predictedGrade;
  final double expectedScore;
  final String actionLabel;

  const AssessmentItem({
    required this.title,
    required this.courseCode,
    required this.instructor,
    required this.daysLeft,
    required this.predictedGrade,
    required this.expectedScore,
    required this.actionLabel,
  });
}

