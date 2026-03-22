import 'package:flutter/material.dart';

class SpecificRequestScreen extends StatefulWidget {
  const SpecificRequestScreen({super.key});

  @override
  State<SpecificRequestScreen> createState() => _SpecificRequestScreenState();
}

class _SpecificRequestScreenState extends State<SpecificRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _drugNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _drugNameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      String name = _drugNameController.text.trim();
      String category = _categoryController.text.trim();
      String description = _descriptionController.text.trim();

      // TODO: Implement actual catalog check and submission logic here
      print("Drug Requested: $name");
      print("Category: $category");
      print("Description: $description");

      // Example: Navigate to catalog or show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted!')),
      );

      // Clear the fields
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Specific Drug Request"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Request a Specific Drug",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Drug Name
              TextFormField(
                controller: _drugNameController,
                decoration: const InputDecoration(
                  labelText: 'Drug Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter a drug name' : null,
              ),
              const SizedBox(height: 16),

              // Therapeutic Category
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Therapeutic Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter a category'
                    : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton.icon(
                onPressed: _handleSubmit,
                icon: const Icon(Icons.send),
                label: const Text("Submit Request"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
