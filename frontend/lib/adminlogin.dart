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
  bool _obscurePassword = true; // 👁️ Password visibility toggle

  void _login() {
    final isValid = _formKey.currentState?.validate() ?? false;
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (!isValid) return;

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
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/login-bg.png',
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.centerLeft,
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: const Color(0xCC9B000A), // 80% opacity red
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Welcome,\nAdmin!',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 56,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                            _buildTextField(
                              controller: _usernameController,
                              label: 'Username',
                              icon: Icons.person,
                              isError: _invalidUsername,
                              errorText: 'Invalid username',
                            ),
                            const SizedBox(height: 2),

                            // Password Field
                            _buildTextField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock,
                              isPassword: true,
                              isError: _invalidPassword,
                              errorText: 'Invalid password',
                            ),
                            const SizedBox(height: 2),
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
          width: double.infinity,
          height: 60,
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? _obscurePassword : false,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.black),
              prefixIcon: Icon(icon, color: Colors.black),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
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
              if ((label == 'Username' && _invalidUsername) ||
                  (label == 'Password' && _invalidPassword)) {
                return errorText;
              }
              return null;
            },
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
