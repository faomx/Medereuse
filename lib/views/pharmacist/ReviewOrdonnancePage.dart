import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewOrdonnancePage extends StatefulWidget {
  const ReviewOrdonnancePage({super.key});

  @override
  State<ReviewOrdonnancePage> createState() => _ReviewOrdonnancePageState();
}

class _ReviewOrdonnancePageState extends State<ReviewOrdonnancePage> {
  Future<void> handleDecision({
    required Map<String, dynamic> requestData,
    required String requestId,
    required bool accept,
  }) async {
    try {
      final donationId = requestData['donationId'] as String;
      final requesterContact = requestData['contact'] as String;

      final donationSnap = await FirebaseFirestore.instance
          .collection('donations')
          .doc(donationId)
          .get();

      if (!donationSnap.exists) {
        throw Exception("Donation not found");
      }

      final donationData = donationSnap.data()!;
      final donorId = donationData['donorId'] as String;

      if (accept) {
        // ✅ Send notification to the donor
        await FirebaseFirestore.instance.collection('notifications').add({
          'toUserId': donorId,
          'type': 'request_accepted',
          'contactInfo': requesterContact,
          'timestamp': Timestamp.now(),
        });

        // ✅ Remove donation from Firestore (donation is considered given)
        await FirebaseFirestore.instance
            .collection('donations')
            .doc(donationId)
            .delete();
      }

      // ✅ Delete the medicine request regardless of accept/reject
      await FirebaseFirestore.instance
          .collection('medicine_requests')
          .doc(requestId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(accept ? 'Request accepted and donation removed.' : 'Request rejected.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Review Ordonnances")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('medicine_requests')
            .where('status', isEqualTo: 'pending')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading requests"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No pending requests"));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final doc = requests[index];
              final data = doc.data() as Map<String, dynamic>;
              final ordonnanceUrl = data['ordonnanceUrl'] as String?;
              final contact = data['contact'] ?? 'N/A';
              final timestamp = (data['timestamp'] as Timestamp?)?.toDate();

              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Contact: $contact",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("Submitted: ${timestamp ?? 'Unknown'}"),
                      if (ordonnanceUrl != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Image.network(
                            ordonnanceUrl,
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => handleDecision(
                              requestData: data,
                              requestId: doc.id,
                              accept: true,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text("Accept"),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () => handleDecision(
                              requestData: data,
                              requestId: doc.id,
                              accept: false,
                            ),
                            child: const Text("Reject"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
