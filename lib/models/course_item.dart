import 'package:flutter/material.dart';

class CourseItem {
  final String id;
  final String name;
  final String code;
  final int attendedClasses;
  final int totalClasses;
  final double scorePercent;
  final String predictedGrade;
  final IconData icon;
  final Color themeColor;

  const CourseItem({
    required this.id,
    required this.name,
    required this.code,
    required this.attendedClasses,
    required this.totalClasses,
    required this.scorePercent,
    required this.predictedGrade,
    required this.icon,
    required this.themeColor,
  });

  double get attendanceRatio =>
      totalClasses == 0 ? 0 : (attendedClasses / totalClasses);

  int get attendancePercent => (attendanceRatio * 100).round();
}

