import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_model.dart';
import '../services/donation_service.dart';

class TestInsertionPage extends StatelessWidget {
  const TestInsertionPage({super.key});

  Future<void> _addTestDonation() async {
    final donation = DonationModel(
      donationId: 'donation_panadol_001',
      drugId: FirebaseFirestore.instance.doc('drugs/drug_001'),
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/Panadol.png/440px-Panadol.png',
      medicineType: 'Tablet',
      requireOrdonnance: false,
      riskLevel: 'Low',
      storageCondition: 'Room temperature',
      autoScore: 85,
      pharmacistEvaluation: 'Looks good',
      comment: 'Unopened, stored at room temp',
      expirationDate: Timestamp.fromDate(DateTime(2025, 12, 30, 23, 0, 0)),
      openingDate: Timestamp.fromDate(DateTime(2025, 4, 30, 23, 0, 0)),
      utilizationPeriod: 12,
      status: 'approved',
      donorId: 'anonymous',
      createdAt: Timestamp.now(),
    );

    await DonationService().addDonation(donation);
    debugPrint('✅ Test donation added');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Insertion Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: _addTestDonation,
          child: const Text('Insert Test Donation'),
        ),
      ),
    );
  }
}
