import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonationModel {
  final String donationId;
  final DocumentReference drugId;
  final String imageUrl;
  final String medicineType;
  final bool requireOrdonnance;
  final String riskLevel;
  final String storageCondition;
  final int autoScore;
  final String pharmacistEvaluation;
  final String comment;
  final Timestamp expirationDate;
  final Timestamp openingDate;
  final int utilizationPeriod;
  final String status;
  final String donorId;
  final Timestamp createdAt;

  DonationModel({
    required this.donationId,
    required this.drugId,
    required this.imageUrl,
    required this.medicineType,
    required this.requireOrdonnance,
    required this.riskLevel,
    required this.storageCondition,
    required this.autoScore,
    required this.pharmacistEvaluation,
    required this.comment,
    required this.expirationDate,
    required this.openingDate,
    required this.utilizationPeriod,
    required this.status,
    required this.donorId,
    required this.createdAt,
  });

  factory DonationModel.fromMap(Map<String, dynamic> map, {required String donationId}) {
    Timestamp parseTimestamp(dynamic value) {
      if (value is Timestamp) return value;
      if (value is String) return Timestamp.fromDate(DateTime.parse(value));
      throw Exception("Invalid timestamp value: $value");
    }

    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return DonationModel(
      donationId: donationId,
      drugId: map['drugId'] as DocumentReference,
      imageUrl: map['imageUrl'] ?? '',
      medicineType: map['medicineType'] ?? '',
      requireOrdonnance: map['requireOrdonnance'] ?? false,
      riskLevel: map['riskLevel'] ?? '',
      storageCondition: map['storageCondition'] ?? '',
      autoScore: parseInt(map['autoScore']),
      pharmacistEvaluation: map['pharmacistEvaluation'] ?? '',
      comment: map['comment'] ?? '',
      expirationDate: parseTimestamp(map['expirationDate']),
      openingDate: parseTimestamp(map['openingDate']),
      utilizationPeriod: parseInt(map['utilizationPeriod']),
      status: map['status'] ?? '',
      donorId: map['donorId'] ?? '',
      createdAt: parseTimestamp(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'drugId': drugId,
      'imageUrl': imageUrl,
      'medicineType': medicineType,
      'requireOrdonnance': requireOrdonnance,
      'riskLevel': riskLevel,
      'storageCondition': storageCondition,
      'autoScore': autoScore,
      'pharmacistEvaluation': pharmacistEvaluation,
      'comment': comment,
      'expirationDate': expirationDate,
      'openingDate': openingDate,
      'utilizationPeriod': utilizationPeriod,
      'status': status,
      'donorId': donorId,
      'createdAt': createdAt,
    };
  }

  // ✅ Getter to convert expirationDate to DateTime
  DateTime get expirationDateAsDateTime => expirationDate.toDate();

  // ✅ Getter for a color based on riskLevel
  Color get riskLevelColor {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
