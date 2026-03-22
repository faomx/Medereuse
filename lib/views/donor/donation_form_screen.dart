import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:medereuse/algorithms/evaluation_algorithm.dart';

class DonationFormScreen extends StatefulWidget {
  final String donorId;

  const DonationFormScreen({super.key, required this.donorId});

  @override
  State<DonationFormScreen> createState() => _DonationFormScreenState();
}

class _DonationFormScreenState extends State<DonationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String brandName = '';
  String genericName = '';
  String medicineType = 'Tablets';
  String therapeuticCategory = '';
  String description = '';
  String expirationDate = '';
  String openingDate = '';
  String utilizationPeriod = '';
  String storageCondition = 'Good';

  final List<String> medicineTypes = [
    'Capsules', 'Tablets', 'Liquid', 'Topical', 'Inhalers', 'Injections'
  ];

  final List<String> storageConditions = ['Good', 'Medium', 'Bad'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate Medicine'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Medicine Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Brand Name', (val) => brandName = val, required: true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField('Generic Name', (val) => genericName = val),
                  ),
                ],
              ),
              _buildDropdown('Medicine Type', medicineType, medicineTypes,
                      (val) => medicineType = val),
              _buildTextField('Therapeutic Category', (val) => therapeuticCategory = val,
                  required: true),
              _buildTextField('Description', (val) => description = val, maxLines: 2),
              const SizedBox(height: 20),
              const Text('Usage & Storage',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildTextField('Expiration Date (YYYY-MM-DD)',
                      (val) => expirationDate = val, required: true),
              _buildTextField('Opening Date (YYYY-MM-DD)',
                      (val) => openingDate = val, required: true),
              _buildTextField('Utilization Period (days)',
                      (val) => utilizationPeriod = val,
                  keyboardType: TextInputType.number, required: true),
              _buildDropdown('Storage Condition', storageCondition, storageConditions,
                      (val) => storageCondition = val),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Submit Donation',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onSaved,
      {int maxLines = 1,
        bool required = false,
        TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        decoration: _inputDecoration(label),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: required
            ? (value) => value == null || value.trim().isEmpty ? 'Required field' : null
            : null,
        onSaved: (value) => onSaved(value ?? ''),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: _inputDecoration(label),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (val) => setState(() => onChanged(val!)),
        onSaved: (val) => onChanged(val!),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade200,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
    );
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();

    try {
      final eval = MedicineEvaluation(
        expiryDate: DateTime.parse(expirationDate),
        openingDate: DateTime.parse(openingDate),
        utilizationDays: int.tryParse(utilizationPeriod) ?? 0,
        storageCondition: storageCondition,
        medicineType: medicineType,
      );

      final result = eval.autoEvaluate();
      final donationId = const Uuid().v4();

      await FirebaseFirestore.instance.collection('donations').doc(donationId).set({
        'donation_id': donationId,
        'donorId': widget.donorId,
        'brandName': brandName,
        'genericName': genericName,
        'medicineType': medicineType,
        'therapeuticCategory': therapeuticCategory,
        'description': description,
        'expirationDate': expirationDate,
        'openingDate': openingDate,
        'utilizationPeriod': int.parse(utilizationPeriod),
        'storageCondition': storageCondition,
        'imageUrl': '',
        'autoScore': result.totalScore,
        'riskLevel': result.riskLevel,
        'pharmacistEvaluation': null,
        'status': 'pending',
        'createdAt': Timestamp.now(),
      });

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Donation Submitted'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total Score: ${result.totalScore}'),
                Text('Risk Level: ${result.riskLevel}'),
                Icon(Icons.warning, color: result.color, size: 40),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  Navigator.of(context).pop(); // go back to previous screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
