import 'package:cloud_firestore/cloud_firestore.dart';

class DonationModel {
  final String donationId;
  final DocumentReference drugId;
  final String autoScore;
  final String comment;
  final Timestamp expirationDate;
  final Timestamp openingDate;
  final String pharmacistEvaluation;
  final String riskLevel;
  final String storageCondition;
  final int utilizationPeriod;
  final String imageUrl;
  final String status; // ✅ Added field

  DonationModel({
    required this.donationId,
    required this.drugId,
    required this.autoScore,
    required this.comment,
    required this.expirationDate,
    required this.openingDate,
    required this.pharmacistEvaluation,
    required this.riskLevel,
    required this.storageCondition,
    required this.utilizationPeriod,
    required this.imageUrl,
    required this.status, // ✅ Include in constructor
  });

  factory DonationModel.fromMap(Map<String, dynamic> map, {required String donationId}) {
    return DonationModel(
      donationId: donationId,
      drugId: map['drugId'] as DocumentReference,
      autoScore: map['autoScore'] ?? '',
      comment: map['comment'] ?? '',
      expirationDate: map['expirationDate'],
      openingDate: map['openingDate'],
      pharmacistEvaluation: map['pharmacistEvaluation'] ?? '',
      riskLevel: map['riskLevel'] ?? '',
      storageCondition: map['storageCondition'] ?? '',
      utilizationPeriod: map['utilizationPeriod'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      status: map['status'] ?? '', // ✅ Read from map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'drugId': drugId,
      'autoScore': autoScore,
      'comment': comment,
      'expirationDate': expirationDate,
      'openingDate': openingDate,
      'pharmacistEvaluation': pharmacistEvaluation,
      'riskLevel': riskLevel,
      'storageCondition': storageCondition,
      'utilizationPeriod': utilizationPeriod,
      'imageUrl': imageUrl,
      'status': status, // ✅ Write to map
    };
  }
}
