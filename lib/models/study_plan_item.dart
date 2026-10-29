class StudyPlanItem {
  final int dayNumber;
  final String dateString;
  final String title;
  final String duration;
  final String objective;
  final bool isCompleted;

  const StudyPlanItem({
    required this.dayNumber,
    required this.dateString,
    required this.title,
    required this.duration,
    required this.objective,
    this.isCompleted = false,
  });

  StudyPlanItem copyWith({
    int? dayNumber,
    String? dateString,
    String? title,
    String? duration,
    String? objective,
    bool? isCompleted,
  }) {
    return StudyPlanItem(
      dayNumber: dayNumber ?? this.dayNumber,
      dateString: dateString ?? this.dateString,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      objective: objective ?? this.objective,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

