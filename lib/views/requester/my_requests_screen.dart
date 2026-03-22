import 'package:flutter/material.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample mock data – later you will load this from a backend or service
    final List<Map<String, String>> requests = [
      {
        'medicine': 'Paracetamol',
        'status': 'Pending',
        'date': '2025-05-26',
      },
      {
        'medicine': 'Ibuprofen',
        'status': 'Approved',
        'date': '2025-05-24',
      },
      {
        'medicine': 'Amoxicillin',
        'status': 'Rejected',
        'date': '2025-05-22',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Requests"),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.medication_outlined, color: Colors.teal),
              title: Text(
                request['medicine'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Status: ${request['status']}  •  Date: ${request['date']}"),
              trailing: _buildStatusChip(request['status']),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    Color chipColor;

    switch (status) {
      case 'Approved':
        chipColor = Colors.green;
        break;
      case 'Pending':
        chipColor = Colors.orange;
        break;
      case 'Rejected':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(status ?? ''),
      backgroundColor: chipColor.withOpacity(0.2),
      labelStyle: TextStyle(color: chipColor),
    );
  }
}
