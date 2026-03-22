import 'package:flutter/material.dart';
import 'package:medereuse/models/user_model.dart';
import 'package:medereuse/views/requester/requester_home_screen.dart';
import 'package:medereuse/views/medicine_catalog_screen.dart';
import 'package:medereuse/views/profile_screen.dart';

class RequesterMainPage extends StatefulWidget {
  final UserModel user;

  const RequesterMainPage({Key? key, required this.user}) : super(key: key);

  @override
  State<RequesterMainPage> createState() => _RequesterMainPageState();
}

class _RequesterMainPageState extends State<RequesterMainPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    print('✅ Logged in as: ${widget.user.email} (${widget.user.userId})');

    _pages = [
      RequesterHomeScreen(user: widget.user),
      MedicineCatalog(), // if it accepts user
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
          setState(() => _currentIndex = index);
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
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
