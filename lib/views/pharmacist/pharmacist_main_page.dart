import 'package:flutter/material.dart';
import 'package:medereuse/models/user_model.dart';
import 'package:medereuse/views/pharmacist/pharmacist_home_screen.dart';
import 'package:medereuse/views/medicine_catalog_screen.dart';
import 'package:medereuse/views/profile_screen.dart';

class PharmacistMainPage extends StatefulWidget {
  final UserModel user;

  const PharmacistMainPage({super.key, required this.user});

  @override
  State<PharmacistMainPage> createState() => _PharmacistMainPageState();
}

class _PharmacistMainPageState extends State<PharmacistMainPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Pass the user to each subpage if needed
    _pages = [
      PharmacistHomeScreen(user: widget.user),
      MedicineCatalog(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pharmacist Dashboard"),
        backgroundColor: Colors.teal,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information_outlined),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
