import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medereuse/views/login_page.dart';
import 'package:medereuse/test_pages/test_insertion_page.dart'; // ✅ Import your test function

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medereuse',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginPage(),
    );
  }
}
