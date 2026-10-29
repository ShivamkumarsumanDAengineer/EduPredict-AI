import 'package:flutter_test/flutter_test.dart';
import 'package:edupredict_ai/services/ml_prediction_service.dart';

void main() {
  group('MlPredictionService Tests', () {
    test('Calculates baseline score correctly', () {
      final result = MlPredictionService.compute(
        attendance: 91.5,
        studyHours: 26.5,
        internalAssessment: 84.0,
        homeworkPercent: 90.0,
        sleepHours: 7.5,
      );

      expect(result.predictedScore, equals(87.4));
      expect(result.grade, equals('A'));
      expect(result.honor, equals('Distinction'));
      expect(result.passProbability, greaterThan(95.0));
      expect(result.riskCategory, equals('Low Risk'));
      expect(result.subjectEstimates.containsKey('Operating Systems'), isTrue);
    });

    test('Increases score when study hours boost scenario applied', () {
      final base = MlPredictionService.compute(
        attendance: 91.5,
        studyHours: 26.5,
        internalAssessment: 84.0,
        homeworkPercent: 90.0,
        sleepHours: 7.5,
      );

      final boosted = MlPredictionService.compute(
        attendance: 91.5,
        studyHours: 26.5,
        internalAssessment: 84.0,
        homeworkPercent: 90.0,
        sleepHours: 7.5,
        scenarioBoostHours: true,
      );

      expect(boosted.predictedScore, greaterThan(base.predictedScore));
    });

    test('Identifies low risk vs moderate risk', () {
      final critical = MlPredictionService.compute(
        attendance: 62.0,
        studyHours: 8.0,
        internalAssessment: 45.0,
        homeworkPercent: 55.0,
        sleepHours: 4.5,
      );

      expect(critical.predictedScore, lessThan(70.0));
      expect(critical.passProbability, lessThan(88.0));
      expect(critical.riskCategory, isNot(equals('Low Risk')));
    });
  });
}

