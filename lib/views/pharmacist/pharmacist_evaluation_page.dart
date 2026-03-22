import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'evaluation_detail_page.dart';

class PharmacistEvaluationPage extends StatelessWidget {
  const PharmacistEvaluationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluate Medicines'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('donations')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final donations = snapshot.data!.docs;

          if (donations.isEmpty) {
            return const Center(child: Text("No pending donations"));
          }

          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(donation['brandName'] ?? 'Unknown'),
                  subtitle: Text("Risk Score: ${donation['autoScore'] ?? '-'}"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EvaluationDetailPage(donation: {
                          ...donation,
                          'id': donations[index].id, // Include ID for updates
                        }),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
