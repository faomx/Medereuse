import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EvaluationDetailPage extends StatefulWidget {
  final Map<String, dynamic> donation;

  const EvaluationDetailPage({super.key, required this.donation});

  @override
  State<EvaluationDetailPage> createState() => _EvaluationDetailPageState();
}

class _EvaluationDetailPageState extends State<EvaluationDetailPage> {
  late TextEditingController brandNameController;
  late TextEditingController genericNameController;
  bool requireOrdonnance = false;

  bool showRiskEditor = false;
  String? selectedRiskLevel;

  // ✅ Corrected risk levels
  final List<String> riskLevels = [
    'Very Low Risk',
    'Low Risk',
    'Moderate Risk',
    'High Risk',
    'Critical Risk'
  ];

  @override
  void initState() {
    super.initState();
    brandNameController = TextEditingController(text: widget.donation['brandName']);
    genericNameController = TextEditingController(text: widget.donation['genericName']);
    requireOrdonnance = widget.donation['requireOrdonnance'] ?? false;

    // ✅ Prevent DropdownButton crash by validating the initial value
    String? incomingRisk = widget.donation['riskLevel'];
    if (riskLevels.contains(incomingRisk)) {
      selectedRiskLevel = incomingRisk;
    } else {
      selectedRiskLevel = null;
    }
  }

  @override
  void dispose() {
    brandNameController.dispose();
    genericNameController.dispose();
    super.dispose();
  }

  Future<void> approveDonation() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final donationId = widget.donation['donation_id'] ?? widget.donation['id'];
      final brandName = brandNameController.text.trim();
      final genericName = genericNameController.text.trim();
      final imageUrl = widget.donation['imageUrl'] ?? '';
      final description = widget.donation['description'] ?? '';
      final category = widget.donation['therapeuticCategory'] ?? '';
      final type = widget.donation['medicineType'] ?? '';

      // Step 1: Check if drug exists
      QuerySnapshot existingDrugSnap = await firestore
          .collection('drugs')
          .where('brandName', isEqualTo: brandName)
          .limit(1)
          .get();

      DocumentReference drugRef;

      if (existingDrugSnap.docs.isNotEmpty) {
        drugRef = existingDrugSnap.docs.first.reference;
      } else {
        // Step 2: Create new drug
        DocumentReference newDrugRef = await firestore.collection('drugs').add({
          'brandName': brandName,
          'genericName': genericName,
          'description': description,
          'imageUrl': imageUrl,
          'therapeuticCategory': category,
          'type': type,
        });
        drugRef = newDrugRef;
      }

      // Step 3: Update donation with drugId and evaluation fields
      await firestore.collection('donations').doc(donationId).update({
        'status': 'approved',
        'brandName': brandName,
        'genericName': genericName,
        'requireOrdonnance': requireOrdonnance,
        'riskLevel': selectedRiskLevel,
        'drugId': drugRef,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Donation approved and linked to catalog.")),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error approving donation: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to approve: $e")),
      );
    }
  }


  Future<void> rejectDonation() async {
    await FirebaseFirestore.instance
        .collection('donations')
        .doc(widget.donation['id'])
        .update({'status': 'rejected'});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Donation rejected")),
    );
    Navigator.pop(context);
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 160,
              child: Text("$label:",
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.donation;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluate Donation"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Editable Fields",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            TextField(
              controller: brandNameController,
              decoration: const InputDecoration(
                  labelText: "Brand Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: genericNameController,
              decoration: const InputDecoration(
                  labelText: "Generic Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            const Text("Additional Info",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            _infoRow("Therapeutic Category", d['therapeuticCategory'] ?? ''),
            _infoRow("Medicine Type", d['medicineType'] ?? ''),
            _infoRow("Expiration Date", d['expirationDate'] ?? ''),
            _infoRow("Opening Date", d['openingDate'] ?? ''),
            _infoRow("Storage", d['storageCondition'] ?? ''),
            _infoRow("Utilization", "${d['utilizationPeriod']} days"),
            _infoRow("Auto Score", d['autoScore'].toString()),
            _infoRow("Risk Level", selectedRiskLevel ?? 'Not set'),

            const SizedBox(height: 16),
            Row(
              children: [
                Switch(
                  value: requireOrdonnance,
                  onChanged: (val) =>
                      setState(() => requireOrdonnance = val),
                ),
                const Text("Require Ordonnance"),
              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () =>
                  setState(() => showRiskEditor = !showRiskEditor),
              icon: const Icon(Icons.replay_circle_filled),
              label: const Text("Re-evaluate Risk Level"),
              style:
              ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),

            if (showRiskEditor) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedRiskLevel,
                items: riskLevels.map((level) {
                  return DropdownMenuItem(
                      value: level, child: Text(level));
                }).toList(),
                onChanged: (value) =>
                    setState(() => selectedRiskLevel = value),
                decoration: const InputDecoration(
                  labelText: "Select New Risk Level",
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text("Approve"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal),
                    onPressed: approveDonation,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: const Text("Reject"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    onPressed: rejectDonation,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
