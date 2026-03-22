import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import 'donation_form_screen.dart';
import 'my_donations_screen.dart';
import 'package:medereuse/views/donor/notification_detail_screen.dart';

class DonorHomeScreen extends StatelessWidget {
  final UserModel user;

  const DonorHomeScreen({super.key, required this.user});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text("Donor Dashboard"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications',
            onPressed: () => _navigateTo(
              context,
              DonorNotificationsPage(donorId: user.userId),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " Welcome, ${user.name}",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "You're logged in as a donor.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1,
                children: [
                  _buildDashboardCard(
                    context,
                    icon: Icons.add_circle_outline,
                    label: "Donate Medicine",
                    onTap: () => _navigateTo(
                      context,
                      DonationFormScreen(donorId: user.userId),
                    ),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.list_alt_outlined,
                    label: "My Donations",
                    onTap: () => _navigateTo(
                      context,
                      MyDonationsScreen(),
                    ),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.notifications_none,
                    label: "Notifications",
                    onTap: () => _navigateTo(
                      context,
                      DonorNotificationsPage(donorId: user.userId),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36, color: Colors.teal),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
