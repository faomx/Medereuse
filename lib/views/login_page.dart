import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medereuse/views/admin/admin_main_page.dart';

import '../models/user_model.dart';
import '../services/current_user.dart';

// Pages for each role
import 'register_page.dart';
import 'donor/donor_main_page.dart';
import 'requester/requester_main_page.dart';
import 'pharmacist/pharmacist_main_page.dart';
import 'package:medereuse/views/medicine_catalog_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> _roles = ['donor', 'requester', 'pharmacist', 'admin'];
  String _selectedRole = 'donor';
  String _errorMessage = '';
  bool _obscurePassword = true;
  bool _isLoading = false; // ✅ Added loading state

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // ✅ Step 1: Authenticate with Firebase Auth
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        setState(() => _errorMessage = 'Authentication failed.');
        return;
      }

      // ✅ Step 2: Fetch only this user's document from Firestore
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        await _auth.signOut();
        setState(() => _errorMessage = 'User data not found.');
        return;
      }

      final data = doc.data()!;
      final List<String> roles = List<String>.from(data['roles'] ?? []);

      // ✅ Step 3: Check if the user has the selected role
      if (!roles.contains(_selectedRole)) {
        await _auth.signOut();
        setState(() => _errorMessage = 'You do not have access as $_selectedRole.');
        return;
      }

      // ✅ Step 4: Build UserModel (no password stored locally)
      final matchedUser = UserModel(
        userId: uid,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        password: '', // ✅ Never store password locally
        age: data['age'] ?? 0,
        roles: roles,
      );

      CurrentUser().user = matchedUser;

      // ✅ Step 5: Navigate based on role
      Widget targetPage;
      switch (_selectedRole) {
        case 'donor':
          targetPage = DonorMainPage(user: matchedUser);
          break;
        case 'requester':
          targetPage = RequesterMainPage(user: matchedUser);
          break;
        case 'pharmacist':
          targetPage = PharmacistMainPage(user: matchedUser);
          break;
        case 'admin':
          targetPage = AdminMainPage();
          break;
        default:
          setState(() => _errorMessage = 'Unknown role selected.');
          return;
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => targetPage),
      );
    } on FirebaseAuthException catch (e) {
      // ✅ Proper Firebase Auth error handling
      String msg;
      switch (e.code) {
        case 'user-not-found':
          msg = 'No account found with this email.';
          break;
        case 'wrong-password':
          msg = 'Incorrect password.';
          break;
        case 'invalid-email':
          msg = 'Invalid email format.';
          break;
        case 'user-disabled':
          msg = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          msg = 'Too many attempts. Please try again later.';
          break;
        default:
          msg = 'Login failed. Please try again.';
      }
      setState(() => _errorMessage = msg);
    } catch (e) {
      setState(() => _errorMessage = 'An unexpected error occurred.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _continueAsGuest() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MedicineCatalog()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/medical.png',
                height: 80,
              ),
              SizedBox(height: 16),
              Text(
                "MediReuse",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),

              // Role dropdown
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: _roles.map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (value) => setState(() => _selectedRole = value!),
                decoration: InputDecoration(labelText: "Login as"),
              ),
              SizedBox(height: 16),

              // Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress, // ✅ Better UX
                decoration: InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 16),

              // Password with toggle
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // ✅ Loading indicator on button
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text("Login"),
              ),

              TextButton(
                onPressed: _continueAsGuest,
                child: Text("Continue as Guest"),
              ),

              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 16),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),

              // Register
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text("Create an Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}