import 'dart:convert';
import 'package:flutter/material.dart';
import 'landingpage.dart';
import 'adminpage.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _invalidUsername = false;
  bool _invalidPassword = false;
  bool _isPasswordVisible = false; // 👁️ toggle

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (username != 'admin' || password != 'adminpms') {
      setState(() {
        _invalidUsername = username != 'admin';
        _invalidPassword = password != 'adminpms';
      });
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AdminPage(adminName: name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Column - Image
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 30.0),
              alignment: Alignment.center,
              child: Container(
                width: 650,
                height: 650,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/sign-in-left.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Image.asset(
                            'assets/images/cba-logo.png',
                            width: 200,
                          ),
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          'assets/images/PMS-white-logo.png',
                          width: 250,
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Image.asset(
                            'assets/images/tagline.png',
                            width: 250,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Right Column - Form
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LandingPage()),
                      );
                    },
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/PMS-logo-2.png',
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFA80504),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Oversee students activity within the simulation environment.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Username
                            _buildTextField(
                              controller: _usernameController,
                              label: 'Username',
                              icon: Icons.person,
                              isError: _invalidUsername,
                              errorText: 'Invalid username',
                            ),

                            // Password with toggle
                            _buildTextField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock,
                              isPassword: true,
                              isError: _invalidPassword,
                              errorText: 'Invalid password',
                            ),

                            // Admin Name
                            SizedBox(
                              width: 500,
                              height: 60,
                              child: TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: "Admin's Name",
                                  prefixIcon: Icon(Icons.badge),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Sign In Button
                            SizedBox(
                              width: 500,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFA80504),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isError = false,
    required String errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 500,
          height: 60,
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? !_isPasswordVisible : false,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: isError ? Colors.red : null),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
              labelStyle: TextStyle(color: isError ? Colors.red : null),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isError ? Colors.red : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isError ? Colors.red : Colors.blue,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ),
        if (isError)
          Transform.translate(
            offset: const Offset(0, -8),
            child: Container(
              width: 500,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
