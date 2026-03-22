import 'package:flutter/material.dart';
import 'package:medereuse/models/user_model.dart';
import 'package:medereuse/views/requester/requester_main_page.dart';
// Add other main pages as needed, e.g.:
// import 'package:medereuse/views/donor/donor_main_page.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Widget mainPage;

    // Use the first role found (you can improve this with a priority system if needed)
    String primaryRole = user.roles.isNotEmpty ? user.roles.first.toLowerCase() : '';

    switch (primaryRole) {
      case 'requester':
        mainPage = RequesterMainPage(user: user);
        break;
    // case 'donor':
    //   mainPage = DonorMainPage(user: user);
    //   break;
      default:
        mainPage = Center(
          child: Text(
            'Unknown role: $primaryRole',
            style: const TextStyle(fontSize: 24),
          ),
        );
    }

    return Scaffold(
      body: mainPage,
    );
  }
}
