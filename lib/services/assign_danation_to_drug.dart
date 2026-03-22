import '../models/drug_model.dart';
import '../models/donation_model.dart';
import '../services/drug_service.dart';
import '../services/donation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class DonationAssignmentLogic {
  final DrugService drugService;
  final DonationService donationService;

  DonationAssignmentLogic({
    required this.drugService,
    required this.donationService,
  });

  Future<void> assignDonationToDrug(
      Map<String, dynamic> donationData, String donationId) async {
    final String genericName = donationData['genericName'] ?? '';
    final String type = donationData['medicineType'] ?? '';
    final String category = donationData['therapeuticCategory'] ?? '';

    DrugModel? existingDrug =
    await drugService.findMatchingDrug(genericName, type, category);

    late String drugId;

    if (existingDrug != null) {
      drugId = existingDrug.drugId;
    } else {
      drugId = const Uuid().v4();
      final newDrug = DrugModel(
        drugId: drugId,
        brandName: donationData['genericName'],
        genericName: genericName,
        description: 'Added automatically from donation.',
        imageUrl: 'https://via.placeholder.com/150',
        therapeuticCategory: category,
        type: type,
        requiresOrdonnance: false, // ✅ added default value
      );
      await drugService.addDrug(newDrug);
    }

    DocumentReference drugRef =
    FirebaseFirestore.instance.collection('drugs').doc(drugId);
    await FirebaseFirestore.instance
        .collection('donations')
        .doc(donationId)
        .update({
      'drugId': drugRef,
    });
  }
}
