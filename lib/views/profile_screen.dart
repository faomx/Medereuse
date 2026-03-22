import 'package:flutter/material.dart';
import 'package:medereuse/models/user_model.dart';
import 'package:medereuse/services/current_user.dart';
import 'package:medereuse/views/login_page.dart';
import 'package:medereuse/views/requester/requester_main_page.dart';
import 'package:medereuse/views/donor/donor_main_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel? currentUser;
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    currentUser = CurrentUser().user;
    selectedRole = CurrentUser().selectedRole ?? currentUser?.roles.first ?? '';
  }

  void changeRole(String role) {
    if (currentUser != null) {
      setState(() {
        selectedRole = role;
        CurrentUser().selectedRole = role;
      });

      if (role == 'requester') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => RequesterMainPage(user: currentUser!)),
        );
      } else if (role == 'donor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DonorMainPage(user: currentUser!)),
        );
      }
    }
  }

  void showRoleSwitcher() {
    if (currentUser == null) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Switch Role", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...currentUser!.roles.map((role) {
                return ListTile(
                  title: Text(role[0].toUpperCase() + role.substring(1)),
                  trailing: selectedRole == role
                      ? const Icon(Icons.check, color: Colors.teal)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    changeRole(role);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Choose Language", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ListTile(title: const Text("English"), onTap: () => Navigator.pop(context)),
              ListTile(title: const Text("Français"), onTap: () => Navigator.pop(context)),
              ListTile(title: const Text("العربية"), onTap: () => Navigator.pop(context)),
            ],
          ),
        );
      },
    );
  }

  void logout() {
    // Clear session and navigate back to login screen
    CurrentUser().user = null;
    CurrentUser().selectedRole = null;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.teal.shade200],
                ),
              ),
              padding: const EdgeInsets.all(4),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              currentUser!.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              currentUser!.email,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              'Current Role: ${selectedRole[0].toUpperCase()}${selectedRole.substring(1)}',
              style: const TextStyle(color: Colors.teal, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 32),

            _buildProfileButton(
              icon: Icons.language,
              label: "Change Language",
              onPressed: showLanguageSelector,
            ),
            const SizedBox(height: 16),

            _buildProfileButton(
              icon: Icons.sync_alt,
              label: "Switch Role",
              onPressed: showRoleSwitcher,
            ),
            const SizedBox(height: 32),

            GestureDetector(
              onTap: logout,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 12),
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.2),
      ),
    );
  }
}
