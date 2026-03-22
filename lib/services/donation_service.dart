import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_model.dart';

class DonationService {
  final CollectionReference donationsRef =
  FirebaseFirestore.instance.collection('donations');

  /// Adds a donation to Firestore
  Future<void> addDonation(DonationModel donation) async {
    try {
      await donationsRef.doc(donation.donationId).set(donation.toMap());
      print('✅ Donation added successfully!');
    } catch (e) {
      print('❌ Error adding donation: $e');
    }
  }

  /// Fetches all donations with status "approved"
  Future<List<DonationModel>> getAllDonations() async {
    try {
      print("🔍 Fetching all approved donations...");

      QuerySnapshot snapshot =
      await donationsRef.where('status', isEqualTo: 'approved').get();

      print("📦 Total approved documents fetched: ${snapshot.docs.length}");

      List<DonationModel> donations = snapshot.docs.map((doc) {
        final map = doc.data() as Map<String, dynamic>;
        return DonationModel.fromMap(map, donationId: doc.id);
      }).toList();

      print("✅ Approved donations parsed: ${donations.length}");
      return donations;
    } catch (e) {
      print('❌ Error fetching donations: $e');
      return [];
    }
  }

  /// Returns the count of approved donations for a specific drugId
  Future<int> getApprovedDonationCountByDrugId(String drugId) async {
    try {
      QuerySnapshot snapshot = await donationsRef
          .where('status', isEqualTo: 'approved')
          .where('drugId', isEqualTo: FirebaseFirestore.instance.doc('drugs/$drugId'))
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('❌ Error getting donation count for drugId $drugId: $e');
      return 0;
    }
  }

  /// Returns the count of donations pending evaluation (no riskLevel assigned)
  Future<int> getPendingDonationsCount() async {
    try {
      print("🔍 Counting donations pending evaluation...");
      QuerySnapshot snapshot = await donationsRef
          .where('riskLevel', isNull: true)
          .get();
      print("🕐 Pending donations found: ${snapshot.docs.length}");
      return snapshot.docs.length;
    } catch (e) {
      print('❌ Error getting pending donation count: $e');
      return 0;
    }
  }

  /// Returns the count of approved donations (evaluated and approved)
  Future<int> getApprovedDonationsCount() async {
    try {
      print("🔍 Counting approved donations...");
      QuerySnapshot snapshot = await donationsRef
          .where('riskLevel', isNotEqualTo: null)
          .where('status', isEqualTo: 'approved')
          .get();
      print("✅ Approved donations found: ${snapshot.docs.length}");
      return snapshot.docs.length;
    } catch (e) {
      print('❌ Error getting approved donations count: $e');
      return 0;
    }
  }

  /// Returns the count of donations that need ordonnance review
  Future<int> getOrdonnanceReviewCount() async {
    try {
      print("🔍 Counting donations needing ordonnance review...");
      QuerySnapshot snapshot = await donationsRef
          .where('needsOrdonnanceReview', isEqualTo: true)
          .get();
      print("📋 Donations needing ordonnance review: ${snapshot.docs.length}");
      return snapshot.docs.length;
    } catch (e) {
      print('❌ Error getting ordonnance review donation count: $e');
      return 0;
    }
  }
}
