import 'package:flutter/material.dart';

class EvaluationResult {
  final int totalScore;
  final String riskLevel;
  final Color color;

  EvaluationResult({
    required this.totalScore,
    required this.riskLevel,
    required this.color,
  });
}

class MedicineEvaluation {
  final DateTime expiryDate;
  final DateTime openingDate;
  final int utilizationDays;
  final String storageCondition;
  final String medicineType;

  MedicineEvaluation({
    required this.expiryDate,
    required this.openingDate,
    required this.utilizationDays,
    required this.storageCondition,
    required this.medicineType,
  });

  EvaluationResult autoEvaluate() {
    final now = DateTime.now();

    // Check invalid entries or expired medicine
    if (expiryDate.isBefore(now)) {
      return EvaluationResult(
        totalScore: 10,
        riskLevel: 'Expired - Critical',
        color: Colors.red,
      );
    }

    if (openingDate.isAfter(now) || expiryDate.isBefore(openingDate)) {
      return EvaluationResult(
        totalScore: 10,
        riskLevel: 'Invalid Dates - Critical',
        color: Colors.red,
      );
    }

    int score = 0;

    final int daysToExpiry = expiryDate.difference(now).inDays;
    final int daysSinceOpened = now.difference(openingDate).inDays;
    final int userProvidedUtilization = utilizationDays;

    // Scoring by medicine type and thresholds
    score += _evaluateByMedicineType(
      medicineType.toLowerCase(),
      daysToExpiry,
      daysSinceOpened,
      userProvidedUtilization,
    );

    // Storage condition score
    score += _evaluateStorageCondition(storageCondition);

    // Determine risk level
    return _generateRiskResult(score);
  }

  int _evaluateByMedicineType(
      String type,
      int daysToExpiry,
      int daysSinceOpened,
      int utilizationDays,
      ) {
    final thresholds = {
      'capsules': [
        [0, 30, 90],
        [0, 30, 90],
        [0, 30, 90],
      ],
      'tablets': [
        [0, 30, 90],
        [0, 30, 90],
        [0, 30, 90],
      ],
      'liquid': [
        [0, 60, 120],
        [0, 15, 30],
        [0, 15, 30],
      ],
      'inhalers': [
        [0, 60, 120],
        [0, 15, 30],
        [0, 15, 30],
      ],
      'topical': [
        [0, 90, 180],
        [0, 30, 60],
        [0, 30, 60],
      ],
      'injections': [
        [0, 15, 30],
        [0, 7, 14],
        [0, 7, 14],
      ],
    };

    final t = thresholds[type];

    if (t == null) {
      return 3; // Unknown medicine type → medium risk
    }

    return _scoreByThreshold(daysToExpiry, t[0]) +
        _scoreByThreshold(daysSinceOpened, t[1]) +
        _scoreByThreshold(utilizationDays, t[2]);
  }

  int _evaluateStorageCondition(String condition) {
    switch (condition.toLowerCase().trim()) {
      case 'good':
      case 'room temperature':
        return 0;
      case 'medium':
        return 1;
      case 'bad':
        return 2;
      default:
        return 1; // Assume average if unknown
    }
  }

  int _scoreByThreshold(int value, List<int> thresholds) {
    if (value <= thresholds[0]) return 3;
    if (value <= thresholds[1]) return 2;
    if (value <= thresholds[2]) return 1;
    return 0;
  }

  EvaluationResult _generateRiskResult(int score) {
    if (score <= 2) {
      return EvaluationResult(
        totalScore: score,
        riskLevel: 'Very Low Risk',
        color: Colors.green.shade800,
      );
    } else if (score <= 4) {
      return EvaluationResult(
        totalScore: score,
        riskLevel: 'Low Risk',
        color: Colors.green,
      );
    } else if (score <= 6) {
      return EvaluationResult(
        totalScore: score,
        riskLevel: 'Moderate Risk',
        color: Colors.yellow.shade700,
      );
    } else if (score <= 8) {
      return EvaluationResult(
        totalScore: score,
        riskLevel: 'High Risk',
        color: Colors.orange,
      );
    } else {
      return EvaluationResult(
        totalScore: score,
        riskLevel: 'Critical Risk',
        color: Colors.red,
      );
    }
  }
}