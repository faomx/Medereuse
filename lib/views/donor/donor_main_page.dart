import 'package:flutter/material.dart';
import 'package:medereuse/views/donor/donor_home_screen.dart';
import 'package:medereuse/views/medicine_catalog_screen.dart';
import 'package:medereuse/views/profile_screen.dart';
import 'package:medereuse/models/user_model.dart';

class DonorMainPage extends StatefulWidget {
  final UserModel user;

  const DonorMainPage({Key? key, required this.user}) : super(key: key);

  @override
  State<DonorMainPage> createState() => _DonorMainPageState();
}

class _DonorMainPageState extends State<DonorMainPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DonorHomeScreen(user: widget.user),
      const MedicineCatalog(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.teal,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
