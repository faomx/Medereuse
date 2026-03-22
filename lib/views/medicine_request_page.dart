import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donationwithdrug.dart';
import '../core/imgur_uploader.dart';

class MedicineRequestPage extends StatefulWidget {
  final DonationWithDrug donationWithDrug;

  const MedicineRequestPage({super.key, required this.donationWithDrug});

  @override
  State<MedicineRequestPage> createState() => _MedicineRequestPageState();
}

class _MedicineRequestPageState extends State<MedicineRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contactController = TextEditingController();

  File? _ordonnanceImage;
  bool _isSubmitting = false;
  bool requiresOrdonnance = false;

  @override
  void initState() {
    super.initState();
    requiresOrdonnance = widget.donationWithDrug.donation.requireOrdonnance;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _ordonnanceImage = File(picked.path));
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    String? uploadedUrl;

    if (requiresOrdonnance) {
      if (_ordonnanceImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ordonnance image is required.')),
        );
        setState(() => _isSubmitting = false);
        return;
      }

      uploadedUrl = await uploadToImgur(_ordonnanceImage!);
      if (uploadedUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ordonnance upload failed.')),
        );
        setState(() => _isSubmitting = false);
        return;
      }
    }

    await FirebaseFirestore.instance.collection('medicine_requests').add({
      'donationId': widget.donationWithDrug.donation.donationId,
      'drugId': widget.donationWithDrug.drug.drugId,
      'donorId': widget.donationWithDrug.donation.donorId,
      'medicineName': widget.donationWithDrug.drug.brandName,
      'contact': _contactController.text.trim(),
      'ordonnanceUrl': uploadedUrl,
      'requiresOrdonnance': requiresOrdonnance,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() => _isSubmitting = false);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request submitted.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Medicine')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (requiresOrdonnance) ...[
                const Text("Upload Ordonnance"),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: _ordonnanceImage == null
                      ? Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.add_a_photo, size: 50),
                  )
                      : Image.file(_ordonnanceImage!, height: 150),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Phone or Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRequest,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
