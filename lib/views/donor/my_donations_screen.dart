import 'package:flutter/material.dart';

class MyDonationsScreen extends StatelessWidget {
  const MyDonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Donations"),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: 5, // Replace with actual user donation data
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.medication),
              title: Text("Donation #${index + 1}"),
              subtitle: const Text("Expires: 2025-12-31"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Navigate to donation details screen
              },
            ),
          );
        },
      ),
    );
  }
}
