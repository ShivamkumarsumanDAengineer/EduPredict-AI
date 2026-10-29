import 'dart:math' as math;

class PredictionResult {
  final double predictedScore;
  final double lowerBand;
  final double upperBand;
  final String grade;
  final String honor;
  final double passProbability;
  final String riskCategory;
  final Map<String, double> subjectEstimates;

  const PredictionResult({
    required this.predictedScore,
    required this.lowerBand,
    required this.upperBand,
    required this.grade,
    required this.honor,
    required this.passProbability,
    required this.riskCategory,
    required this.subjectEstimates,
  });
}

class MlPredictionService {
  static const double baselineAttendance = 91.5;
  static const double baselineHours = 26.5;
  static const double baselineIa = 84.0;
  static const double baselineHw = 90.0;
  static const double baselineSleep = 7.5;
  static const double baselineScore = 87.4;

  static PredictionResult compute({
    required double attendance,
    required double studyHours,
    required double internalAssessment,
    required double homeworkPercent,
    required double sleepHours,
    bool scenarioBoostHours = false,
    bool scenarioMaxHw = false,
  }) {
    // Delta adjustments from baseline parameters
    final double dAttendance = (attendance - baselineAttendance) * 0.12;
    final double dHours = (studyHours - baselineHours) * 0.35;
    final double dIa = (internalAssessment - baselineIa) * 0.28;
    final double dHw = (homeworkPercent - baselineHw) * 0.10;
    final double dSleep = (sleepHours - baselineSleep) * 0.40;

    double extraBoost = 0.0;
    if (scenarioBoostHours) extraBoost += 3.2;
    if (scenarioMaxHw) extraBoost += 1.8;

    double score = baselineScore +
        dAttendance +
        dHours +
        dIa +
        dHw +
        dSleep +
        extraBoost;

    // Clamp score within reasonable bounds [45, 99.5]
    score = score.clamp(45.0, 99.5);
    score = (score * 10).roundToDouble() / 10;

    final double lowerBand =
        ((score - 2.3).clamp(40.0, 99.0) * 10).roundToDouble() / 10;
    final double upperBand =
        ((score + 2.3).clamp(45.0, 100.0) * 10).roundToDouble() / 10;

    String grade = 'A';
    String honor = 'Distinction';
    if (score >= 93.0) {
      grade = 'A+';
      honor = 'High Distinction';
    } else if (score >= 85.0) {
      grade = 'A';
      honor = 'Distinction';
    } else if (score >= 78.0) {
      grade = 'B+';
      honor = 'Merit';
    } else if (score >= 68.0) {
      grade = 'B';
      honor = 'Good Standing';
    } else if (score >= 55.0) {
      grade = 'C';
      honor = 'Passing';
    } else {
      grade = 'F';
      honor = 'Critical Alert';
    }

    // Sigmoid pass probability
    final double exponent = -0.15 * (score - 50.0);
    final double sigmoid = 1.0 / (1.0 + math.exp(exponent));
    final double passProb =
        ((sigmoid * 100).clamp(50.0, 99.9) * 10).roundToDouble() / 10;

    String riskCategory = 'Low Risk';
    if (passProb < 75.0) {
      riskCategory = 'High Risk';
    } else if (passProb < 88.0) {
      riskCategory = 'Moderate Risk';
    }

    // Relative coursework estimates
    final double dsa = (score * 1.04).clamp(50.0, 98.0).roundToDouble();
    final double os = (score * 0.94).clamp(45.0, 95.0).roundToDouble();
    final double db = (score * 1.02).clamp(48.0, 97.0).roundToDouble();
    final double ai = (score * 1.08).clamp(52.0, 99.0).roundToDouble();

    return PredictionResult(
      predictedScore: score,
      lowerBand: lowerBand,
      upperBand: upperBand,
      grade: grade,
      honor: honor,
      passProbability: passProb,
      riskCategory: riskCategory,
      subjectEstimates: {
        'Data Structures & Algorithms': dsa,
        'Operating Systems': os,
        'Database Management': db,
        'AI & Machine Learning': ai,
      },
    );
  }
}

