import 'package:flutter/material.dart';
import 'package:medereuse/models/user_model.dart';
import 'pharmacist_evaluation_page.dart';
import 'package:medereuse/views/pharmacist/ReviewOrdonnancePage.dart'; // <-- Import added
import '../../services/donation_service.dart';

class PharmacistHomeScreen extends StatefulWidget {
  final UserModel user;

  const PharmacistHomeScreen({super.key, required this.user});

  @override
  State<PharmacistHomeScreen> createState() => _PharmacistHomeScreenState();
}

class _PharmacistHomeScreenState extends State<PharmacistHomeScreen> {
  int _pendingCount = 0;
  int _approvedCount = 0;
  int _ordonnanceCount = 0;
  final DonationService _donationService = DonationService();

  @override
  void initState() {
    super.initState();
    _loadDashboardCounts();
  }

  Future<void> _loadDashboardCounts() async {
    final pending = await _donationService.getPendingDonationsCount();
    final approved = await _donationService.getApprovedDonationsCount();
    final ordonnance = await _donationService.getOrdonnanceReviewCount();

    setState(() {
      _pendingCount = pending;
      _approvedCount = approved;
      _ordonnanceCount = ordonnance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _DashboardContent(
        user: widget.user,
        pendingCount: _pendingCount,
        approvedCount: _approvedCount,
        ordonnanceCount: _ordonnanceCount,
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final UserModel user;
  final int pendingCount;
  final int approvedCount;
  final int ordonnanceCount;

  const _DashboardContent({
    required this.user,
    required this.pendingCount,
    required this.approvedCount,
    required this.ordonnanceCount,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome, ${user.name}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Here is your summary for today.',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _DashboardCard(
                icon: Icons.pending_actions,
                label: 'Evaluate Medicines',
                count: pendingCount,
                color: Colors.teal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PharmacistEvaluationPage()),
                  );
                },
              ),
              _DashboardCard(
                icon: Icons.check_circle_outline,
                label: 'Approved Donations',
                count: approvedCount,
                color: Colors.green,
              ),
              _DashboardCard(
                icon: Icons.description_outlined,
                label: 'Review Ordonnance',
                count: ordonnanceCount,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReviewOrdonnancePage()),
                  );
                },
              ),

            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final VoidCallback? onTap;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 12),
              Text(label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('$count',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
