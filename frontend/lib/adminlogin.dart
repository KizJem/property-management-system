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
          // LEFT COL (Image)
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 30.0),
              alignment: Alignment.center,
              child: Container(
                width: 650,
                height: 650,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/login-bg.png',
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.centerLeft,
                        ),
                      ),

                      Positioned.fill(
                        child: Container(
                          color: const Color(0xCC9B000A), // 80% opacity red
                        ),
                      ),

                      // Welcome Text at bottom-left
                      const Positioned(
                        left: 32,
                        bottom: 32,
                        child: Text(
                          'Welcome,\nAdmin!',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            // letterSpacing: -1,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // RIGHT COL (Form + Back Arrow)
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Login Form
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
                              'assets/images/pms-logo-red.png',
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
                            // Username Field
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                    color: _invalidUsername
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: _invalidUsername
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _invalidUsername
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _invalidUsername
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Username';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            if (_invalidUsername)
                              const Padding(
                                padding: EdgeInsets.only(top: 4, left: 4),
                                child: Text(
                                  'Invalid username',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 10),

                            // Password Field
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: _invalidPassword
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: _invalidPassword
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _invalidPassword
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _invalidPassword
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Password';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            if (_invalidPassword)
                              const Padding(
                                padding: EdgeInsets.only(top: 4, left: 4),
                                child: Text(
                                  'Invalid password',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 10),
                            const SizedBox(height: 2),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: "Admin's Name",
                                  labelStyle: TextStyle(
                                    color: _nameController.text.isEmpty
                                        ? Colors.black
                                        : Colors.black,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.badge,
                                    color: _nameController.text.isEmpty
                                        ? Colors.black
                                        : Colors.black,
                                  ),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
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
                            SizedBox(
                              width: double.infinity,
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
                            Transform.translate(
                              offset: const Offset(0, 25), // overlap upwards
                              child: Container(
                                width: double.infinity,
                                height: 100,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFBD00),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(200),
                                    topRight: Radius.circular(200),
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

                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LandingPage()),
                      );
                    },
                    child: Container(
                      width: 450,
                      height: 200,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFBD00),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(80),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 50.0,
                            right: 100.0,
                          ),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFA80504),
                            ),
                            child: const Icon(
                              Icons.chevron_left,
                              size: 35,
                              color: Color(0xFFFFBD00),
                            ),
                          ),
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
            obscureText: isPassword,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: isError ? Colors.red : null),
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
            offset: const Offset(0, -8), // keep it close to the field
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
