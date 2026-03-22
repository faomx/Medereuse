import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DonorNotificationsPage extends StatelessWidget {
  final String donorId;

  const DonorNotificationsPage({super.key, required this.donorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Notifications'),
          backgroundColor: Colors.teal,
        ),
        body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
        .where('toUserId', isEqualTo: donorId)
        .orderBy('timestamp', descending: true)
        .snapshots(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(child: Text("No notifications yet."));
    }

    final notifications = snapshot.data!.docs;

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final doc = notifications[index];
        final data = doc.data() as Map<String, dynamic>;

        final type = data['type'] ?? 'unknown';
        final contact = data['contactInfo'] ?? 'N/A';
        final timestamp = data['timestamp'] != null
            ? (data['timestamp'] as Timestamp).toDate()
            : null;
        final formattedDate = timestamp != null
            ? DateFormat.yMMMd().add_jm().format(timestamp)
            : 'No date';

        String message;
        switch (type) {
          case 'request_accepted':
            message =
            "🎉 Thank you for your generous donation!\n\nSomeone has requested your medicine donation. Please contact them at:\n📞 $contact";
            break;
          case 'request_rejected':
            message = "Your medicine donation request was declined.";
            break;
          default:
            message = "You have a new notification.";
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.notifications, color: Colors.teal),
                    SizedBox(width: 8),
                    Text(
                      'Notification',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  "Date: $formattedDate",
                  style: const TextStyle(
                      fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('notifications')
                          .doc(doc.id)
                          .delete();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text('Notification marked as read.')),
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Mark as Read'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
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