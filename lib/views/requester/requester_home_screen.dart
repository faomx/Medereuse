import 'package:flutter/material.dart';
import 'package:medereuse/models/user_model.dart';
import 'my_requests_screen.dart';
import 'specific_request_screen.dart'; // Import the new screen

class RequesterHomeScreen extends StatelessWidget {
  final UserModel user;

  const RequesterHomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Requester Dashboard"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "Welcome, ${user.name}!",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),

            // Request Medicine
            _buildOptionCard(
              context,
              icon: Icons.medical_services_outlined,
              label: "Request Medicine",
              onPressed: () {
                // TODO: Navigate to Request Medicine Page
              },
            ),

            const SizedBox(height: 20),

            // My Requests
            _buildOptionCard(
              context,
              icon: Icons.list_alt_outlined,
              label: "My Requests",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyRequestsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Specific Request
            _buildOptionCard(
              context,
              icon: Icons.search_outlined,
              label: "Specific Request",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SpecificRequestScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onPressed,
      }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.shade100.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.teal.shade700),
            const SizedBox(width: 20),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
