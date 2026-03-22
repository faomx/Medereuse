import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/donationwithdrug.dart';
import 'medicine_request_page.dart';

class DonationDetailPage extends StatelessWidget {
  final List<DonationWithDrug> donationsWithDrug;

  const DonationDetailPage({Key? key, required this.donationsWithDrug}) : super(key: key);

  Color _getRiskColor(String riskLevel) {
    final normalized = riskLevel.trim().toLowerCase();

    switch (normalized) {
      case 'very low risk':
        return Colors.green;
      case 'low risk':
        return Colors.lightGreen;
      case 'moderate risk':
        return Colors.yellow;
      case 'high risk':
        return Colors.orange;
      case 'critical risk':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _goToRequestPage(BuildContext context, DonationWithDrug donationWithDrug) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedicineRequestPage(donationWithDrug: donationWithDrug),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (donationsWithDrug.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Donation Details')),
        body: const Center(child: Text("No donations available.")),
      );
    }

    final drug = donationsWithDrug.first.drug;

    return Scaffold(
      appBar: AppBar(
        title: Text(drug.brandName),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: donationsWithDrug.length,
        itemBuilder: (context, index) {
          final donationWithDrug = donationsWithDrug[index];
          final donation = donationWithDrug.donation;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber, size: 20),
                      const SizedBox(width: 8),
                      const Text("Risk Level:", style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getRiskColor(donation.riskLevel),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          donation.riskLevel,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Expiration Date: ${_formatDate(donation.expirationDate.toDate())}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 20),
                      const SizedBox(width: 8),
                      Text("Utilization Period: ${donation.utilizationPeriod} days",
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.score, size: 20),
                      const SizedBox(width: 8),
                      Text("Auto Score: ${donation.autoScore}", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _goToRequestPage(context, donationWithDrug),
                      icon: const Icon(Icons.medical_services),
                      label: const Text("Request This Donation"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
